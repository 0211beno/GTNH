

local serialization = require("serialization")
local component = require("component")

local gpu = component.gpu
local modem = component.modem




-- Settings

LSC_address = nil
local broadcast_port = 1000

-- End settings

if LSC_address == nil then -- if LSC address in undefined, pull a gt_machine. If more gt machines are connected, then the progam will probably not work.
    LSC_address = component.list("gt_machine")
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


totalCapacity = LSC.getEUCapacity()


message = {}

message["capacity"] = LSC.getEUCapacity()
message["capacityString"] = LSC.getEUCapacityString()


-- runtime
while true do
    message["eu_stored"] = LSC.getEUStored()
    message["output_Average"] = LSC.getEUOutputAverage()
    message["input_Average"] = LSC.getEUInputAverage()
    if modem.broadcast(broadcast_port, serialization.serialize(message)) != true then
        print("Error sending message")
    end
    os.sleep(5)
end