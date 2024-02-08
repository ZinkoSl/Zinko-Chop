
local TimeToChop = 0
local chopshopActiveTime = 0
local choping = false
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()


end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job

end)


Citizen.CreateThread(function()
    if Config.EnableChopBlip == true then
        for k,zone in pairs(Config.ChopShop) do
            CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
        end
    end
	if Config.EnableSellBlip == true then
        for k,zone in pairs(Config.SellShop) do
            CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
        end
    end
end)


function CreateBlipCircle(coords, text, radius, color, sprite)

    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

exports.ox_target:addBoxZone({
    coords = vec3(-558.9, -1691.48, 19.17),
    size = vec3(5, 5, 5),
    options = {
        {
            name = 'chop',
            event = 'chop:start',
            icon = 'fa-solid fa-car-burst',
            label = _U('target_label'),
            onSelect = function()
                checkTime()
            end
        }
    }
})

function ChopajCheck()

    if Config.AnyCarChop == true then
        if Config.NeedItem == true then
            ESX.TriggerServerCallback('Check:item', function(ima)
                if ima == true then
                    Odpri()
                else
                    notify(_U('item:missing'))
                end
            end)
        else
            Odpri()
        end
    else
        local playerPed = PlayerPedId()
        local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(playerPed))
        TriggerServerEvent('preglej:tablico', plate)
    end
end


function Odpri()
    if choping == false then
        
        if Config.EnablePoliceChop == true then
            for k,v in pairs(Config.BlackListedJobs) do
                if v == ESX.PlayerData.job.name then
                    notify(_U('blacklist:notify'))
                else
                    ChopCar()
                end
            end
        else
            ChopCar()
        end
    end
end



function ChopCar()
    ESX.TriggerServerCallback('chopshop:anycops', function(anycops)
        if anycops >= Config.CopsRequired then
            if IsDriver() then
                local playerPed = PlayerPedId()
                local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(playerPed))
                print(tablica)
                if Config.EnableAlertChat then
                    TriggerServerEvent("announce", tablica)
                end
		choping = true			
                StartChop()
            else
                notify(_U('not_in_car'))
            end
        else
            ESX.ShowNotification(_U('not_enough_cops'))
        end
    end)
end



function notify(msg)
    ESX.ShowNotification(msg)
end

function IsDriver()
    return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), - 1) == PlayerPedId()
end

function StartChop()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn( ped, false )
    local rearLeftDoor = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'door_dside_r')
    local bonnet = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'bonnet')
    local boot = GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(-1), false), 'boot')
    SetVehicleEngineOn(vehicle, false, false, true)
    SetVehicleUndriveable(vehicle, false)
    local ped = PlayerPedId()
    lib.progressBar({
        duration = 2000,
        label = 'Start Choping',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'amb@world_human_welding@male@base',
            clip = 'base'
        },
    })
    SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 0, false, false)
    SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 1, false, false)
    SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 2, false, false)
    SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 3, false, false)
    SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 4, false, false)
    SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 5, false, false)
    SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 6, false, false)
    SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 7, false, false)
    Citizen.Wait(Config.WaitTime)
    lib.progressBar({
        duration = 10000,
        label = 'Cutting the front left door',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'amb@world_human_welding@male@base',
            clip = 'base'
        },
    })
    SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 0, true)
    Citizen.Wait(Config.WaitTime)
    lib.progressBar({
        duration = 10000,
        label = 'Cutting the front right door',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'amb@world_human_welding@male@base',
            clip = 'base'
        },
    })
    Citizen.Wait(Config.WaitTime)
    SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 1, true)
    if rearLeftDoor ~= -1 then
        lib.progressBar({
            duration = 10000,
            label = 'Removing the front left door',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_welding@male@base',
                clip = 'base'
            },
        })
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 2, true)
        Citizen.Wait(Config.WaitTime)
        lib.progressBar({
            duration = 10000,
            label = 'Removing the front Right door',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_welding@male@base',
                clip = 'base'
            },
        })
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 3, true)
    end
    Citizen.Wait(Config.WaitTime)
    if bonnet ~= -1 then
        lib.progressBar({
            duration = 10000,
            label = 'Cutting the bonnet',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_welding@male@base',
                clip = 'base'
            },
        })
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),4, true)
    end
    Citizen.Wait(Config.WaitTime)
    if boot ~= -1 then
        lib.progressBar({
            duration = 10000,
            label = 'Cutting the boot',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_welding@male@base',
                clip = 'base'
            },
        })
        SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),5, true)
    end
    local vehicle =  GetVehiclePedIsIn( ped, false )
    DeleteVehicle(vehicle)
    TimeToChop = Config.CooldownMinutes
    choping = false
    konec()
end


RegisterNetEvent('Chop:Start', function()
    if Config.NeedItem == true then
        ESX.TriggerServerCallback('Check:item', function(ima)
            if ima == true then
                Odpri()
            else
                notify(_U('item:missing'))
            end
        end)
    else
        Odpri()
    end
end)

function konec()
    if Config.AnyCarChop == true then
        TriggerServerEvent('Give:Reward')
    else
        local playerPed = PlayerPedId()
        local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(playerPed))
        TriggerServerEvent('odstrani:lastnika', tablica)
        TriggerServerEvent('Give:Reward')
    end
end


RegisterNUICallback('sellItem', function(data, cb)
	TriggerServerEvent('sellItem', data.item, 1, data.price)
end)

RegisterNUICallback('focusOff', function(data, cb)
	SetNuiFocus(false, false)
end)



Citizen.CreateThread(function()
    if Config.EnablePed == true then
        for _,v in pairs(Config.Ped) do
            RequestModel(GetHashKey(v[7]))
            while not HasModelLoaded(GetHashKey(v[7])) do
              Wait(1)
            end
        
            RequestAnimDict("mini@strip_club@idles@bouncer@base")
            while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
              Wait(1)
            end
            ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
            SetEntityHeading(ped, v[5])
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
          end
    end
end)


if Config.EnableSell == true then
    exports.ox_target:addBoxZone({
        coords = vec3(-55.28, 6392.81, 31.49),
        size = vec3(1, 1, 1),
        options = {
            {
                name = 'sell',
                event = 'chop:sell',
                icon = 'fa-solid fa-shop',
                label = _U('target_sell'),
                onSelect = function()
                    UiOpen()
                end
            }
        }
    })
end

function UiOpen()
    SetNuiFocus(true, true)

	SendNUIMessage({
		display = true,
	})
	for i=1, #Config.ItemsForSell.Items, 1 do
		local item = Config.ItemsForSell.Items[i]
		SendNUIMessage({
			itemLabel = item.label,
			item = item.name,
			price = item.price
		})
	end
end


function checkTime()
    if TimeToChop == 0 then
        ChopajCheck()
    else
        ESX.ShowNotification('You have to wait ' ..TimeToChop.. ' minutes before you can chop another vehicle.')
    end
end

RegisterCommand("checkTime", function()
    print(TimeToChop)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if TimeToChop >= 1 then
            Citizen.Wait(Config.CountDownTime)
            TimeToChop = TimeToChop - 1
        end
    end
end)
