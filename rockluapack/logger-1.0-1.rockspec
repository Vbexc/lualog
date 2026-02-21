package = "logger"
version = "1.0-1"
tag = "v1.1.1"
source = {
    url = "file://./logger.lua"
}
description = {
    summary = "A simple logging module for Lua",
    license = "MIT"
}
dependencies = {}
build = {
    type = "builtin",
    modules = {
        logger = "logger.lua"
    }
}

