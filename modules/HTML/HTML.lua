package.path = package.path .. "./?.lua;"
rgb = require("./modules/HTML/rgb")
rgba = require("./modules/HTML/rgba")
hex = require("./modules/HTML/hex")
CSS = require("./modules/HTML/css")
_global = require("./meta/global")
_theme = _global.theme or {}
inspect = require('./modules/inspect/inspect')
HTML = {
    Element = {},
    Component = {}
}

local _fonts = {}
local _curr_render_mode = "dev"
GFont = require("./modules/HTML/GFont")(_fonts)

local HTML_Element_Cache ={}
local _js_cache = {}
local _state_cache = {}
local _css_cache = {}
local run_start = os.clock()
local _style_number = 0

local function CSS_cacher(css_obj)
    local style_object = {}
    if #css_obj > 1 then
        for _, style in ipairs(css_obj) do
            table_concat(style_object, style)
        end
    else
        style_object = css_obj
    end
    for property, value in pairs(style_object) do
        if _css_cache[property] == nil then
            _css_cache[property] = {}
            _css_cache[property]._counter = 0
            _css_cache[property]._style_number = _style_number
            _style_number =  _style_number + 1
        end

        if(_css_cache[property][value]  == nil ) then
            _css_cache[property]._counter = _css_cache[property]._counter + 1
            _css_cache[property][value] = _css_cache[property]._counter             
        end
    end
    
    return css_obj
end

local function CSS_obj(css_obj)
    local accumumaltor = ""
    local style_object = {}
    local _css_cache_class = ""
    if #css_obj > 1 then
        for _, style in ipairs(css_obj) do
            table_concat(style_object, style)
        end
    else
        style_object = css_obj
    end
    for property, value in pairs(style_object) do
        accumumaltor = accumumaltor .. property .. ":" .. value .. ";"
        local value_num = _css_cache[property][value]
        local style_num = _css_cache[property]._style_number
        _css_cache_class = _css_cache_class .. "_" .. style_num .. "_" .. value_num .. " "
    end
    return {style = accumumaltor, css_class = _css_cache_class}
end

local function GenerateCSS()
    local css_file = ""
    for property, values in pairs(_css_cache) do
        for value, num in pairs(values) do
            if not(value == "_counter" or value == "_style_number") then
                css_file = css_file .. "._" .. values._style_number .. "_" .. num .. "{".. property .. ":" .. value ..";}\n"
            end
        end
    end
    return css_file
end

local _webpages = {}
function HTML:set_render_mode(mode)
        _curr_render_mode = mode or _curr_render_mode
end
function HTML:render()
    local js_file = ""
    local file = io.open("./modules/HTML/lib.js", "r")
    io.input(file)
    local content = io.read("*all")
    js_file = js_file .. content
    file = io.open("./views/views.js", "r")
    io.input(file)
    content = io.read("*all")
    js_file = js_file .. content

    file = io.open("./styles/global.css", "r")
    io.input(file)
    global_css = io.read("*all") 
    file = io.open("./modules/HTML/State.js", "r")
    io.input(file)
    js_file = js_file .. io.read("*all") 
    file = io.open("./website/public/" .. "js_comp.js", "w")
    io.output(file)
    for _, value in pairs(_state_cache) do
        js_file = js_file .. value      
    end   
    for _, value in pairs(_js_cache) do
        js_file = js_file .. value      
    end
    io.write(js_file)

    local CSSFile = GenerateCSS()
    file = io.open("./website/public/".. "css_comp.css", "w")
    io.output(file)
    io.write(CSS.root .. global_css .. "\n" .. CSSFile)
    for path, webpage in pairs(_webpages) do
        file = io.open("./website".. path, "w")
        io.output(file)
        io.write(HTML:stringify(webpage))        
    end
    local run_end  = os.clock()
    print("Build Sucessful!", "Compile time:", run_end - run_start, "seconds")
end

