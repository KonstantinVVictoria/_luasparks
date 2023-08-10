local CSS = {
    root = ""
}

function CSS.set_root(css_obj)
    local styles = ""

    for property, value in pairs(css_obj) do
        styles = styles .. property ..  ":".. (type(value) =="table" and ~value or value) .. ";" .. "\n"
    end
    CSS.root = string.format(":root{\n%s}\n",styles)
end

return CSS