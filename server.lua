local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('cardealer:getCars', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM car_dealer', {}, function(result)
        cb(result)
    end)
end)

RegisterServerEvent('cardealer:buyCar')
AddEventHandler('cardealer:buyCar', function(model)
    local xPlayer = ESX.GetPlayerFromId(source)
    local carPrice = 0

    for i=1, #Config.Cars, 1 do
        if Config.Cars[i].model == model then
            carPrice = Config.Cars[i].price
            break
        end
    end

    if xPlayer.getMoney() >= carPrice then
        xPlayer.removeMoney(carPrice)
        TriggerClientEvent('esx:showNotification', source, 'You bought a ' .. GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(model))) .. ' for $' .. carPrice)
        TriggerClientEvent('cardealer:spawnCar', source, model)
    else
        TriggerClientEvent('esx:showNotification', source, 'You do not have enough money to buy this car')
    end
end)

RegisterServerEvent('cardealer:spawnCar')
AddEventHandler('cardealer:spawnCar', function(model)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))

    ESX.Game.SpawnVehicle(model, playerCoords, 0.0, function(vehicle)
        TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
    end)
end)