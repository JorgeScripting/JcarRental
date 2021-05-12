local markerPos = vector3(-305.75, -981.08, 31.08)
local markerPos2 = vector3(225.98, -763.22, 30.82)
local HasAlreadyGotMessage = false
local HasAlreadyGotMessage2 = false

print("JcarRental")

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(ped)
        local distance = #(playerCoords - markerPos)
        local isInMarker = false
        if distance < 100.0 then
            DrawMarker(25, markerPos.x, markerPos.y, markerPos.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 55, 288, 0, 100, false, true, 2, nil, nil, false)
            if distance < 2.0 and IsControlJustReleased (0, 38) then
                isInMarker = true
            else 
                HasAlreadyGotMessage = false
            end
        else
            Citizen.Wait(2000)
        end

        if isInMarker and not HasAlreadyGotMessage then
            local ped = PlayerPedId()
            HasAlreadyGotMessage = true
            exports['progressBars']:startUI(5000, "Renting Car")
            TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_CROSS_ROAD_WAIT", 0, false)
            Wait(5000)
            ClearPedTasksImmediately(PlayerPedId())
            local cars = {"dominator"}
            local car = (cars[math.random(#cars)])
            spawnCar(car)
            TriggerServerEvent("scriptname:rentcar")
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName("~b~ You paid 500$ to rent a car")
            EndTextCommandThefeedPostTicker(true, true)
        end
      end
end)

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        local ped = PlayerPedId()
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(ped)
        local distance = #(playerCoords - markerPos2)
        local isInMarker = false
        if distance < 100.0 then
            DrawMarker(25, markerPos2.x, markerPos2.y, markerPos2.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 288, 0, 255, false, true, 2, nil, nil, false)
            if distance < 2.0 and IsControlJustReleased (0, 38) then
                isInMarker = true
            else 
                HasAlreadyGotMessage2 = false
            end
        else
            Citizen.Wait(2000)
        end

        if isInMarker and not HasAlreadyGotMessage2 then
            HasAlreadyGotMessage2 = true
            exports['progressBars']:startUI(5000, "Returning Rental")
            Wait(5000)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if IsVehicleModel(vehicle, `dominator`) then
                ExecuteCommand("dv")
            TriggerServerEvent("scriptname:rentcar2")
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName("~b~ You returned the vehicle and received 250$")
            EndTextCommandThefeedPostTicker(true, true)
            else 
                BeginTextCommandThefeedPost("STRING")
                AddTextComponentSubstringPlayerName("~b~ This is not rental vehicle")
                EndTextCommandThefeedPostTicker(true, true)
            end
        end
    end
end)

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do 
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, x + 2, y + 2, z + 1, 0.0, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    Citizen.Wait(500)
end

local blips = {
    {title="Car Rental", colour=30, id=225, x = -305.75, y = -981.08, z = 31.08},
    {title="Rental Return", colour=30, id=225, x = 225.98, y = -763.22, z = 30.82}
}
      
Citizen.CreateThread(function()
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.8)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)