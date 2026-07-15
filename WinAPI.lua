--[[
    Windows API 完整封装模块 (User32.dll)
    专为 FNF 模组 Lua 环境设计
    包含所有 User32 函数、常量、结构体和指针工具
    版本: 3.0.0
]]

local WinAPI = {}

-- ============================================================
-- 1. 基础常量定义
-- ============================================================

WinAPI.TRUE = 1
WinAPI.FALSE = 0
WinAPI.NULL = 0

-- ============================================================
-- 1.1 窗口扩展样式 (GWL_EXSTYLE)
-- ============================================================
WinAPI.WS_EX_DLGMODALFRAME    = 0x00000001
WinAPI.WS_EX_NOPARENTNOTIFY   = 0x00000004
WinAPI.WS_EX_TOPMOST          = 0x00000008
WinAPI.WS_EX_ACCEPTFILES      = 0x00000010
WinAPI.WS_EX_TRANSPARENT      = 0x00000020
WinAPI.WS_EX_MDICHILD         = 0x00000040
WinAPI.WS_EX_TOOLWINDOW       = 0x00000080
WinAPI.WS_EX_WINDOWEDGE       = 0x00000100
WinAPI.WS_EX_CLIENTEDGE       = 0x00000200
WinAPI.WS_EX_OVERLAPPEDWINDOW = 0x00000300
WinAPI.WS_EX_PALETTEWINDOW    = 0x00000188
WinAPI.WS_EX_LAYERED          = 0x00080000
WinAPI.WS_EX_NOINHERITLAYOUT  = 0x00100000
WinAPI.WS_EX_LAYOUTRTL        = 0x00400000
WinAPI.WS_EX_COMPOSITED       = 0x02000000
WinAPI.WS_EX_NOACTIVATE       = 0x08000000
WinAPI.WS_EX_APPWINDOW        = 0x00040000
WinAPI.WS_EX_LEFT             = 0x00000000
WinAPI.WS_EX_RIGHT            = 0x00001000
WinAPI.WS_EX_RTLREADING       = 0x00002000
WinAPI.WS_EX_LEFTSCROLLBAR    = 0x00004000
WinAPI.WS_EX_CONTROLPARENT    = 0x00010000
WinAPI.WS_EX_STATICEDGE       = 0x00020000

-- ============================================================
-- 1.2 窗口样式 (GWL_STYLE)
-- ============================================================
WinAPI.WS_OVERLAPPED          = 0x00000000
WinAPI.WS_POPUP               = 0x80000000
WinAPI.WS_CHILD               = 0x40000000
WinAPI.WS_MINIMIZE            = 0x20000000
WinAPI.WS_VISIBLE             = 0x10000000
WinAPI.WS_DISABLED            = 0x08000000
WinAPI.WS_CLIPSIBLINGS        = 0x04000000
WinAPI.WS_CLIPCHILDREN        = 0x02000000
WinAPI.WS_MAXIMIZE            = 0x01000000
WinAPI.WS_CAPTION             = 0x00C00000
WinAPI.WS_BORDER              = 0x00800000
WinAPI.WS_DLGFRAME            = 0x00400000
WinAPI.WS_VSCROLL             = 0x00200000
WinAPI.WS_HSCROLL             = 0x00100000
WinAPI.WS_SYSMENU             = 0x00080000
WinAPI.WS_THICKFRAME          = 0x00040000
WinAPI.WS_GROUP               = 0x00020000
WinAPI.WS_TABSTOP             = 0x00010000
WinAPI.WS_MINIMIZEBOX         = 0x00020000
WinAPI.WS_MAXIMIZEBOX         = 0x00010000
WinAPI.WS_OVERLAPPEDWINDOW    = 0x00CF0000
WinAPI.WS_POPUPWINDOW         = 0x80880000
WinAPI.WS_CHILDWINDOW         = 0x40000000
WinAPI.WS_TILED               = 0x00000000
WinAPI.WS_ICONIC              = 0x20000000
WinAPI.WS_SIZEBOX             = 0x00040000
WinAPI.WS_TILEDWINDOW         = 0x00CF0000

-- ============================================================
-- 1.3 SetWindowLong 索引 (nIndex)
-- ============================================================
WinAPI.GWL_WNDPROC            = -4
WinAPI.GWL_HINSTANCE          = -6
WinAPI.GWL_HWNDPARENT         = -8
WinAPI.GWL_STYLE              = -16
WinAPI.GWL_EXSTYLE            = -20
WinAPI.GWL_USERDATA           = -21
WinAPI.GWL_ID                 = -12

WinAPI.GCL_WNDPROC            = -24
WinAPI.GCL_HBRBACKGROUND      = -10
WinAPI.GCL_HCURSOR            = -12
WinAPI.GCL_HICON              = -14
WinAPI.GCL_HMODULE            = -16
WinAPI.GCL_CBWNDEXTRA         = -18
WinAPI.GCL_CBCLSEXTRA         = -20
WinAPI.GCL_STYLE              = -26
WinAPI.GCL_MENUNAME           = -8

-- ============================================================
-- 1.4 SetLayeredWindowAttributes 标志
-- ============================================================
WinAPI.LWA_COLORKEY           = 0x00000001
WinAPI.LWA_ALPHA              = 0x00000002

-- ============================================================
-- 1.5 窗口消息 (Window Messages) - 完整版
-- ============================================================
WinAPI.WM_NULL                = 0x0000
WinAPI.WM_CREATE              = 0x0001
WinAPI.WM_DESTROY             = 0x0002
WinAPI.WM_MOVE                = 0x0003
WinAPI.WM_SIZE                = 0x0005
WinAPI.WM_ACTIVATE            = 0x0006
WinAPI.WM_SETFOCUS            = 0x0007
WinAPI.WM_KILLFOCUS           = 0x0008
WinAPI.WM_ENABLE              = 0x000A
WinAPI.WM_SETREDRAW           = 0x000B
WinAPI.WM_SETTEXT             = 0x000C
WinAPI.WM_GETTEXT             = 0x000D
WinAPI.WM_GETTEXTLENGTH       = 0x000E
WinAPI.WM_PAINT               = 0x000F
WinAPI.WM_CLOSE               = 0x0010
WinAPI.WM_QUERYENDSESSION     = 0x0011
WinAPI.WM_QUIT                = 0x0012
WinAPI.WM_QUERYOPEN           = 0x0013
WinAPI.WM_ERASEBKGND          = 0x0014
WinAPI.WM_SYSCOLORCHANGE      = 0x0015
WinAPI.WM_ENDSESSION          = 0x0016
WinAPI.WM_SHOWWINDOW          = 0x0018
WinAPI.WM_CTLCOLOR            = 0x0019
WinAPI.WM_WININICHANGE        = 0x001A
WinAPI.WM_SETTINGCHANGE       = 0x001A
WinAPI.WM_DEVMODECHANGE       = 0x001B
WinAPI.WM_ACTIVATEAPP         = 0x001C
WinAPI.WM_FONTCHANGE          = 0x001D
WinAPI.WM_TIMECHANGE          = 0x001E
WinAPI.WM_CANCELMODE          = 0x001F
WinAPI.WM_SETCURSOR           = 0x0020
WinAPI.WM_MOUSEACTIVATE       = 0x0021
WinAPI.WM_CHILDACTIVATE       = 0x0022
WinAPI.WM_QUEUESYNC           = 0x0023
WinAPI.WM_GETMINMAXINFO       = 0x0024
WinAPI.WM_PAINTICON           = 0x0026
WinAPI.WM_ICONERASEBKGND      = 0x0027
WinAPI.WM_NEXTDLGCTL          = 0x0028
WinAPI.WM_SPOOLERSTATUS       = 0x002A
WinAPI.WM_DRAWITEM            = 0x002B
WinAPI.WM_MEASUREITEM         = 0x002C
WinAPI.WM_DELETEITEM          = 0x002D
WinAPI.WM_VKEYTOITEM          = 0x002E
WinAPI.WM_CHARTOITEM          = 0x002F
WinAPI.WM_SETFONT             = 0x0030
WinAPI.WM_GETFONT             = 0x0031
WinAPI.WM_SETHOTKEY           = 0x0032
WinAPI.WM_GETHOTKEY           = 0x0033
WinAPI.WM_QUERYDRAGICON       = 0x0037
WinAPI.WM_COMPAREITEM         = 0x0039
WinAPI.WM_GETOBJECT           = 0x003D
WinAPI.WM_COMPACTING          = 0x0041
WinAPI.WM_COMMNOTIFY          = 0x0044
WinAPI.WM_WINDOWPOSCHANGING   = 0x0046
WinAPI.WM_WINDOWPOSCHANGED    = 0x0047
WinAPI.WM_POWER               = 0x0048
WinAPI.WM_COPYDATA            = 0x004A
WinAPI.WM_CANCELJOURNAL       = 0x004B
WinAPI.WM_NOTIFY              = 0x004E
WinAPI.WM_INPUTLANGCHANGEREQUEST = 0x0050
WinAPI.WM_INPUTLANGCHANGE     = 0x0051
WinAPI.WM_TCARD               = 0x0052
WinAPI.WM_HELP                = 0x0053
WinAPI.WM_USERCHANGED         = 0x0054
WinAPI.WM_NOTIFYFORMAT        = 0x0055
WinAPI.WM_CONTEXTMENU         = 0x007B
WinAPI.WM_STYLECHANGING       = 0x007C
WinAPI.WM_STYLECHANGED        = 0x007D
WinAPI.WM_DISPLAYCHANGE       = 0x007E
WinAPI.WM_GETICON             = 0x007F
WinAPI.WM_SETICON             = 0x0080
WinAPI.WM_NCCREATE            = 0x0081
WinAPI.WM_NCDESTROY           = 0x0082
WinAPI.WM_NCCALCSIZE          = 0x0083
WinAPI.WM_NCHITTEST           = 0x0084
WinAPI.WM_NCPAINT             = 0x0085
WinAPI.WM_NCACTIVATE          = 0x0086
WinAPI.WM_GETDLGCODE          = 0x0087
WinAPI.WM_SYNCPAINT           = 0x0088
WinAPI.WM_NCMOUSEMOVE         = 0x00A0
WinAPI.WM_NCLBUTTONDOWN       = 0x00A1
WinAPI.WM_NCLBUTTONUP         = 0x00A2
WinAPI.WM_NCLBUTTONDBLCLK     = 0x00A3
WinAPI.WM_NCRBUTTONDOWN       = 0x00A4
WinAPI.WM_NCRBUTTONUP         = 0x00A5
WinAPI.WM_NCRBUTTONDBLCLK     = 0x00A6
WinAPI.WM_NCMBUTTONDOWN       = 0x00A7
WinAPI.WM_NCMBUTTONUP         = 0x00A8
WinAPI.WM_NCMBUTTONDBLCLK     = 0x00A9
WinAPI.WM_NCXBUTTONDOWN       = 0x00AB
WinAPI.WM_NCXBUTTONUP         = 0x00AC
WinAPI.WM_NCXBUTTONDBLCLK     = 0x00AD
WinAPI.WM_INPUT               = 0x00FF
WinAPI.WM_KEYDOWN             = 0x0100
WinAPI.WM_KEYUP               = 0x0101
WinAPI.WM_CHAR                = 0x0102
WinAPI.WM_DEADCHAR            = 0x0103
WinAPI.WM_SYSKEYDOWN          = 0x0104
WinAPI.WM_SYSKEYUP            = 0x0105
WinAPI.WM_SYSCHAR             = 0x0106
WinAPI.WM_SYSDEADCHAR         = 0x0107
WinAPI.WM_UNICHAR             = 0x0109
WinAPI.WM_KEYLAST             = 0x0109
WinAPI.WM_IME_STARTCOMPOSITION = 0x010D
WinAPI.WM_IME_ENDCOMPOSITION  = 0x010E
WinAPI.WM_IME_COMPOSITION     = 0x010F
WinAPI.WM_IME_KEYLAST         = 0x010F
WinAPI.WM_INITDIALOG          = 0x0110
WinAPI.WM_COMMAND             = 0x0111
WinAPI.WM_SYSCOMMAND          = 0x0112
WinAPI.WM_TIMER               = 0x0113
WinAPI.WM_HSCROLL             = 0x0114
WinAPI.WM_VSCROLL             = 0x0115
WinAPI.WM_INITMENU            = 0x0116
WinAPI.WM_INITMENUPOPUP       = 0x0117
WinAPI.WM_MENUSELECT          = 0x011F
WinAPI.WM_MENUCHAR            = 0x0120
WinAPI.WM_ENTERIDLE           = 0x0121
WinAPI.WM_MENURBUTTONUP       = 0x0122
WinAPI.WM_MENUDRAG            = 0x0123
WinAPI.WM_MENUGETOBJECT       = 0x0124
WinAPI.WM_UNINITMENUPOPUP     = 0x0125
WinAPI.WM_MENUCOMMAND         = 0x0126
WinAPI.WM_CHANGEUISTATE       = 0x0127
WinAPI.WM_UPDATEUISTATE       = 0x0128
WinAPI.WM_QUERYUISTATE        = 0x0129
WinAPI.WM_CTLCOLORMSGBOX      = 0x0132
WinAPI.WM_CTLCOLOREDIT        = 0x0133
WinAPI.WM_CTLCOLORLISTBOX     = 0x0134
WinAPI.WM_CTLCOLORBTN         = 0x0135
WinAPI.WM_CTLCOLORDLG         = 0x0136
WinAPI.WM_CTLCOLORSCROLLBAR   = 0x0137
WinAPI.WM_CTLCOLORSTATIC      = 0x0138
WinAPI.WM_MOUSEMOVE           = 0x0200
WinAPI.WM_LBUTTONDOWN         = 0x0201
WinAPI.WM_LBUTTONUP           = 0x0202
WinAPI.WM_LBUTTONDBLCLK       = 0x0203
WinAPI.WM_RBUTTONDOWN         = 0x0204
WinAPI.WM_RBUTTONUP           = 0x0205
WinAPI.WM_RBUTTONDBLCLK       = 0x0206
WinAPI.WM_MBUTTONDOWN         = 0x0207
WinAPI.WM_MBUTTONUP           = 0x0208
WinAPI.WM_MBUTTONDBLCLK       = 0x0209
WinAPI.WM_MOUSEWHEEL          = 0x020A
WinAPI.WM_XBUTTONDOWN         = 0x020B
WinAPI.WM_XBUTTONUP           = 0x020C
WinAPI.WM_XBUTTONDBLCLK       = 0x020D
WinAPI.WM_MOUSELAST           = 0x020D
WinAPI.WM_PARENTNOTIFY        = 0x0210
WinAPI.WM_ENTERMENULOOP       = 0x0211
WinAPI.WM_EXITMENULOOP        = 0x0212
WinAPI.WM_NEXTMENU            = 0x0213
WinAPI.WM_SIZING              = 0x0214
WinAPI.WM_CAPTURECHANGED      = 0x0215
WinAPI.WM_MOVING              = 0x0216
WinAPI.WM_POWERBROADCAST      = 0x0218
WinAPI.WM_DEVICECHANGE        = 0x0219
WinAPI.WM_MDICREATE           = 0x0220
WinAPI.WM_MDIDESTROY          = 0x0221
WinAPI.WM_MDIACTIVATE         = 0x0222
WinAPI.WM_MDIRESTORE          = 0x0223
WinAPI.WM_MDINEXT             = 0x0224
WinAPI.WM_MDIMAXIMIZE         = 0x0225
WinAPI.WM_MDITILE             = 0x0226
WinAPI.WM_MDICASCADE          = 0x0227
WinAPI.WM_MDIICONARRANGE      = 0x0228
WinAPI.WM_MDIGETACTIVE        = 0x0229
WinAPI.WM_MDISETMENU          = 0x0230
WinAPI.WM_ENTERSIZEMOVE       = 0x0231
WinAPI.WM_EXITSIZEMOVE        = 0x0232
WinAPI.WM_DROPFILES           = 0x0233
WinAPI.WM_MDIREFRESHMENU      = 0x0234
WinAPI.WM_IME_SETCONTEXT      = 0x0281
WinAPI.WM_IME_NOTIFY          = 0x0282
WinAPI.WM_IME_CONTROL         = 0x0283
WinAPI.WM_IME_COMPOSITIONFULL = 0x0284
WinAPI.WM_IME_SELECT          = 0x0285
WinAPI.WM_IME_CHAR            = 0x0286
WinAPI.WM_IME_REQUEST         = 0x0288
WinAPI.WM_IME_KEYDOWN         = 0x0290
WinAPI.WM_IME_KEYUP           = 0x0291
WinAPI.WM_MOUSEHOVER          = 0x02A1
WinAPI.WM_MOUSELEAVE          = 0x02A3
WinAPI.WM_NCMOUSEHOVER        = 0x02A0
WinAPI.WM_NCMOUSELEAVE        = 0x02A2
WinAPI.WM_WTSSESSION_CHANGE   = 0x02B1
WinAPI.WM_TABLET_FIRST        = 0x02C0
WinAPI.WM_TABLET_LAST         = 0x02DF
WinAPI.WM_DPICHANGED          = 0x02E0
WinAPI.WM_CUT                 = 0x0300
WinAPI.WM_COPY                = 0x0301
WinAPI.WM_PASTE               = 0x0302
WinAPI.WM_CLEAR               = 0x0303
WinAPI.WM_UNDO                = 0x0304
WinAPI.WM_RENDERFORMAT        = 0x0305
WinAPI.WM_RENDERALLFORMATS    = 0x0306
WinAPI.WM_DESTROYCLIPBOARD    = 0x0307
WinAPI.WM_DRAWCLIPBOARD       = 0x0308
WinAPI.WM_PAINTCLIPBOARD      = 0x0309
WinAPI.WM_VSCROLLCLIPBOARD    = 0x030A
WinAPI.WM_SIZECLIPBOARD       = 0x030B
WinAPI.WM_ASKCBFORMATNAME     = 0x030C
WinAPI.WM_CHANGECBCHAIN       = 0x030D
WinAPI.WM_HSCROLLCLIPBOARD    = 0x030E
WinAPI.WM_QUERYNEWPALETTE     = 0x030F
WinAPI.WM_PALETTEISCHANGING   = 0x0310
WinAPI.WM_PALETTECHANGED      = 0x0311
WinAPI.WM_HOTKEY              = 0x0312
WinAPI.WM_PRINT               = 0x0317
WinAPI.WM_PRINTCLIENT         = 0x0318
WinAPI.WM_APPCOMMAND          = 0x0319
WinAPI.WM_THEMECHANGED        = 0x031A
WinAPI.WM_CLIPBOARDUPDATE     = 0x031D
WinAPI.WM_DWMCOMPOSITIONCHANGED = 0x031E
WinAPI.WM_DWMNCRENDERINGCHANGED = 0x031F
WinAPI.WM_DWMCOLORIZATIONCOLORCHANGED = 0x0320
WinAPI.WM_DWMWINDOWMAXIMIZEDCHANGE = 0x0321
WinAPI.WM_GETTITLEBARINFOEX   = 0x033F
WinAPI.WM_APP                 = 0x8000
WinAPI.WM_USER                = 0x0400