function HTML:new_webpage()
    local Page = {
        Body = {},
        Head = {},
        Footer = {}
    }
    Page.route = function(path)
        local html = HTML.Element:new("html")
        local body = HTML.Element:new("body")
        local head = HTML.Element:new("head")
        local footer = HTML.Element:new("footer")
        local meta = HTML.Element:new("meta")
        local GFont_Header = _fonts.length > 0 and {
            (link)({rel="preconnect", href="https://fonts.googleapis.com"})(),
            (link)({rel="preconnect", href="https://fonts.gstatic.com", crossorigin = true})(),
            } or {}

        local Header_Template = {
            (meta)({ charset = "UTF-8" })(),
            (meta)({ name = "viewport", content = "width=device-width, initial-scale=1.0" })(),
            (meta)({ ["http-equiv"] = "X-UA-Compatible", content = "ie=edge" })(),
            (script)({src="js_comp.js", defer=true}){}(script),
            (link)({ rel = "stylesheet", href = "css_comp.css", type = "text/css" })(),
            GFont_Header,
            Page.Head,
        }
        if _curr_render_mode == "dev" then
            Header_Template[#Header_Template + 1] = (script)({src="/reload/reload.js"}){}(script)
        end
        local template =
            html({lang="en"}){
                head()(Header_Template)(head),
                body()(
                    Page.Body
                )(body),
                footer() {
                    Page.Footer
                }(footer)
            }(html)
        _webpages[path =="/" and "/index.html" or path..".html"] = template

    end
    return Page
end

local function State_cacher(state)
    local file = io.open("./state/"..state..".js", "r")
    io.input(file)
    local content = io.read("*all") 
    _state_cache[i] = content     

end
function HTML.Element:new(tag)
    local Element
    Element = function(config)
        local element = HTML_Element_Cache[tag] or {
            tag = tag,
            children = "",
        }
        element.config = config
        if element.config then            
            if element.config.style then
                CSS_cacher(element.config.style)
            end    
            if element.config.state then          
                State_cacher(element.config.state)
            end
        end      
        return function(children)
            if children == nil then
                element.children = nil
                return element
            end
            element.children = children
            return function(element_closing)
                if element_closing == Element then
                    return element
                else
                    return nil
                end
            end
        end
    end
    return Element
end

function HTML.Component:new(component)
    local Element
    Element = function(config_arg)
        local config = config_arg or {}
        return function(children_arg)
            if children_arg == nil then
                return component(config)
            end

            return function(element_closing)
                if element_closing == Element then
                    config.children = children_arg
                    return component(config)
                else
                    return nil
                end
            end
        end
    end
    return Element
end

function HTML:stringify(elements)
    local HTML_Text = ""
    for _, element in ipairs(elements.tag and {elements} or elements) do
        if element.tag ~= nil then
            local attributes = ""        
            if element.config then
                if element.config.style then
                    local CSS_info = CSS_obj(element.config.style) 
                    if  element.config.class  == nil then element.config.class = "" end
                    element.config.class = element.config.class .. " " .. CSS_info.css_class 
                end   
                if element.config.class then
                    attributes =  ("class=" .. "\"".. element.config.class .. "\"" .. " ") 
                    element.config.class = nil
                end
            end

            for attr_name, attr_value in pairs(element.config or {}) do
                if type(attr_value) == "string" then
                    attributes = attributes .. attr_name .. "=" .. "\"".. attr_value .. "\"".. " "
                elseif type(attr_value) == "boolean" then
                    attributes = attributes .. attr_name .. " "
                elseif getmetatable(attr_value) and getmetatable(attr_value).type == "javascript" then
                    attributes = attributes .. attr_name .. "=" .. "\"".. attr_value.stringify .. "\"".. " "
                end
            end
            attributes = attributes:sub(0, #attributes - 1)
            local children = ""
            if element.children == nil then
                return string.format("<%s %s/>", element.tag, attributes)
            end
            if type(element.children) == "string" then
                children = element.children
            else
                for _, value in ipairs(element.children) do
                    if value.tag and type(value) == "table" then
                        children = children .. HTML:stringify(value)
                    elseif value.tag == nil and type(value) == "table" then
                        for i, iterable_element in ipairs(value) do
                            if type(iterable_element) == "string" then
                                children = children .. iterable_element
                            elseif type(iterable_element) == "table" then
                                children = children .. HTML:stringify(iterable_element)                       
                            end
                        end
                    elseif type(value) == "string" then
                        children = children.. value
                    end
                end
            end
            HTML_Text = HTML_Text .. string.format("<%s %s>%s</%s>", element.tag, attributes, children, element.tag)   
        end     
    end
    return HTML_Text
end

function Query()

end

function argm(param)
    return setmetatable({stringify = param}, {__tostring = function(_internal) return _internal.stringify end, type = "argument"})
end
local JS_meta = {type = "javascript"}
JS_meta.__tostring = function(_internal)
    return _internal.as_arg
end

function JS(function_name)

    local file = io.open("./javascript/"..function_name..".js", "r")
    io.input(file)
    content = io.read("*all")
    _js_cache[function_name] = content
    return function(...)
        local args = ""
        for i, argument in ipairs({...}) do
            if type(argument) == "string" then
                args = args .. "'" .. argument:gsub('"','&#34;'):gsub("'","&#39;") .. "'" .. ", "
            elseif type(argument) == "boolean" or type(argument) == "number" or type(argument)== "table" then
                if getmetatable(argument) and (getmetatable(argument).type == "javascript" or getmetatable(argument).type == "argument") then
                    args = args  .. tostring(argument) .. ", "
                end
            end
        end
        local JS_interface = {
            stringify = function_name .. "(" .. args:sub(0,#args - 2)  .. ")",
            as_arg = function_name .. "(" .. args:sub(0,#args - 2)  .. ")"
        }
        return setmetatable(JS_interface, JS_meta)
    end
end


function table_concat(t1, t2)
    for key, value in pairs(t2) do
        t1[key] = value
    end
    return t1
end





a = HTML.Element:new("a")
abbr = HTML.Element:new("abbr")
acronym = HTML.Element:new("acronym")
address = HTML.Element:new("address")
applet = HTML.Element:new("applet")
area = HTML.Element:new("area")
article = HTML.Element:new("article")
aside = HTML.Element:new("aside")
audio = HTML.Element:new("audio")
b = HTML.Element:new("b")
base = HTML.Element:new("base")
basefont = HTML.Element:new("basefont")
bdi = HTML.Element:new("bdi")
bdo = HTML.Element:new("bdo")
big = HTML.Element:new("big")
blockquote = HTML.Element:new("blockquote")
body = HTML.Element:new("body")
br = HTML.Element:new("br")
button = HTML.Element:new("button")
canvas = HTML.Element:new("canvas")
caption = HTML.Element:new("caption")
center = HTML.Element:new("center")
cite = HTML.Element:new("cite")
code = HTML.Element:new("code")
col = HTML.Element:new("col")
colgroup = HTML.Element:new("colgroup")
data = HTML.Element:new("data")
datalist = HTML.Element:new("datalist")
dd = HTML.Element:new("dd")
del = HTML.Element:new("del")
details = HTML.Element:new("details")
dfn = HTML.Element:new("dfn")
dialog = HTML.Element:new("dialog")
dir = HTML.Element:new("dir")
div = HTML.Element:new("div")
dl = HTML.Element:new("dl")
dt = HTML.Element:new("dt")
em = HTML.Element:new("em")
embed = HTML.Element:new("embed")
fieldset = HTML.Element:new("fieldset")
figcaption = HTML.Element:new("figcaption")
figure = HTML.Element:new("figure")
font = HTML.Element:new("font")
footer = HTML.Element:new("footer")
form = HTML.Element:new("form")
frame = HTML.Element:new("frame")
frameset = HTML.Element:new("frameset")
h1 = HTML.Element:new("h1")
h2 = HTML.Element:new("h2")
h3 = HTML.Element:new("h3")
h4 = HTML.Element:new("h4")
h5 = HTML.Element:new("h5")
h6 = HTML.Element:new("h6")
head = HTML.Element:new("head")
header = HTML.Element:new("header")
hr = HTML.Element:new("hr")
html = HTML.Element:new("html")
i = HTML.Element:new("i")
iframe = HTML.Element:new("iframe")
img = HTML.Element:new("img")
input = HTML.Element:new("input")
ins = HTML.Element:new("ins")
kbd = HTML.Element:new("kbd")
label = HTML.Element:new("label")
legend = HTML.Element:new("legend")
li = HTML.Element:new("li")
link = HTML.Element:new("link")
main = HTML.Element:new("main")
map = HTML.Element:new("map")
mark = HTML.Element:new("mark")
meta = HTML.Element:new("meta")
meter = HTML.Element:new("meter")
nav = HTML.Element:new("nav")
noframes = HTML.Element:new("noframes")
noscript = HTML.Element:new("noscript")
object = HTML.Element:new("object")
ol = HTML.Element:new("ol")
optgroup = HTML.Element:new("optgroup")
option = HTML.Element:new("option")
output = HTML.Element:new("output")
p = HTML.Element:new("p")
param = HTML.Element:new("param")
picture = HTML.Element:new("picture")
pre = HTML.Element:new("pre")
progress = HTML.Element:new("progress")
q = HTML.Element:new("q")
rp = HTML.Element:new("rp")
rt = HTML.Element:new("rt")
ruby = HTML.Element:new("ruby")
s = HTML.Element:new("s")
samp = HTML.Element:new("samp")
script = HTML.Element:new("script")
section = HTML.Element:new("section")
select = HTML.Element:new("select")
small = HTML.Element:new("small")
source = HTML.Element:new("source")
span = HTML.Element:new("span")
strike = HTML.Element:new("strike")
strong = HTML.Element:new("strong")
style = HTML.Element:new("style")
sub = HTML.Element:new("sub")
summary = HTML.Element:new("summary")
sup = HTML.Element:new("sup")
svg = HTML.Element:new("svg")
table = HTML.Element:new("table")
tbody = HTML.Element:new("tbody")
td = HTML.Element:new("td")
template = HTML.Element:new("template")
textarea = HTML.Element:new("textarea")
tfoot = HTML.Element:new("tfoot")
th = HTML.Element:new("th")
thead = HTML.Element:new("thead")
time = HTML.Element:new("time")
title = HTML.Element:new("title")
tr = HTML.Element:new("tr")
track = HTML.Element:new("track")
tt = HTML.Element:new("tt")
u = HTML.Element:new("u")
ul = HTML.Element:new("ul")
var = HTML.Element:new("var")
video = HTML.Element:new("video")
wbr = HTML.Element:new("wbr")

return HTML