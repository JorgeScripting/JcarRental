ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("CarRental:rentCar", function(action)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if action == "remove" then
        xPlayer.removeMoney(500)
    elseif action == "add" then
        xPlayer.addMoney(250)
    end
end)