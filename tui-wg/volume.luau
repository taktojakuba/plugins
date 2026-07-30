local SCRIPT_DIR = noctalia.pluginDir() .. "/"

function update()
  noctalia.setUpdateInterval(100)

  noctalia.runAsync(
    SCRIPT_DIR .. "volume.sh",
    function(result)
      if result.exitCode == 0 then
        local vol = result.stdout:gsub("%s+$", "")
        barWidget.setText("vol: " .. vol)
      else
        barWidget.setText("ERR")
      end
    end
  )
end
