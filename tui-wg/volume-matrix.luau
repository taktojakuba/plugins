local SCRIPT_DIR = noctalia.pluginDir() .. "/"
local size = 10
function update()
  noctalia.setUpdateInterval(100)

  noctalia.runAsync(
    SCRIPT_DIR .. "volume.sh",
    function(result)
      local vol = 0
      if result.exitCode == 0 then
        vol = tonumber(result.stdout:gsub("%s+$", ""):match("%d+")) or 0
        vol = math.floor(vol * size / 100)
      else
        barWidget.setText("ERR")
      end
  local line = ""
  for i = 1, size do
    if i<= vol then
      line = line .. "█"
    else
      line = line .. "░"
    end
  end
        barWidget.setText("vol: " .. line)
    end
  )
end
