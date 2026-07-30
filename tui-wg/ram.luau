local SCRIPT_DIR = noctalia.pluginDir() .. "/"

function update()
  noctalia.setUpdateInterval(1000)

  noctalia.runAsync(
    SCRIPT_DIR .. "ram.sh",
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

