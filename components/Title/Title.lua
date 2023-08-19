return HTML.Component:new(
    function(config)

        return
            (div)({
                id = config.id or {},
                style= {
                    ["background-color"] = config.color or ~rgb(33,33,33),
                    ["padding"] = "1rem",
                    display = "flex",
                    ["flex-direction"] = "column"
                }
            }){
                (h1)({
                    style={
                        ["font-size"] = (config.font_size or 2) .. "rem",
                        margin = 0,
                        ["margin-bottom"] = config.margin or "1rem",
                    }
                }){ config.text or ""}(h1),
                (h2)({
                    style={
                        margin = 0,
                        ["font-size"] = (config.font_size * (config.subtitle_ratio or 1)) .. "rem",
                    }
                }){ config.caption or ""}(h2)
            }(div)
    end
)