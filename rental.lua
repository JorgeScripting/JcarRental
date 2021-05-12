local markerPos = vector3(-305.75, -981.08, 30.08)
local markerPos2 = vector3(225.98, -763.22, 29.82)
local HasAlreadyGotMessage, HasAlreadyGotMessage2

CreateThread(function()
    local ped = PlayerPedId()
    while true do
        local playerCoords = GetEntityCoords(ped)
        local distance, distance2 = #(playerCoords - markerPos), #(playerCoords - markerPos2)
        local isInMarker = false
        if (distance < 10.0) and inFoot then
            DrawMarker(25, markerPos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 55, 288, 0, 100, false, true, 2, nil, nil, false)
            if (distance < 2.0) and IsControlJustReleased (0, 38) then
                isInMarker = true
            else 
                HasAlreadyGotMessage = false
            end
        elseif (distance2 < 15.0) and inVehicle then
            DrawMarker(25, markerPos2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 288, 0, 255, false, true, 2, nil, nil, false)
            if (distance2 < 2.0) and IsControlJustReleased(0, 38) then
                isInMarker = true
            else 
                HasAlreadyGotMessage2 = false
            end
        else
            Wait(2000)
        end

        if isInMarker and not HasAlreadyGotMessage then
            if inFoot then
                exports['progressBars']:startUI(5000, "Renting Car")
                TaskStartScenarioInPlace(ped, "CODE_HUMAN_CROSS_ROAD_WAIT", 0, false)
                Wait(5000)
                ClearPedTasksImmediately(ped)
                spawnCar("dominator")
                TriggerServerEvent("CarRental:rentCar", "add")
                showNotification("~b~ You paid 500$ to rent a car")
                HasAlreadyGotMessage = true
            else
                showNotification("~r~ You need to be on foot to rent a car")
            end
        elseif isInMarker and not HasAlreadyGotMessage2 then
            if inVehicle then
                HasAlreadyGotMessage2 = true
                exports['progressBars']:startUI(5000, "Returning Rental")
                Wait(5000)
                local vehicle = GetVehiclePedIsIn(ped, false)
                if IsVehicleModel(vehicle, "dominator") then
                    deleteVehicle(vehicle)
                    TriggerServerEvent("CarRental:rentCar", "remove")
                    showNotification("~b~ You returned the vehicle and received $250")
                else 
                    showNotification("~b~ This is not rental vehicle")
                end
            end
        end
        Wait(5)
    end
end)

CreateThread(function()
    while true do
        if IsPedOnFoot(PlayerPedId()) then
            inFoot = true
        else
            inFoot = false
        end
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            inVehicle = true
        else
            inVehicle = false
        end
        Wait(500)
    end
end)

-- Functions
function showNotification(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(0, 1)
end

function deleteVehicle(vehicle)
    SetEntityAsMissionEntity(vehicle, false, true)
    DeleteVehicle(vehicle)
end

function spawnCar(modelHash)
    local model = GetHashKey(modelHash)

    RequestModel(model)
    while not HasModelLoaded(model) do 
        RequestModel(model)
        Wait(50)
    end
    local coords = GetEntityCoords(PlayerPedId(), false)
    local vehicle = CreateVehicle(model, coords.x + 5, coords.y + 5, coords.z + 1, 70.0, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    Wait(500)
end

-- Blips functions
local blips = {
    {title = "Car Rental", colour = 30, id = 225, x = -305.75, y = -981.08, z = 31.08},
    {title = "Rental Return", colour = 30, id = 225, x = 225.98, y = -763.22, z = 30.82}
}
      
CreateThread(function()
    for k, v in pairs(blips) do
      v.blip = AddBlipForCoord(v.x, v.y, v.z)
      SetBlipSprite(v.blip, v.id)
      SetBlipDisplay(v.blip, 4)
      SetBlipScale(v.blip, 0.8)
      SetBlipColour(v.blip, v.colour)
      SetBlipAsShortRange(v.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(v.title)
      EndTextCommandSetBlipName(v.blip)
    end
end)
