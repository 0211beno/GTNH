

local serialization = require("serialization")
local component = require("component")
local event = require("event")

local gpu = component.gpu
local modem = component.modem
local server_port = 1000


function sendMessage(event_name, localAddress, remoteAddress, port, distance, send_address, send_port)
        
    -- Settings

    local LSC_address = nil
    

    -- End settings

    if LSC_address == nil then -- if LSC address in undefined, pull a gt_machine. If more gt machines are connected, then the progam will probably not work.
        LSC_address = component.list("gt_machine")()
    end

    LSC = component.proxy(LSC_address)
    -- Functions
    --  getEUCapacity()
    --  getEUCapacityString() (String output)
    --  getEUStored()
    --  getEUOutputAverage()
    --  getEUInputAverage()
    --  getAverageElectricOutput()
    --  getAverageElectricInput()


    local totalCapacity = LSC.getEUCapacity()


    local message = {}

    message["capacity"] = LSC.getEUCapacity()
    message["capacityString"] = LSC.getEUCapacityString()

    message["eu_stored"] = LSC.getEUStored()
    message["output_Average"] = LSC.getEUOutputAverage()
    message["input_Average"] = LSC.getEUInputAverage()
    print(event_name)
    print(localAddress)
    print(remoteAddress)
    print(port)
    print(distance)
    print(send_address)
    print(send_port)


    modem.send(send_address, send_port, serialization.serialize(message))
end

modem.open(server_port)
event.listen("modem_message", sendMessage)



