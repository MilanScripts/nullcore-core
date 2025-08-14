-- { Variables } --
Nullcore = Nullcore or {}
Nullcore.Ready = Nullcore.Ready or false
Nullcore.framework = Nullcore.framework or nil
Nullcore.ReadyIDs = {}

-- { Client Ready } --
RegisterNetEvent("Nullcore:Core:Server:ClientReady", function()
    if Nullcore.ReadyIDs[source] then
        return
    end

    Nullcore.ReadyIDs[source] = true
    print("info", "Client " .. source .. " is ready.")
    TriggerClientEvent("Nullcore:Core:Client:RecieveReady", source)
end)

-- { Cleanup on disconnect } --
AddEventHandler("playerDropped", function()
    if Nullcore.ReadyIDs[source] then
        Nullcore.ReadyIDs[source] = nil
    end
end)

-- { Connecting Handler } --
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    deferrals.defer()

    if not Nullcore.Ready then
        deferrals.done("Nullcore core is not ready yet. Please wait a moment before connecting again.")
    end

    deferrals.done()
end)

AddEventHandler("playerDropped", function()
    if Nullcore.ReadyIDs[source] then
        Nullcore.ReadyIDs[source] = nil
    end
end)

-- { Exports } --
exports("GetNullcore", function()
    return Nullcore
end)

exports("GetReadyIds", function()
    local out = {}
    for src, ready in pairs(Nullcore.ReadyIDs) do
        if ready then out[#out+1] = src end
    end
    table.sort(out)
    return out
end)