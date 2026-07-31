local SCRIPT_DIR = noctalia.pluginDir() .. "/"

local function shq(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function appArgs(apps)
  local parts = {}
  for _, entry in ipairs(apps or {}) do
    table.insert(parts, shq(entry))
  end
  if #parts == 0 then
    return ""
  end
  return " " .. table.concat(parts, " ")
end

local function activate(name)
  local apps = noctalia.getConfig("apps")
  noctalia.runAsync(shq(SCRIPT_DIR .. "apptray.sh") .. " activate " .. shq(name) .. appArgs(apps))
end

local function render(apps)
  if #apps == 0 then
    barWidget.setVisible(false)
    return
  end
  barWidget.setVisible(true)

  local children = {}
  for i, app in ipairs(apps) do
    _G["apptray_activate_" .. i] = function()
      activate(app)
    end
    table.insert(children, ui.button({
      key = "app-" .. i,
      text = app,
      variant = "ghost",
      tooltip = app,
      onClick = "apptray_activate_" .. i,
    }))
  end

  local container = barWidget.isVertical() and ui.column or ui.row
  barWidget.render(container({ gap = 6, align = "center" }, children))
end

function update()
  noctalia.setUpdateInterval(2000)

  local apps = noctalia.getConfig("apps")
  noctalia.runAsync(shq(SCRIPT_DIR .. "apptray.sh") .. " list" .. appArgs(apps), function(result)
    if result.exitCode == 0 then
      local running = {}
      for line in result.stdout:gmatch("[^\r\n]+") do
        table.insert(running, line)
      end
      render(running)
    else
      barWidget.setVisible(false)
    end
  end)
end
