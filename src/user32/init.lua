local ffi = require("ffi")

ffi.cdef([[#embed "user32/ffi/ffidefs.h"]])

---@class winapi.user32.Fns
---@field CreateWindowExA fun(dwExStyle: number, lpClassName: string, lpWindowName: string, dwStyle: number, X: number, Y: number, nWidth: number, nHeight: number, hWndParent: userdata?, hMenu: userdata?, hInstance: userdata?, lpParam: userdata?): winapi.user32.ffi.HWND?
---@field DestroyWindow fun(hWnd: winapi.user32.ffi.HWND): number
---@field ShowWindow fun(hWnd: winapi.user32.ffi.HWND, nCmdShow: number): number
---@field UpdateWindow fun(hWnd: winapi.user32.ffi.HWND): number
---@field SetWindowTextA fun(hWnd: winapi.user32.ffi.HWND, lpString: string): number
---@field RegisterClassExA fun(lpWndClass: winapi.user32.ffi.WNDCLASSEXA): number
---@field UnregisterClassA fun(lpClassName: string, hInstance: ffi.cdata*): number
---@field IsWindow fun(hWnd: winapi.user32.ffi.HWND): number
---@field GetClientRect fun(hWnd: winapi.user32.ffi.HWND, lpRect: winapi.user32.ffi.RECT): number
---@field ValidateRect fun(hWnd: winapi.user32.ffi.HWND, lpRect: winapi.user32.ffi.RECT): number
---@field GetWindowTextA fun(hWnd: winapi.user32.ffi.HWND, lpString: ffi.cdata*, nMaxCount: number): number
---@field IsWindowVisible fun(hWnd: winapi.user32.ffi.HWND): number
---@field SetCursor fun(hCursor: ffi.cdata*): ffi.cdata*
---@field PeekMessageA fun(lpMsg: ffi.cdata*, hWnd: ffi.cdata*, wMsgFilterMin: number, wMsgFilterMax: number, wRemoveMsg: number): number
---@field GetMessageA fun(lpMsg: ffi.cdata*, hWnd: ffi.cdata*, wMsgFilterMin: number, wMsgFilterMax: number): number
---@field TranslateMessage fun(lpMsg: ffi.cdata*): number
---@field DispatchMessageA fun(lpMsg: ffi.cdata*): number
---@field PostQuitMessage fun(nExitCode: number): nil
---@field GetDC fun(hwnd: winapi.user32.ffi.HWND): winapi.user32.ffi.HDC
---@field DefWindowProcA fun(hwnd: winapi.user32.ffi.HWND, Msg: number, wParam: winapi.user32.ffi.WPARAM, lParam: winapi.user32.ffi.LPARAM): number
---@field LoadCursorA fun(hInstance: ffi.cdata*, lpCursorName: string | winapi.user32.ffi.LPCSTR): ffi.cdata*
---@field LoadIconA fun(hInstance: ffi.cdata*, lpIconName: string | winapi.user32.ffi.LPCSTR): ffi.cdata*
---@field GetSysColorBrush fun(nIndex: number): ffi.cdata*
---@field AdjustWindowRect fun(lpRect: winapi.user32.ffi.RECT, dwStyle: number, bMenu: boolean): number
---@field GetKeyState fun(nVirtKey: number): number
---@field GetAsyncKeyState fun(vKey: number): number
---@field GetCursorPos fun(lpPoint: winapi.user32.ffi.POINT): number
---@field SetCursorPos fun(X: number, Y: number): number
---@field ShowCursor fun(bShow: number): number
---@field SetCapture fun(hWnd: winapi.user32.ffi.HWND): winapi.user32.ffi.HWND?
---@field ReleaseCapture fun(): number
local C = ffi.load("user32")

---@class winapi.user32: winapi.user32.Enums
local user32 = {}

user32.createWindow = C.CreateWindowExA
user32.destroyWindow = C.DestroyWindow
user32.setWindowText = C.SetWindowTextA
user32.registerClass = C.RegisterClassExA
user32.unregisterClass = C.UnregisterClassA
user32.setCursor = C.SetCursor
user32.getMessage = C.GetMessageA
user32.translateMessage = C.TranslateMessage
user32.dispatchMessage = C.DispatchMessageA
user32.postQuitMessage = C.PostQuitMessage
user32.getDC = C.GetDC
user32.defWindowProc = C.DefWindowProcA
user32.loadCursor = C.LoadCursorA
user32.loadIcon = C.LoadIconA
user32.getSysColorBrush = C.GetSysColorBrush
user32.getKeyState = C.GetKeyState
user32.getAsyncKeyState = C.GetAsyncKeyState
user32.setCapture = C.SetCapture

---@param wnd winapi.user32.ffi.HWND
---@param show winapi.user32.ShowWindow
function user32.showWindow(wnd, show)
	return C.ShowWindow(wnd, show) ~= 0
end

---@param wnd winapi.user32.ffi.HWND
function user32.updateWindow(wnd)
	return C.UpdateWindow(wnd) ~= 0
end

---@param lpMsg winapi.user32.ffi.MSG
---@param hWnd winapi.user32.ffi.HWND?
---@param wMsgFilterMin number
---@param wMsgFilterMax number
---@param wRemoveMsg number
function user32.peekMessage(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax, wRemoveMsg)
	return C.PeekMessageA(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax, wRemoveMsg) ~= 0
end

---@param rect winapi.user32.ffi.RECT
---@param style number
---@param hasMenu boolean
function user32.adjustWindowRect(rect, style, hasMenu)
	return C.AdjustWindowRect(rect, style, hasMenu and 1 or 0) ~= 0
end

---@param lpPoint winapi.user32.ffi.POINT
---@return boolean
function user32.getCursorPos(lpPoint)
	return C.GetCursorPos(lpPoint) ~= 0
end

---@param x number
---@param y number
---@return boolean
function user32.setCursorPos(x, y)
	return C.SetCursorPos(x, y) ~= 0
end

---@param show boolean
---@return number
function user32.showCursor(show)
	return C.ShowCursor(show and 1 or 0)
end

---@return boolean
function user32.releaseCapture()
	return C.ReleaseCapture() ~= 0
end

---@param hwnd winapi.user32.ffi.HWND
---@param rect winapi.user32.ffi.RECT
---@return boolean
function user32.getClientRect(hwnd, rect)
	return C.GetClientRect(hwnd, rect) ~= 0
end

---@param hwnd winapi.user32.ffi.HWND
---@param rect winapi.user32.ffi.RECT
---@return boolean
function user32.validateRect(hwnd, rect)
	return C.ValidateRect(hwnd, rect) ~= 0
end

---@param hwnd winapi.user32.ffi.HWND
---@param maxCount number?
---@return string
function user32.getWindowText(hwnd, maxCount)
	maxCount = maxCount or 256
	local buffer = ffi.new("char[?]", maxCount)
	local len = C.GetWindowTextA(hwnd, buffer, maxCount)
	if len == 0 then
		return ""
	end
	return ffi.string(buffer, len)
end

---@param hwnd winapi.user32.ffi.HWND
---@return boolean
function user32.isWindow(hwnd)
	return C.IsWindow(hwnd) ~= 0
end

---@param hwnd winapi.user32.ffi.HWND
---@return boolean
function user32.isWindowVisible(hwnd)
	return C.IsWindowVisible(hwnd) ~= 0
end

---@type fun(): winapi.user32.ffi.MSG
user32.Msg = ffi.typeof("MSG") ---@diagnostic disable-line # ffi.cast isn't typed properly

---@return winapi.user32.ffi.WNDCLASSEXA
function user32.WndClassEx()
	return ffi.new("WNDCLASSEXA", { cbSize = ffi.sizeof("WNDCLASSEXA") }) ---@diagnostic disable-line # ffi.cast isn't typed properly
end

---@param fn winapi.user32.ffi.WNDPROC
---@return winapi.user32.ffi.WNDPROC
function user32.WndProc(fn)
	return ffi.cast("WNDPROC", fn) ---@diagnostic disable-line # ffi.cast isn't typed properly
end

---@type fun(): winapi.user32.ffi.RECT
user32.Rect = ffi.typeof("RECT") ---@diagnostic disable-line # ffi.cast isn't typed properly

---@type fun(): winapi.user32.ffi.POINT
user32.Point = ffi.typeof("POINT") ---@diagnostic disable-line # ffi.typeof isn't typed properly

---@type fun(s: winapi.user32.ffi.LPCSTR?): winapi.user32.ffi.LPCSTR
user32.LPCSTR = ffi.typeof("LPCSTR") ---@diagnostic disable-line # ffi.cast isn't typed properly

-- Macro equivalents for extracting values from wParam/lParam
-- These mimic the Windows API macros GET_X_LPARAM, GET_Y_LPARAM, LOWORD, HIWORD

---@param lParam winapi.user32.ffi.LPARAM
---@return number
function user32.GET_X_LPARAM(lParam)
	return tonumber(ffi.cast("short", bit.band(tonumber(lParam), 0xFFFF)))
end

---@param lParam winapi.user32.ffi.LPARAM
---@return number
function user32.GET_Y_LPARAM(lParam)
	return tonumber(ffi.cast("short", bit.rshift(tonumber(lParam), 16)))
end

---@param value winapi.user32.ffi.WPARAM|winapi.user32.ffi.LPARAM
---@return number
function user32.LOWORD(value)
	return bit.band(value, 0xFFFF)
end

---@param value winapi.user32.ffi.WPARAM|winapi.user32.ffi.LPARAM
---@return number
function user32.HIWORD(value)
	return bit.rshift(value, 16)
end

---@param wParam winapi.user32.ffi.WPARAM
---@return number
function user32.GET_WHEEL_DELTA_WPARAM(wParam)
	return tonumber(ffi.cast("short", bit.rshift(tonumber(wParam), 16)))
end

-- Load and merge enums
local enums = require("winapi.user32.ffi.enums")(user32)
for k, v in pairs(enums) do
	user32[k] = v
end

return user32
