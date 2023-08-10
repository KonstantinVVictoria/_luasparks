_route_path = package.path .. "./?.lua;" -- DO NOT TOUCH
package.path = _route_path -- DO NOT TOUCH
HTML = require("./modules/HTML/HTML") -- DO NOT TOUCH
HTML:set_render_mode("dev") -- prod or dev
--import webpages:
local MainPage = require("./pages/index")
--Define webpage routes here:
MainPage.route("/")

HTML:render() -- DO NOT TOUCH