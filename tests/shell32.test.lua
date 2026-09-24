local test = require("lde-test")
local ffi = require("ffi")
local winapi = require("winapi")

local kernel32 = winapi.kernel32
local shell32 = winapi.shell32
local user32 = winapi.user32

local CLASS_NAME = "winapiShell32TestWindow"

-- The dropped files are only ever described in memory: DragQueryFile reads the
-- CF_HDROP blob, it never touches the file system, so these paths need not exist.
local FILES = {
	"C:\\temp\\a.txt",
	"C:\\temp\\ünïcode 世界.txt",
}
local DROP_X, DROP_Y = 120, 45

--- The number of UTF-16 code units before the terminating NUL of a wide buffer.
---@param w winapi.kernel32.ffi.WCHAR
---@return number
local function wideLength(w)
	local units = 0
	while w[units] ~= 0 do
		units = units + 1
	end
	return units
end

--- Build the global memory blob that CF_HDROP describes: a DROPFILES header
--- followed by a double NUL-terminated list of UTF-16 file names. The caller
--- owns the result and releases it with shell32.dragFinish.
---@param files string[]
---@param x number
---@param y number
---@return winapi.shell32.ffi.HDROP?
local function makeDropFiles(files, x, y)
	local wideNames = {}
	local units = 1 -- the extra null that terminates the file list

	for i, file in ipairs(files) do
		wideNames[i] = kernel32.utf8ToWide(file)
		units = units + wideLength(wideNames[i]) + 1
	end

	local headerSize = ffi.sizeof("DROPFILES")
	local hDrop = kernel32.globalAlloc(kernel32.GMEM.MOVEABLE, headerSize + units * 2)
	if hDrop == nil then
		return nil
	end

	local ptr = kernel32.globalLock(hDrop)
	if ptr == nil then
		kernel32.globalFree(hDrop)
		return nil
	end

	local bytes = ffi.cast("char*", ptr)
	local header = ffi.cast("DROPFILES*", bytes)
	header.pFiles = headerSize
	header.pt.x = x
	header.pt.y = y
	header.fNC = 0
	header.fWide = 1

	local list = ffi.cast("WCHAR*", bytes + headerSize)
	local offset = 0
	for _, wideName in ipairs(wideNames) do
		local len = wideLength(wideName)
		for unit = 0, len - 1 do
			list[offset + unit] = wideName[unit]
		end
		offset = offset + len + 1
		list[offset - 1] = 0 -- every name is null terminated
	end
	list[offset] = 0 -- and the list ends with an extra null

	kernel32.globalUnlock(hDrop)

	return hDrop
end

--- Create the test window. `wndProc` must stay referenced until the window has
--- been destroyed, and the returned handle is NULL when creation failed.
---@param wndProc winapi.user32.ffi.WNDPROC
---@return winapi.user32.ffi.HWND?, winapi.kernel32.ffi.HMODULE
local function createWindow(wndProc)
	local hInstance = kernel32.getModuleHandle(nil)

	local wndClass = user32.WndClassEx()
	wndClass.lpszClassName = CLASS_NAME
	wndClass.lpfnWndProc = wndProc
	wndClass.hInstance = hInstance
	wndClass.hCursor = user32.loadCursor(nil, user32.IDC.ARROW)
	wndClass.hIcon = user32.loadIcon(nil, user32.IDI.APPLICATION)
	wndClass.hbrBackground = user32.getSysColorBrush(user32.COLOR.WINDOW)
	wndClass.style = user32.CS.HREDRAW + user32.CS.VREDRAW

	if user32.registerClass(wndClass) == 0 then
		return nil, hInstance
	end

	local hwnd = user32.createWindow(
		0,
		CLASS_NAME,
		"winapi shell32 test",
		user32.WS.OVERLAPPEDWINDOW,
		user32.CW_USEDEFAULT,
		user32.CW_USEDEFAULT,
		200,
		100,
		nil,
		nil,
		hInstance,
		nil
	)

	return hwnd, hInstance
end

test.it("should decode a dropped file list", function()
	local hDrop = makeDropFiles(FILES, DROP_X, DROP_Y)
	test.notEqual(hDrop, nil, "could not build the CF_HDROP blob")

	test.equal(shell32.dragQueryFileCount(hDrop), #FILES)
	test.equal(shell32.dragQueryFile(hDrop, 0), FILES[1])
	test.equal(shell32.dragQueryFile(hDrop, 1), FILES[2])

	shell32.dragFinish(hDrop)
end)

test.it("should return an empty string for an out of range index", function()
	local hDrop = makeDropFiles(FILES, DROP_X, DROP_Y)
	test.notEqual(hDrop, nil, "could not build the CF_HDROP blob")

	test.equal(shell32.dragQueryFile(hDrop, #FILES), "")
	test.equal(shell32.dragQueryFile(hDrop, 99), "")

	shell32.dragFinish(hDrop)
end)

test.it("should report the size a dropped file name needs", function()
	local hDrop = makeDropFiles(FILES, DROP_X, DROP_Y)
	test.notEqual(hDrop, nil, "could not build the CF_HDROP blob")

	-- Documented behaviour of the raw binding: with a NULL buffer the required
	-- size is returned in characters, NOT including the terminating null.
	local size = shell32.dragQueryFileW(hDrop, 0, nil, 0)
	test.equal(size, wideLength(kernel32.utf8ToWide(FILES[1])))

	shell32.dragFinish(hDrop)
end)

test.it("should report the drop point", function()
	local hDrop = makeDropFiles(FILES, DROP_X, DROP_Y)
	test.notEqual(hDrop, nil, "could not build the CF_HDROP blob")

	local point = shell32.Point()
	test.equal(shell32.dragQueryPoint(hDrop, point), true)
	test.equal(point.x, DROP_X)
	test.equal(point.y, DROP_Y)

	shell32.dragFinish(hDrop)
end)

test.it("should accept dropped files on a window", function()
	local dropped = false

	local wndProc = user32.WndProc(function(hwnd, msg, wParam, lParam)
		if msg == user32.WM.DROPFILES then
			dropped = true
		elseif msg == user32.WM.DESTROY then
			user32.postQuitMessage(0)
			return 0
		end
		return user32.defWindowProc(hwnd, msg, wParam, lParam)
	end)

	local hwnd, hInstance = createWindow(wndProc)
	test.notEqual(hwnd, nil, "could not create the test window")

	shell32.dragAcceptFiles(hwnd, true)

	-- Dropped files are delivered as WM_DROPFILES with the HDROP in wParam, so
	-- sending it proves the binding resolved and reached the window procedure.
	test.equal(user32.sendMessage(hwnd, user32.WM.DROPFILES, 0, 0), 0)
	test.equal(dropped, true, "the window procedure never saw WM_DROPFILES")

	-- Posting it proves the message queue path the drop flow uses.
	test.equal(user32.postMessage(hwnd, user32.WM.DROPFILES, 0, 0), true)

	local msg = user32.Msg()
	test.equal(user32.peekMessage(msg, nil, user32.WM.DROPFILES, user32.WM.DROPFILES, user32.PM.REMOVE), true)
	test.equal(msg.message, user32.WM.DROPFILES)

	shell32.dragAcceptFiles(hwnd, false)

	test.notEqual(user32.destroyWindow(hwnd), 0)
	test.notEqual(user32.unregisterClass(CLASS_NAME, hInstance), 0)
end)
