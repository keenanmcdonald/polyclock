-- polyclock

local ratios = {4, 4, 4, 4}
local outputIsOn = {false, false, false, false}
local metros = {}
local ratioSelect = 1

function init()
  params:add{type = "number", id = "masterBPM", name = "MasterBPM", min=1, max=200, default=60, action=function() updateMetros() end}

  for i = 1, 4 do
    metros[i] = metro.init()
    metros[i].time = ((60/params:get('masterBPM'))/ ratios[i]*2)
    metros[i].event = function() step(i) end
    metros[i]:start()
  end
  redraw()
end

function redraw()
  screen.clear()
  screen.level(15)
  for i=1,4 do
    x = (i-1)*34
    screen.move(x, 10)
    screen.text(tostring(i))
    screen.move(x,20)
    screen.text('r: ')
    screen.text(ratios[i])
    screen.move(x,30)
    if ratioSelect == i then
      screen.move(x,40)
      screen.line(x+20, 40)
      screen.stroke()
    end
  end
  screen.update()
end

function updateMetros()
  for i = 1, 4 do
    metros[i].time = ((60/params:get('masterBPM')) / ratios[i]*2)
  end
end

function step(out)
  if outputIsOn[out] then
    crow.output[out].volts = 0
    outputIsOn[out] = false
  else
    crow.output[out].volts = 5
    outputIsOn[out] = true
  end
end

function enc(n, z)
  if n == 2 then
    ratioSelect = util.clamp(ratioSelect + z, 1, 4)
  elseif n==3 then
    ratios[ratioSelect] = util.clamp(ratios[ratioSelect] + z, 1, 16)
    updateMetros()
  end
  redraw()
end
