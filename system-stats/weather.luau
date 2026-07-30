function update()
  noctalia.setUpdateInterval(100000)

  noctalia.runAsync(
    noctalia.expandPath("~/.config/noctalia/plugins/system-stats/weather.sh"),
    function(result)
      if result.exitCode == 0 then
        local status = result.stdout:gsub("%s+$", "")
        barWidget.setText("weather: " .. status)
      else
        barWidget.setText("weather: ERR")
      end
    end
  )
end

