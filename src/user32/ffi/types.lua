---@class winapi.user32.ffi.HWND: ffi.cdata*

---@class winapi.user32.ffi.WPARAM: ffi.cdata*

---@class winapi.user32.ffi.LPARAM: ffi.cdata*

---@class winapi.user32.ffi.MSG: ffi.cdata*
---@field hwnd winapi.user32.ffi.HWND
---@field message number
---@field wParam winapi.user32.ffi.WPARAM
---@field lParam winapi.user32.ffi.LPARAM
---@field time number
---@field pt { x: number, y: number }
---@field lPrivate number

---@alias winapi.user32.ffi.WNDPROC fun(hWnd: winapi.user32.ffi.HWND, uMsg: number, wParam: winapi.user32.ffi.WPARAM, lParam: winapi.user32.ffi.LPARAM): number

---@class winapi.user32.ffi.WNDCLASSEXA: ffi.cdata*
---@field lpfnWndProc ffi.cdata*
---@field hInstance ffi.cdata*
---@field lpszClassName string
---@field hCursor ffi.cdata*
---@field hIcon ffi.cdata*
---@field hIconSm ffi.cdata*
---@field cbSize number
---@field hbrBackground ffi.cdata*
---@field style number

---@class winapi.user32.ffi.HDC: ffi.cdata*

---@class winapi.user32.ffi.RECT: ffi.cdata*
---@field left number
---@field top number
---@field right number
---@field bottom number

---@class winapi.user32.ffi.LPCSTR: ffi.cdata*

---@class winapi.user32.ffi.POINT: ffi.cdata*
---@field x number
---@field y number

---@class winapi.user32.ffi.HANDLE: ffi.cdata*
