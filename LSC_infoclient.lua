local serialization = require("serialization")
local component = require("component")
local event = require("event")
local colors = require("colors")
local term = require("term")

local gpu = component.gpu
local modem = component.modem


local recive_port = 1100
local server_port = 1000

modem.open(recive_port)

local server_address = "d861217c-b169-4b50-a80d-243e36590912"

local err

local message = nil


function draw_screen(totalCap_EU, stored_EU, average_output, average_input)
    --For 80x25 res screen. Maybe maxe resolutoin independetn
    local fullFrac = stored_EU/totalCap_EU
    gpu.fill(10, 15, 60, 5, "|") -- Draws background of power bar
    gpu.setForeground(colors.green, true)
    gpu.fill(10, 15, 60*fullFrac, 5, "|") -- Draws filled part of power bar
    gpu.setForeground(colors.white, true)

    gpu.fill(10,3, 60, 13, " ")

    gpu.set(10, 3, string.format("Percentage full:  %.1f", fullFrac))
    gpu.set(10, 5, string.format("Total Capacity:   %i", stored_EU))
    gpu.set(10, 6, string.format("Stored Capacity:  %i", totalCap_EU))
    gpu.set(10, 8, string.format("EU Input:         %i", average_input))
    gpu.set(10, 9, string.format("EU Output:        %i", average_output))

    gpu.set(10, 11, string.format("Net EU:          %i", average_input-average_output))
    
end






--runtime

term.clear()
while true do
    modem.send(server_address, server_port, modem.address, recive_port)

    err, _, _ ,_ ,_ , message = event.pull(3, "modem_message")
    if err == nil then
        print("Message timeout")
        os.exit()
    end
    message = serialization.unserialize(message)
    draw_screen(message["capacity"], message["eu_stored"], message["output_Average"], message["input_Average"])
    -- debug..
    --print(string.format("Stored EU: %i", message["eu_stored"]))
    --print(string.format("Average Output EU: %i", message["output_Average"]))
    --print(string.format("Average Input EU: %i", message["input_Average"]))
    --print(string.format("Total Capacity EU: %i", message["capacity"]))


    os.sleep(5)
end
