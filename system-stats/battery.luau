function update()
  noctalia.setUpdateInterval(5000)

  noctalia.runAsync(
    noctalia.expandPath("~/.config/noctalia/plugins/system-stats/battery.sh"),
    function(result)
      if result.exitCode == 0 then
        local battery = result.stdout:gsub("%s+$", "")
        barWidget.setText("batt: " .. battery)
      else
        barWidget.setText("batt: ERR")
      end
    end
  )
end

