--[[
    SuperBigNum.lua
    基于 LuaJIT FFI 的任意精度大数库
    包含 BigInt（整数）和 BigFloat（浮点数）
    支持所有常用数学函数：sqrt, ln, exp, sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, pow 等
    精度由用户指定，内部计算使用保护位确保结果准确
]]

local ffi = require("ffi")

-- ============================================================
-- 1. 内存管理 (C 标准库)
-- ============================================================
ffi.cdef([[
    void* malloc(size_t size);
    void  free(void* ptr);
    void* memcpy(void* dest, const void* src, size_t n);
    void* memset(void* s, int c, size_t n);
]])

local function alloc(size)
    local p = ffi.C.malloc(size)
    if p == nil then error("内存分配失败: " .. size .. " bytes") end
    return p
end
local function free(p) if p ~= nil then ffi.C.free(p) end end

-- ============================================================
-- 2. BigInt (任意精度整数)
-- ============================================================
local BigInt = {}
local IntMeta = {}

function BigInt:new(value)
    local num = { sign = 1, digits = {} }
    if value == nil or value == 0 then
        num.digits = {0}
        return setmetatable(num, IntMeta)
    end
    local str = tostring(value)
    if str:sub(1,1) == '-' then
        num.sign = -1
        str = str:sub(2)
    end
    for i = #str, 1, -1 do
        table.insert(num.digits, tonumber(str:sub(i,i)))
    end
    while #num.digits > 1 and num.digits[#num.digits] == 0 do
        table.remove(num.digits)
    end
    return setmetatable(num, IntMeta)
end

function BigInt:copy()
    local new = { sign = self.sign, digits = {} }
    for i, v in ipairs(self.digits) do new.digits[i] = v end
    return setmetatable(new, IntMeta)
end

function BigInt:len() return #self.digits end

function BigInt:toString()
    local s = {}
    for i = #self.digits, 1, -1 do table.insert(s, tostring(self.digits[i])) end
    local str = table.concat(s)
    if self.sign == -1 and not (str == "0") then return "-" .. str end
    return str
end

-- 绝对值比较
local function absCmp(a, b)
    if #a.digits ~= #b.digits then
        return #a.digits > #b.digits and 1 or -1
    end
    for i = #a.digits, 1, -1 do
        if a.digits[i] ~= b.digits[i] then
            return a.digits[i] > b.digits[i] and 1 or -1
        end
    end
    return 0
end

function BigInt:cmp(other)
    if self.sign ~= other.sign then
        return self.sign > other.sign and 1 or -1
    end
    local cmp = absCmp(self, other)
    if self.sign == -1 then cmp = -cmp end
    return cmp
end

