local base = require("packages.base")

local package = pl.class(base)
package._name = "textual"

local function font (options, command)
  return { family = options.family or SILE.settings:get(command..".family"),
           size = options.size or SILE.settings:get(command..".size"),
           weight = options.weight or SILE.settings:get(command..".weight") }
end

function package:_init()
    base._init(self)
    self:loadPackage("rotate")
    self:loadPackage("counters")
    self:loadPackage("textcase") 
    self:loadPackage("tableofcontents")
end

function package.declareSettings (_)
    for _, command in ipairs({ "ellipsis", "epigraph" }) do -- for those using the defaults... 
      -- SILE.settings:declare({ parameter = command..".family", default = SILE.settings:get("font.family"), type = "string or nil" })
      SILE.settings:declare({ parameter = command..".size", default = SILE.settings:get("font.size"), type = "number or integer" })
      SILE.settings:declare({ parameter = command..".weight", default = SILE.settings:get("font.weight"), type = "integer" })
    end

    SILE.settings:declare({ parameter = "versalete.family", default = "Alegreya SC", type = "string or nil" })
    SILE.settings:declare({ parameter = "versalete.size", default = ".8em", type = "number or integer or measurement" })
    SILE.settings:declare({ parameter = "versalete.weight", default = 500, type = "integer" })

    SILE.settings:declare({ parameter = "ellipsis.family", default = "Symbola", type = "string" })
    SILE.settings:declare({ parameter = "ellipsis.skip", default = "4%ph", type = "measurement" })
    SILE.settings:declare({ parameter = "ellipsis.rotate", default = 0, type = "number" })
    SILE.settings:declare({ parameter = "ellipsis.symbol", default = "*", type = "string" })

    SILE.settings:declare({ parameter = "epigraph.family", default = nil, type = "string or nil" })
    SILE.settings:declare({ parameter = "epigraph.style", default = "italic", type = "string" })
    SILE.settings:declare({ parameter = "epigraph.parSkip", default = SILE.settings:get("document.parskip"), type = "measurement or nil" })
    SILE.settings:declare({ parameter = "epigraph.topSkip", default = "3%ph", type = "measurement" })
    SILE.settings:declare({ parameter = "epigraph.bottomSkip", default = "5%ph", type = "measurement" })
    SILE.settings:declare({ parameter = "epigraph.width", default = "50%fw", type = "measurement" })
    SILE.settings:declare({ parameter = "epigraph.alignment", default = "right", type = "string" })
    
    SILE.settings:declare({ parameter = "head.folio", default = true, type = "boolean" })
    SILE.settings:declare({ parameter = "head.indent", default = true, type = "boolean" })
    SILE.settings:declare({ parameter = "head.openSpread", default = false, type = "boolean" })
    SILE.settings:declare({ parameter = "head.family", default = SILE.settings:get("font.family"), type = "string or nil" })

    SILE.settings:declare({ parameter = "head.toc", default = true, type = "boolean" })
    SILE.settings:declare({ parameter = "section.toc", default = true, type = "boolean" })
    SILE.settings:declare({ parameter = "subsection.toc", default = true, type = "boolean" })

    SILE.settings:declare({ parameter = "head.case", default = "uppercase", type = "string" })
    SILE.settings:declare({ parameter = "section.case", default = "uppercase", type = "string" })
    SILE.settings:declare({ parameter = "subsection.case", default = "versalete", type = "string" })

    SILE.settings:declare({ parameter = "head.alignment", default = "left", type = "string" })
    SILE.settings:declare({ parameter = "section.alignment", default = "left", type = "string" })
    SILE.settings:declare({ parameter = "subsection.alignment", default = "left", type = "string" })

    SILE.settings:declare({ parameter = "head.topSkip", default = "3%ph", type = "measurement" })
    SILE.settings:declare({ parameter = "head.bottomSkip", default = "7%ph", type = "measurement" })
    SILE.settings:declare({ parameter = "section.topSkip", default = "4%ph", type = "measurement" })
    SILE.settings:declare({ parameter = "section.bottomSkip", default = "5%ph", type = "measurement" })
    SILE.settings:declare({ parameter = "subsection.topSkip", default = "4%ph", type = "measurement" })
    SILE.settings:declare({ parameter = "subsection.bottomSkip", default = "5%ph", type = "measurement" })

    SILE.settings:declare({ parameter = "head.size", default = 20, type = "number or integer or measurement" })
    SILE.settings:declare({ parameter = "section.size", default = 15, type = "number or integer or measurement" })
    SILE.settings:declare({ parameter = "subsection.size", default = 12, type = "number or integer or measurement" })

    SILE.settings:declare({ parameter = "head.weight", default = 700, type = "integer" })
    SILE.settings:declare({ parameter = "section.weight", default = 600, type = "integer" })
    SILE.settings:declare({ parameter = "subsection.weight", default = 600, type = "integer" })

    -- SILE.settings:declare({ parameter = "head.valign", default = nil, type = "string or nil" })
    
    SILE.settings:declare({ parameter = "shrink.right", default = "15%fw", type = "measurement" })
    SILE.settings:declare({ parameter = "shrink.left", default = "15%fw", type = "measurement" })
    
    SILE.settings:declare({ parameter = "double-skip.height", default = 0, type = "measurement" })
    SILE.settings:declare({ parameter = "double-skip.top", default = "4%ph", type = "measurement" })
    SILE.settings:declare({ parameter = "double-skip.bottom", default = "4%ph", type = "measurement" })
