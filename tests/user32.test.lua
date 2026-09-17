local test = require("lde-test")
local winapi = require("winapi")

test.it("should load cursor", function()
	local cursor = winapi.user32.loadCursor(nil, winapi.user32.IDC.ARROW)
	test.notEqual(cursor, nil)
end)

test.it("should load icon", function()
	local icon = winapi.user32.loadIcon(nil, winapi.user32.IDI.APPLICATION)
	test.notEqual(icon, nil)
end)

test.it("should get system color brush", function()
	local brush = winapi.user32.getSysColorBrush(winapi.user32.COLOR.WINDOW)
	test.notEqual(brush, nil)
end)

test.it("should create and manipulate RECT", function()
	local rect = winapi.user32.Rect()
	rect.left = 0
	rect.top = 0
	rect.right = 800
	rect.bottom = 600
	test.equal(rect.right, 800)
	test.equal(rect.bottom, 600)
end)

test.it("should adjust window rect", function()
	local rect = winapi.user32.Rect()
	rect.left = 0
	rect.top = 0
	rect.right = 800
	rect.bottom = 600

	local result = winapi.user32.adjustWindowRect(rect, winapi.user32.WS.OVERLAPPEDWINDOW, false)
	test.equal(result, true)
	-- Window rect should be larger after accounting for decorations
	test.notEqual(rect.left, 0)
end)

test.it("should create window class structure", function()
	local wndClass = winapi.user32.WndClassEx()

	wndClass.lpszClassName = "TestWindowClass"
	wndClass.lpfnWndProc = winapi.user32.WndProc(function(hwnd, msg, wparam, lparam)
		if msg == winapi.user32.WM.DESTROY then
			winapi.user32.postQuitMessage(0)
			return 0
		end
		return winapi.user32.defWindowProc(hwnd, msg, wparam, lparam)
	end)
	wndClass.hInstance = winapi.kernel32.getModuleHandle(nil)
	wndClass.hCursor = winapi.user32.loadCursor(nil, winapi.user32.IDC.ARROW)
	wndClass.hIcon = winapi.user32.loadIcon(nil, winapi.user32.IDI.APPLICATION)
	wndClass.hbrBackground = winapi.user32.getSysColorBrush(winapi.user32.COLOR.WINDOW)
	wndClass.style = winapi.user32.CS.HREDRAW + winapi.user32.CS.VREDRAW

	test.notEqual(wndClass.hInstance, nil)
	test.notEqual(wndClass.hCursor, nil)
	test.notEqual(wndClass.hIcon, nil)
end)
