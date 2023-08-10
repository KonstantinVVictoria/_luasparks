local rgba_meta = {
    type = "rgba"
}

rgba_meta.__add = 
    function(rgba_1, rgba_2) 
        local r = math.max(math.min(rgba_1[1] + rgba_2[1], 255), 0)
        local g = math.max(math.min((rgba_1[2] + rgba_2[2]), 255), 0)
        local b = math.max(math.min((rgba_1[3] + rgba_2[3]), 255), 0)   
        if type(rgba_1) == "string" or type(rgba_2) == "string" then
            return nil 
        end
        local a_1 = rgba_1[4] and rgba_1[4] or 0
        local a_2  = rgba_2[4] and rgba_2[4] or 0
        return  (rgba_1[4] or rgba_2[4]) and setmetatable({r, g, b, math.max(math.min(a_1 + a_2, 1), 0)}, rgba_meta) or rgb(r, g, b)
    end
rgba_meta.__bnot = 
    function(a)
        return string.format("rgba(%s, %s, %s, %s)", a[1], a[2], a[3], a[4])
    end

rgba_meta.__mul =
    function(v1, v2)
        local r, g, b, a, vector
        if (type(v1) == "number" and type(v2) == "table") or (type(v2) == "number" and type(v1) == "table")  then
            local scalar = type(v1) == "number" and v1 or v2
            vector = type(v1) == "number" and v2 or v1
            r = vector[1] * scalar
            g = vector[2] * scalar
            b = vector[3] * scalar
        elseif (type(g) == "table" and type(v2) == "table") then
            r = v1[1] * v2[1]
            g = v1[2] * v2[2]
            b = v1[3] * v2[3]
            a = v1[4] * v2[4]
        else
            return nil
        end
        return setmetatable({math.max(math.min(r, 255), 0), math.max(math.min(g, 255), 0), math.max(math.min(b, 255), 0), math.max(math.min(a, 1), -1)}, rgba_meta)
    end

return function(r, g, b, a)
    local _ = {r or 0, g or 0, b or 0, a or 1}
    return getmetatable(r) and getmetatable(r).type == "hex" and r.rgba or setmetatable(_, rgba_meta)
end
