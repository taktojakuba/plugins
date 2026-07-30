local SCRIPT_DIR = noctalia.pluginDir() .. "/"

function update()
  noctalia.setUpdateInterval(1000)

  noctalia.runAsync(
    SCRIPT_DIR .. "cpu.sh",
    function(result)
      if result.exitCode == 0 then
        local cpu = result.stdout:gsub("%s+$", "")
        barWidget.setText("cpu: " .. cpu)
      else
        barWidget.setText("cpu: ERR")
      end
    end
  )
end

