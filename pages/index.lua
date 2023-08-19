local Title = require("./components/Title/Title")
local Section = require("./components/Section/Section")
local MainPage = HTML.new_webpage()

CSS.set_root(_global.themes.root)

MainPage.Head = {
    (title)(){"LuaSparks✨"}(title),
    (link)({rel = "icon", type="image/x-icon", href="/images/favicon.ico"})(),
    GFont(_global.themes.root["--font-1"]),
}

MainPage.Body = {
    (Title)({
        id = "main_title", 
        text = "LuaSparks✨", 
        font_size = 2.7,
        subtitle_ratio = 0.7,
        caption = "Spark your creativity!", 
        margin = "1.2rem"
    })(),
}
return MainPage