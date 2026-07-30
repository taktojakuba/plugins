local SCRIPT_DIR = noctalia.pluginDir() .. "/"

function update()
  local u = noctalia.getConfig("interval") or 100
  noctalia.setUpdateInterval(u)
  local w = noctalia.getConfig("width") or 30
  local g = noctalia.getConfig("sensitivity") or 1.5

  noctalia.runAsync(
    "SIZE=" .. w .. " GAIN=" .. g .. " " .. SCRIPT_DIR .. "visualizer.sh",
    function(result)
      if result.exitCode == 0 then
        local viz = result.stdout:gsub("%s+$", "")
        barWidget.render(ui.label({ text = viz, color = "primary", flexGrow = 1 }))
      else
        barWidget.render(ui.label({ text = "ERR", color = "primary", flexGrow = 1 }))
      end
    end
  )
end

