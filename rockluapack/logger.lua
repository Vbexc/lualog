-- logger.lua
-- this is v1 now instead of protoype
local logger = {}

logger._VERSION = "V1"
logger._AUTHOR = "VB"
logger._DESCRIPTION = "A logging module"

logger.level = "info"
logger.outputFile = nil

function logger.log(level, message)
     local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	 local output = string.format("[%s] [%s] %s", timestamp, level, message)
	 print(output)
end

local function errorHandler(err)
	local trace = debug.traceback(err, 2)
	return trace
end

local function inner()
	error("Something went wrong")
end

local function outer()
	inner()
end

local succes, message = xpcall(outer, errorHandler)
print(message)

local status, result = pcall(divide, 10, 0)
if status then
    print("Result:", result)
else
    logger.log("error", "Caught division error: " .. result)
end

	
return logger