-- ============================================================
-- 1.6 系统命令 (WM_SYSCOMMAND)
-- ============================================================
WinAPI.SC_SIZE                = 0xF000
WinAPI.SC_MOVE                = 0xF010
WinAPI.SC_MINIMIZE            = 0xF020
WinAPI.SC_MAXIMIZE            = 0xF030
WinAPI.SC_NEXTWINDOW          = 0xF040
WinAPI.SC_PREVWINDOW          = 0xF050
WinAPI.SC_CLOSE               = 0xF060
WinAPI.SC_VSCROLL             = 0xF070
WinAPI.SC_HSCROLL             = 0xF080
WinAPI.SC_MOUSEMENU           = 0xF090
WinAPI.SC_KEYMENU             = 0xF100
WinAPI.SC_ARRANGE             = 0xF110
WinAPI.SC_RESTORE             = 0xF120
WinAPI.SC_TASKLIST            = 0xF130
WinAPI.SC_SCREENSAVE          = 0xF140
WinAPI.SC_HOTKEY              = 0xF150
WinAPI.SC_DEFAULT             = 0xF160
WinAPI.SC_MONITORPOWER        = 0xF170
WinAPI.SC_CONTEXTHELP         = 0xF180
WinAPI.SC_SEPARATOR           = 0xF00F
WinAPI.SC_ICON                = 0xF020
WinAPI.SC_ZOOM                = 0xF030

-- ============================================================
-- 1.7 显示窗口命令 (ShowWindow)
-- ============================================================
WinAPI.SW_HIDE                = 0
WinAPI.SW_SHOWNORMAL          = 1
WinAPI.SW_NORMAL              = 1
WinAPI.SW_SHOWMINIMIZED       = 2
WinAPI.SW_SHOWMAXIMIZED       = 3
WinAPI.SW_MAXIMIZE            = 3
WinAPI.SW_SHOWNOACTIVATE      = 4
WinAPI.SW_SHOW                = 5
WinAPI.SW_MINIMIZE            = 6
WinAPI.SW_SHOWMINNOACTIVE     = 7
WinAPI.SW_SHOWNA              = 8
WinAPI.SW_RESTORE             = 9
WinAPI.SW_SHOWDEFAULT         = 10
WinAPI.SW_FORCEMINIMIZE       = 11
WinAPI.SW_MAX                 = 11

-- ============================================================
-- 1.8 设置窗口位置标志 (SetWindowPos)
-- ============================================================
WinAPI.SWP_NOSIZE             = 0x0001
WinAPI.SWP_NOMOVE             = 0x0002
WinAPI.SWP_NOZORDER           = 0x0004
WinAPI.SWP_NOREDRAW           = 0x0008
WinAPI.SWP_NOACTIVATE         = 0x0010
WinAPI.SWP_FRAMECHANGED       = 0x0020
WinAPI.SWP_SHOWWINDOW         = 0x0040
WinAPI.SWP_HIDEWINDOW         = 0x0080
WinAPI.SWP_NOCOPYBITS         = 0x0100
WinAPI.SWP_NOOWNERZORDER      = 0x0200
WinAPI.SWP_NOSENDCHANGING     = 0x0400
WinAPI.SWP_DRAWFRAME          = 0x0020
WinAPI.SWP_NOREPOSITION       = 0x0200
WinAPI.SWP_DEFERERASE         = 0x2000
WinAPI.SWP_ASYNCWINDOWPOS     = 0x4000

WinAPI.HWND_TOP               = 0
WinAPI.HWND_BOTTOM            = 1
WinAPI.HWND_TOPMOST           = -1
WinAPI.HWND_NOTOPMOST         = -2

-- ============================================================
-- 1.9 虚拟键码 (Virtual Keys) - 完整版
-- ============================================================
WinAPI.VK_LBUTTON             = 0x01
WinAPI.VK_RBUTTON             = 0x02
WinAPI.VK_CANCEL              = 0x03
WinAPI.VK_MBUTTON             = 0x04
WinAPI.VK_XBUTTON1            = 0x05
WinAPI.VK_XBUTTON2            = 0x06
WinAPI.VK_BACK                = 0x08
WinAPI.VK_TAB                 = 0x09
WinAPI.VK_CLEAR               = 0x0C
WinAPI.VK_RETURN              = 0x0D
WinAPI.VK_SHIFT               = 0x10
WinAPI.VK_CONTROL             = 0x11
WinAPI.VK_MENU                = 0x12
WinAPI.VK_PAUSE               = 0x13
WinAPI.VK_CAPITAL             = 0x14
WinAPI.VK_KANA                = 0x15
WinAPI.VK_HANGEUL             = 0x15
WinAPI.VK_HANGUL              = 0x15
WinAPI.VK_JUNJA               = 0x17
WinAPI.VK_FINAL               = 0x18
WinAPI.VK_HANJA               = 0x19
WinAPI.VK_KANJI               = 0x19
WinAPI.VK_ESCAPE              = 0x1B
WinAPI.VK_CONVERT             = 0x1C
WinAPI.VK_NONCONVERT          = 0x1D
WinAPI.VK_ACCEPT              = 0x1E
WinAPI.VK_MODECHANGE          = 0x1F
WinAPI.VK_SPACE               = 0x20
WinAPI.VK_PRIOR               = 0x21
WinAPI.VK_NEXT                = 0x22
WinAPI.VK_END                 = 0x23
WinAPI.VK_HOME                = 0x24
WinAPI.VK_LEFT                = 0x25
WinAPI.VK_UP                  = 0x26
WinAPI.VK_RIGHT               = 0x27
WinAPI.VK_DOWN                = 0x28
WinAPI.VK_SELECT              = 0x29
WinAPI.VK_PRINT               = 0x2A
WinAPI.VK_EXECUTE             = 0x2B
WinAPI.VK_SNAPSHOT            = 0x2C
WinAPI.VK_INSERT              = 0x2D
WinAPI.VK_DELETE              = 0x2E
WinAPI.VK_HELP                = 0x2F
WinAPI.VK_LWIN                = 0x5B
WinAPI.VK_RWIN                = 0x5C
WinAPI.VK_APPS                = 0x5D
WinAPI.VK_SLEEP               = 0x5F
WinAPI.VK_NUMPAD0             = 0x60
WinAPI.VK_NUMPAD1             = 0x61
WinAPI.VK_NUMPAD2             = 0x62
WinAPI.VK_NUMPAD3             = 0x63
WinAPI.VK_NUMPAD4             = 0x64
WinAPI.VK_NUMPAD5             = 0x65
WinAPI.VK_NUMPAD6             = 0x66
WinAPI.VK_NUMPAD7             = 0x67
WinAPI.VK_NUMPAD8             = 0x68
WinAPI.VK_NUMPAD9             = 0x69
WinAPI.VK_MULTIPLY            = 0x6A
WinAPI.VK_ADD                 = 0x6B
WinAPI.VK_SEPARATOR           = 0x6C
WinAPI.VK_SUBTRACT            = 0x6D
WinAPI.VK_DECIMAL             = 0x6E
WinAPI.VK_DIVIDE              = 0x6F
WinAPI.VK_F1                  = 0x70
WinAPI.VK_F2                  = 0x71
WinAPI.VK_F3                  = 0x72
WinAPI.VK_F4                  = 0x73
WinAPI.VK_F5                  = 0x74
WinAPI.VK_F6                  = 0x75
WinAPI.VK_F7                  = 0x76
WinAPI.VK_F8                  = 0x77
WinAPI.VK_F9                  = 0x78
WinAPI.VK_F10                 = 0x79
WinAPI.VK_F11                 = 0x7A
WinAPI.VK_F12                 = 0x7B
WinAPI.VK_F13                 = 0x7C
WinAPI.VK_F14                 = 0x7D
WinAPI.VK_F15                 = 0x7E
WinAPI.VK_F16                 = 0x7F
WinAPI.VK_F17                 = 0x80
WinAPI.VK_F18                 = 0x81
WinAPI.VK_F19                 = 0x82
WinAPI.VK_F20                 = 0x83
WinAPI.VK_F21                 = 0x84
WinAPI.VK_F22                 = 0x85
WinAPI.VK_F23                 = 0x86
WinAPI.VK_F24                 = 0x87
WinAPI.VK_NUMLOCK             = 0x90
WinAPI.VK_SCROLL              = 0x91
WinAPI.VK_LSHIFT              = 0xA0
WinAPI.VK_RSHIFT              = 0xA1
WinAPI.VK_LCONTROL            = 0xA2
WinAPI.VK_RCONTROL            = 0xA3
WinAPI.VK_LMENU               = 0xA4
WinAPI.VK_RMENU               = 0xA5
WinAPI.VK_BROWSER_BACK        = 0xA6
WinAPI.VK_BROWSER_FORWARD     = 0xA7
WinAPI.VK_BROWSER_REFRESH     = 0xA8
WinAPI.VK_BROWSER_STOP        = 0xA9
WinAPI.VK_BROWSER_SEARCH      = 0xAA
WinAPI.VK_BROWSER_FAVORITES   = 0xAB
WinAPI.VK_BROWSER_HOME        = 0xAC
WinAPI.VK_VOLUME_MUTE         = 0xAD
WinAPI.VK_VOLUME_DOWN         = 0xAE
WinAPI.VK_VOLUME_UP           = 0xAF
WinAPI.VK_MEDIA_NEXT_TRACK    = 0xB0
WinAPI.VK_MEDIA_PREV_TRACK    = 0xB1
WinAPI.VK_MEDIA_STOP          = 0xB2
WinAPI.VK_MEDIA_PLAY_PAUSE    = 0xB3
WinAPI.VK_LAUNCH_MAIL         = 0xB4
WinAPI.VK_LAUNCH_MEDIA_SELECT = 0xB5
WinAPI.VK_LAUNCH_APP1         = 0xB6
WinAPI.VK_LAUNCH_APP2         = 0xB7
WinAPI.VK_OEM_1               = 0xBA
WinAPI.VK_OEM_PLUS            = 0xBB
WinAPI.VK_OEM_COMMA           = 0xBC
WinAPI.VK_OEM_MINUS           = 0xBD
WinAPI.VK_OEM_PERIOD          = 0xBE
WinAPI.VK_OEM_2               = 0xBF
WinAPI.VK_OEM_3               = 0xC0
WinAPI.VK_OEM_4               = 0xDB
WinAPI.VK_OEM_5               = 0xDC
WinAPI.VK_OEM_6               = 0xDD
WinAPI.VK_OEM_7               = 0xDE
WinAPI.VK_OEM_8               = 0xDF
WinAPI.VK_OEM_102             = 0xE2
WinAPI.VK_PROCESSKEY          = 0xE5
WinAPI.VK_PACKET              = 0xE7
WinAPI.VK_ATTN                = 0xF6
WinAPI.VK_CRSEL               = 0xF7
WinAPI.VK_EXSEL               = 0xF8
WinAPI.VK_EREOF               = 0xF9
WinAPI.VK_PLAY                = 0xFA
WinAPI.VK_ZOOM                = 0xFB
WinAPI.VK_NONAME              = 0xFC
WinAPI.VK_PA1                 = 0xFD
WinAPI.VK_OEM_CLEAR           = 0xFE

-- ============================================================
-- 1.10 光标资源
-- ============================================================
WinAPI.IDC_ARROW              = 32512
WinAPI.IDC_IBEAM              = 32513
WinAPI.IDC_WAIT               = 32514
WinAPI.IDC_CROSS              = 32515
WinAPI.IDC_UPARROW            = 32516
WinAPI.IDC_SIZENWSE           = 32642
WinAPI.IDC_SIZENESW           = 32643
WinAPI.IDC_SIZEWE             = 32644
WinAPI.IDC_SIZENS             = 32645
WinAPI.IDC_SIZEALL            = 32646
WinAPI.IDC_NO                 = 32648
WinAPI.IDC_HAND               = 32649
WinAPI.IDC_APPSTARTING        = 32650
WinAPI.IDC_HELP               = 32651

