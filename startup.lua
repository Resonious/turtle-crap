function say(msg)
    print(msg)
    peripheral.call("left", "sendMessage", msg)
    http.post("https://hook.snd.one/nigel/mcturtle", msg)
end

local file, err = fs.open("state", "r")

if err then
  say("Hello")
elseif fs.exists("go") then
  say("Turtle starting dig!")
  fs.delete("go")
  shell.execute("ex.lua", "6")
else
  say("Hi. I'm at " .. file.readLine())
  file.close()
end
