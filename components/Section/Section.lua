return HTML.Component:new(
    function(config)
        return 
            (div)(){
                (h1)(){config.title or ""}(h1),
                (div)(){
                    config.children
                }(div)
            }(div)
    end
)