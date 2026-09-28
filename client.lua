local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, Config.Dealer.Pos.x, Config.Dealer.Pos.y, Config.Dealer.Pos.z, true)

        if distance < 10.0 then
            DrawMarker(Config.Dealer.Type, Config.Dealer.Pos.x, Config.Dealer.Pos.y, Config.Dealer.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Dealer.Size.x, Config.Dealer.Size.y, Config.Dealer.Size.z, Config.Dealer.Color.r, Config.Dealer.Color.g, Config.Dealer.Color.b, 100, false, true, 2, false, nil, nil, false)

            if distance < 1.5 then
                ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to open the car dealer')

                if IsControlJustReleased(0, 38) then
                    OpenCarDealerMenu()
                end
            end
        end
    end
end)

function OpenCarDealerMenu()
    local elements = {}

    for i=1, #Config.Cars, 1 do
        table.insert(elements, { label = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(Config.Cars[i].model))) .. ' - $' .. Config.Cars[i].price, value = Config.Cars[i].model })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_dealer', {
        title    = 'Car Dealer',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('cardealer:buyCar', data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end