-- { Variables } --
Nullcore = Nullcore or {}
Nullcore.ClientReady = false

-- { Client Ready } --
CreateThread(function()
    while not Nullcore.ClientReady do
        Wait(2500)
        TriggerServerEvent("Nullcore:Core:Server:ClientReady")
    end
end)

RegisterNetEvent("Nullcore:Core:Client:RecieveReady", function()
    Nullcore.ClientReady = true
end)

while not Nullcore.ClientReady do
    Wait(100)
end