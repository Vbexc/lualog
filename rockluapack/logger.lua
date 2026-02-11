-- logger.lua
local logger = {}

logger._VERSION = "prototype"
logger._AUTHOR = "VB"
logger._DESCRIPTION = "A logging module"

logger.level = "info"
logger.outputFile = nil

function logger.log(level, message)
     local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	 local output = string.format("[%s] [%s] %s", timestamp, level, message)
	 print(output)
end

return logger
