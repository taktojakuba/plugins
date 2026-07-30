local side = noctalia.getConfig("side") or "left"

function update()
  noctalia.setUpdateInterval(86400000)
  barWidget.setText(side == "left" and "[" or "]")
end
