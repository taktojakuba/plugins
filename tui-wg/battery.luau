local SCRIPT_DIR = noctalia.pluginDir() .. "/"

function update()
  noctalia.setUpdateInterval(5000)

  noctalia.runAsync(
    SCRIPT_DIR .. "battery.sh",
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

