-- lualog_utf8.lua
-- UTF-8 aware helpers for lualog (character-based length, sub, pad, truncate)
-- Usage: local utf8helpers = require("lualog_utf8")
-- Then use utf8helpers.len/sub/pad/truncate when formatting log fields.

local M = {}

local has_utf8 = type(utf8) == "table"

-- iterate UTF-8 characters (works without Lua utf8 lib)
local function iter_chars(s)
    return s:gmatch("[%z\1-\127\194-\244][\128-\191]*")
end

-- length in (Unicode) characters
function M.len(s)
    if not s then return 0 end
    if has_utf8 then
        local n = utf8.len(s)
        if n then return n end -- utf8.len returns nil + pos on invalid sequences
    end
    local c = 0
    for _ in iter_chars(s) do c = c + 1 end
    return c
end

-- substring by character indexes (1-based, supports negative indices)
function M.sub(s, i, j)
    if not s then return nil end
    i = i or 1
    j = j or -1
    local total = M.len(s)
    if i < 0 then i = total + 1 + i end
    if j < 0 then j = total + 1 + j end
    if i < 1 then i = 1 end
    if j > total then j = total end
    if i > j then return "" end

    -- If utf8 library available, use byte offsets for efficiency
    if has_utf8 then
        local start_byte = utf8.offset(s, i)
        local end_byte = (j == total) and #s or (utf8.offset(s, j + 1) and utf8.offset(s, j + 1) - 1)
        if start_byte and end_byte then
            return string.sub(s, start_byte, end_byte)
        end
        -- fallback to char iteration if offsets fail
    end

    local out = {}
    local idx = 0
    for ch in iter_chars(s) do
        idx = idx + 1
        if idx >= i and idx <= j then
            out[#out + 1] = ch
        end
        if idx > j then break end
    end
    return table.concat(out)
end

-- pad s to width (characters). align = "left"|"right"|"center"
function M.pad(s, width, align)
    s = s or ""
    width = width or 0
    align = align or "left"
    local cur = M.len(s)
    if cur >= width then return s end
    local need = width - cur
    if align == "right" then
        return string.rep(" ", need) .. s
    elseif align == "center" then
        local left = math.floor(need / 2)
        local right = need - left
        return string.rep(" ", left) .. s .. string.rep(" ", right)
    else -- left
        return s .. string.rep(" ", need)
    end
end

-- truncate to width characters, optionally add ellipsis (defaults to "…")
function M.truncate(s, width, ellipsis)
    s = s or ""
    ellipsis = ellipsis or "…"
    local cur = M.len(s)
    if width <= 0 then return "" end
    if cur <= width then return s end
    local ell = ellipsis
    local ell_len = M.len(ell)
    if ell_len >= width then
        -- ellipsis doesn't fit; return first width chars
        return M.sub(s, 1, width)
    end
    local keep = width - ell_len
    return M.sub(s, 1, keep) .. ell
end

-- convenience patch function: attach helpers to a lualog table if present
function M.patch(lualog)
    if type(lualog) ~= "table" then return false end
    lualog.utf8 = lualog.utf8 or {}
    lualog.utf8.len = M.len
    lualog.utf8.sub = M.sub
    lualog.utf8.pad = M.pad
    lualog.utf8.truncate = M.truncate
    return true
end

return M