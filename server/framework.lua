repeat Wait(1) until type(Nullcore) == "table"

local esxStarted = (GetResourceState("es_extended") == "started")
local qbStarted = (GetResourceState("qb-core") == "started")
if esxStarted then
    Nullcore.framework = "esx"
    print("info", "Detected ESX framework.")
elseif qbStarted then
    Nullcore.framework = "qbcore"
    print("info", "Detected QBCore framework.")
else
    Nullcore.framework = "standalone"
    print("info", "Detected Standalone framework.")
end

exports('GetFramework', function()
    return (Nullcore and Nullcore.framework) or nil
end)
