local serialization = require("serialization")
local component = require("component")
local event = require("event")

local gpu = component.gpu
local modem = component.modem

local recive_port = 1100
local server_port = 1000

modem.open(recive_port)

local server_address = "d861217c-b169-4b50-a80d-243e36590912"

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
