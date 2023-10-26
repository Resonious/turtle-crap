function say(msg)
    print(msg)
    peripheral.call("left", "sendMessage", msg)
    http.post("https://hook.snd.one/nigel/mcturtle", msg)
end

local file, err = fs.open("state", "r")

if err then
  say("Hello")
else
  say("Hi. I'm at " .. file.readLine())
  file.close()
end
