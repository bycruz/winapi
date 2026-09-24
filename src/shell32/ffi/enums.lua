---@class winapi.shell32.Enums
local enums = {}

--- The message a window receives for each dropped file once it has been
--- registered with shell32.dragAcceptFiles(hwnd, true). wParam is the HDROP to
--- pass to the dragQuery* helpers, lParam is unused (0).
---@enum winapi.shell32.WM
enums.WM = {
	DROPFILES = 0x0233,
}

return enums