-- ============================================================
-- 1.11 系统度量 (GetSystemMetrics 索引)
-- ============================================================
WinAPI.SM_CXSCREEN            = 0
WinAPI.SM_CYSCREEN            = 1
WinAPI.SM_CXVSCROLL           = 2
WinAPI.SM_CYHSCROLL           = 3
WinAPI.SM_CYCAPTION           = 4
WinAPI.SM_CXBORDER            = 5
WinAPI.SM_CYBORDER            = 6
WinAPI.SM_CXDLGFRAME          = 7
WinAPI.SM_CYDLGFRAME          = 8
WinAPI.SM_CYVTHUMB            = 9
WinAPI.SM_CXHTHUMB            = 10
WinAPI.SM_CXICON              = 11
WinAPI.SM_CYICON              = 12
WinAPI.SM_CXCURSOR            = 13
WinAPI.SM_CYCURSOR            = 14
WinAPI.SM_CYMENU              = 15
WinAPI.SM_CXFULLSCREEN        = 16
WinAPI.SM_CYFULLSCREEN        = 17
WinAPI.SM_CYKANJIWINDOW       = 18
WinAPI.SM_MOUSEPRESENT        = 19
WinAPI.SM_CYVSCROLL           = 20
WinAPI.SM_CXHSCROLL           = 21
WinAPI.SM_DEBUG               = 22
WinAPI.SM_SWAPBUTTON          = 23
WinAPI.SM_RESERVED1           = 24
WinAPI.SM_RESERVED2           = 25
WinAPI.SM_RESERVED3           = 26
WinAPI.SM_RESERVED4           = 27
WinAPI.SM_CXMIN               = 28
WinAPI.SM_CYMIN               = 29
WinAPI.SM_CXSIZE              = 30
WinAPI.SM_CYSIZE              = 31
WinAPI.SM_CXFRAME             = 32
WinAPI.SM_CYFRAME             = 33
WinAPI.SM_CXMINTRACK          = 34
WinAPI.SM_CYMINTRACK          = 35
WinAPI.SM_CXDOUBLECLK         = 36
WinAPI.SM_CYDOUBLECLK         = 37
WinAPI.SM_CXICONSPACING       = 38
WinAPI.SM_CYICONSPACING       = 39
WinAPI.SM_MENUDROPALIGNMENT   = 40
WinAPI.SM_PENWINDOWS          = 41
WinAPI.SM_DBCSENABLED         = 42
WinAPI.SM_CMOUSEBUTTONS       = 43
WinAPI.SM_CXFIXEDFRAME        = 7
WinAPI.SM_CYFIXEDFRAME        = 8
WinAPI.SM_CXSIZEFRAME         = 32
WinAPI.SM_CYSIZEFRAME         = 33
WinAPI.SM_SECURE              = 44
WinAPI.SM_CXEDGE              = 45
WinAPI.SM_CYEDGE              = 46
WinAPI.SM_CXMINSPACING        = 47
WinAPI.SM_CYMINSPACING        = 48
WinAPI.SM_CXSMICON            = 49
WinAPI.SM_CYSMICON            = 50
WinAPI.SM_CYSMCAPTION         = 51
WinAPI.SM_CXSMSIZE            = 52
WinAPI.SM_CYSMSIZE            = 53
WinAPI.SM_CXMENUSIZE          = 54
WinAPI.SM_CYMENUSIZE          = 55
WinAPI.SM_ARRANGE             = 56
WinAPI.SM_CXMINIMIZED         = 57
WinAPI.SM_CYMINIMIZED         = 58
WinAPI.SM_CXMAXTRACK          = 59
WinAPI.SM_CYMAXTRACK          = 60
WinAPI.SM_CXMAXIMIZED         = 61
WinAPI.SM_CYMAXIMIZED         = 62
WinAPI.SM_NETWORK             = 63
WinAPI.SM_CLEANBOOT           = 67
WinAPI.SM_CXDRAG              = 68
WinAPI.SM_CYDRAG              = 69
WinAPI.SM_SHOWSOUNDS          = 70
WinAPI.SM_CXMENUCHECK         = 71
WinAPI.SM_CYMENUCHECK         = 72
WinAPI.SM_SLOWMACHINE         = 73
WinAPI.SM_MIDEASTENABLED      = 74
WinAPI.SM_MOUSEWHEELPRESENT   = 75
WinAPI.SM_XVIRTUALSCREEN      = 76
WinAPI.SM_YVIRTUALSCREEN      = 77
WinAPI.SM_CXVIRTUALSCREEN     = 78
WinAPI.SM_CYVIRTUALSCREEN     = 79
WinAPI.SM_CMONITORS           = 80
WinAPI.SM_SAMEDISPLAYFORMAT   = 81
WinAPI.SM_IMMENABLED          = 82
WinAPI.SM_CXFOCUSBORDER       = 83
WinAPI.SM_CYFOCUSBORDER       = 84
WinAPI.SM_TABLETPC            = 86
WinAPI.SM_MEDIACENTER         = 87
WinAPI.SM_STARTER             = 88
WinAPI.SM_SERVERR2            = 89
WinAPI.SM_MOUSEHORIZONTALWHEELPRESENT = 91
WinAPI.SM_CXPADDEDBORDER      = 92
WinAPI.SM_DIGITIZER           = 94
WinAPI.SM_MAXIMUMTOUCHES      = 95
WinAPI.SM_REMOTESESSION       = 0x1000
WinAPI.SM_SHUTTINGDOWN        = 0x2000
WinAPI.SM_REMOTECONTROL       = 0x2001
WinAPI.SM_CARETBLINKINGENABLED = 0x2002

-- ============================================================
-- 1.12 消息框类型
-- ============================================================
WinAPI.MB_OK                  = 0x00000000
WinAPI.MB_OKCANCEL            = 0x00000001
WinAPI.MB_ABORTRETRYIGNORE    = 0x00000002
WinAPI.MB_YESNOCANCEL         = 0x00000003
WinAPI.MB_YESNO               = 0x00000004
WinAPI.MB_RETRYCANCEL         = 0x00000005
WinAPI.MB_CANCELTRYCONTINUE   = 0x00000006
WinAPI.MB_ICONHAND            = 0x00000010
WinAPI.MB_ICONQUESTION        = 0x00000020
WinAPI.MB_ICONEXCLAMATION     = 0x00000030
WinAPI.MB_ICONASTERISK        = 0x00000040
WinAPI.MB_ICONWARNING         = 0x00000030
WinAPI.MB_ICONERROR           = 0x00000010
WinAPI.MB_ICONINFORMATION     = 0x00000040
WinAPI.MB_ICONSTOP            = 0x00000010
WinAPI.MB_DEFBUTTON1          = 0x00000000
WinAPI.MB_DEFBUTTON2          = 0x00000100
WinAPI.MB_DEFBUTTON3          = 0x00000200
WinAPI.MB_DEFBUTTON4          = 0x00000300
WinAPI.MB_APPLMODAL           = 0x00000000
WinAPI.MB_SYSTEMMODAL         = 0x00001000
WinAPI.MB_TASKMODAL           = 0x00002000
WinAPI.MB_HELP                = 0x00004000
WinAPI.MB_NOFOCUS             = 0x00008000
WinAPI.MB_SETFOREGROUND       = 0x00010000
WinAPI.MB_DEFAULT_DESKTOP_ONLY = 0x00020000
WinAPI.MB_TOPMOST             = 0x00040000
WinAPI.MB_RIGHT               = 0x00080000
WinAPI.MB_RTLREADING          = 0x00100000
WinAPI.MB_SERVICE_NOTIFICATION = 0x00200000
WinAPI.MB_SERVICE_NOTIFICATION_NT3X = 0x00040000

WinAPI.IDOK                   = 1
WinAPI.IDCANCEL               = 2
WinAPI.IDABORT                = 3
WinAPI.IDRETRY                = 4
WinAPI.IDIGNORE               = 5
WinAPI.IDYES                  = 6
WinAPI.IDNO                   = 7
WinAPI.IDCLOSE                = 8
WinAPI.IDHELP                 = 9
WinAPI.IDTRYAGAIN             = 10
WinAPI.IDCONTINUE             = 11

-- ============================================================
-- 1.13 钩子类型
-- ============================================================
WinAPI.WH_MSGFILTER           = -1
WinAPI.WH_JOURNALRECORD       = 0
WinAPI.WH_JOURNALPLAYBACK     = 1
WinAPI.WH_KEYBOARD            = 2
WinAPI.WH_GETMESSAGE          = 3
WinAPI.WH_CALLWNDPROC         = 4
WinAPI.WH_CBT                 = 5
WinAPI.WH_SYSMSGFILTER        = 6
WinAPI.WH_MOUSE               = 7
WinAPI.WH_HARDWARE            = 8
WinAPI.WH_DEBUG               = 9
WinAPI.WH_SHELL               = 10
WinAPI.WH_FOREGROUNDIDLE      = 11
WinAPI.WH_CALLWNDPROCRET      = 12
WinAPI.WH_KEYBOARD_LL         = 13
WinAPI.WH_MOUSE_LL            = 14

-- ============================================================
-- 1.14 剪切板格式
-- ============================================================
WinAPI.CF_TEXT                = 1
WinAPI.CF_BITMAP              = 2
WinAPI.CF_METAFILEPICT        = 3
WinAPI.CF_SYLK                = 4
WinAPI.CF_DIF                 = 5
WinAPI.CF_TIFF                = 6
WinAPI.CF_OEMTEXT             = 7
WinAPI.CF_DIB                 = 8
WinAPI.CF_PALETTE             = 9
WinAPI.CF_PENDATA             = 10
WinAPI.CF_RIFF                = 11
WinAPI.CF_WAVE                = 12
WinAPI.CF_UNICODETEXT         = 13
WinAPI.CF_ENHMETAFILE         = 14
WinAPI.CF_HDROP               = 15
WinAPI.CF_LOCALE              = 16
WinAPI.CF_DIBV5               = 17
WinAPI.CF_MAX                 = 18
WinAPI.CF_OWNERDISPLAY        = 0x0080
WinAPI.CF_DSPTEXT             = 0x0081
WinAPI.CF_DSPBITMAP           = 0x0082
WinAPI.CF_DSPMETAFILEPICT     = 0x0083
WinAPI.CF_DSPENHMETAFILE      = 0x008E

-- ============================================================
-- 1.15 窗口动画常量
-- ============================================================
WinAPI.AW_HOR_POSITIVE        = 0x00000001
WinAPI.AW_HOR_NEGATIVE        = 0x00000002
WinAPI.AW_VER_POSITIVE        = 0x00000004
WinAPI.AW_VER_NEGATIVE        = 0x00000008
WinAPI.AW_CENTER              = 0x00000010
WinAPI.AW_HIDE                = 0x00010000
WinAPI.AW_ACTIVATE            = 0x00020000
WinAPI.AW_SLIDE               = 0x00040000
WinAPI.AW_BLEND               = 0x00080000

-- ============================================================
-- 1.16 窗口闪烁常量
-- ============================================================
WinAPI.FLASHW_STOP            = 0
WinAPI.FLASHW_CAPTION         = 1
WinAPI.FLASHW_TRAY            = 2
WinAPI.FLASHW_ALL             = 3
WinAPI.FLASHW_TIMER           = 4
WinAPI.FLASHW_TIMERNOFG       = 12

-- ============================================================
-- 1.17 消息队列状态
-- ============================================================
WinAPI.QS_KEY                 = 0x0001
WinAPI.QS_MOUSEMOVE           = 0x0002
WinAPI.QS_MOUSEBUTTON         = 0x0004
WinAPI.QS_POSTMESSAGE         = 0x0008
WinAPI.QS_TIMER               = 0x0010
WinAPI.QS_PAINT               = 0x0020
WinAPI.QS_SENDMESSAGE         = 0x0040
WinAPI.QS_HOTKEY              = 0x0080
WinAPI.QS_ALLPOSTMESSAGE      = 0x0100
WinAPI.QS_RAWINPUT            = 0x0400
WinAPI.QS_INPUT               = 0x0800
WinAPI.QS_ALLEVENTS           = 0x04BF
WinAPI.QS_ALLINPUT            = 0x04FF

-- ============================================================
-- 1.18 鼠标事件常量
-- ============================================================
WinAPI.MOUSEEVENTF_MOVE       = 0x0001
WinAPI.MOUSEEVENTF_LEFTDOWN   = 0x0002
WinAPI.MOUSEEVENTF_LEFTUP     = 0x0004
WinAPI.MOUSEEVENTF_RIGHTDOWN  = 0x0008
WinAPI.MOUSEEVENTF_RIGHTUP    = 0x0010
WinAPI.MOUSEEVENTF_MIDDLEDOWN = 0x0020
WinAPI.MOUSEEVENTF_MIDDLEUP   = 0x0040
WinAPI.MOUSEEVENTF_XDOWN      = 0x0080
WinAPI.MOUSEEVENTF_XUP        = 0x0100
WinAPI.MOUSEEVENTF_WHEEL      = 0x0800
WinAPI.MOUSEEVENTF_HWHEEL     = 0x1000
WinAPI.MOUSEEVENTF_ABSOLUTE   = 0x8000

-- ============================================================
-- 1.19 键盘事件常量
-- ============================================================
WinAPI.KEYEVENTF_EXTENDEDKEY  = 0x0001
WinAPI.KEYEVENTF_KEYUP        = 0x0002
WinAPI.KEYEVENTF_UNICODE      = 0x0004
WinAPI.KEYEVENTF_SCANCODE     = 0x0008

-- ============================================================
-- 1.20 系统颜色常量
-- ============================================================
WinAPI.COLOR_SCROLLBAR        = 0
WinAPI.COLOR_BACKGROUND        = 1
WinAPI.COLOR_ACTIVECAPTION     = 2
WinAPI.COLOR_INACTIVECAPTION   = 3
WinAPI.COLOR_MENU              = 4
WinAPI.COLOR_WINDOW            = 5
WinAPI.COLOR_WINDOWFRAME       = 6
WinAPI.COLOR_MENUTEXT          = 7
WinAPI.COLOR_WINDOWTEXT        = 8
WinAPI.COLOR_CAPTIONTEXT       = 9
WinAPI.COLOR_ACTIVEBORDER      = 10
WinAPI.COLOR_INACTIVEBORDER    = 11
WinAPI.COLOR_APPWORKSPACE      = 12
WinAPI.COLOR_HIGHLIGHT         = 13
WinAPI.COLOR_HIGHLIGHTTEXT     = 14
WinAPI.COLOR_BTNFACE           = 15
WinAPI.COLOR_BTNSHADOW         = 16
WinAPI.COLOR_GRAYTEXT          = 17
WinAPI.COLOR_BTNTEXT           = 18
WinAPI.COLOR_INACTIVECAPTIONTEXT = 19
WinAPI.COLOR_BTNHIGHLIGHT      = 20
WinAPI.COLOR_3DDKSHADOW        = 21
WinAPI.COLOR_3DLIGHT           = 22
WinAPI.COLOR_INFOTEXT          = 23
WinAPI.COLOR_INFOBK            = 24
WinAPI.COLOR_HOTLIGHT          = 26
WinAPI.COLOR_GRADIENTACTIVECAPTION = 27
WinAPI.COLOR_GRADIENTINACTIVECAPTION = 28
WinAPI.COLOR_MENUHILIGHT       = 29
WinAPI.COLOR_MENUBAR           = 30

-- ============================================================
-- 1.21 GetAncestor 标志
-- ============================================================
WinAPI.GA_PARENT              = 1
WinAPI.GA_ROOT                = 2
WinAPI.GA_ROOTOWNER           = 3

-- ============================================================
-- 1.22 窗口关系常量 (GetWindow)
-- ============================================================
WinAPI.GW_HWNDFIRST           = 0
WinAPI.GW_HWNDLAST            = 1
WinAPI.GW_HWNDNEXT            = 2
WinAPI.GW_HWNDPREV            = 3
WinAPI.GW_OWNER               = 4
WinAPI.GW_CHILD               = 5
WinAPI.GW_ENABLEDPOPUP        = 6

-- ============================================================
-- 1.23 滚动条常量
-- ============================================================
WinAPI.SB_HORZ                = 0
WinAPI.SB_VERT                = 1
WinAPI.SB_CTL                 = 2
WinAPI.SB_BOTH                = 3

WinAPI.ESB_ENABLE_BOTH        = 0x0000
WinAPI.ESB_DISABLE_BOTH       = 0x0003
WinAPI.ESB_DISABLE_LEFT       = 0x0001
WinAPI.ESB_DISABLE_RIGHT      = 0x0002
WinAPI.ESB_DISABLE_UP         = 0x0001
WinAPI.ESB_DISABLE_DOWN       = 0x0002
WinAPI.ESB_DISABLE_LTUP       = 0x0001
WinAPI.ESB_DISABLE_RTDN       = 0x0002

-- ============================================================
-- 1.24 设备上下文常量
-- ============================================================
WinAPI.DCX_WINDOW             = 0x00000001
WinAPI.DCX_CACHE              = 0x00000002
WinAPI.DCX_NORESETATTRS       = 0x00000004
WinAPI.DCX_CLIPCHILDREN       = 0x00000008
WinAPI.DCX_CLIPSIBLINGS       = 0x00000010
WinAPI.DCX_PARENTCLIP         = 0x00000020
WinAPI.DCX_EXCLUDERGN         = 0x00000040
WinAPI.DCX_INTERSECTRGN       = 0x00000080
WinAPI.DCX_EXCLUDEUPDATE      = 0x00000100
WinAPI.DCX_INTERSECTUPDATE    = 0x00000200
WinAPI.DCX_LOCKWINDOWUPDATE   = 0x00000400
WinAPI.DCX_VALIDATE           = 0x00000800

-- ============================================================
-- 1.25 原始输入常量
-- ============================================================
WinAPI.RID_INPUT              = 0x10000003
WinAPI.RID_HEADER             = 0x10000005

-- ============================================================
-- 2. 结构体定义
-- ============================================================

local ffi = nil
local isWindows = (buildTarget == 'windows')

