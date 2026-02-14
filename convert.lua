    --thanks grok
--fixed by me

speed=15.0 --scroll
stepsplit = 8 --steps per beat
chartpath = "bismuth-chart.json"
metapath = "bismuth-metadata.json"
songname = "bismuth"
bg = "cover.jpg"


-- dont touch
pos=1
len=20
str=""
function skip_whitespace()
        while pos <= len do
            local c = str:sub(pos, pos)
            if not (c == " " or c == "\t" or c == "\n" or c == "\r") then break end
            pos = pos + 1
        end
    end
    function parse_string()
        pos = pos + 1  -- skip opening "
        local start = pos
        local result = ""
        while pos <= len do
            local c = str:sub(pos, pos)
            if c == "\\" then
                pos = pos + 1
                local esc = str:sub(pos, pos)
                if esc == '"' or esc == "\\" or esc == "/" then
                    result = result .. esc
                elseif esc == "n" then result = result .. "\n"
                elseif esc == "t" then result = result .. "\t"
                elseif esc == "r" then result = result .. "\r"
                else result = result .. "\\" .. esc end
                pos = pos + 1
            elseif c == '"' then
                pos = pos + 1
                return result
            else
                result = result .. c
                pos = pos + 1
            end
        end
        error("Unterminated string")
    end

    function parse_number()
        local start = pos
        while pos <= len do
            local c = str:sub(pos, pos)
            if not (c:match("[0-9.eE+-]")) then break end
            pos = pos + 1
        end
        local num_str = str:sub(start, pos-1)
        local num = tonumber(num_str)
        if not num then error("Invalid number: " .. num_str) end
        return num
    end

    function parse_array()
        local arr = {}
        pos = pos + 1  -- skip [
        skip_whitespace()
        if str:sub(pos, pos) == "]" then
            pos = pos + 1
            return arr
        end
        while true do
            table.insert(arr, parse_value())
            skip_whitespace()
            local c = str:sub(pos, pos)
            if c == "," then
                pos = pos + 1
                skip_whitespace()
            elseif c == "]" then
                pos = pos + 1
                return arr
            else
                error("Expected , or ] in array")
            end
        end
    end

    function parse_object()
        local obj = {}
        pos = pos + 1  -- skip {
        skip_whitespace()
        if str:sub(pos, pos) == "}" then
            pos = pos + 1
            return obj
        end
        while true do
            skip_whitespace()
            if str:sub(pos, pos) ~= '"' then
                error("Expected string key")
            end
            local key = parse_string()
            skip_whitespace()
            if str:sub(pos, pos) ~= ":" then
                error("Expected : after key")
            end
            pos = pos + 1
            local val = parse_value()
            obj[key] = val
            skip_whitespace()
            local c = str:sub(pos, pos)
            if c == "," then
                pos = pos + 1
            elseif c == "}" then
                pos = pos + 1
                return obj
            else
                error("Expected , or } in object")
            end
        end
    end
    function parse_value()
        skip_whitespace()
        local c = str:sub(pos, pos)
        if c == "{" then
            return parse_object()
        elseif c == "[" then
            return parse_array()
        elseif c == '"' then
            return parse_string()
        elseif c == "t" and str:sub(pos, pos+3) == "true" then
            pos = pos + 4
            return true
        elseif c == "f" and str:sub(pos, pos+4) == "false" then
            pos = pos + 5
            return false
        elseif c == "n" and str:sub(pos, pos+3) == "null" then
            pos = pos + 4
            return nil
        elseif c:match("[-%d]") then
            return parse_number()
        else
            error("Unexpected character at " .. pos .. ": " .. c)
        end
    end

local function json_decode(stre)
    pos = 1
    str=stre
    len = #str
    


    local result = parse_value()
    skip_whitespace()
    if pos <= len then
        error("Extra characters after JSON")
    end
    return result
end

-- Simple encoder (same as before)
local function json_encode(value)
    local t = type(value)
    if t == "nil" then return "null" end
    if t == "boolean" then return value and "true" or "false" end
    if t == "number" then return tostring(value) end
    if t == "string" then
        return '"' .. value:gsub('[%c\\"]', function(c)
            if c == '"'  then return '\\"' end
            if c == "\\" then return "\\\\" end
            if c == "\n" then return "\\n" end
            if c == "\r" then return "\\r" end
            if c == "\t" then return "\\t" end
            return "\\" .. string.format("%03d", c:byte())
        end) .. '"'
    end
    if t == "table" then
        local is_array = #value > 0
        local parts = {}
        if is_array then
            for _, v in ipairs(value) do
                parts[#parts+1] = json_encode(v)
            end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            for k, v in pairs(value) do
                parts[#parts+1] = json_encode(tostring(k)) .. ":" .. json_encode(v)
            end
            return "{" .. table.concat(parts, ",") .. "}"
        end
    end
    return "null"
end

-------------------------------------------------------
-- Conversion function – takes JSON strings
-------------------------------------------------------
function fnf_json_to_phigros(chart_json_str, metadata_json_str)
    local chart    = json_decode(chart_json_str)
    local metadata = json_decode(metadata_json_str)

    -- Fallbacks
    local song_name   = metadata.songName   or "Unknown Song"
    local artist      = metadata.artist     or "Unknown Artist"
    local charter     = metadata.charter    or "Unknown Charter"
    local time_changes = metadata.timeChanges or {{t=0, bpm=120}}
    local notes_list   = chart.notes and chart.notes.normal or {}

    -- Player lane → Phigros X position
    local spacing=250
    local lane_to_x = {[-1]=0, [0]=-spacing*1.5, [1]=-spacing/2, [2]=spacing/2, [3]=spacing*1.5}

    local ph_notes = {}
    -- Very basic BPM list (timestamps in seconds)
    local bpm_list = {}
    
        local l = 0.0001
        local itis = function(a,b)
        return math.abs(a-b)<=l
        end
        
    local function getb(mss)
    local total = 0
    for i, seg in ipairs(time_changes) do
        local next_t = time_changes[i+1] and time_changes[i+1].t or 9e9
        if seg.t <= mss and mss < next_t then
            for j = 1, i-1 do
                local prev = time_changes[j]
                local p_next = time_changes[j+1].t
                total = total + (p_next - prev.t) * prev.bpm / 60000
            end
            total = total + (mss - seg.t) * seg.bpm / 60000
            return total
        end
    end
    return total
end
    for _, tc in ipairs(time_changes) do
        local ms = tc.t or 0
        local beat = getb(ms)
        local beat_int = math.floor(beat)
        local other = beat - beat_int
        local fenzi = 0
        local fenmu = 1

        for i=0,stepsplit do
        if itis(other,i/stepsplit) then
        fenzi =i
        fenmu= stepsplit
        while fenzi%2 == 0 and fenmu%2 == 0 do
        fenzi=fenzi /2
        fenmu=fenmu/2
                end
        end
        
        end
        
        table.insert(bpm_list, {
            bpm = tc.bpm,
            startTime = {beat_int, fenzi, fenmu}
        })
    end


    for _, note in ipairs(notes_list) do
        local lane = note.d
        if lane >= 0 and lane <= 3 then  -- player notes only
            local ms = note.t or 0
            local len = note.l or 0

            local is_hold = len >= 100

        
        local beat = getb(ms)
        local beat_int = math.floor(beat)
        local other = beat - beat_int
        local fenzi = 0
        local fenmu = 1
        for i=0,stepsplit do
             if itis(other,i/stepsplit) then
        
        fenzi =i
        fenmu=stepsplit 
        
        while fenzi%2 == 0 and fenmu%2 == 0 do
        fenzi=fenzi /2
        fenmu=fenmu/2
                end
                if i==0 then 
        fenmu=1
                end
            end 
        end
            local entry = {
                above       = 1,
                alpha       = 255,
                isFake      = 0,
                positionX   = lane_to_x[lane],
                size        = 1.0,
                speed       = 1.0,
                visibleTime = 999999.0,
                yOffset     = 0.0,
                type        = is_hold and 2 or 1,
                startTime   = {beat_int, fenzi, fenmu},
                endTime     = {beat_int, fenzi, fenmu}
            }

            if is_hold then
                local e_ms = ms + len
                
        local beat = getb(e_ms)
        local beat_int = math.floor(beat)
        local other = beat - beat_int
        local fenzi = 0
        local fenmu = 1
        for i=0,stepsplit do
        if itis(other,i/stepsplit) then
        
        fenzi =i
        fenmu=stepsplit
        
while fenzi%2 == 0 and fenmu%2 == 0 do
        fenzi=fenzi /2
        fenmu=fenmu/2
                end
        if i==0 then 
        fenmu=1
        end
        end end
                
                entry.endTime = {beat_int, fenzi, fenmu}
            end

            table.insert(ph_notes, entry)
        end
    end

    -- Phigros chart structure
    local phigros = {
        BPMList = bpm_list,

        META = {
            RPEVersion = 140,
            background = bg,
            charter    = charter,
            composer   = artist,
            id         = "converted",
            level      = "4K",
            name       = song_name,
            offset     = 0,
            song       = songname..".ogg"
        },

        judgeLineGroup = {"Default"},

        judgeLineList = {
            {
                Group = 0,
                Name = "Main",
                Texture = "line.png",
                alphaControl = {
                    {alpha=1.0, easing=1, x=0.0},
                    {alpha=1.0, easing=1, x=9999999.0}
                },
                bpmfactor = 1.0,
                eventLayers = {
                    {
                        alphaEvents = {{bezier=0, bezierPoints={0,0,0,0}, easingLeft=0, easingRight=1, easingType=1, ['end']=255, endTime={1,0,1}, linkgroup=0, start=255, startTime={0,0,1}}},
                        moveXEvents = {{bezier=0, bezierPoints={0,0,0,0}, easingLeft=0, easingRight=1, easingType=1, ['end']=0.0, endTime={1,0,1}, linkgroup=0, start=0.0, startTime={0,0,1}}},
                        moveYEvents = {{bezier=0, bezierPoints={0,0,0,0}, easingLeft=0, easingRight=1, easingType=1, ['end']=-300.0, endTime={1,0,1}, linkgroup=0, start=-300.0, startTime={0,0,1}}},
                        rotateEvents = {{bezier=0, bezierPoints={0,0,0,0}, easingLeft=0, easingRight=1, easingType=1, ['end']=0.0, endTime={1,0,1}, linkgroup=0, start=0.0, startTime={0,0,1}}},
                        speedEvents = {{['end']=speed, endTime={1,0,1}, linkgroup=0, start=speed, startTime={0,0,1}}}
                    }
                },
                extended = {
                    inclineEvents = {{bezier=0, bezierPoints={0,0,0,0}, easingLeft=0, easingRight=1, easingType=0, ['end']=0.0, endTime={1,0,1}, linkgroup=0, start=0.0, startTime={0,0,1}}}
                },
                father = -1,
                isCover = 1,
                notes = ph_notes
            }
        }
    }

    return phigros
end

-- ────────────────────────────────────────────────
-- Example usage (Psych Engine style)
-- ────────────────────────────────────────────────

function onCreate()
luaDebugMode =true
local chart_json    = getTextFromFile(chartpath)
local metadata_json = getTextFromFile(metapath)

local phigros_table = fnf_json_to_phigros(chart_json, metadata_json)

-- Then you can encode it again if needed
local phigros_json_string = json_encode(phigros_table)

saveFile(songname..".json", phigros_json_string)
-- debugPrint("Converted!")
end
