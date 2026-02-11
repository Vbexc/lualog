# loggermodule
Provides timestamps, log levels, and optional file logging. Perfect for debugging Lua projects.

Features

logger.log(level, message) — log messages with timestamps

Supports multiple log levels: info, warning, error

Optional output to a file (logger.outputFile)

Lightweight and easy to integrate

Installation

Option 1: Use the raw Lua file

Download logger.lua from this repository.

Place it in your project folder.

Require it in your Lua script:

local logger = require("logger")


Option 2: Install via LuaRocks (optional)

luarocks make logger-1.0-1.rockspec


Then in Lua:

local logger = require("logger")

Usage Examples
local logger = require("logger")

-- Basic messages
logger.log("info", "This is an info message")
logger.log("warning", "This is a warning message")
logger.log("error", "This is an error message")

-- Logging to a file
logger.outputFile = "log.txt"
logger.log("info", "This message will also be saved to log.txt")


Sample Output:

[2026-02-11 17:30:15] [info] This is an info message
[2026-02-11 17:30:15] [warning] This is a warning message
[2026-02-11 17:30:15] [error] This is an error message

Contributing

Feel free to fork this project and improve it!
Suggestions:

Filter log messages by level

Color-coded console output

Async or buffered file logging

License

MIT License — free to use, modify, and distribute.