if isWindows then
    ffi = require("ffi")
    ffi.cdef([[
        // ===== 基础类型 =====
        typedef void* HWND;
        typedef void* HINSTANCE;
        typedef void* HICON;
        typedef void* HCURSOR;
        typedef void* HMENU;
        typedef void* HBRUSH;
        typedef void* HDC;
        typedef void* HHOOK;
        typedef void* HACCEL;
        typedef void* HIMC;
        typedef void* HKL;
        typedef void* HRAWINPUT;
        typedef void* HPEN;
        typedef void* HFONT;
        typedef void* HBITMAP;
        typedef void* HGDIOBJ;
        typedef void* HMONITOR;
        typedef void* HDROP;
        typedef void* HRGN;
        typedef int BOOL;
        typedef unsigned char BYTE;
        typedef unsigned long DWORD;
        typedef unsigned long LONG;
        typedef unsigned int UINT;
        typedef unsigned short WORD;
        typedef unsigned long ULONG;
        typedef long LRESULT;
        typedef void* LPVOID;
        typedef const char* LPCSTR;
        typedef char* LPSTR;
        typedef void* LPARAM;
        typedef void* WPARAM;
        typedef unsigned short ATOM;
        typedef unsigned int UINT_PTR;
        typedef void* HANDLE;
        typedef unsigned int DPI_AWARENESS_CONTEXT;

        // ===== 基础结构体 =====
        typedef struct {
            long left;
            long top;
            long right;
            long bottom;
        } RECT;

        typedef struct {
            long x;
            long y;
        } POINT;

        typedef struct {
            long x;
            long y;
            long cx;
            long cy;
        } POINTL;

        typedef struct {
            long left;
            long top;
            long right;
            long bottom;
        } RECTL;

        typedef struct {
            int x;
            int y;
            int cx;
            int cy;
            int flags;
            int showCmd;
            int ptMinPosition_x;
            int ptMinPosition_y;
            int ptMaxPosition_x;
            int ptMaxPosition_y;
            int ptNormalPosition_x;
            int ptNormalPosition_y;
        } WINDOWPLACEMENT;

        typedef struct {
            int cbSize;
            HWND hwnd;
            int wFlags;
            int rcNormalPosition_left;
            int rcNormalPosition_top;
            int rcNormalPosition_right;
            int rcNormalPosition_bottom;
            int rcDevice_left;
            int rcDevice_top;
            int rcDevice_right;
            int rcDevice_bottom;
        } WINDOWPLACEMENTEX;

        typedef struct {
            HWND hwnd;
            RECT rcNormalPosition;
            RECT rcDevice;
            int status;
        } WINDOWINFO;

        typedef struct {
            int x;
            int y;
            int cx;
            int cy;
            int flags;
        } MINMAXINFO;

        typedef struct {
            HWND hwnd;
            UINT wMsg;
            int wParam_high;
            int wParam_low;
            int lParam_high;
            int lParam_low;
            DWORD time;
            POINT pt;
        } MSG;

        typedef struct {
            UINT cbSize;
            HWND hwnd;
            DWORD dwFlags;
            UINT uCount;
            DWORD dwTimeout;
        } FLASHWINFO;

        typedef struct {
            long left;
            long top;
            long right;
            long bottom;
        } RECT;

        typedef struct {
            int x;
            int y;
            int cx;
            int cy;
        } RECT;

        typedef struct {
            int x;
            int y;
        } POINT;

        typedef struct {
            int x;
            int y;
        } POINT;

        typedef struct {
            int cbSize;
            int x;
            int y;
            int cx;
            int cy;
            int wnd;
            int hwnd;
            int parent;
            int child;
            int self;
        } WINDOWINFO;

        typedef struct {
            int cbSize;
            int flags;
            int hInstance;
            int hIcon;
            int hCursor;
            int hbrBackground;
            int lpszMenuName;
            int lpszClassName;
        } WNDCLASSA;

        typedef struct {
            int nMinTrackWidth;
            int nMinTrackHeight;
            int nMaxTrackWidth;
            int nMaxTrackHeight;
        } MINMAXINFO;

        // ===== 滚动条信息 =====
        typedef struct {
            UINT cbSize;
            UINT fMask;
            int nMin;
            int nMax;
            UINT nPage;
            int nPos;
            int nTrackPos;
        } SCROLLINFO;

        // ===== 菜单信息 =====
        typedef struct {
            int cbSize;
            int fMask;
            int dwStyle;
            int cyMax;
            int hbrBack;
            int dwContextHelpID;
            int dwMenuData;
        } MENUINFO;

        // ===== 剪切板 =====
        typedef struct {
            int cbSize;
            int fMask;
            int fWinIni;
            int lpWinIni;
        } SYSTEMPARAMETERSINFO;

        // ===== 显示器信息 =====
        typedef struct {
            int cbSize;
            RECT rcMonitor;
            RECT rcWork;
            DWORD dwFlags;
        } MONITORINFO;

        typedef struct {
            int cbSize;
            RECT rcMonitor;
            RECT rcWork;
            DWORD dwFlags;
            char szDevice[32];
        } MONITORINFOEXA;

        // ===== 原始输入 =====
        typedef struct {
            USHORT usUsagePage;
            USHORT usUsage;
            DWORD dwFlags;
            HWND hwndTarget;
        } RAWINPUTDEVICE;

        // ===== 窗口类 =====
        typedef struct {
            UINT cbSize;
            UINT style;
            void* lpfnWndProc;
            int cbClsExtra;
            int cbWndExtra;
            HINSTANCE hInstance;
            HICON hIcon;
            HCURSOR hCursor;
            HBRUSH hbrBackground;
            LPCSTR lpszMenuName;
            LPCSTR lpszClassName;
        } WNDCLASSEXA;

        // ===== 指针工具函数 =====
        void* memcpy(void* dest, const void* src, unsigned long n);
        void* memset(void* s, int c, unsigned long n);
        int memcmp(const void* s1, const void* s2, unsigned long n);

        // ===== User32 函数 =====
        // 窗口管理
        HWND GetActiveWindow(void);
        HWND GetForegroundWindow(void);
        HWND FindWindowA(LPCSTR lpClassName, LPCSTR lpWindowName);
        HWND FindWindowExA(HWND hWndParent, HWND hWndChildAfter, LPCSTR lpszClass, LPCSTR lpszWindow);
        BOOL IsWindow(HWND hWnd);
        BOOL IsWindowVisible(HWND hWnd);
        BOOL IsWindowEnabled(HWND hWnd);
        BOOL IsChild(HWND hWndParent, HWND hWnd);
        BOOL IsZoomed(HWND hWnd);
        BOOL IsIconic(HWND hWnd);
        BOOL IsWindowUnicode(HWND hWnd);
        BOOL IsWindowRedirectedForPrint(HWND hWnd);
        BOOL IsHungAppWindow(HWND hWnd);
        BOOL IsGUIThread(BOOL bConvert);
        BOOL IsProcessDPIAware(void);
        BOOL ShowWindow(HWND hWnd, int nCmdShow);
        BOOL SetWindowPos(HWND hWnd, HWND hWndInsertAfter, int X, int Y, int cx, int cy, UINT uFlags);
        BOOL GetWindowRect(HWND hWnd, RECT* lpRect);
        BOOL GetClientRect(HWND hWnd, RECT* lpRect);
        BOOL MoveWindow(HWND hWnd, int X, int Y, int nWidth, int nHeight, BOOL bRepaint);
        BOOL SetWindowTextA(HWND hWnd, LPCSTR lpString);
        int GetWindowTextA(HWND hWnd, LPSTR lpString, int nMaxCount);
        int GetWindowTextLengthA(HWND hWnd);
        HWND GetParent(HWND hWnd);
        HWND SetParent(HWND hWndChild, HWND hWndNewParent);
        LONG GetWindowLongA(HWND hWnd, int nIndex);
        LONG SetWindowLongA(HWND hWnd, int nIndex, LONG dwNewLong);
        ULONG_PTR GetWindowLongPtrA(HWND hWnd, int nIndex);
        ULONG_PTR SetWindowLongPtrA(HWND hWnd, int nIndex, ULONG_PTR dwNewLong);
        BOOL SetLayeredWindowAttributes(HWND hwnd, DWORD crKey, BYTE bAlpha, DWORD dwFlags);
        BOOL BringWindowToTop(HWND hWnd);
        BOOL SetForegroundWindow(HWND hWnd);
        HWND SetCapture(HWND hWnd);
        BOOL ReleaseCapture(void);
        HWND GetCapture(void);
        HWND GetFocus(void);
        HWND SetFocus(HWND hWnd);
        HWND GetDesktopWindow(void);
        HWND GetWindow(HWND hWnd, UINT uCmd);
        BOOL EnumWindows(void* lpEnumFunc, LPARAM lParam);
        BOOL EnumChildWindows(HWND hWndParent, void* lpEnumFunc, LPARAM lParam);
        HWND GetNextWindow(HWND hWnd, UINT wCmd);
        HWND GetTopWindow(HWND hWnd);
        HWND GetAncestor(HWND hWnd, UINT gaFlags);
        HWND GetLastActivePopup(HWND hWnd);
        int GetSystemMetrics(int nIndex);
        int GetSystemMetricsForDpi(int nIndex, UINT dpi);
        DWORD GetWindowThreadProcessId(HWND hWnd, DWORD* lpdwProcessId);
        BOOL GetWindowInfo(HWND hwnd, WINDOWINFO* pwi);
        BOOL GetWindowPlacement(HWND hWnd, WINDOWPLACEMENT* lpwndpl);
        BOOL SetWindowPlacement(HWND hWnd, WINDOWPLACEMENT* lpwndpl);
        BOOL LockWindowUpdate(HWND hWnd);
        BOOL FlashWindow(HWND hWnd, BOOL bInvert);
        BOOL FlashWindowEx(FLASHWINFO* pfwi);
        BOOL AnimateWindow(HWND hWnd, DWORD dwTime, DWORD dwFlags);
        BOOL UpdateWindow(HWND hWnd);
        BOOL RedrawWindow(HWND hWnd, RECT* lprcUpdate, HRGN hrgnUpdate, UINT flags);
        BOOL InvalidateRect(HWND hWnd, RECT* lpRect, BOOL bErase);
        BOOL ValidateRect(HWND hWnd, RECT* lpRect);
        BOOL ScrollWindow(HWND hWnd, int XAmount, int YAmount, RECT* lpRect, RECT* lpClipRect);
        int ScrollWindowEx(HWND hWnd, int dx, int dy, RECT* prcScroll, RECT* prcClip, HRGN hrgnUpdate, RECT* prcUpdate, UINT flags);
        BOOL ShowScrollBar(HWND hWnd, int wBar, BOOL bShow);
        BOOL EnableScrollBar(HWND hWnd, UINT wSBflags, UINT wArrows);
        int GetScrollPos(HWND hWnd, int nBar);
        int SetScrollPos(HWND hWnd, int nBar, int nPos, BOOL bRedraw);
        BOOL GetScrollInfo(HWND hWnd, int nBar, SCROLLINFO* lpsi);
        BOOL SetScrollInfo(HWND hWnd, int nBar, SCROLLINFO* lpsi, BOOL bRedraw);
        BOOL SetWindowRgn(HWND hWnd, HRGN hRgn, BOOL bRedraw);
        int GetWindowRgn(HWND hWnd, HRGN hRgn);
        BOOL SetWindowDisplayAffinity(HWND hWnd, DWORD dwAffinity);
        DWORD GetWindowDisplayAffinity(HWND hWnd);
        BOOL PrintWindow(HWND hwnd, HDC hdcBlt, UINT nFlags);
        BOOL SetWindowContextHelpId(HWND hWnd, DWORD dwContextHelpId);
        DWORD GetWindowContextHelpId(HWND hWnd);
        UINT GetWindowModuleFileNameA(HWND hWnd, LPSTR lpszFileName, UINT cchFileNameMax);
        BOOL IsWindowRedirectedForPrint(HWND hWnd);
        BOOL HungWindowFromGhostWindow(HWND hWnd);
        BOOL GhostWindowFromHungWindow(HWND hWnd);
        HWND RealChildWindowFromPoint(HWND hwndParent, POINT* ptParentClientCoords);
        UINT RealGetWindowClassA(HWND hwnd, LPSTR pszType, UINT cchType);
        BOOL LogicalToPhysicalPoint(HWND hWnd, POINT* lpPoint);
        BOOL PhysicalToLogicalPoint(HWND hWnd, POINT* lpPoint);

        // 消息函数
        LRESULT SendMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
        LRESULT SendMessageTimeoutA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam, UINT fuFlags, UINT uTimeout, DWORD* lpdwResult);
        BOOL SendNotifyMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
        BOOL PostMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
        BOOL PostThreadMessageA(DWORD idThread, UINT Msg, WPARAM wParam, LPARAM lParam);
        BOOL PeekMessageA(MSG* lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg);
        BOOL GetMessageA(MSG* lpMsg, HWND hWnd, UINT wMsgFilterMin, UINT wMsgFilterMax);
        LRESULT DispatchMessageA(MSG* lpMsg);
        BOOL TranslateMessage(MSG* lpMsg);
        LRESULT TranslateAcceleratorA(HWND hWnd, HACCEL hAccTable, MSG* lpMsg);
        BOOL IsDialogMessageA(HWND hDlg, MSG* lpMsg);
        BOOL WaitMessage(void);
        DWORD GetQueueStatus(UINT flags);
        BOOL SetMessageQueue(int cMessagesMax);
        LRESULT BroadcastSystemMessageA(DWORD dwFlags, DWORD* lpdwRecipients, UINT uiMessage, WPARAM wParam, LPARAM lParam);

        // 输入函数
        SHORT GetAsyncKeyState(int vKey);
        SHORT GetKeyState(int nVirtKey);
        BOOL GetKeyboardState(BYTE* lpKeyState);
        BOOL SetKeyboardState(BYTE* lpKeyState);
        UINT GetKeyboardType(int nTypeFlag);
        UINT GetDoubleClickTime(void);
        BOOL SetDoubleClickTime(UINT uInterval);
        BOOL GetCursorPos(POINT* lpPoint);
        BOOL SetCursorPos(int X, int Y);
        HCURSOR GetCursor(void);
        HCURSOR SetCursor(HCURSOR hCursor);
        HCURSOR LoadCursorA(HINSTANCE hInstance, LPCSTR lpCursorName);
        HCURSOR LoadCursorFromFileA(LPCSTR lpFileName);
        BOOL DestroyCursor(HCURSOR hCursor);
        BOOL ClipCursor(RECT* lpRect);
        BOOL GetClipCursor(RECT* lpRect);
        int ShowCursor(BOOL bShow);
        BOOL SwapMouseButton(BOOL fSwap);
        void mouse_event(DWORD dwFlags, DWORD dx, DWORD dy, DWORD dwData, DWORD dwExtraInfo);
        void keybd_event(BYTE bVk, BYTE bScan, DWORD dwFlags, DWORD dwExtraInfo);
        int GetMouseMovePointsEx(UINT cbSize, void* lppt, int* lpcPoints);
        BOOL RegisterHotKey(HWND hWnd, int id, UINT fsModifiers, UINT vk);
        BOOL UnregisterHotKey(HWND hWnd, int id);
        UINT GetRawInputData(HRAWINPUT hRawInput, UINT uiCommand, void* pData, UINT* pcbSize, UINT cbSizeHeader);
        BOOL RegisterRawInputDevices(RAWINPUTDEVICE* pRawInputDevices, UINT uiNumDevices, UINT cbSize);
        UINT GetRawInputDeviceInfoA(HANDLE hDevice, UINT uiCommand, void* pData, UINT* pcbSize);
        UINT GetRawInputDeviceList(void* pRawInputDeviceList, UINT* puiNumDevices, UINT cbSize);

        // 图标函数
        HICON LoadIconA(HINSTANCE hInstance, LPCSTR lpIconName);
        HICON LoadImageA(HINSTANCE hInst, LPCSTR name, UINT type, int cx, int cy, UINT fuLoad);
        BOOL DestroyIcon(HICON hIcon);
        HICON CopyIcon(HICON hIcon);
        HICON CreateIcon(HINSTANCE hInstance, int nWidth, int nHeight, BYTE cPlanes, BYTE cBitsPixel, BYTE* lpbANDbits, BYTE* lpbXORbits);
        BOOL DrawIconEx(HDC hdc, int xLeft, int yTop, HICON hIcon, int cxWidth, int cyWidth, UINT istepIfAniCur, HBRUSH hbrFlickerFreeDraw, UINT diFlags);

        // 菜单函数
        HMENU GetMenu(HWND hWnd);
        BOOL SetMenu(HWND hWnd, HMENU hMenu);
        HMENU CreateMenu(void);
        HMENU CreatePopupMenu(void);
        BOOL DestroyMenu(HMENU hMenu);
        BOOL AppendMenuA(HMENU hMenu, UINT uFlags, UINT_PTR uIDNewItem, LPCSTR lpNewItem);
        BOOL InsertMenuA(HMENU hMenu, UINT uPosition, UINT uFlags, UINT_PTR uIDNewItem, LPCSTR lpNewItem);
        BOOL DeleteMenu(HMENU hMenu, UINT uPosition, UINT uFlags);
        BOOL ModifyMenuA(HMENU hMenu, UINT uPosition, UINT uFlags, UINT_PTR uIDNewItem, LPCSTR lpNewItem);
        BOOL GetMenuStringA(HMENU hMenu, UINT uIDItem, LPSTR lpString, int cchMax, UINT uFlags);
        int GetMenuItemCount(HMENU hMenu);
        UINT GetMenuItemID(HMENU hMenu, int nPos);
        BOOL CheckMenuItem(HMENU hMenu, UINT uIDCheckItem, UINT uCheck);
        BOOL EnableMenuItem(HMENU hMenu, UINT uIDEnableItem, UINT uEnable);
        HMENU GetSubMenu(HMENU hMenu, int nPos);
        BOOL GetMenuInfo(HMENU hMenu, MENUINFO* lpcmi);
        BOOL SetMenuInfo(HMENU hMenu, MENUINFO* lpcmi);
        BOOL DrawMenuBar(HWND hWnd);
        HMENU GetSystemMenu(HWND hWnd, BOOL bRevert);
        BOOL HiliteMenuItem(HWND hWnd, HMENU hMenu, UINT uIDHiliteItem, UINT uHilite);
        BOOL GetMenuItemInfoA(HMENU hMenu, UINT uItem, BOOL fByPosition, void* lpmii);
        BOOL SetMenuItemInfoA(HMENU hMenu, UINT uItem, BOOL fByPosition, void* lpmii);
        int GetMenuState(HMENU hMenu, UINT uId, UINT uFlags);
        int GetMenuDefaultItem(HMENU hMenu, UINT fByPos, UINT gmdiFlags);
        BOOL SetMenuDefaultItem(HMENU hMenu, UINT uItem, UINT fByPos);
        BOOL SetMenuItemBitmaps(HMENU hMenu, UINT uPosition, UINT uFlags, HBITMAP hBitmapUnchecked, HBITMAP hBitmapChecked);

        // 定时器函数
        UINT_PTR SetTimer(HWND hWnd, UINT_PTR nIDEvent, UINT uElapse, void* lpTimerFunc);
        BOOL KillTimer(HWND hWnd, UINT_PTR uIDEvent);

        // 钩子函数
        HHOOK SetWindowsHookExA(int idHook, void* lpfn, HINSTANCE hMod, DWORD dwThreadId);
        BOOL UnhookWindowsHookEx(HHOOK hhk);
        LRESULT CallNextHookEx(HHOOK hhk, int nCode, WPARAM wParam, LPARAM lParam);

        // 剪切板函数
        BOOL OpenClipboard(HWND hWndNewOwner);
        BOOL CloseClipboard(void);
        HANDLE SetClipboardData(UINT uFormat, HANDLE hMem);
        HANDLE GetClipboardData(UINT uFormat);
        BOOL EmptyClipboard(void);
        BOOL IsClipboardFormatAvailable(UINT format);
        UINT RegisterClipboardFormatA(LPCSTR lpszFormat);
        UINT CountClipboardFormats(void);
        UINT EnumClipboardFormats(UINT format);
        HWND GetClipboardOwner(void);
        HWND GetClipboardViewer(void);
        HWND SetClipboardViewer(HWND hWndNewViewer);
        BOOL ChangeClipboardChain(HWND hWndRemove, HWND hWndNewNext);
        int GetClipboardSequenceNumber(void);
        HWND GetOpenClipboardWindow(void);

        // 拖放函数
        void DragAcceptFiles(HWND hWnd, BOOL fAccept);
        UINT DragQueryFileA(HDROP hDrop, UINT iFile, LPSTR lpszFile, UINT cch);
        BOOL DragQueryPoint(HDROP hDrop, POINT* lppt);
        void DragFinish(HDROP hDrop);

        // 窗口类函数
        ATOM RegisterClassA(WNDCLASSEXA* lpWndClass);
        BOOL UnregisterClassA(LPCSTR lpClassName, HINSTANCE hInstance);
        BOOL GetClassInfoA(HINSTANCE hInstance, LPCSTR lpClassName, WNDCLASSEXA* lpWndClass);
        DWORD GetClassLongA(HWND hWnd, int nIndex);
        DWORD SetClassLongA(HWND hWnd, int nIndex, LONG dwNewLong);
        int GetClassWord(HWND hWnd, int nIndex);
        int SetClassWord(HWND hWnd, int nIndex, WORD wNewWord);

        // 系统参数
        BOOL SystemParametersInfoA(UINT uiAction, UINT uiParam, void* pvParam, UINT fWinIni);

        // 消息框
        int MessageBoxA(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType);
        int MessageBoxExA(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType, WORD wLanguageId);
        int MessageBoxIndirectA(void* lpMsgBoxParams);

        // 模块/资源
        HINSTANCE GetModuleHandleA(LPCSTR lpModuleName);

        // 设备上下文
        HDC GetDC(HWND hWnd);
        HDC GetWindowDC(HWND hWnd);
        int ReleaseDC(HWND hWnd, HDC hDC);
        HDC GetDCEx(HWND hWnd, HRGN hrgnClip, DWORD flags);

        // 子窗口/对话框
        HWND GetDlgItem(HWND hDlg, int nIDDlgItem);
        UINT GetDlgItemTextA(HWND hDlg, int nIDDlgItem, LPSTR lpString, int cchMax);
        BOOL SetDlgItemTextA(HWND hDlg, int nIDDlgItem, LPCSTR lpString);
        LRESULT SendDlgItemMessageA(HWND hDlg, int nIDDlgItem, UINT Msg, WPARAM wParam, LPARAM lParam);
        int GetDlgCtrlID(HWND hWnd);
        BOOL CheckDlgButton(HWND hDlg, int nIDButton, UINT uCheck);
        BOOL CheckRadioButton(HWND hDlg, int nIDFirstButton, int nIDLastButton, int nIDCheckButton);
        BOOL IsDlgButtonChecked(HWND hDlg, int nIDButton);
        int DialogBoxParamA(HINSTANCE hInstance, LPCSTR lpTemplateName, HWND hWndParent, void* lpDialogFunc, LPARAM dwInitParam);
        HWND CreateDialogParamA(HINSTANCE hInstance, LPCSTR lpTemplateName, HWND hWndParent, void* lpDialogFunc, LPARAM dwInitParam);
        BOOL EndDialog(HWND hDlg, int nResult);
        BOOL MapDialogRect(HWND hDlg, RECT* lpRect);
        int GetDialogBaseUnits(void);
        int SendDlgItemMessageA(HWND hDlg, int nIDDlgItem, UINT Msg, WPARAM wParam, LPARAM lParam);
        HWND GetNextDlgGroupItem(HWND hDlg, HWND hCtl, BOOL bPrevious);
        HWND GetNextDlgTabItem(HWND hDlg, HWND hCtl, BOOL bPrevious);
        int GetDlgItemInt(HWND hDlg, int nIDDlgItem, BOOL* lpTranslated, BOOL bSigned);
        BOOL SetDlgItemInt(HWND hDlg, int nIDDlgItem, UINT uValue, BOOL bSigned);

        // 系统颜色
        DWORD GetSysColor(int nIndex);
        BOOL SetSysColors(int cElements, int* lpaElements, DWORD* lpaRgbValues);
        int GetSysColorBrush(int nIndex);

        // DPI 相关
        BOOL SetProcessDPIAware(void);
        BOOL SetProcessDpiAwarenessContext(DPI_AWARENESS_CONTEXT value);
        DPI_AWARENESS_CONTEXT GetProcessDpiAwarenessContext(HWND hwnd);
        BOOL SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT dpiContext);
        DPI_AWARENESS_CONTEXT GetThreadDpiAwarenessContext(void);
        DPI_AWARENESS_CONTEXT GetWindowDpiAwarenessContext(HWND hwnd);
        UINT GetDpiForWindow(HWND hwnd);
        UINT GetDpiForSystem(void);
        int GetSystemMetricsForDpi(int nIndex, UINT dpi);

        // 多显示器
        HMONITOR MonitorFromWindow(HWND hwnd, DWORD dwFlags);
        HMONITOR MonitorFromRect(RECT* lprc, DWORD dwFlags);
        HMONITOR MonitorFromPoint(POINT pt, DWORD dwFlags);
        BOOL GetMonitorInfoA(HMONITOR hMonitor, MONITORINFO* lpmi);
        BOOL EnumDisplayMonitors(HDC hdc, RECT* lprcClip, void* lpfnEnum, LPARAM dwData);

        // 输入法
        HIMC ImmGetContext(HWND hWnd);
        BOOL ImmSetContext(HWND hWnd, HIMC hIMC);
        HKL GetKeyboardLayout(DWORD idThread);
        BOOL ActivateKeyboardLayout(HKL hkl, UINT Flags);
        BOOL ImmGetOpenStatus(HIMC hIMC);
        BOOL ImmSetOpenStatus(HIMC hIMC, BOOL fOpen);

        // 线程/进程
        BOOL AttachThreadInput(DWORD idAttach, DWORD idAttachTo, BOOL fAttach);
        DWORD GetWindowThreadProcessId(HWND hWnd, DWORD* lpdwProcessId);
        DWORD WaitForInputIdle(HANDLE hProcess, DWORD dwMilliseconds);

        // 桌面/窗口站
        BOOL SetThreadDesktop(void* hDesktop);
        void* GetThreadDesktop(DWORD dwThreadId);
        BOOL CloseDesktop(void* hDesktop);
        void* CreateDesktopA(LPCSTR lpszDesktop, LPCSTR lpszDevice, void* pDevmode, DWORD dwFlags, DWORD dwDesiredAccess, void* lpsa);
        void* OpenDesktopA(LPCSTR lpszDesktop, DWORD dwFlags, BOOL fInherit, DWORD dwDesiredAccess);
        void* CreateWindowStationA(LPCSTR lpszWinSta, DWORD dwFlags, DWORD dwDesiredAccess, void* lpsa);
        void* OpenWindowStationA(LPCSTR lpszWinSta, BOOL fInherit, DWORD dwDesiredAccess);
        BOOL CloseWindowStation(void* hWinSta);
        BOOL SetProcessWindowStation(void* hWinSta);
        void* GetProcessWindowStation(void);
        BOOL EnumWindowStationsA(void* lpEnumFunc, LPARAM lParam);
        BOOL EnumDesktopsA(void* hwinsta, void* lpEnumFunc, LPARAM lParam);

        // 特殊窗口操作
        BOOL SetShellWindow(HWND hWnd);
        HWND GetShellWindow(void);
        BOOL SetProgmanWindow(HWND hWnd);
        HWND GetProgmanWindow(void);
        BOOL SetTaskmanWindow(HWND hWnd);
        HWND GetTaskmanWindow(void);
        BOOL IsServerSideWindow(HWND hwnd);

        // 反馈设置
        BOOL SetWindowFeedbackSetting(HWND hwnd, DWORD feedback, DWORD flags, UINT size, void* configuration);
        BOOL GetWindowFeedbackSetting(HWND hwnd, DWORD feedback, DWORD flags, UINT* size, void* configuration);

        // 手势
        BOOL SetGestureConfig(HWND hwnd, DWORD dwReserved, UINT cIDs, void* pGestureConfig, UINT cbSize);
        BOOL GetGestureConfig(HWND hwnd, DWORD dwReserved, UINT dwFlags, UINT cIDs, void* pGestureConfig, UINT cbSize);

        // 窗口组合属性
        BOOL SetWindowCompositionAttribute(HWND hwnd, void* pAttrData);
        BOOL GetWindowCompositionAttribute(HWND hwnd, void* pAttrData);

        // 其他
        BOOL SetWindowArrangement(HWND hwnd, UINT wFlags, void* lpSid);
        BOOL GetWindowArrangement(HWND hwnd, UINT* pwFlags, void* lpSid);
        BOOL SetWindowStationUser(HWND hwnd, void* hWinSta, void* hDesk);
        BOOL GetWindowStationUser(HWND hwnd, void* phWinSta, void* phDesk);
        BOOL SetCursorPos(int X, int Y);
        BOOL GetCursorPos(POINT* lpPoint);
        BOOL ClipCursor(RECT* lpRect);
        BOOL GetClipCursor(RECT* lpRect);
        int ShowCursor(BOOL bShow);
        BOOL GetWindowRgnBox(HWND hWnd, RECT* lprc);
    ]])
