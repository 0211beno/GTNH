local serialization = require("serialization")
local component = require("component")
local event = require("event")

local gpu = component.gpu
local modem = component.modem

recive_port = 1100
server_port = 1000

modem.open(recive_port)

server_address = ""

void = nil
message = ""

while true do
    modem.send(server_address, server_port, modem.address, recive_port)
    err = event.pull(15, "modem_message", void, void, void, void, message)
    if err == nil then
        print("Message timeout")
    end
    message = serialization.unserialize(message)
    print(message["eu_stored"])
    print(message["output_Average"])
    print(message["input_Average"])
    print(message["capacity"])
    os.wait(5)

end
