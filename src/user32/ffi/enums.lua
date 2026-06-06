local ffi = require("ffi")

---@param user32 winapi.user32
return function(user32)
	---@class winapi.user32.Enums
	local enums = {}

	---@enum winapi.user32.IDC
	enums.IDC = {
		ARROW = user32.LPCSTR(ffi.cast("const char*", 32512)),
		HAND = user32.LPCSTR(ffi.cast("const char*", 32649))
	}

	---@enum winapi.user32.IDI
	enums.IDI = {
		APPLICATION = user32.LPCSTR(ffi.cast("const char*", 32512))
	}

	---@enum winapi.user32.COLOR
	enums.COLOR = {
		WINDOW = 5
	}

	---@enum winapi.user32.CS
	enums.CS = {
		HREDRAW = 0x0002,
		VREDRAW = 0x0001
	}

	---@enum winapi.user32.WS
	enums.WS = {
		BORDER           = 0x00800000,
		CAPTION          = 0x00C00000,
		CHILD            = 0x40000000,
		CHILDWINDOW      = 0x40000000,
		CLIPCHILDREN     = 0x02000000,
		CLIPSIBLINGS     = 0x04000000,
		DISABLED         = 0x08000000,
		DLGFRAME         = 0x00400000,
		GROUP            = 0x00020000,
		HSCROLL          = 0x00100000,
		ICONIC           = 0x20000000,
		MAXIMIZE         = 0x01000000,
		MAXIMIZEBOX      = 0x00010000,
		MINIMIZE         = 0x20000000,
		MINIMIZEBOX      = 0x00020000,
		OVERLAPPED       = 0x00000000,
		OVERLAPPEDWINDOW = 0x00CF0000,
		POPUP            = 0x80000000,
		POPUPWINDOW      = 0x80880000,
		SIZEBOX          = 0x00040000,
		SYSMENU          = 0x00080000,
		TABSTOP          = 0x00010000,
		THICKFRAME       = 0x00040000,
		VISIBLE          = 0x10000000,
		VSCROLL          = 0x00200000
	}

	---@enum winapi.user32.WM
	enums.WM = {
		CREATE            = 0x0001,
		DESTROY           = 0x0002,
		CLOSE             = 0x0010,
		QUIT              = 0x0012,
		PAINT             = 0x000F,
		SIZE              = 0x0005,
		SETCURSOR         = 0x0020,
		MOUSEMOVE         = 0x0200,
		LBUTTONDOWN       = 0x0201,
		LBUTTONUP         = 0x0202,
		RBUTTONDOWN       = 0x0204,
		RBUTTONUP         = 0x0205,
		MBUTTONDOWN       = 0x0207,
		MBUTTONUP         = 0x0208,
		MOUSEWHEEL        = 0x020A,
		XBUTTONDOWN       = 0x020B,
		XBUTTONUP         = 0x020C,
		MOUSEHWHEEL       = 0x020E,
		KEYDOWN           = 0x0100,
		KEYUP             = 0x0101,
		CHAR              = 0x0102,
		SYSKEYDOWN        = 0x0104,
		SYSKEYUP          = 0x0105,
		SYSCHAR           = 0x0106,
		ERASEBKGND        = 0x0014,
		NCDESTROY         = 0x0082,
		ACTIVATE          = 0x0006,
		ACTIVATEAPP       = 0x001C,
		SETFOCUS          = 0x0007,
		KILLFOCUS         = 0x0008,
		GETMINMAXINFO     = 0x0024,
		COMMAND           = 0x0111,
		SYSCOMMAND        = 0x0112,
		TIMER             = 0x0113,
		CTLCOLORBTN       = 0x0135,
		CTLCOLOREDIT      = 0x0133,
		CTLCOLORLISTBOX   = 0x0134,
		CTLCOLORMSGBOX    = 0x0132,
		CTLCOLORSCROLLBAR = 0x0136,
		CTLCOLORSTATIC    = 0x0138
	}

	---@enum winapi.user32.VK
	enums.VK = {
		LBUTTON    = 0x01,
		RBUTTON    = 0x02,
		CANCEL     = 0x03,
		MBUTTON    = 0x04,
		XBUTTON1   = 0x05,
		XBUTTON2   = 0x06,
		BACK       = 0x08,
		TAB        = 0x09,
		CLEAR      = 0x0C,
		RETURN     = 0x0D,
		SHIFT      = 0x10,
		CONTROL    = 0x11,
		MENU       = 0x12,
		PAUSE      = 0x13,
		CAPITAL    = 0x14,
		ESCAPE     = 0x1B,
		SPACE      = 0x20,
		PRIOR      = 0x21,
		NEXT       = 0x22,
		END        = 0x23,
		HOME       = 0x24,
		LEFT       = 0x25,
		UP         = 0x26,
		RIGHT      = 0x27,
		DOWN       = 0x28,
		SELECT     = 0x29,
		PRINT      = 0x2A,
		EXECUTE    = 0x2B,
		SNAPSHOT   = 0x2C,
		INSERT     = 0x2D,
		DELETE     = 0x2E,
		HELP       = 0x2F,
		KEY_0      = 0x30,
		KEY_1      = 0x31,
		KEY_2      = 0x32,
		KEY_3      = 0x33,
		KEY_4      = 0x34,
		KEY_5      = 0x35,
		KEY_6      = 0x36,
		KEY_7      = 0x37,
		KEY_8      = 0x38,
		KEY_9      = 0x39,
		A          = 0x41,
		B          = 0x42,
		C          = 0x43,
		D          = 0x44,
		E          = 0x45,
		F          = 0x46,
		G          = 0x47,
		H          = 0x48,
		I          = 0x49,
		J          = 0x4A,
		K          = 0x4B,
		L          = 0x4C,
		M          = 0x4D,
		N          = 0x4E,
		O          = 0x4F,
		P          = 0x50,
		Q          = 0x51,
		R          = 0x52,
		S          = 0x53,
		T          = 0x54,
		U          = 0x55,
		V          = 0x56,
		W          = 0x57,
		X          = 0x58,
		Y          = 0x59,
		Z          = 0x5A,
		LWIN       = 0x5B,
		RWIN       = 0x5C,
		APPS       = 0x5D,
		SLEEP      = 0x5F,
		NUMPAD0    = 0x60,
		NUMPAD1    = 0x61,
		NUMPAD2    = 0x62,
		NUMPAD3    = 0x63,
		NUMPAD4    = 0x64,
		NUMPAD5    = 0x65,
		NUMPAD6    = 0x66,
		NUMPAD7    = 0x67,
		NUMPAD8    = 0x68,
		NUMPAD9    = 0x69,
		MULTIPLY   = 0x6A,
		ADD        = 0x6B,
		SEPARATOR  = 0x6C,
		SUBTRACT   = 0x6D,
		DECIMAL    = 0x6E,
		DIVIDE     = 0x6F,
		F1         = 0x70,
		F2         = 0x71,
		F3         = 0x72,
		F4         = 0x73,
		F5         = 0x74,
		F6         = 0x75,
		F7         = 0x76,
		F8         = 0x77,
		F9         = 0x78,
		F10        = 0x79,
		F11        = 0x7A,
		F12        = 0x7B,
		F13        = 0x7C,
		F14        = 0x7D,
		F15        = 0x7E,
		F16        = 0x7F,
		F17        = 0x80,
		F18        = 0x81,
		F19        = 0x82,
		F20        = 0x83,
		F21        = 0x84,
		F22        = 0x85,
		F23        = 0x86,
		F24        = 0x87,
		NUMLOCK    = 0x90,
		SCROLL     = 0x91,
		LSHIFT     = 0xA0,
		RSHIFT     = 0xA1,
		LCONTROL   = 0xA2,
		RCONTROL   = 0xA3,
		LMENU      = 0xA4,
		RMENU      = 0xA5,
		OEM_1      = 0xBA,
		OEM_PLUS   = 0xBB,
		OEM_COMMA  = 0xBC,
		OEM_MINUS  = 0xBD,
		OEM_PERIOD = 0xBE,
		OEM_2      = 0xBF,
		OEM_3      = 0xC0,
		OEM_4      = 0xDB,
		OEM_5      = 0xDC,
		OEM_6      = 0xDD,
		OEM_7      = 0xDE,
		OEM_8      = 0xDF
	}

	---@enum winapi.user32.PM
	enums.PM = {
		REMOVE = 0x0001
	}

	---@enum winapi.user32.ShowWindow
	enums.ShowWindow = {
		HIDE            = 0,
		SHOWNORMAL      = 1,
		SHOWMINIMIZED   = 2,
		SHOWMAXIMIZED   = 3,
		SHOWNOACTIVATE  = 4,
		SHOW            = 5,
		MINIMIZE        = 6,
		SHOWMINNOACTIVE = 7,
		SHOWNA          = 8,
		RESTORE         = 9,
		SHOWDEFAULT     = 10,
		FORCEMINIMIZE   = 11
	}

	-- Create window default
	enums.CW_USEDEFAULT = 0x80000000

	---@enum winapi.user32.GWLP
	enums.GWLP = {
		WNDPROC = -4
	}

	return enums
end
