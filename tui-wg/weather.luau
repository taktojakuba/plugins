local SCRIPT_DIR = noctalia.pluginDir() .. "/"

function update()
  noctalia.setUpdateInterval(100000)
  local location = noctalia.getConfig("location") or "Warsaw"

  noctalia.runAsync(
    "LOCATION=" .. location .. " " .. SCRIPT_DIR .. "weather.sh",
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

