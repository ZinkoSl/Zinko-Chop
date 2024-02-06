ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("Check:item", function(source, cb)
    local igrac = ESX.GetPlayerFromId(source)
    local kartica = igrac.getInventoryItem(Config.ItemName)
    if kartica.count >= 1 then
        cb(true)
    else
        cb(false)
    end
end)




RegisterServerEvent('announce')
AddEventHandler('announce', function(tablica)
  TriggerClientEvent('chatMessage', -1, '^7[^1ChopShop^7]^2', { 0,0,0 }, _U('text:chat') .. tablica .. '')
end)

RegisterServerEvent('preglej:tablico')
AddEventHandler('preglej:tablico', function(plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local plate = plate
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate=@plate",{ ['@plate'] = plate}, function(result)
        if result[1] then
            print("Vehicle is owned")
            Citizen.Wait(5)
            print('deleted = ' ..plate)
            TriggerClientEvent('Chop:Start')
        else
            print("Not owned")
            TriggerClientEvent('esx:showNotification', _source, _U('cant:chop'))
        end
    end)
end)

RegisterServerEvent('odstrani:lastnika')
AddEventHandler('odstrani:lastnika', function(plate, source)
    local plate = plate
    local igrac = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    })
    if Config.RemoveItem == true then
        igrac.removeInventoryItem(Config.ItemName, 1)
    end
end)

RegisterServerEvent('Give:Reward')
AddEventHandler('Give:Reward', function(plate)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    for i= 1, 3, 1 do
        local chance = math.random(1, #Config.Items)
        local amount = math.random(1,3)
        local myItem = Config.Items[chance]

        if xPlayer.canCarryItem(myItem, amount) then
            xPlayer.addInventoryItem(myItem, amount)
            TriggerClientEvent('esx:showNotification', source, '~g~Rewards has been given!')
        else
            TriggerClientEvent('esx:showNotification', source, '~r~You cant carry anymore!')
        end
    end
end)

RegisterServerEvent('call:cops')
AddEventHandler('call:cops', function(plate)
    _source  = source
    xPlayer  = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], _U('alert:police'))
        end
    end
end)

RegisterServerEvent('sellItem')
AddEventHandler('sellItem', function(itemName, amount, itemPrice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local items = xPlayer.getInventoryItem(itemName)
	if items.count >= 1 then
        xPlayer.removeInventoryItem(itemName, 1)
		xPlayer.showNotification(_U('item:sold'))
        if Config.Black == true then
            xPlayer.addInventoryItem('black_money', itemPrice)
        else
            xPlayer.addInventoryItem('money', itemPrice)
        end
    else
        xPlayer.showNotification(_U('item:missing'))
    end
end)

ESX.RegisterServerCallback('chopshop:anycops',function(src, cb)
    local anycops = 0
    local playerList = GetPlayers()
    for i=1, #playerList, 1 do
        local _source = playerList[i]
        local xPlayer = ESX.GetPlayerFromId(_source)
        local playerjob = xPlayer.job.name

        if playerjob == 'police' then
            anycops = anycops + 1
        end
    end
    cb(anycops)
end)