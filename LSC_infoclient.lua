local serialization = require("serialization")
local component = require("component")
local event = require("event")

local gpu = component.gpu
local modem = component.modem

local recive_port = 1100
local server_port = 1000

modem.open(recive_port)

local server_address = "1047eb80-972f-4f7c-b6e5-47957a29b6a4"

local arg1 = nil
local arg2 = nil
local arg3 = nil
local arg4 = nil
local err

local message = nil

while true do
    modem.send(server_address, server_port, modem.address, recive_port)

    err, _, _ ,_ ,_ , message = event.pull(3, "modem_message")
    if err == nil then
        print("Message timeout")
        os.exit()
    end
    message = serialization.unserialize(message)
    print(string.format("Stored EU: %i", message["eu_stored"]))
    print(string.format("Average Output EU: %i", message["output_Average"]))
    print(string.format("Average Input EU: %i", message["input_Average"]))
    print(string.format("Total Capacity EU: %i", message["capacity"]))
    os.sleep(5)
end
