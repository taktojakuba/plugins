local SCRIPT_DIR = noctalia.pluginDir() .. "/"

function update()
  noctalia.setUpdateInterval(10000)
  local iface = noctalia.getConfig("wifi_interface") or "wlan0"

  noctalia.runAsync(
    "WIFI_IFACE=" .. iface .. " " .. SCRIPT_DIR .. "wifi.sh",
    function(result)
      if result.exitCode == 0 then
        local wifi = result.stdout:gsub("%s+$", "")
        barWidget.setText("wifi: " .. wifi)
      else
        barWidget.setText("wifi: ERR")
      end
    end
  )
end

