local rgb_meta = {
    type = "rgb"
}

rgb_meta.__add = 
    function(rgb_1, rgb_2) 
        local r = math.max(math.min(rgb_1[1] + rgb_2[1], 255), 0)
        local g = math.max(math.min((rgb_1[2] + rgb_2[2]), 255), 0)
        local b = math.max(math.min((rgb_1[3] + rgb_2[3]), 255), 0)
        if type(rgb_1) == "string" or type(rgb_2) == "string" then
            return nil 
        end
        local a_1 = rgb_1[4] and rgb_1[4] or 0
        local a_2  = rgb_2[4] and rgb_2[4] or 0
        return  (rgb_1[4] or rgb_2[4]) and rgba(r, g, b, math.max(math.min(a_1 + a_2, 1), 0)) or setmetatable({r, g, b}, rgb_meta)
    end
rgb_meta.__bnot = 
    function(a)
        return string.format("rgb( %s, %s, %s)", a[1], a[2], a[3])
    end

rgb_meta.__mul =
    function(a, f)
        local r, g, b
        if (type(a) == "number" and type(f) == "table") or (type(f) == "number" and type(a) == "table")  then
            local scalar = type(a) == "number" and a or f
            local vector = type(a) == "number" and f or a
            r = vector[1] * scalar
            g = vector[2] * scalar
            b = vector[3] * scalar
        elseif (type(a) == "table" and type(f) == "table") then
            r = a[1] * f[1]
            g = a[2] * f[2]
            b = a[3] * f[3]
        else
            return nil
        end
        return setmetatable({math.max(math.min(r, 255), 0), math.max(math.min(g, 255), 0), math.max(math.min(b, 255), 0)}, rgb_meta)
    end

return function(r, g, b)
    local _ = {r or 0, g or 0, b or 0}
    return getmetatable(r) and getmetatable(r).type == "hex" and r.rgb or setmetatable(_, rgb_meta)
end