end

-- ============================================================
-- 3. 安全调用辅助
-- ============================================================

local function safeCall(func, default)
    if not isWindows or not ffi then
        return default
    end
    local success, result = pcall(func)
    if success then
        return result
    end
    return default
end

local function safeCallVoid(func, ...)
    if not isWindows or not ffi then
        return
    end
    pcall(func, ...)
end

-- ============================================================
-- 4. 指针工具函数
-- ============================================================

-- 检查指针是否为空
function WinAPI.IsNull(ptr)
    return ptr == nil or ptr == ffi.NULL or ptr == 0
end

-- 获取指针地址 (调试用)
function WinAPI.GetPointerAddress(ptr)
    if WinAPI.IsNull(ptr) then return 0 end
    return tonumber(ffi.cast("uintptr_t", ptr))
end

-- 复制内存
function WinAPI.MemCopy(dest, src, size)
    if WinAPI.IsNull(dest) or WinAPI.IsNull(src) then return false end
    return safeCall(function()
        ffi.C.memcpy(dest, src, size or ffi.sizeof(dest))
        return true
    end, false)
end

-- 设置内存
function WinAPI.MemSet(dest, value, size)
    if WinAPI.IsNull(dest) then return false end
    return safeCall(function()
        ffi.C.memset(dest, value or 0, size or ffi.sizeof(dest))
        return true
    end, false)
end

-- 比较内存
function WinAPI.MemCompare(ptr1, ptr2, size)
    if WinAPI.IsNull(ptr1) or WinAPI.IsNull(ptr2) then return -1 end
    return safeCall(function()
        return ffi.C.memcmp(ptr1, ptr2, size or ffi.sizeof(ptr1))
    end, -1)
end

-- 创建缓冲区
function WinAPI.CreateBuffer(size)
    return ffi.new("char[?]", size)
end

-- 创建结构体
function WinAPI.CreateStruct(structType)
    return ffi.new(structType .. "[1]")
end

-- 指针转换
function WinAPI.CastPtr(ptr, targetType)
    if WinAPI.IsNull(ptr) then return nil end
    return ffi.cast(targetType, ptr)
end

-- 获取结构体大小
function WinAPI.SizeOf(structType)
    return ffi.sizeof(structType)
end

-- 获取指针指向的值 (用于调试)
function WinAPI.Dereference(ptr, type)
    if WinAPI.IsNull(ptr) then return nil end
    return ffi.cast(type .. "*", ptr)[0]
end

-- ============================================================
-- 5. 导出函数 (按类别分组)
-- ============================================================

-- 5.1 窗口管理
function WinAPI.GetActiveWindow() return safeCall(ffi.C.GetActiveWindow, nil) end
function WinAPI.GetForegroundWindow() return safeCall(ffi.C.GetForegroundWindow, nil) end
function WinAPI.FindWindow(className, windowName)
    return safeCall(function() return ffi.C.FindWindowA(className or nil, windowName or nil) end, nil)
end
function WinAPI.FindWindowEx(parent, childAfter, className, windowName)
    return safeCall(function() return ffi.C.FindWindowExA(parent or nil, childAfter or nil, className or nil, windowName or nil) end, nil)
