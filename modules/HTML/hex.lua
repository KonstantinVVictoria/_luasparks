local hex_meta = {
    type = "hex"
}

hex_meta.__add = 
function(a, b)
    local rgb_1 = a.rgb and a.rgb or a
    local rgb_2 = b.rgb and b.rgb or b
    return rgb_1 + rgb_2
end

hex_meta.__bnot = 
function(a)
    return a.string
end


local function hex_to_rgb(hex)
    hex = hex:gsub("#","")
    local r = tonumber("0x"..hex:sub(1,2))
    local g = tonumber("0x"..hex:sub(3,4))
    local b = tonumber("0x"..hex:sub(5,6))
    return rgb(r, g, b)
end

local function hex_to_rgba(hex, a)
    hex = hex:gsub("#","")
    local r = tonumber("0x"..hex:sub(1,2))
    local g = tonumber("0x"..hex:sub(3,4))
    local b = tonumber("0x"..hex:sub(5,6))
    return rgba(r, g, b, a)
end

local function rgb_to_hex(r,g,b)
    local rgb = (r * 0x10000) + (g * 0x100) + b
    return "#" .. string.format("%x", rgb)
end


return function(hex_string, opacity)
    local meta = getmetatable(hex_string)
    local string = hex_string
    if(meta.type == "rgb" or meta.type == "rgba") then
        string = rgb_to_hex(string[1], string[2], string[3])
    end
    local _
    _ = {
        string = string,
        rgb = hex_to_rgb(string),
        rgba = hex_to_rgba(string, opacity or 1)
    }
    _.alpha = function(a)
        _.rgba = hex_to_rgba(string, a or 1)
        return setmetatable(_, hex_meta)
    end
    return setmetatable(_, hex_meta)
end

