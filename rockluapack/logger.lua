-- logger.lua
-- this is v1 now instead of protoype
local logger = {}

logger._VERSION = "V1"
logger._AUTHOR = "VB"
logger._DESCRIPTION = "A logging module"

logger.level = "info"
logger.outputFile = "logs.txt"

function logger.log(level, message)
     local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	 local output = string.format("[%s] [%s] %s", timestamp, level, message)
	 print(output)
end

return logger