end
function WinAPI.IsWindow(hwnd) return safeCall(function() return ffi.C.IsWindow(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.IsWindowVisible(hwnd) return safeCall(function() return ffi.C.IsWindowVisible(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.IsWindowEnabled(hwnd) return safeCall(function() return ffi.C.IsWindowEnabled(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.IsChild(parent, child) return safeCall(function() return ffi.C.IsChild(parent, child) == WinAPI.TRUE end, false) end
function WinAPI.IsZoomed(hwnd) return safeCall(function() return ffi.C.IsZoomed(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.IsIconic(hwnd) return safeCall(function() return ffi.C.IsIconic(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.IsWindowUnicode(hwnd) return safeCall(function() return ffi.C.IsWindowUnicode(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.IsWindowRedirectedForPrint(hwnd) return safeCall(function() return ffi.C.IsWindowRedirectedForPrint(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.IsHungAppWindow(hwnd) return safeCall(function() return ffi.C.IsHungAppWindow(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.IsGUIThread(convert) return safeCall(function() return ffi.C.IsGUIThread(convert and 1 or 0) == WinAPI.TRUE end, false) end
function WinAPI.IsProcessDPIAware() return safeCall(ffi.C.IsProcessDPIAware, 0) end
function WinAPI.ShowWindow(hwnd, cmdShow) return safeCall(function() return ffi.C.ShowWindow(hwnd, cmdShow) == WinAPI.TRUE end, false) end
function WinAPI.SetWindowPos(hwnd, insertAfter, x, y, cx, cy, flags)
    return safeCall(function() return ffi.C.SetWindowPos(hwnd, insertAfter or 0, x or 0, y or 0, cx or 0, cy or 0, flags or 0) == WinAPI.TRUE end, false)
end
function WinAPI.GetWindowRect(hwnd)
    local rect = ffi.new("RECT[1]")
    if safeCall(function() return ffi.C.GetWindowRect(hwnd, rect) == WinAPI.TRUE end, false) then
        return rect[0].left, rect[0].top, rect[0].right, rect[0].bottom
    end
    return 0, 0, 0, 0
end
function WinAPI.GetClientRect(hwnd)
    local rect = ffi.new("RECT[1]")
    if safeCall(function() return ffi.C.GetClientRect(hwnd, rect) == WinAPI.TRUE end, false) then
        return rect[0].left, rect[0].top, rect[0].right, rect[0].bottom
    end
    return 0, 0, 0, 0
end
function WinAPI.MoveWindow(hwnd, x, y, width, height, repaint)
    return safeCall(function() return ffi.C.MoveWindow(hwnd, x or 0, y or 0, width or 0, height or 0, repaint and 1 or 0) == WinAPI.TRUE end, false)
end
function WinAPI.SetWindowText(hwnd, text) return safeCall(function() return ffi.C.SetWindowTextA(hwnd, text or "") == WinAPI.TRUE end, false) end
function WinAPI.GetWindowText(hwnd)
    return safeCall(function()
        local len = ffi.C.GetWindowTextLengthA(hwnd)
        if len <= 0 then return "" end
        local buf = ffi.new("char[?]", len + 1)
        ffi.C.GetWindowTextA(hwnd, buf, len + 1)
        return ffi.string(buf)
    end, "")
end
function WinAPI.GetWindowTextLength(hwnd) return safeCall(function() return ffi.C.GetWindowTextLengthA(hwnd) end, 0) end
function WinAPI.GetParent(hwnd) return safeCall(function() return ffi.C.GetParent(hwnd) end, nil) end
function WinAPI.SetParent(child, parent) return safeCall(function() return ffi.C.SetParent(child, parent or nil) end, nil) end
function WinAPI.GetWindowLong(hwnd, index) return safeCall(function() return ffi.C.GetWindowLongA(hwnd, index) end, 0) end
function WinAPI.SetWindowLong(hwnd, index, newLong) return safeCall(function() return ffi.C.SetWindowLongA(hwnd, index, newLong) end, 0) end
function WinAPI.GetWindowLongPtr(hwnd, index) return safeCall(function() return ffi.C.GetWindowLongPtrA(hwnd, index) end, 0) end
function WinAPI.SetWindowLongPtr(hwnd, index, newLong) return safeCall(function() return ffi.C.SetWindowLongPtrA(hwnd, index, newLong) end, 0) end
function WinAPI.SetLayeredWindowAttributes(hwnd, colorKey, alpha, flags)
    return safeCall(function() return ffi.C.SetLayeredWindowAttributes(hwnd, colorKey or 0, alpha or 0, flags or 0) == WinAPI.TRUE end, false)
end
function WinAPI.BringWindowToTop(hwnd) return safeCall(function() return ffi.C.BringWindowToTop(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.SetForegroundWindow(hwnd) return safeCall(function() return ffi.C.SetForegroundWindow(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.SetCapture(hwnd) return safeCall(function() return ffi.C.SetCapture(hwnd) end, nil) end
function WinAPI.ReleaseCapture() return safeCall(function() return ffi.C.ReleaseCapture() == WinAPI.TRUE end, false) end
function WinAPI.GetCapture() return safeCall(ffi.C.GetCapture, nil) end
function WinAPI.GetFocus() return safeCall(ffi.C.GetFocus, nil) end
function WinAPI.SetFocus(hwnd) return safeCall(function() return ffi.C.SetFocus(hwnd) end, nil) end
function WinAPI.GetDesktopWindow() return safeCall(ffi.C.GetDesktopWindow, nil) end
function WinAPI.GetWindow(hwnd, cmd) return safeCall(function() return ffi.C.GetWindow(hwnd, cmd or 0) end, nil) end
function WinAPI.EnumWindows(callback, lParam)
    return safeCall(function() return ffi.C.EnumWindows(callback, lParam or 0) == WinAPI.TRUE end, false)
end
function WinAPI.EnumChildWindows(parent, callback, lParam)
    return safeCall(function() return ffi.C.EnumChildWindows(parent, callback, lParam or 0) == WinAPI.TRUE end, false)
end
function WinAPI.GetNextWindow(hwnd, cmd) return safeCall(function() return ffi.C.GetNextWindow(hwnd, cmd or 0) end, nil) end
function WinAPI.GetTopWindow(parent) return safeCall(function() return ffi.C.GetTopWindow(parent or nil) end, nil) end
function WinAPI.GetAncestor(hwnd, flags) return safeCall(function() return ffi.C.GetAncestor(hwnd, flags or WinAPI.GA_PARENT) end, nil) end
function WinAPI.GetLastActivePopup(hwnd) return safeCall(function() return ffi.C.GetLastActivePopup(hwnd) end, nil) end
function WinAPI.GetSystemMetrics(index) return safeCall(function() return ffi.C.GetSystemMetrics(index or 0) end, 0) end
function WinAPI.GetSystemMetricsForDpi(index, dpi) return safeCall(function() return ffi.C.GetSystemMetricsForDpi(index or 0, dpi or 96) end, 0) end
function WinAPI.GetWindowThreadProcessId(hwnd)
    return safeCall(function()
        local pid = ffi.new("DWORD[1]")
        local tid = ffi.C.GetWindowThreadProcessId(hwnd, pid)
        return tid, pid[0]
    end, 0, 0)
end
function WinAPI.GetWindowInfo(hwnd)
    local info = ffi.new("WINDOWINFO[1]")
    info[0].cbSize = ffi.sizeof("WINDOWINFO")
    if safeCall(function() return ffi.C.GetWindowInfo(hwnd, info) == WinAPI.TRUE end, false) then
        return info[0]
    end
    return nil
end
function WinAPI.GetWindowPlacement(hwnd)
    local placement = ffi.new("WINDOWPLACEMENT[1]")
    placement[0].cbSize = ffi.sizeof("WINDOWPLACEMENT")
    if safeCall(function() return ffi.C.GetWindowPlacement(hwnd, placement) == WinAPI.TRUE end, false) then
        return placement[0]
    end
    return nil
end
function WinAPI.SetWindowPlacement(hwnd, placement) return safeCall(function() return ffi.C.SetWindowPlacement(hwnd, placement) == WinAPI.TRUE end, false) end
function WinAPI.LockWindowUpdate(hwnd) return safeCall(function() return ffi.C.LockWindowUpdate(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.FlashWindow(hwnd, invert) return safeCall(function() return ffi.C.FlashWindow(hwnd, invert and 1 or 0) == WinAPI.TRUE end, false) end
function WinAPI.FlashWindowEx(hwnd, flags, count, timeout)
    local fwi = ffi.new("FLASHWINFO[1]")
    fwi[0].cbSize = ffi.sizeof("FLASHWINFO")
    fwi[0].hwnd = hwnd
    fwi[0].dwFlags = flags or 0
    fwi[0].uCount = count or 3
    fwi[0].dwTimeout = timeout or 0
    return safeCall(function() return ffi.C.FlashWindowEx(fwi) == WinAPI.TRUE end, false)
end
function WinAPI.AnimateWindow(hwnd, time, flags)
    return safeCall(function() return ffi.C.AnimateWindow(hwnd, time or 200, flags or 0) == WinAPI.TRUE end, false)
end
function WinAPI.UpdateWindow(hwnd) return safeCall(function() return ffi.C.UpdateWindow(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.RedrawWindow(hwnd, rect, region, flags)
    return safeCall(function() return ffi.C.RedrawWindow(hwnd, rect or nil, region or nil, flags or 0) == WinAPI.TRUE end, false)
end
function WinAPI.InvalidateRect(hwnd, rect, erase)
    return safeCall(function() return ffi.C.InvalidateRect(hwnd, rect or nil, erase and 1 or 0) == WinAPI.TRUE end, false)
end
function WinAPI.ValidateRect(hwnd, rect) return safeCall(function() return ffi.C.ValidateRect(hwnd, rect or nil) == WinAPI.TRUE end, false) end
function WinAPI.ScrollWindow(hwnd, dx, dy, rect, clipRect)
    return safeCallVoid(ffi.C.ScrollWindow, hwnd, dx or 0, dy or 0, rect or nil, clipRect or nil)
end
function WinAPI.ScrollWindowEx(hwnd, dx, dy, scrollRect, clipRect, region, updateRect, flags)
    return safeCall(function() return ffi.C.ScrollWindowEx(hwnd, dx or 0, dy or 0, scrollRect or nil, clipRect or nil, region or nil, updateRect or nil, flags or 0) end, 0)
end
function WinAPI.ShowScrollBar(hwnd, bar, show) return safeCall(function() return ffi.C.ShowScrollBar(hwnd, bar or 0, show and 1 or 0) == WinAPI.TRUE end, false) end
function WinAPI.EnableScrollBar(hwnd, flags, arrows) return safeCall(function() return ffi.C.EnableScrollBar(hwnd, flags or 0, arrows or 0) == WinAPI.TRUE end, false) end
function WinAPI.GetScrollPos(hwnd, bar) return safeCall(function() return ffi.C.GetScrollPos(hwnd, bar or 0) end, 0) end
function WinAPI.SetScrollPos(hwnd, bar, pos, redraw) return safeCall(function() return ffi.C.SetScrollPos(hwnd, bar or 0, pos or 0, redraw and 1 or 0) end, 0) end
function WinAPI.GetScrollInfo(hwnd, bar)
    local info = ffi.new("SCROLLINFO[1]")
    info[0].cbSize = ffi.sizeof("SCROLLINFO")
    info[0].fMask = 0x001F -- SIF_ALL
    if safeCall(function() return ffi.C.GetScrollInfo(hwnd, bar or 0, info) == WinAPI.TRUE end, false) then
        return info[0]
    end
    return nil
end
function WinAPI.SetScrollInfo(hwnd, bar, info, redraw) return safeCall(function() return ffi.C.SetScrollInfo(hwnd, bar or 0, info, redraw and 1 or 0) end, 0) end
function WinAPI.SetWindowRgn(hwnd, region, redraw) return safeCall(function() return ffi.C.SetWindowRgn(hwnd, region, redraw and 1 or 0) end, 0) end
function WinAPI.GetWindowRgn(hwnd, region) return safeCall(function() return ffi.C.GetWindowRgn(hwnd, region) end, 0) end
function WinAPI.SetWindowDisplayAffinity(hwnd, affinity) return safeCall(function() return ffi.C.SetWindowDisplayAffinity(hwnd, affinity or 0) == WinAPI.TRUE end, false) end
function WinAPI.GetWindowDisplayAffinity(hwnd)
    return safeCall(function()
        local affinity = ffi.new("DWORD[1]")
        if ffi.C.GetWindowDisplayAffinity(hwnd, affinity) == WinAPI.TRUE then
            return affinity[0]
        end
        return 0
    end, 0)
end
function WinAPI.PrintWindow(hwnd, hdc, flags) return safeCall(function() return ffi.C.PrintWindow(hwnd, hdc, flags or 0) == WinAPI.TRUE end, false) end
function WinAPI.SetWindowContextHelpId(hwnd, id) return safeCall(function() return ffi.C.SetWindowContextHelpId(hwnd, id or 0) == WinAPI.TRUE end, false) end
function WinAPI.GetWindowContextHelpId(hwnd) return safeCall(function() return ffi.C.GetWindowContextHelpId(hwnd) end, 0) end
function WinAPI.GetWindowModuleFileName(hwnd, maxLen)
    return safeCall(function()
        local buf = ffi.new("char[?]", (maxLen or 260) + 1)
        local len = ffi.C.GetWindowModuleFileNameA(hwnd, buf, maxLen or 260)
        return ffi.string(buf, len)
    end, "")
end
function WinAPI.IsHungAppWindow(hwnd) return safeCall(function() return ffi.C.IsHungAppWindow(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.RealChildWindowFromPoint(hwnd, x, y)
    local pt = ffi.new("POINT[1]")
    pt[0].x = x or 0
    pt[0].y = y or 0
    return safeCall(function() return ffi.C.RealChildWindowFromPoint(hwnd, pt) end, nil)
end
function WinAPI.RealGetWindowClass(hwnd, maxLen)
    return safeCall(function()
        local buf = ffi.new("char[?]", (maxLen or 256) + 1)
        local len = ffi.C.RealGetWindowClassA(hwnd, buf, maxLen or 256)
        return ffi.string(buf, len)
    end, "")
end
function WinAPI.LogicalToPhysicalPoint(hwnd, x, y)
    local pt = ffi.new("POINT[1]")
    pt[0].x = x or 0
    pt[0].y = y or 0
    if safeCall(function() return ffi.C.LogicalToPhysicalPoint(hwnd, pt) == WinAPI.TRUE end, false) then
        return pt[0].x, pt[0].y
    end
    return x, y
end
function WinAPI.PhysicalToLogicalPoint(hwnd, x, y)
    local pt = ffi.new("POINT[1]")
    pt[0].x = x or 0
    pt[0].y = y or 0
    if safeCall(function() return ffi.C.PhysicalToLogicalPoint(hwnd, pt) == WinAPI.TRUE end, false) then
        return pt[0].x, pt[0].y
    end
    return x, y
end

-- 5.2 消息函数
function WinAPI.SendMessage(hwnd, msg, wParam, lParam)
    return safeCall(function() return ffi.C.SendMessageA(hwnd, msg or 0, wParam or 0, lParam or 0) end, 0)
end
function WinAPI.SendMessageTimeout(hwnd, msg, wParam, lParam, flags, timeout)
    return safeCall(function()
        local result = ffi.new("DWORD[1]")
        local ret = ffi.C.SendMessageTimeoutA(hwnd, msg or 0, wParam or 0, lParam or 0, flags or 0, timeout or 1000, result)
        return ret == WinAPI.TRUE, result[0]
    end, false, 0)
end
function WinAPI.SendNotifyMessage(hwnd, msg, wParam, lParam)
    return safeCall(function() return ffi.C.SendNotifyMessageA(hwnd, msg or 0, wParam or 0, lParam or 0) == WinAPI.TRUE end, false)
end
function WinAPI.PostMessage(hwnd, msg, wParam, lParam)
    return safeCall(function() return ffi.C.PostMessageA(hwnd, msg or 0, wParam or 0, lParam or 0) == WinAPI.TRUE end, false)
end
function WinAPI.PostThreadMessage(threadId, msg, wParam, lParam)
    return safeCall(function() return ffi.C.PostThreadMessageA(threadId or 0, msg or 0, wParam or 0, lParam or 0) == WinAPI.TRUE end, false)
end
function WinAPI.PeekMessage(hwnd, filterMin, filterMax, removeFlags)
    local msg = ffi.new("MSG[1]")
    if safeCall(function() return ffi.C.PeekMessageA(msg, hwnd or nil, filterMin or 0, filterMax or 0, removeFlags or 0) == WinAPI.TRUE end, false) then
        return msg[0]
    end
    return nil
end
function WinAPI.GetMessage(hwnd, filterMin, filterMax)
    local msg = ffi.new("MSG[1]")
    if safeCall(function() return ffi.C.GetMessageA(msg, hwnd or nil, filterMin or 0, filterMax or 0) end, 0) > 0 then
        return msg[0]
    end
    return nil
end
function WinAPI.DispatchMessage(msg) return safeCall(function() return ffi.C.DispatchMessageA(msg) end, 0) end
function WinAPI.TranslateMessage(msg) return safeCall(function() return ffi.C.TranslateMessage(msg) == WinAPI.TRUE end, false) end
function WinAPI.TranslateAccelerator(hwnd, accelTable, msg)
    return safeCall(function() return ffi.C.TranslateAcceleratorA(hwnd, accelTable, msg) == WinAPI.TRUE end, false)
end
function WinAPI.IsDialogMessage(hwnd, msg) return safeCall(function() return ffi.C.IsDialogMessageA(hwnd, msg) == WinAPI.TRUE end, false) end
function WinAPI.WaitMessage() return safeCall(function() return ffi.C.WaitMessage() == WinAPI.TRUE end, false) end
function WinAPI.GetQueueStatus(flags) return safeCall(function() return ffi.C.GetQueueStatus(flags or 0) end, 0) end
function WinAPI.BroadcastSystemMessage(flags, recipients, msg, wParam, lParam)
    return safeCall(function()
        local recips = ffi.new("DWORD[1]", recipients or 0)
        local ret = ffi.C.BroadcastSystemMessageA(flags or 0, recips, msg or 0, wParam or 0, lParam or 0)
        return ret, recips[0]
    end, 0, 0)
end

-- 5.3 输入函数
function WinAPI.GetAsyncKeyState(vKey) return safeCall(function() return ffi.C.GetAsyncKeyState(vKey or 0) end, 0) end
function WinAPI.GetKeyState(vKey) return safeCall(function() return ffi.C.GetKeyState(vKey or 0) end, 0) end
function WinAPI.GetKeyboardState()
    return safeCall(function()
        local state = ffi.new("BYTE[256]")
        if ffi.C.GetKeyboardState(state) == WinAPI.TRUE then
            return state
        end
        return nil
    end, nil)
end
function WinAPI.SetKeyboardState(state)
    return safeCall(function() return ffi.C.SetKeyboardState(state) == WinAPI.TRUE end, false)
end
function WinAPI.GetKeyboardType(typeFlag) return safeCall(function() return ffi.C.GetKeyboardType(typeFlag or 0) end, 0) end
function WinAPI.GetDoubleClickTime() return safeCall(ffi.C.GetDoubleClickTime, 0) end
function WinAPI.SetDoubleClickTime(interval) return safeCall(function() return ffi.C.SetDoubleClickTime(interval or 500) == WinAPI.TRUE end, false) end
function WinAPI.GetCursorPos()
    local pt = ffi.new("POINT[1]")
    if safeCall(function() return ffi.C.GetCursorPos(pt) == WinAPI.TRUE end, false) then
        return pt[0].x, pt[0].y
    end
    return 0, 0
end
function WinAPI.SetCursorPos(x, y) return safeCall(function() return ffi.C.SetCursorPos(x or 0, y or 0) == WinAPI.TRUE end, false) end
function WinAPI.GetCursor() return safeCall(ffi.C.GetCursor, nil) end
function WinAPI.SetCursor(cursor) return safeCall(function() return ffi.C.SetCursor(cursor) end, nil) end
function WinAPI.LoadCursor(instance, cursorName)
    return safeCall(function() return ffi.C.LoadCursorA(instance or nil, cursorName or 0) end, nil)
end
function WinAPI.LoadCursorFromFile(fileName)
    return safeCall(function() return ffi.C.LoadCursorFromFileA(fileName) end, nil)
end
function WinAPI.DestroyCursor(cursor) return safeCall(function() return ffi.C.DestroyCursor(cursor) == WinAPI.TRUE end, false) end
function WinAPI.ClipCursor(rect) return safeCall(function() return ffi.C.ClipCursor(rect) == WinAPI.TRUE end, false) end
function WinAPI.GetClipCursor()
    local rect = ffi.new("RECT[1]")
    if safeCall(function() return ffi.C.GetClipCursor(rect) == WinAPI.TRUE end, false) then
        return rect[0]
    end
    return nil
end
function WinAPI.ShowCursor(show) return safeCall(function() return ffi.C.ShowCursor(show and 1 or 0) end, 0) end
function WinAPI.SwapMouseButton(swap) return safeCall(function() return ffi.C.SwapMouseButton(swap and 1 or 0) == WinAPI.TRUE end, false) end
function WinAPI.MouseEvent(flags, dx, dy, data, extraInfo)
    return safeCallVoid(ffi.C.mouse_event, flags or 0, dx or 0, dy or 0, data or 0, extraInfo or 0)
end
function WinAPI.KeyboardEvent(vKey, scan, flags, extraInfo)
    return safeCallVoid(ffi.C.keybd_event, vKey or 0, scan or 0, flags or 0, extraInfo or 0)
end
function WinAPI.RegisterHotKey(hwnd, id, modifiers, vk)
    return safeCall(function() return ffi.C.RegisterHotKey(hwnd, id or 0, modifiers or 0, vk or 0) == WinAPI.TRUE end, false)
end
function WinAPI.UnregisterHotKey(hwnd, id) return safeCall(function() return ffi.C.UnregisterHotKey(hwnd, id or 0) == WinAPI.TRUE end, false) end

-- 5.4 图标函数
function WinAPI.LoadIcon(instance, iconName)
    return safeCall(function() return ffi.C.LoadIconA(instance or nil, iconName or 0) end, nil)
end
function WinAPI.LoadImage(instance, name, type, cx, cy, loadFlags)
    return safeCall(function() return ffi.C.LoadImageA(instance or nil, name, type or 0, cx or 0, cy or 0, loadFlags or 0) end, nil)
end
function WinAPI.DestroyIcon(icon) return safeCall(function() return ffi.C.DestroyIcon(icon) == WinAPI.TRUE end, false) end
function WinAPI.CopyIcon(icon) return safeCall(function() return ffi.C.CopyIcon(icon) end, nil) end
function WinAPI.CreateIcon(instance, width, height, planes, bitsPixel, andBits, xorBits)
    return safeCall(function() return ffi.C.CreateIcon(instance or nil, width or 0, height or 0, planes or 1, bitsPixel or 1, andBits, xorBits) end, nil)
end
function WinAPI.DrawIconEx(hdc, x, y, icon, cx, cy, step, brush, flags)
    return safeCall(function() return ffi.C.DrawIconEx(hdc, x or 0, y or 0, icon, cx or 0, cy or 0, step or 0, brush or nil, flags or 0) == WinAPI.TRUE end, false)
end

-- 5.5 菜单函数
function WinAPI.GetMenu(hwnd) return safeCall(function() return ffi.C.GetMenu(hwnd) end, nil) end
function WinAPI.SetMenu(hwnd, menu) return safeCall(function() return ffi.C.SetMenu(hwnd, menu) == WinAPI.TRUE end, false) end
function WinAPI.CreateMenu() return safeCall(ffi.C.CreateMenu, nil) end
function WinAPI.CreatePopupMenu() return safeCall(ffi.C.CreatePopupMenu, nil) end
function WinAPI.DestroyMenu(menu) return safeCall(function() return ffi.C.DestroyMenu(menu) == WinAPI.TRUE end, false) end
function WinAPI.AppendMenu(menu, flags, id, item)
    return safeCall(function() return ffi.C.AppendMenuA(menu, flags or 0, id or 0, item or "") == WinAPI.TRUE end, false)
end
function WinAPI.InsertMenu(menu, position, flags, id, item)
    return safeCall(function() return ffi.C.InsertMenuA(menu, position or 0, flags or 0, id or 0, item or "") == WinAPI.TRUE end, false)
end
function WinAPI.DeleteMenu(menu, position, flags)
    return safeCall(function() return ffi.C.DeleteMenu(menu, position or 0, flags or 0) == WinAPI.TRUE end, false)
end
function WinAPI.ModifyMenu(menu, position, flags, id, item)
    return safeCall(function() return ffi.C.ModifyMenuA(menu, position or 0, flags or 0, id or 0, item or "") == WinAPI.TRUE end, false)
end
function WinAPI.GetMenuString(menu, id, maxLen, flags)
    return safeCall(function()
        local buf = ffi.new("char[?]", (maxLen or 256) + 1)
        if ffi.C.GetMenuStringA(menu, id or 0, buf, maxLen or 256, flags or 0) > 0 then
            return ffi.string(buf)
        end
        return ""
    end, "")
end
function WinAPI.GetMenuItemCount(menu) return safeCall(function() return ffi.C.GetMenuItemCount(menu) end, -1) end
function WinAPI.GetMenuItemID(menu, pos) return safeCall(function() return ffi.C.GetMenuItemID(menu, pos or 0) end, 0) end
function WinAPI.CheckMenuItem(menu, id, check) return safeCall(function() return ffi.C.CheckMenuItem(menu, id or 0, check or 0) end, 0) end
function WinAPI.EnableMenuItem(menu, id, enable) return safeCall(function() return ffi.C.EnableMenuItem(menu, id or 0, enable or 0) end, 0) end
function WinAPI.GetSubMenu(menu, pos) return safeCall(function() return ffi.C.GetSubMenu(menu, pos or 0) end, nil) end
function WinAPI.GetMenuInfo(menu)
    local info = ffi.new("MENUINFO[1]")
    info[0].cbSize = ffi.sizeof("MENUINFO")
    if safeCall(function() return ffi.C.GetMenuInfo(menu, info) == WinAPI.TRUE end, false) then
        return info[0]
    end
    return nil
end
function WinAPI.SetMenuInfo(menu, info) return safeCall(function() return ffi.C.SetMenuInfo(menu, info) == WinAPI.TRUE end, false) end
function WinAPI.DrawMenuBar(hwnd) return safeCall(function() return ffi.C.DrawMenuBar(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.GetSystemMenu(hwnd, revert) return safeCall(function() return ffi.C.GetSystemMenu(hwnd, revert and 1 or 0) end, nil) end
function WinAPI.HiliteMenuItem(hwnd, menu, id, hilite) return safeCall(function() return ffi.C.HiliteMenuItem(hwnd, menu, id or 0, hilite or 0) == WinAPI.TRUE end, false) end
function WinAPI.GetMenuState(menu, id, flags) return safeCall(function() return ffi.C.GetMenuState(menu, id or 0, flags or 0) end, 0) end
function WinAPI.GetMenuDefaultItem(menu, byPos, flags) return safeCall(function() return ffi.C.GetMenuDefaultItem(menu, byPos and 1 or 0, flags or 0) end, 0) end
function WinAPI.SetMenuDefaultItem(menu, item, byPos) return safeCall(function() return ffi.C.SetMenuDefaultItem(menu, item or 0, byPos and 1 or 0) == WinAPI.TRUE end, false) end

-- 5.6 定时器函数
function WinAPI.SetTimer(hwnd, id, elapsed, callback)
    return safeCall(function() return ffi.C.SetTimer(hwnd, id or 0, elapsed or 1000, callback or nil) end, 0)
end
function WinAPI.KillTimer(hwnd, id) return safeCall(function() return ffi.C.KillTimer(hwnd, id or 0) == WinAPI.TRUE end, false) end

-- 5.7 钩子函数
function WinAPI.SetWindowsHookEx(id, callback, instance, threadId)
    return safeCall(function() return ffi.C.SetWindowsHookExA(id or 0, callback, instance or nil, threadId or 0) end, nil)
end
function WinAPI.UnhookWindowsHookEx(hook) return safeCall(function() return ffi.C.UnhookWindowsHookEx(hook) == WinAPI.TRUE end, false) end
function WinAPI.CallNextHookEx(hook, code, wParam, lParam)
    return safeCall(function() return ffi.C.CallNextHookEx(hook, code or 0, wParam or 0, lParam or 0) end, 0)
end

-- 5.8 剪切板函数
function WinAPI.OpenClipboard(hwnd) return safeCall(function() return ffi.C.OpenClipboard(hwnd or nil) == WinAPI.TRUE end, false) end
function WinAPI.CloseClipboard() return safeCall(function() return ffi.C.CloseClipboard() == WinAPI.TRUE end, false) end
function WinAPI.SetClipboardData(format, handle)
    return safeCall(function() return ffi.C.SetClipboardData(format or 0, handle) end, nil)
end
function WinAPI.GetClipboardData(format) return safeCall(function() return ffi.C.GetClipboardData(format or 0) end, nil) end
function WinAPI.EmptyClipboard() return safeCall(function() return ffi.C.EmptyClipboard() == WinAPI.TRUE end, false) end
function WinAPI.IsClipboardFormatAvailable(format) return safeCall(function() return ffi.C.IsClipboardFormatAvailable(format or 0) == WinAPI.TRUE end, false) end
function WinAPI.RegisterClipboardFormat(formatName)
    return safeCall(function() return ffi.C.RegisterClipboardFormatA(formatName) end, 0)
end
function WinAPI.CountClipboardFormats() return safeCall(ffi.C.CountClipboardFormats, 0) end
function WinAPI.EnumClipboardFormats(format) return safeCall(function() return ffi.C.EnumClipboardFormats(format or 0) end, 0) end
function WinAPI.GetClipboardOwner() return safeCall(ffi.C.GetClipboardOwner, nil) end
function WinAPI.GetClipboardViewer() return safeCall(ffi.C.GetClipboardViewer, nil) end
function WinAPI.SetClipboardViewer(hwnd) return safeCall(function() return ffi.C.SetClipboardViewer(hwnd) end, nil) end
function WinAPI.ChangeClipboardChain(remove, next)
    return safeCall(function() return ffi.C.ChangeClipboardChain(remove, next) == WinAPI.TRUE end, false)
end
function WinAPI.GetClipboardSequenceNumber() return safeCall(ffi.C.GetClipboardSequenceNumber, 0) end
function WinAPI.GetOpenClipboardWindow() return safeCall(ffi.C.GetOpenClipboardWindow, nil) end

-- 5.9 拖放函数
function WinAPI.DragAcceptFiles(hwnd, accept) return safeCallVoid(ffi.C.DragAcceptFiles, hwnd, accept and 1 or 0) end
function WinAPI.DragQueryFile(drop, index, maxLen)
    return safeCall(function()
        if maxLen then
            local buf = ffi.new("char[?]", maxLen + 1)
            local count = ffi.C.DragQueryFileA(drop, index or 0, buf, maxLen + 1)
            if count > 0 then return ffi.string(buf) end
            return ""
        else
            return ffi.C.DragQueryFileA(drop, index or 0, nil, 0)
        end
    end, 0)
end
function WinAPI.DragQueryPoint(drop)
    local pt = ffi.new("POINT[1]")
    if safeCall(function() return ffi.C.DragQueryPoint(drop, pt) == WinAPI.TRUE end, false) then
        return pt[0].x, pt[0].y
    end
    return 0, 0
end
function WinAPI.DragFinish(drop) return safeCallVoid(ffi.C.DragFinish, drop) end

-- 5.10 窗口类函数
function WinAPI.RegisterClass(wndClass) return safeCall(function() return ffi.C.RegisterClassA(wndClass) end, 0) end
function WinAPI.UnregisterClass(className, instance)
    return safeCall(function() return ffi.C.UnregisterClassA(className, instance or nil) == WinAPI.TRUE end, false)
end
function WinAPI.GetClassInfo(instance, className)
    local wndClass = ffi.new("WNDCLASSEXA[1]")
    wndClass[0].cbSize = ffi.sizeof("WNDCLASSEXA")
    if safeCall(function() return ffi.C.GetClassInfoA(instance or nil, className, wndClass) == WinAPI.TRUE end, false) then
        return wndClass[0]
    end
    return nil
end
function WinAPI.GetClassLong(hwnd, index) return safeCall(function() return ffi.C.GetClassLongA(hwnd, index) end, 0) end
function WinAPI.SetClassLong(hwnd, index, newLong) return safeCall(function() return ffi.C.SetClassLongA(hwnd, index, newLong) end, 0) end
function WinAPI.GetClassWord(hwnd, index) return safeCall(function() return ffi.C.GetClassWord(hwnd, index) end, 0) end
function WinAPI.SetClassWord(hwnd, index, newWord) return safeCall(function() return ffi.C.SetClassWord(hwnd, index, newWord) end, 0) end

-- 5.11 系统参数
function WinAPI.SystemParametersInfo(action, param, data, winIni)
    return safeCall(function() return ffi.C.SystemParametersInfoA(action or 0, param or 0, data or nil, winIni or 0) == WinAPI.TRUE end, false)
end

-- 5.12 消息框
function WinAPI.MessageBox(hwnd, text, caption, flags)
    return safeCall(function() return ffi.C.MessageBoxA(hwnd or nil, text or "", caption or "", flags or 0) end, 0)
end
function WinAPI.MessageBoxEx(hwnd, text, caption, flags, languageId)
    return safeCall(function() return ffi.C.MessageBoxExA(hwnd or nil, text or "", caption or "", flags or 0, languageId or 0) end, 0)
end

-- 5.13 模块/资源
function WinAPI.GetModuleHandle(moduleName)
    return safeCall(function() return ffi.C.GetModuleHandleA(moduleName or nil) end, nil)
end

-- 5.14 设备上下文
function WinAPI.GetDC(hwnd) return safeCall(function() return ffi.C.GetDC(hwnd or nil) end, nil) end
function WinAPI.GetWindowDC(hwnd) return safeCall(function() return ffi.C.GetWindowDC(hwnd or nil) end, nil) end
function WinAPI.ReleaseDC(hwnd, hdc) return safeCall(function() return ffi.C.ReleaseDC(hwnd or nil, hdc) end, 0) end
function WinAPI.GetDCEx(hwnd, clipRegion, flags) return safeCall(function() return ffi.C.GetDCEx(hwnd or nil, clipRegion or nil, flags or 0) end, nil) end

-- 5.15 子窗口/对话框
function WinAPI.GetDlgItem(hwnd, id) return safeCall(function() return ffi.C.GetDlgItem(hwnd, id or 0) end, nil) end
function WinAPI.GetDlgItemText(hwnd, id, maxLen)
    return safeCall(function()
        local buf = ffi.new("char[?]", (maxLen or 256) + 1)
        local len = ffi.C.GetDlgItemTextA(hwnd, id or 0, buf, maxLen or 256)
        return ffi.string(buf, len)
    end, "")
end
function WinAPI.SetDlgItemText(hwnd, id, text) return safeCall(function() return ffi.C.SetDlgItemTextA(hwnd, id or 0, text or "") == WinAPI.TRUE end, false) end
function WinAPI.SendDlgItemMessage(hwnd, id, msg, wParam, lParam)
    return safeCall(function() return ffi.C.SendDlgItemMessageA(hwnd, id or 0, msg or 0, wParam or 0, lParam or 0) end, 0)
end
function WinAPI.GetDlgCtrlID(hwnd) return safeCall(function() return ffi.C.GetDlgCtrlID(hwnd) end, 0) end
function WinAPI.CheckDlgButton(hwnd, id, check) return safeCall(function() return ffi.C.CheckDlgButton(hwnd, id or 0, check or 0) == WinAPI.TRUE end, false) end
function WinAPI.CheckRadioButton(hwnd, first, last, check)
    return safeCall(function() return ffi.C.CheckRadioButton(hwnd, first or 0, last or 0, check or 0) == WinAPI.TRUE end, false)
end
function WinAPI.IsDlgButtonChecked(hwnd, id) return safeCall(function() return ffi.C.IsDlgButtonChecked(hwnd, id or 0) end, 0) end
function WinAPI.EndDialog(hwnd, result) return safeCall(function() return ffi.C.EndDialog(hwnd, result or 0) == WinAPI.TRUE end, false) end
function WinAPI.MapDialogRect(hwnd, rect) return safeCall(function() return ffi.C.MapDialogRect(hwnd, rect) == WinAPI.TRUE end, false) end
function WinAPI.GetDialogBaseUnits() return safeCall(ffi.C.GetDialogBaseUnits, 0) end
function WinAPI.GetNextDlgGroupItem(hwnd, ctl, previous) return safeCall(function() return ffi.C.GetNextDlgGroupItem(hwnd, ctl or nil, previous and 1 or 0) end, nil) end
function WinAPI.GetNextDlgTabItem(hwnd, ctl, previous) return safeCall(function() return ffi.C.GetNextDlgTabItem(hwnd, ctl or nil, previous and 1 or 0) end, nil) end
function WinAPI.GetDlgItemInt(hwnd, id, signed)
    local translated = ffi.new("BOOL[1]")
    local val = safeCall(function() return ffi.C.GetDlgItemInt(hwnd, id or 0, translated, signed and 1 or 0) end, 0)
    return val, translated[0] == WinAPI.TRUE
end
function WinAPI.SetDlgItemInt(hwnd, id, value, signed) return safeCall(function() return ffi.C.SetDlgItemInt(hwnd, id or 0, value or 0, signed and 1 or 0) == WinAPI.TRUE end, false) end

-- 5.16 系统颜色
function WinAPI.GetSysColor(index) return safeCall(function() return ffi.C.GetSysColor(index or 0) end, 0) end
function WinAPI.SetSysColors(elements, colors)
    return safeCall(function()
        local elems = ffi.new("int[?]", #elements)
        local vals = ffi.new("DWORD[?]", #elements)
        for i, v in ipairs(elements) do
            elems[i-1] = v.index or 0
            vals[i-1] = v.color or 0
        end
        return ffi.C.SetSysColors(#elements, elems, vals) == WinAPI.TRUE
    end, false)
end
function WinAPI.GetSysColorBrush(index) return safeCall(function() return ffi.C.GetSysColorBrush(index or 0) end, nil) end

-- 5.17 DPI 相关
function WinAPI.SetProcessDPIAware() return safeCall(function() return ffi.C.SetProcessDPIAware() == WinAPI.TRUE end, false) end
function WinAPI.SetProcessDpiAwarenessContext(context) return safeCall(function() return ffi.C.SetProcessDpiAwarenessContext(context) == WinAPI.TRUE end, false) end
function WinAPI.GetProcessDpiAwarenessContext(hwnd) return safeCall(function() return ffi.C.GetProcessDpiAwarenessContext(hwnd) end, nil) end
function WinAPI.SetThreadDpiAwarenessContext(context) return safeCall(function() return ffi.C.SetThreadDpiAwarenessContext(context) end, nil) end
function WinAPI.GetThreadDpiAwarenessContext() return safeCall(ffi.C.GetThreadDpiAwarenessContext, nil) end
function WinAPI.GetWindowDpiAwarenessContext(hwnd) return safeCall(function() return ffi.C.GetWindowDpiAwarenessContext(hwnd) end, nil) end
function WinAPI.GetDpiForWindow(hwnd) return safeCall(function() return ffi.C.GetDpiForWindow(hwnd) end, 96) end
function WinAPI.GetDpiForSystem() return safeCall(ffi.C.GetDpiForSystem, 96) end

-- 5.18 多显示器
function WinAPI.MonitorFromWindow(hwnd, flags) return safeCall(function() return ffi.C.MonitorFromWindow(hwnd, flags or 0) end, nil) end
function WinAPI.MonitorFromRect(rect, flags) return safeCall(function() return ffi.C.MonitorFromRect(rect, flags or 0) end, nil) end
function WinAPI.MonitorFromPoint(x, y, flags)
    local pt = ffi.new("POINT[1]")
    pt[0].x = x or 0
    pt[0].y = y or 0
    return safeCall(function() return ffi.C.MonitorFromPoint(pt[0], flags or 0) end, nil)
end
function WinAPI.GetMonitorInfo(monitor)
    local info = ffi.new("MONITORINFO[1]")
    info[0].cbSize = ffi.sizeof("MONITORINFO")
    if safeCall(function() return ffi.C.GetMonitorInfoA(monitor, info) == WinAPI.TRUE end, false) then
        return info[0]
    end
    return nil
end
function WinAPI.EnumDisplayMonitors(hdc, rect, callback, lParam)
    return safeCall(function() return ffi.C.EnumDisplayMonitors(hdc or nil, rect or nil, callback, lParam or 0) == WinAPI.TRUE end, false)
end

-- 5.19 输入法 (IME)
function WinAPI.ImmGetContext(hwnd) return safeCall(function() return ffi.C.ImmGetContext(hwnd) end, nil) end
function WinAPI.ImmSetContext(hwnd, himc) return safeCall(function() return ffi.C.ImmSetContext(hwnd, himc) == WinAPI.TRUE end, false) end
function WinAPI.ImmGetOpenStatus(himc) return safeCall(function() return ffi.C.ImmGetOpenStatus(himc) == WinAPI.TRUE end, false) end
function WinAPI.ImmSetOpenStatus(himc, open) return safeCall(function() return ffi.C.ImmSetOpenStatus(himc, open and 1 or 0) == WinAPI.TRUE end, false) end
function WinAPI.GetKeyboardLayout(threadId) return safeCall(function() return ffi.C.GetKeyboardLayout(threadId or 0) end, nil) end
function WinAPI.ActivateKeyboardLayout(hkl, flags) return safeCall(function() return ffi.C.ActivateKeyboardLayout(hkl, flags or 0) end, nil) end

-- 5.20 线程/进程
function WinAPI.AttachThreadInput(attach, attachTo, attachFlag)
    return safeCall(function() return ffi.C.AttachThreadInput(attach or 0, attachTo or 0, attachFlag and 1 or 0) == WinAPI.TRUE end, false)
end
function WinAPI.WaitForInputIdle(process, timeout) return safeCall(function() return ffi.C.WaitForInputIdle(process, timeout or 5000) end, 0) end

-- 5.21 桌面/窗口站
function WinAPI.SetThreadDesktop(hDesktop) return safeCall(function() return ffi.C.SetThreadDesktop(hDesktop) == WinAPI.TRUE end, false) end
function WinAPI.GetThreadDesktop(threadId) return safeCall(function() return ffi.C.GetThreadDesktop(threadId or 0) end, nil) end
function WinAPI.CloseDesktop(hDesktop) return safeCall(function() return ffi.C.CloseDesktop(hDesktop) == WinAPI.TRUE end, false) end
function WinAPI.CreateDesktop(name, device, devMode, flags, access, lpsa)
    return safeCall(function() return ffi.C.CreateDesktopA(name, device or nil, devMode or nil, flags or 0, access or 0, lpsa or nil) end, nil)
end
function WinAPI.OpenDesktop(name, flags, inherit, access) return safeCall(function() return ffi.C.OpenDesktopA(name, flags or 0, inherit and 1 or 0, access or 0) end, nil) end
function WinAPI.CreateWindowStation(name, flags, access, lpsa) return safeCall(function() return ffi.C.CreateWindowStationA(name, flags or 0, access or 0, lpsa or nil) end, nil) end
function WinAPI.OpenWindowStation(name, inherit, access) return safeCall(function() return ffi.C.OpenWindowStationA(name, inherit and 1 or 0, access or 0) end, nil) end
function WinAPI.CloseWindowStation(hWinSta) return safeCall(function() return ffi.C.CloseWindowStation(hWinSta) == WinAPI.TRUE end, false) end
function WinAPI.SetProcessWindowStation(hWinSta) return safeCall(function() return ffi.C.SetProcessWindowStation(hWinSta) == WinAPI.TRUE end, false) end
function WinAPI.GetProcessWindowStation() return safeCall(ffi.C.GetProcessWindowStation, nil) end
function WinAPI.EnumWindowStations(callback, lParam) return safeCall(function() return ffi.C.EnumWindowStationsA(callback, lParam or 0) == WinAPI.TRUE end, false) end
function WinAPI.EnumDesktops(hWinSta, callback, lParam) return safeCall(function() return ffi.C.EnumDesktopsA(hWinSta, callback, lParam or 0) == WinAPI.TRUE end, false) end

-- 5.22 特殊窗口
function WinAPI.SetShellWindow(hwnd) return safeCall(function() return ffi.C.SetShellWindow(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.GetShellWindow() return safeCall(ffi.C.GetShellWindow, nil) end
function WinAPI.SetProgmanWindow(hwnd) return safeCall(function() return ffi.C.SetProgmanWindow(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.GetProgmanWindow() return safeCall(ffi.C.GetProgmanWindow, nil) end
function WinAPI.SetTaskmanWindow(hwnd) return safeCall(function() return ffi.C.SetTaskmanWindow(hwnd) == WinAPI.TRUE end, false) end
function WinAPI.GetTaskmanWindow() return safeCall(ffi.C.GetTaskmanWindow, nil) end
function WinAPI.IsServerSideWindow(hwnd) return safeCall(function() return ffi.C.IsServerSideWindow(hwnd) == WinAPI.TRUE end, false) end

-- 5.23 反馈和手势
function WinAPI.SetWindowFeedbackSetting(hwnd, feedback, flags, size, config)
    return safeCall(function() return ffi.C.SetWindowFeedbackSetting(hwnd, feedback or 0, flags or 0, size or 0, config or nil) == WinAPI.TRUE end, false)
end
function WinAPI.GetWindowFeedbackSetting(hwnd, feedback, flags)
    local size = ffi.new("UINT[1]")
    return safeCall(function()
        return ffi.C.GetWindowFeedbackSetting(hwnd, feedback or 0, flags or 0, size, nil) == WinAPI.TRUE
    end, false)
end

-- 5.24 高级工具函数
function WinAPI.EnableColorKey(hwnd, colorKey)
    if WinAPI.IsNull(hwnd) then return false end
    local oldStyle = WinAPI.SetWindowLong(hwnd, WinAPI.GWL_EXSTYLE, WinAPI.WS_EX_LAYERED)
    if oldStyle == 0 then return false end
    return WinAPI.SetLayeredWindowAttributes(hwnd, colorKey, 0, WinAPI.LWA_COLORKEY)
end

function WinAPI.DisableLayered(hwnd)
    if WinAPI.IsNull(hwnd) then return false end
    local oldStyle = WinAPI.GetWindowLong(hwnd, WinAPI.GWL_EXSTYLE)
    local newStyle = bit.band(oldStyle, bit.bnot(WinAPI.WS_EX_LAYERED))
    WinAPI.SetWindowLong(hwnd, WinAPI.GWL_EXSTYLE, newStyle)
    return true
end

function WinAPI.SetWindowAlpha(hwnd, alpha)
    if WinAPI.IsNull(hwnd) then return false end
    local oldStyle = WinAPI.SetWindowLong(hwnd, WinAPI.GWL_EXSTYLE, WinAPI.WS_EX_LAYERED)
    if oldStyle == 0 then return false end
    return WinAPI.SetLayeredWindowAttributes(hwnd, 0, alpha, WinAPI.LWA_ALPHA)
end

function WinAPI.SetTopMost(hwnd, enable)
    if WinAPI.IsNull(hwnd) then return false end
    local insertAfter = enable and WinAPI.HWND_TOPMOST or WinAPI.HWND_NOTOPMOST
    return WinAPI.SetWindowPos(hwnd, insertAfter, 0, 0, 0, 0, WinAPI.SWP_NOMOVE | WinAPI.SWP_NOSIZE)
end

function WinAPI.ResetWindow(hwnd)
    if WinAPI.IsNull(hwnd) then return false end
    local oldStyle = WinAPI.GetWindowLong(hwnd, WinAPI.GWL_EXSTYLE)
    local newStyle = bit.band(oldStyle, bit.bnot(WinAPI.WS_EX_LAYERED))
    WinAPI.SetWindowLong(hwnd, WinAPI.GWL_EXSTYLE, newStyle)
    return true
end

function WinAPI.GetScreenSize()
    local width = WinAPI.GetSystemMetrics(WinAPI.SM_CXSCREEN)
    local height = WinAPI.GetSystemMetrics(WinAPI.SM_CYSCREEN)
    return width, height
end

function WinAPI.GetVirtualScreenSize()
    local x = WinAPI.GetSystemMetrics(WinAPI.SM_XVIRTUALSCREEN)
    local y = WinAPI.GetSystemMetrics(WinAPI.SM_YVIRTUALSCREEN)
    local width = WinAPI.GetSystemMetrics(WinAPI.SM_CXVIRTUALSCREEN)
    local height = WinAPI.GetSystemMetrics(WinAPI.SM_CYVIRTUALSCREEN)
    return x, y, width, height
end

function WinAPI.IsKeyDown(vKey)
    local state = WinAPI.GetAsyncKeyState(vKey)
    return bit.band(state, 0x8000) ~= 0
end

function WinAPI.IsKeyToggled(vKey)
    local state = WinAPI.GetKeyState(vKey)
    return bit.band(state, 0x0001) ~= 0
end

-- ============================================================
-- 6. 模块导出
-- ============================================================

return WinAPI