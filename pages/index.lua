
local MainPage = HTML.new_webpage()

CSS.set_root(_global.themes.root)

MainPage.Head = {
    (title)(){"LuaSparks✨"}(title),
    (link)({rel = "icon", type="image/x-icon", href="/images/favicon.ico"})(),
    GFont(_global.themes.root["--font-1"]),
}

MainPage.Body = {
 
}
return MainPage
