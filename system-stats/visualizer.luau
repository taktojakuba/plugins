function update()
  noctalia.setUpdateInterval(100)
  local w = noctalia.getConfig("width") or 30

  noctalia.runAsync(
    "SIZE=" .. w .. " " .. noctalia.expandPath("~/.config/noctalia/plugins/system-stats/visualizer.sh"),
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

