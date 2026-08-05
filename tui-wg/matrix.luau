local size = 5
local freq = 1000
local cpu = 0
local prev = nil -- { idle, total } from the previous tick

function update()
  noctalia.setUpdateInterval(freq)

  local raw = noctalia.readFile("/proc/stat")
  if raw then
    local cpuLine = raw:match("^cpu%s+(.+)")
    if cpuLine then
      local a, b, c, d, e, f, g, h = cpuLine:match("(%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+)")
      if a then
        local idle = d + e -- idle + iowait
        local total = a + b + c + d + e + f + g + h
        if prev and total > prev.total then
          local used = 1 - (idle - prev.idle) / (total - prev.total)
          cpu = math.max(0, math.min(100, math.floor(used * size)))
        end
        prev = { idle = idle, total = total }
      end
    end
  end

  local line = ""
  for i = 1, size do
    if i<= cpu then
      line = line .. "█"
    else
      line = line .. "░"
    end
  end

  barWidget.setText(line)
end
