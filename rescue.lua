print("Fuel: "..turtle.getFuelLevel())

local facing = '.'
while facing ~= 'X' and facing ~= 'Z' and facing ~= '-X' and facing ~= '-Z' do
  print("Which way is forward? X? Z? -X? -Z?")
  facing = io.stdin:read()
end

print("Input your X")
local fromX = tonumber(io.stdin:read())
print("Input your Y")
local fromY = tonumber(io.stdin:read())
print("Input your Z")
local fromZ = tonumber(io.stdin:read())

print("Input rescue X")
local toX = tonumber(io.stdin:read())
print("Input rescue Y")
local toY = tonumber(io.stdin:read())
print("Input rescue Z")
local toZ = tonumber(io.stdin:read())

local moveX = toX - fromX
local moveY = toY - fromY
local moveZ = toZ - fromZ

local function refuel(amount)
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" then
        return true
    end
    
    local needed = amount or (moveX * 2 + moveY + moveZ + 2)
    if turtle.getFuelLevel() < needed then
        local fueled = false
        for n=1,16 do
            if turtle.getItemCount(n) > 0 then
                turtle.select(n)
                if turtle.refuel(1) then
                    while turtle.getItemCount(n) > 0 and turtle.getFuelLevel() < needed do
                        turtle.refuel(1)
                    end
                    if turtle.getFuelLevel() >= needed then
                        turtle.select(1)
                        return true
                    end
                end
            end
        end
        turtle.select(1)
        return false
    end
    
    return true
end

local function say(msg)
    print(msg)
    peripheral.call("left", "sendMessage", msg)
    http.post("https://hook.snd.one/nigel/mcturtle", msg)
end

local isStuck = false

local function curState()
  return "" .. moveX .. ", " .. moveY .. ", " .. moveZ
end

local function stuck(where)
  isStuck = true
  say("I'm stuck!! " .. where .. " " .. curState())
end

local function forward()
  turtle.refuel(2)
  
  if not turtle.up() then
    turtle.digUp()
    if not turtle.up() then
      return stuck("(forward) Going up")
    end
  end
  
  if not turtle.forward() then
    turtle.dig()
    if not turtle.forward() then
      return stuck("Going forward")
    end
  end
  if facing == 'X' then
    moveX = moveX - 1
  elseif facing == '-X' then
    moveX = moveX + 1
  elseif facing == 'Z' then
    moveZ = moveZ - 1
  else
    moveZ = moveZ + 1
  end
  print("forward "..curState())

  if not turtle.down() then
    turtle.digDown()
    if not turtle.down() then
      return stuck("(forward) Going down")
    end
  end
end

local function down()
  if not turtle.down() then
    turtle.digDown()
    if not turtle.down() then
      return stuck("Going down after dig")
    end
  end
  moveY = moveY + 1
  
  print("down "..curState())
end

local function up()
  if not turtle.up() then
    turtle.digUp()
    if not turtle.up() then
      return stuck("Going up after dig")
    end
  end
  moveY = moveY - 1

  print("up "..curState())
end

local function madeIt()
  while moveY > 0 do
    up()
    if stuck then
      io.stdin:read()
      isStuck = false
    end
  end

  while moveY < 0 do
    down()
    if stuck then
      io.stdin:read()
      isStuck = false
    end
  end
  
  say("Made it")
end

-- Time to go

while true do
  turtle.select(1)
  turtle.refuel(1)
  
  if isStuck then
    io.stdin:read()
    isStuck = false
  end
  
  if facing == 'X' and moveX == 0 then
    if moveZ < 0 then
      turtle.turnLeft()
      facing = 'Z'
    elseif moveZ == 0 then
      madeIt()
      break
    else
      turtle.turnRight()
      facing = '-Z'
    end

  elseif facing == '-X' and moveX == 0 then
    if moveZ < 0 then
      turtle.turnRight()
      facing = 'Z'
    elseif moveZ == 0 then
      madeIt()
      break
    else
      turtle.turnLeft()
      facing = '-Z'
    end

  elseif facing == 'Z' and moveZ == 0 then
    if moveX < 0 then
      turtle.turnLeft()
      facing = 'X'
    elseif moveX == 0 then
      madeIt()
      break
    else
      turtle.turnRight()
      facing = '-X'
    end
  
  elseif facing == '-Z' and moveZ == 0 then
    if moveX < 0 then
      turtle.turnRight()
      facing = 'X'
    elseif moveX == 0 then
      madeIt()
      break
    else
      turtle.turnLeft()
      facing = '-X'
    end

  elseif facing == 'X' and moveX > 
  end

  forward()
  
  if not stuck and moveY > 0 then
    up()
  end

  if not stuck and moveY < 0 then
    down()
  end
end
