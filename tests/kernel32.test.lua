local test = require("lde-test")
local winapi = require("winapi")

test.it("should get module handle", function()
	local handle = winapi.kernel32.getModuleHandle(nil)
	test.notEqual(handle, nil)
end)

test.it("should get last error message", function()
	local msg = winapi.kernel32.getLastErrorMessage()
	test.equal(type(msg), "string")
	test.notEqual(#msg, 0)
end)
