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


local powerOutputTimeSeries = {} --creates an empty array with "indexes" 0 to 1440 to represent 0 to 24 hours.
for i=1, 1440 do 
    a[i] = 0
end


function draw_screen(timeSeries, index) --160x50 resolution
    --Graph
    gpu.fill(10, 5, 1, 40, "|")
    gpu.fill(10, 5, 140, 1, "-")
end






--runtime

term.clear()

local timeSeriesIndex = 1

local count = 0
local rollingAverageSum = 0
while true do
    count = count + 1
    modem.send(server_address, server_port, modem.address, recive_port)

    err, _, _ ,_ ,_ , message = event.pull(3, "modem_message")
    if err == nil then
        print("Message timeout")
        os.exit()
    end
    message = serialization.unserialize(message)
    
    -- debug..
    --print(string.format("Stored EU: %i", message["eu_stored"]))
    --print(string.format("Average Output EU: %i", message["output_Average"]))
    --print(string.format("Average Input EU: %i", message["input_Average"]))
    --print(string.format("Total Capacity EU: %i", message["capacity"]))
    --draw_screen(message["capacity"], message["eu_stored"], message["output_Average"], message["input_Average"])
    rollingAverageSum = rollingAverageSum + message["output_Average"]
    if count > 11 then
        count = 0
        powerOutputTimeSeries[timeSeriesIndex] = rollingAverageSum
        timeSeriesIndex = timeSeriesIndex + 1
        if timeSeriesIndex > 1440 then
            timeSeriesIndex = 1
        end
        rollingAverageSum = 0

        draw_screen(powerOutputTimeSeries, timeSeriesIndex)


    end

    os.sleep(5)
end
