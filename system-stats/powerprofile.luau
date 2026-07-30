local SCRIPT_DIR = noctalia.expandPath("~/.config/noctalia/plugins/system-stats/")

local function refresh()
  noctalia.runAsync(SCRIPT_DIR .. "powerprofile.sh", function(result)
    if result.exitCode == 0 then
      barWidget.setText("prof: " .. result.stdout:gsub("%s+$", ""))
    else
      barWidget.setText("prof: ERR")
    end
  end)
end

function update()
  noctalia.setUpdateInterval(1000)
  refresh()
end

function onClick()
  noctalia.runAsync(SCRIPT_DIR .. "powerprofilecycle.sh", refresh)
end
