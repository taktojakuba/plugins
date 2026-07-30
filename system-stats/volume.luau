function update()
  noctalia.setUpdateInterval(100)

  noctalia.runAsync(
    noctalia.expandPath("~/.config/noctalia/plugins/system-stats/volume.sh"),
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
