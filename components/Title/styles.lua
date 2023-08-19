return {
    Background = {},
    Title = {
        ["font-size"] = (config.font_size or 2) .. "rem",
        ["margin-top"] = config.margin or "1rem",
    },
    Subtitle = {
        ["font-size"] = (config.font_size * (config.subtitle_ratio or 1)) .. "rem",
        ["margin-top"] = config.margin or "1rem",
        ["margin-bottom"] = config.margin or "1rem",
    },
}