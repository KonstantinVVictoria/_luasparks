return function(font_cache)
    font_cache.length = 0
    return function(...)
        local composite_string = ""
        for i, font in ipairs({ ... }) do
            font_cache[font] = true
            composite_string = composite_string .. font .. "|"
            font_cache.length = font_cache.length + 1
        end
        composite_string = composite_string:sub(0, string.len(composite_string) - 1)
        return
            (link)({href=string.format("https://fonts.googleapis.com/css2?family=%s&display=swap", composite_string), rel="stylesheet"})()
    end
end