end

function package:registerCommands()
    self:registerCommand("dash", function(options, _)
        SILE.call("font", { style = "normal" }, function() -- assure it's going to be a straight line if its parent style is italic
            SILE.typesetter:typeset("―")
        end)
    end)

    self:registerCommand("double-skip", function(options, content)
        local height = options.height or SILE.settings:get("double-skip.height")
        if height.amount == 0 then height = nil end

        local top = options.top or SILE.settings:get("double-skip.top")
        local bottom = options.bottom or SILE.settings:get("double-skip.bottom")

        SILE.call("goodbreak")
        SILE.call("skip", { height = height or top })
        SILE.process(content)
        SILE.call("skip", { height = height or bottom })
    end)

    self:registerCommand("shrink", function (options, content)
        local left = options.left or SILE.settings:get("shrink.left")
        local right = options.right or SILE.settings:get("shrink.right")

        SILE.settings:temporarily(function ()
            SILE.settings:set("document.lskip", left)
            SILE.settings:set("document.rskip", right)
            SILE.process(content)
            SILE.typesetter:leaveHmode()
        end)
    end)

    -- three align modes: align to borders and align to internal constraints, both covering horizontal and vertical directions. It's just to distinguish between those options with same name e.g. 'left', 'center'...
    self:registerCommand("align", function(options, content)
        local internal = SU.boolean(options.internal, false) -- align to borders by default, instead of internal constraints
        local vertical = SU.boolean(options.vertical, false)
        local direction = options.to
        local width = options.width or "50%fw"
        local ok = true

        if internal then
            local left, right
            if direction == "center"    then left, right = "25%fw", "25%fw" 
            elseif direction == "left"  then left, right = 0, width 
            elseif direction == "right" then left, right = width, 0
            else ok = false end

            SILE.call("shrink", { left = left, right = right }, content)
        elseif vertical then
            if direction == "center" then
                SILE.call("hbox")
                SILE.call("vfill")
                SILE.process(content)
                SILE.call("eject")
            elseif direction == "top" then
                SILE.process(content)
                SILE.call("vfill")
                SILE.call("eject")
            elseif direction == "bottom" then
                SILE.call("hbox")
                SILE.call("vfill")
                SILE.process(content)
                SILE.typesetter:leaveHmode()
                SILE.call("break")
            else ok = false end
            --[[
                top-left
                top-center
                top-right
                and so on...
            ]]
        else 
            if direction == "center" then
                SILE.call("center", _, content)
            elseif direction == "right" then
                SILE.call("raggedleft", _, content)
            elseif direction == "left" then
                SILE.call("raggedright", _,  content)
            else ok = false end
        end
      
       if not ok then
           SU.warn("\tDirection unknown or not specified: ".. tostring(direction) .."\n\tSee the docs to see the available options! \n\tIgnoring...\n" )
           SILE.process(content)
       end
    end)

    self:registerCommand("ellipsis", function(options, content)
        local skip = options.skip or SILE.settings:get("ellipsis.skip")
        local symbol = options.symbol or SILE.settings:get("ellipsis.symbol")
        local rotate = options.rotate or SILE.settings:get("ellipsis.rotate")
        local font = font(options, "ellipsis")
        
        content = SU.ast.hasContent(content) and SU.ast.contentToString(content) or symbol

        SILE.call("double-skip", { height = skip }, function()
            SILE.call("center", _, function()
                SILE.call("font", font, function()
                    SILE.call("rotate", { angle = rotate }, function()
                        SILE.typesetter:typeset(content)
                    end)
                end)
            end)
        end)
    end)
   
    self:registerCommand("epigraph", function(options, content)
        local width = options.width or SILE.settings:get("epigraph.width")
        local parSkip = options.parSkip or SILE.settings:get("epigraph.parSkip")
        local topSkip = options.topSkip or SILE.settings:get("epigraph.topSkip")
        local bottomSkip = options.bottomSkip or SILE.settings:get("epigraph.bottomSkip")
        local alignment = options.alignment or SILE.settings:get("epigraph.alignment")

        local font = font(options, "epigraph")
        font.style = options.style or SILE.settings:get("epigraph.style")
 
        SILE.settings:temporarily(function()
          SILE.settings:set("document.parskip", parSkip)
          SILE.call("double-skip", { top = topSkip, bottom = bottomSkip }, function()
              SILE.call("align", { to = alignment, internal = true }, function()
                  SILE.call("font", font, content)
              end)
          end)
        end)
    end)

    self:registerCommand("versalete", function (options, content)
        options.family = nil -- this shouldn't be inherited, declare through settings instead
        local font = font(options, "versalete")

        SILE.call("font", font, function ()
            SILE.call("lowercase", _, content)
        end)
    end)

    self:registerCommand("head", function(options, content)
        -- inheritable
        local case       = options.case or SILE.settings:get("head.case")
        local toc        = SU.boolean(options.toc, SILE.settings:get("head.toc"))
        local indent     = SU.boolean(options.indent, SILE.settings:get("head.indent"))
        local openSpread = SU.boolean(options.openSpread, SILE.settings:get("head.openSpread"))
        local alignment  = options.alignment or SILE.settings:get("head.alignment")

        local font = font(options, "head") -- only options.family is, actually

        -- not inheritable
        local topSkip = options.topSkip or SILE.settings:get("head.topSkip")
        local bottomSkip = options.bottomSkip or SILE.settings:get("head.bottomSkip")
        local folio = SU.boolean(options.folio, SILE.settings:get("head.folio"))
        local level = options.level and SU.cast("number", options.level) or 1

        if level == 1 then
            if openSpread then
                SILE.call("open-spread", { double = false })
            elseif SILE.scratch.counters.folio.value == 1 then
                SILE.call("par")
            else
                SILE.call("supereject")
            end
        end        

        SILE.call("increment-multilevel-counter", { id = "sectioning", level = level })
        --SILE.call("show-multilevel-counter", { id = "sectioning" })

        local number = self.class.packages.counters:formatMultilevelCounter(self.class:getMultilevelCounter("sectioning"))
        
        SILE.call("double-skip", { top = topSkip, bottom = bottomSkip }, function() 
            SILE.call("noindent") ---- ????? it's working as \neverindent !!!!!

            SILE.call("align", { to = alignment }, function()
                SILE.call("font", font, function()
                    SILE.call(case, font, content)
                end)
            end)
            SILE.call("nobreak")
        end)

        if toc then
           SILE.call("tocentry", { level = level, number = number }, SU.ast.subContent(content))
        end

        if not folio and level == 1 then
            SILE.call("nofoliothispage") -- not working properly!? page 2
        end

        SILE.call("nobreak")
        SILE.call("indent")
    end)

    self:registerCommand("section", function(options, content)
      SILE.call("head", { level = 2,
                          case     = options.case or SILE.settings:get("section.case"),
                          size     = options.size or SILE.settings:get("section.size"),
                          weight   = options.weight or SILE.settings:get("section.weight"),
                          topSkip  = options.topSkip or SILE.settings:get("section.topSkip"),
                          bottomSkip = options.bottomSkip or SILE.settings:get("section.bottomSkip"),
                          alignment  = options.alignment or SILE.settings:get("section.alignment"),
                          toc = SU.boolean(options.toc, SILE.settings:get("section.toc")),
                          }, content)
    end)

    self:registerCommand("subsection", function(options, content)
      SILE.call("head", { level = 3,
                          case     = options.case or SILE.settings:get("subsection.case"),
                          size     = options.size or SILE.settings:get("subsection.size"),
                          weight   = options.weight or SILE.settings:get("subsection.weight"),
                          topSkip  = options.topSkip or SILE.settings:get("subsection.topSkip"),
                          bottomSkip = options.bottomSkip or SILE.settings:get("subsection.bottomSkip"),
                          alignment  = options.alignment or SILE.settings:get("subsection.alignment"),
                          toc = SU.boolean(options.toc, SILE.settings:get("subsection.toc")),
                         }, content)
    end)
end

package.documentation = [[
\begin{document}
This \autodoc:package{textual} package aims to provide...
\end{document}
]]

return package

