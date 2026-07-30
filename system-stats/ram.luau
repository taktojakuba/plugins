function update()
  noctalia.setUpdateInterval(1000)

  noctalia.runAsync(
    noctalia.expandPath("~/.config/noctalia/plugins/system-stats/ram.sh"),
    function(result)
      if result.exitCode == 0 then
        local ram = result.stdout:gsub("%s+$", "")
        barWidget.setText("ram: " .. ram)
      else
        barWidget.setText("ram: ERR")
      end
    end
  )
end