-- 绝对值加
local function absAdd(a, b)
    local res = { sign = 1, digits = {} }
    local carry = 0
    local maxLen = math.max(#a.digits, #b.digits)
    for i = 1, maxLen do
        local da = a.digits[i] or 0
        local db = b.digits[i] or 0
        local sum = da + db + carry
        carry = math.floor(sum / 10)
        table.insert(res.digits, sum % 10)
    end
    if carry > 0 then table.insert(res.digits, carry) end
    return setmetatable(res, IntMeta)
end

-- 绝对值减 (a >= b)
local function absSub(a, b)
    local res = { sign = 1, digits = {} }
    local borrow = 0
    for i = 1, #a.digits do
        local da = a.digits[i] or 0
        local db = b.digits[i] or 0
        local diff = da - db - borrow
        if diff < 0 then diff = diff + 10; borrow = 1 else borrow = 0 end
        table.insert(res.digits, diff)
    end
    while #res.digits > 1 and res.digits[#res.digits] == 0 do
        table.remove(res.digits)
    end
    return setmetatable(res, IntMeta)
end

function IntMeta.__add(a, b)
    if type(b) ~= "table" or not b.digits then b = BigInt:new(b) end
    if a.sign == b.sign then
        local res = absAdd(a, b)
        res.sign = a.sign
        return res
    else
        local cmp = absCmp(a, b)
        if cmp == 0 then return BigInt:new(0) end
        if cmp > 0 then
            local res = absSub(a, b)
            res.sign = a.sign
            return res
        else
            local res = absSub(b, a)
            res.sign = b.sign
            return res
        end
    end
end

function IntMeta.__sub(a, b)
    if type(b) ~= "table" or not b.digits then b = BigInt:new(b) end
    local neg_b = b:copy()
    neg_b.sign = -neg_b.sign
    return a + neg_b
end

function IntMeta.__mul(a, b)
    if type(b) ~= "table" or not b.digits then b = BigInt:new(b) end
    local lenA, lenB = #a.digits, #b.digits
    local res_digits = {}
    for i = 1, lenA + lenB + 1 do res_digits[i] = 0 end
    for i = 1, lenA do
        for j = 1, lenB do
            local idx = i + j - 1
            res_digits[idx] = res_digits[idx] + a.digits[i] * b.digits[j]
        end
    end
    local carry = 0
    for i = 1, #res_digits do
        local val = res_digits[i] + carry
        res_digits[i] = val % 10
        carry = math.floor(val / 10)
    end
    while carry > 0 do
        table.insert(res_digits, carry % 10)
        carry = math.floor(carry / 10)
    end
    while #res_digits > 1 and res_digits[#res_digits] == 0 do
        table.remove(res_digits)
    end
    local res = { sign = a.sign * b.sign, digits = res_digits }
    return setmetatable(res, IntMeta)
end

-- 整数除法 (floor)
function IntMeta.__div(a, b)
    if type(b) ~= "table" or not b.digits then b = BigInt:new(b) end
    if b:toString() == "0" then error("除以零错误") end
    if absCmp(a, b) < 0 then return BigInt:new(0) end
    local dividend = a:copy()
    local divisor = b:copy()
    dividend.sign, divisor.sign = 1, 1
    local quotient_digits = {}
    local remainder = BigInt:new(0)
    for i = #dividend.digits, 1, -1 do
        local new_digits = remainder.digits
        table.insert(new_digits, 1, dividend.digits[i])
        remainder = setmetatable({ sign = 1, digits = new_digits }, IntMeta)
        while #remainder.digits > 1 and remainder.digits[#remainder.digits] == 0 do
            table.remove(remainder.digits)
        end
        local q = 0
        for d = 9, 0, -1 do
            local test = divisor * BigInt:new(d)
            if absCmp(test, remainder) <= 0 then q = d; break end
        end
        table.insert(quotient_digits, 1, q)
        local sub = divisor * BigInt:new(q)
        remainder = remainder - sub
    end
    local res = { sign = a.sign * b.sign, digits = quotient_digits }
    while #res.digits > 1 and res.digits[#res.digits] == 0 do
        table.remove(res.digits)
    end
    return setmetatable(res, IntMeta)
end

function BigInt:pow(exp)
    if type(exp) ~= "number" then error("指数必须为整数") end
    if exp < 0 then error("暂不支持负指数") end
    local base = self:copy()
    local result = BigInt:new(1)
    local e = exp
    while e > 0 do
        if e % 2 == 1 then result = result * base end
        base = base * base
        e = math.floor(e / 2)
    end
    return result
end

IntMeta.__tostring = BigInt.toString
IntMeta.__eq = function(a,b) return a:cmp(b) == 0 end
IntMeta.__lt = function(a,b) return a:cmp(b) < 0 end
IntMeta.__le = function(a,b) return a:cmp(b) <= 0 end

-- ============================================================
-- 3. BigFloat (任意精度浮点数)
-- ============================================================
-- 存储为 scaled = 整数部分 * 10^precision + 小数部分 (保持整数)
-- 实际值 = sign * scaled / 10^precision

local BigFloat = {}
local FloatMeta = {}
local scaleCache = {}

local function getScale(prec)
    if not scaleCache[prec] then
        scaleCache[prec] = BigInt:new(10):pow(prec)
    end
    return scaleCache[prec]
end

-- 从字符串或数字构造
function BigFloat:new(value, precision)
    precision = precision or 50
    local num = { precision = precision, sign = 1 }
    if value == nil then
        num.scaled = BigInt:new(0)
        return setmetatable(num, FloatMeta)
    end
    local str = tostring(value)
    if str:sub(1,1) == '-' then
        num.sign = -1
        str = str:sub(2)
    end
    local int_part, frac_part = str:match("^(%d+)%.?(.*)$")
    if not int_part then int_part = "0" end
    -- 补齐小数到 precision 位
    if #frac_part > precision then
        frac_part = frac_part:sub(1, precision)
    else
        frac_part = frac_part .. string.rep("0", precision - #frac_part)
    end
    local full_str = int_part .. frac_part
    num.scaled = BigInt:new(full_str)
    return setmetatable(num, FloatMeta)
end

-- 从缩放整数构造 (内部使用)
function BigFloat._fromScaled(scaled, sign, precision)
    local num = { precision = precision, sign = sign, scaled = scaled }
    return setmetatable(num, FloatMeta)
end

function BigFloat:copy()
    return BigFloat._fromScaled(self.scaled:copy(), self.sign, self.precision)
end

function BigFloat:toString()
    local scale = getScale(self.precision)
    local abs_scaled = self.scaled:copy()
    abs_scaled.sign = 1
    local int_part = abs_scaled / scale
    local frac_scaled = abs_scaled - int_part * scale
    local int_str = int_part:toString()
    local frac_str = frac_scaled:toString()
    while #frac_str < self.precision do frac_str = "0" .. frac_str end
    -- 去除尾部多余的0，但至少保留一位
    frac_str = frac_str:gsub("0*$", "")
    if frac_str == "" then frac_str = "0" end
    local sign_str = (self.sign == -1 and not (int_str == "0" and frac_str == "0")) and "-" or ""
    return sign_str .. int_str .. "." .. frac_str
end

-- 转为 Lua number (可能溢出)
function BigFloat:toNumber()
    return tonumber(self:toString())
end

-- 调整精度 (舍入或补零)
function BigFloat:setPrecision(newPrec)
    if newPrec == self.precision then return self:copy() end
    local scale_old = getScale(self.precision)
    local scale_new = getScale(newPrec)
    local abs_scaled = self.scaled:copy()
    abs_scaled.sign = 1
    -- 计算新 scaled = old_scaled * 10^(newPrec - oldPrec) 或 /
    if newPrec > self.precision then
        local factor = BigInt:new(10):pow(newPrec - self.precision)
        abs_scaled = abs_scaled * factor
    else
        local factor = BigInt:new(10):pow(self.precision - newPrec)
        -- 舍入：加上 5 * 10^(newPrec-1) 再除以 factor
        local half = BigInt:new(5) * (BigInt:new(10):pow(newPrec - 1))
        abs_scaled = (abs_scaled + half) / factor
    end
    return BigFloat._fromScaled(abs_scaled, self.sign, newPrec)
end

-- 四舍五入到指定小数位数 (按十进制)
function BigFloat:round(decimals)
    if decimals >= self.precision then return self:copy() end
    local newPrec = decimals
    local scale = getScale(self.precision)
    local scale_new = getScale(newPrec)
    local abs_scaled = self.scaled:copy()
    abs_scaled.sign = 1
    local factor = BigInt:new(10):pow(self.precision - newPrec)
    local half = BigInt:new(5) * (BigInt:new(10):pow(newPrec - 1))
    abs_scaled = (abs_scaled + half) / factor
    return BigFloat._fromScaled(abs_scaled, self.sign, newPrec)
end

-- ============================================================
-- 3.1 基本算术 (四则运算)
-- ============================================================
function FloatMeta.__add(a, b)
    local prec = math.max(a.precision, b.precision)
    -- 对齐精度
    local a2 = a:setPrecision(prec)
    local b2 = b:setPrecision(prec)
    local sum_scaled = a2.scaled + b2.scaled
    local sign = 1
    if sum_scaled.sign < 0 then
        sign = -1
        sum_scaled.sign = 1
    end
    -- 确保符号与 scaled 一致
    local res = BigFloat._fromScaled(sum_scaled, sign, prec)
    return res:setPrecision(math.min(a.precision, b.precision)) -- 返回原精度
end

function FloatMeta.__sub(a, b)
    local neg_b = b:copy()
    neg_b.sign = -neg_b.sign
    return a + neg_b
end

function FloatMeta.__mul(a, b)
    local prec = math.max(a.precision, b.precision)
    local a2 = a:setPrecision(prec)
    local b2 = b:setPrecision(prec)
    -- product = (A*B) / 10^prec
    local prod_scaled = a2.scaled * b2.scaled
    local scale = getScale(prec)
    -- 四舍五入
    local half = scale / BigInt:new(2)
    prod_scaled = (prod_scaled + half) / scale
    local sign = a.sign * b.sign
    if prod_scaled.sign < 0 then
        sign = -sign
        prod_scaled.sign = 1
    end
    local res = BigFloat._fromScaled(prod_scaled, sign, prec)
    return res:setPrecision(math.min(a.precision, b.precision))
end

function FloatMeta.__div(a, b)
    if b:toString() == "0" then error("除以零") end
    local prec = math.max(a.precision, b.precision) + 10  -- 保护位
    local a2 = a:setPrecision(prec)
    local b2 = b:setPrecision(prec)
    -- quotient = (A * 10^prec) / B (因为 a/b = (A/10^p)/(B/10^p) = A/B * 10^p)
    local scale = getScale(prec)
    local num = a2.scaled * scale
    local den = b2.scaled
    -- 四舍五入
    local half = den / BigInt:new(2)
    local quot_scaled = (num + half) / den
    local sign = a.sign * b.sign
    if quot_scaled.sign < 0 then
        sign = -sign
        quot_scaled.sign = 1
    end
    local res = BigFloat._fromScaled(quot_scaled, sign, prec)
    return res:setPrecision(math.min(a.precision, b.precision))
end

function FloatMeta.__unm(a)
    local new = a:copy()
    new.sign = -new.sign
    return new
end

-- ============================================================
-- 3.2 辅助工具：内部高精度运算
-- ============================================================
-- 内部使用更高的精度 (extra 位保护位) 进行迭代计算
local function withExtraPrecision(func, basePrec, extra)
    extra = extra or 20
    local workPrec = basePrec + extra
    -- 执行函数，传入工作精度，返回结果 BigFloat
    local result = func(workPrec)
    -- 截断到原精度
    return result:setPrecision(basePrec)
end

-- ===== BigInt 阶乘（带缓存） =====
local factCache = {}

function BigInt.factorial(n)
    if n < 0 then error("阶乘不支持负数") end
    if n <= 1 then return BigInt:new(1) end
    if factCache[n] then return factCache[n]:copy() end

    local res = BigInt:new(1)
    for i = 2, n do
        res = res * BigInt:new(i)
    end
    factCache[n] = res:copy()
    return res
end

-- 将 BigInt 转换为 BigFloat（缩放 = int * 10^prec）
function BigFloat.fromInt(int_num, prec)
    prec = prec or 50
    local scale = getScale(prec)
    local scaled = int_num * scale
    return BigFloat._fromScaled(scaled, 1, prec)
end

-- ============================================================
-- 3.3 常数：pi
-- ============================================================
local piCache = {}
-- ============================================================
-- π 计算 —— Chudnovsky 算法
-- 每迭代一项增加约 14.18 位精确小数
-- 收敛极快，可用于任意高精度
-- ============================================================
local piCache = {}

function BigFloat.pi(precision)
    if piCache[precision] then return piCache[precision]:copy() end
    if precision == nil then precision = 50 end

    local prec = precision + 20   -- 保护位
    local C = 640320
    local C3 = BigInt:new(C * C * C)

    -- 计算常数部分：12 / 640320^(3/2)
    local C_float = BigFloat:new(C, prec)
    local C_sqrt = BigFloat.sqrt(C_float)                    -- sqrt(640320)
    local C_pow_3_2 = C_sqrt * C_sqrt * C_sqrt              -- 640320^(3/2)
    local twelve = BigFloat:new(12, prec)
    local const = C_pow_3_2 / twelve                         -- 640320^(3/2) / 12

    local sum = BigFloat:new(0, prec)
    local k = 0
    local pow_c3 = BigInt:new(1)    -- 640320^(3k)，k=0 时为 1

    while true do
        local sixk = 6 * k
        local threek = 3 * k

        -- 计算阶乘
        local fact_sixk = BigInt.factorial(sixk)
        local fact_threek = BigInt.factorial(threek)
        local fact_k = BigInt.factorial(k)

        -- P(k) = 13591409 + 545140134 * k
        local P = BigInt:new(13591409 + 545140134 * k)

        -- 分子 = (6k)! * P(k)
        local num = fact_sixk * P
        -- 分母 = (3k)! * (k!)^3 * 640320^(3k)
        local den = fact_threek * fact_k * fact_k * fact_k * pow_c3

        -- 当前项 = num / den（作为 BigFloat）
        local term = BigFloat.fromInt(num, prec) / BigFloat.fromInt(den, prec)

        -- 按 (-1)^k 决定加减
        if k % 2 == 1 then
            sum = sum - term
        else
            sum = sum + term
        end

        -- ★ 收敛判断：如果这一项小到在当前精度下为 0，停止迭代
        if term:toString() == "0" then
            break
        end

        -- 更新下一次迭代
        k = k + 1
        pow_c3 = pow_c3 * C3   -- 640320^(3k)
    end

    -- 最终结果：π = 1 / ( const * sum )
    local inv_pi = const * sum
    local result = BigFloat:new(1, prec) / inv_pi

    -- 截断到用户要求的精度
    result = result:setPrecision(precision)
    piCache[precision] = result:copy()
    return result
end

-- ============================================================
-- 3.4 超越函数实现
-- ============================================================

-- exp(x) 使用级数 e^x = sum x^n/n!
-- 先缩小 x 到 [-1,1] 以保证快速收敛
function BigFloat.exp(x)
    if x:toString() == "0" then return BigFloat:new(1, x.precision) end
    local prec = x.precision
    local abs_x = x:copy()
    abs_x.sign = 1
    local n = 0
    local temp = abs_x:copy()
    while temp > BigFloat:new(1, prec) do
        temp = temp / BigFloat:new(2, prec)
        n = n + 1
    end
    -- 现在 temp 在 [0,1)
    local result = BigFloat:new(1, prec+20)
    local term = BigFloat:new(1, prec+20)
    local fact = BigFloat:new(1, prec+20)
    local one = BigFloat:new(1, prec+20)
    local x_work = temp:setPrecision(prec+20)
    if x.sign == -1 then x_work.sign = -1 end
    for i = 1, 100 do  -- 足够收敛
        fact = fact * BigFloat:new(i, prec+20)
        term = term * x_work
        local add = term / fact
        result = result + add
        if add:toString() == "0" then break end
    end
    -- 平方回去
    for i = 1, n do
        result = result * result
    end
    return result:setPrecision(prec)
end

-- ln(x) 使用牛顿法：y_{k+1} = y_k + 2*(x - exp(y_k))/(x + exp(y_k))
function BigFloat.ln(x)
    if x:toString() == "0" then error("ln(0) 无定义") end
    if x.sign == -1 then error("ln(负数) 无定义") end
    local prec = x.precision
    local one = BigFloat:new(1, prec+20)
    if x == one then return BigFloat:new(0, prec) end
    -- 初始猜测：使用位数估计
    local str = x:toString()
    local int_str = str:match("^(%d+)%.?") or "0"
    local exp_guess = #int_str - 1  -- 数量级
    local y = BigFloat:new(tostring(exp_guess), prec+20)
    -- 迭代
    for iter = 1, 30 do
        local exp_y = BigFloat.exp(y)
        local num = x:setPrecision(prec+20) - exp_y
        local den = x:setPrecision(prec+20) + exp_y
        local delta = (num / den) * BigFloat:new(2, prec+20)
        y = y + delta
        if delta:toString() == "0" then break end
    end
    return y:setPrecision(prec)
end

-- pow(a, b) = exp(b * ln(a))
function BigFloat.pow(a, b)
    if a:toString() == "0" then
        if b:toString() == "0" then error("0^0 无定义") end
        return BigFloat:new(0, a.precision)
    end
    local ln_a = BigFloat.ln(a:setPrecision(a.precision+20))
    local prod = b:setPrecision(a.precision+20) * ln_a
    return BigFloat.exp(prod):setPrecision(a.precision)
end

-- sqrt(x) 牛顿迭代
function BigFloat.sqrt(x)
    if x:toString() == "0" then return BigFloat:new(0, x.precision) end
    if x.sign == -1 then error("sqrt(负数) 无定义") end
    local prec = x.precision
    local one = BigFloat:new(1, prec+20)
    -- 初始猜测：使用数量级的一半
    local str = x:toString()
    local int_str = str:match("^(%d+)%.?") or "0"
    local len = #int_str
    local guess_str
    if len % 2 == 0 then
        guess_str = "1" .. string.rep("0", len/2 - 1)
    else
        guess_str = "3" .. string.rep("0", math.floor(len/2) - 1)
    end
    if guess_str == "" then guess_str = "1" end
    local y = BigFloat:new(guess_str, prec+20)
    for iter = 1, 30 do
        local y2 = y * y
        local diff = x:setPrecision(prec+20) - y2
        local delta = diff / (y * BigFloat:new(2, prec+20))
        y = y + delta
        if delta:toString() == "0" then break end
    end
    return y:setPrecision(prec)
end

-- 内部 atan (用于 pi)
function BigFloat._atan(x, prec)
    if x:toString() == "0" then return BigFloat:new(0, prec) end
    -- 用级数 atan(x) = sum (-1)^n x^(2n+1)/(2n+1)
    local result = BigFloat:new(0, prec)
    local term = x:setPrecision(prec)
    local x2 = x * x
    local n = 0
    while true do
        local add = term / BigFloat:new(2*n+1, prec)
        if n % 2 == 1 then add.sign = -add.sign end
        result = result + add
        term = term * x2
        if term:toString() == "0" then break end
        if add:toString() == "0" and n > 10 then break end
        n = n + 1
    end
    return result
end

-- atan(x) 用级数，若 |x|>1 用 atan(x) = pi/2 - atan(1/x)
function BigFloat.atan(x)
    local prec = x.precision
    local one = BigFloat:new(1, prec)
    if x:toString() == "0" then return BigFloat:new(0, prec) end
    if x > one then
        local inv = one / x
        local atan_inv = BigFloat._atan(inv, prec+20)
        local pi_half = BigFloat.pi(prec+20) / BigFloat:new(2, prec+20)
        return (pi_half - atan_inv):setPrecision(prec)
    elseif x < -one then
        local inv = one / x
        local atan_inv = BigFloat._atan(inv, prec+20)
        local pi_half = BigFloat.pi(prec+20) / BigFloat:new(2, prec+20)
        return (-pi_half - atan_inv):setPrecision(prec)
    else
        return BigFloat._atan(x, prec):setPrecision(prec)
    end
end

-- asin(x) = atan(x / sqrt(1-x^2))
function BigFloat.asin(x)
    if x:toString() == "0" then return BigFloat:new(0, x.precision) end
    local one = BigFloat:new(1, x.precision+20)
    local x2 = x:setPrecision(x.precision+20) * x:setPrecision(x.precision+20)
    local denom = BigFloat.sqrt(one - x2)
    return BigFloat.atan(x:setPrecision(x.precision+20) / denom):setPrecision(x.precision)
end

-- acos(x) = pi/2 - asin(x)
function BigFloat.acos(x)
    local prec = x.precision
    local pi_half = BigFloat.pi(prec+20) / BigFloat:new(2, prec+20)
    return (pi_half - BigFloat.asin(x:setPrecision(prec+20))):setPrecision(prec)
end

-- sin(x) 泰勒级数，先缩小到 [-pi, pi] 范围
function BigFloat.sin(x)
    if x:toString() == "0" then return BigFloat:new(0, x.precision) end
    local prec = x.precision
    local pi = BigFloat.pi(prec+20)
    local two_pi = pi * BigFloat:new(2, prec+20)
    -- 化简到 [-pi, pi]
    local y = x:setPrecision(prec+20)
    while y > pi do y = y - two_pi end
    while y < -pi do y = y + two_pi end
    -- 级数
    local result = BigFloat:new(0, prec+20)
    local term = y
    local n = 0
    while true do
        local add = term / BigFloat:new(2*n+1, prec+20)
        if n % 2 == 1 then add.sign = -add.sign end
        result = result + add
        term = term * y * y
        if term:toString() == "0" then break end
        if add:toString() == "0" and n > 10 then break end
        n = n + 1
        if n > 100 then break end
    end
    return result:setPrecision(prec)
end

-- cos(x) = sin(pi/2 - x)
function BigFloat.cos(x)
    local prec = x.precision
    local pi_half = BigFloat.pi(prec+20) / BigFloat:new(2, prec+20)
    return BigFloat.sin(pi_half - x:setPrecision(prec+20)):setPrecision(prec)
end

-- tan(x) = sin/cos
function BigFloat.tan(x)
    local prec = x.precision
    local s = BigFloat.sin(x:setPrecision(prec+20))
    local c = BigFloat.cos(x:setPrecision(prec+20))
    if c:toString() == "0" then error("tan 无定义 (cos=0)") end
    return (s / c):setPrecision(prec)
end

-- 双曲函数
function BigFloat.sinh(x)
    local prec = x.precision
    local ex = BigFloat.exp(x:setPrecision(prec+20))
    local en = BigFloat.exp(-x:setPrecision(prec+20))
    return ((ex - en) / BigFloat:new(2, prec+20)):setPrecision(prec)
end

function BigFloat.cosh(x)
    local prec = x.precision
    local ex = BigFloat.exp(x:setPrecision(prec+20))
    local en = BigFloat.exp(-x:setPrecision(prec+20))
    return ((ex + en) / BigFloat:new(2, prec+20)):setPrecision(prec)
end

function BigFloat.tanh(x)
    local prec = x.precision
    local s = BigFloat.sinh(x:setPrecision(prec+20))
    local c = BigFloat.cosh(x:setPrecision(prec+20))
    return (s / c):setPrecision(prec)
end

-- ============================================================
-- 3.5 类型转换和输出
-- ============================================================
FloatMeta.__tostring = BigFloat.toString
FloatMeta.__eq = function(a,b)
    if a.precision ~= b.precision then
        a = a:setPrecision(math.max(a.precision, b.precision))
        b = b:setPrecision(math.max(a.precision, b.precision))
    end
    return a.scaled == b.scaled and a.sign == b.sign
end
FloatMeta.__lt = function(a,b)
    return (a - b):sign == -1
end
FloatMeta.__le = function(a,b)
    return (a - b):sign <= 0
end

-- ============================================================
-- 4. 导出
-- ============================================================
local Decimal = {
    BigInt = BigInt,
    BigFloat = BigFloat,
    Int = BigInt.new,
    Float = BigFloat.new,
    pi = BigFloat.pi,
    exp = BigFloat.exp,
    ln = BigFloat.ln,
    sqrt = BigFloat.sqrt,
    pow = BigFloat.pow,
    sin = BigFloat.sin,
    cos = BigFloat.cos,
    tan = BigFloat.tan,
    asin = BigFloat.asin,
    acos = BigFloat.acos,
    atan = BigFloat.atan,
    sinh = BigFloat.sinh,
    cosh = BigFloat.cosh,
    tanh = BigFloat.tanh,
}

return Decimal
