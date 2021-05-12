ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("scriptname:rentcar")
AddEventHandler("scriptname:rentcar", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(500)
end)

RegisterNetEvent("scriptname:rentcar2")
AddEventHandler("scriptname:rentcar2", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(250)
end)