Config = {}

Config.Locale = 'en'

--Alerts--
Config.EnableChopBlip = true --Chop Shop blip True = yes, False = no.
Config.EnableSellBlip = true --Sell Shop blip True = yes, False = no.
Config.EnableAlertChat = true  --Alert that car is choping in chat
Config.EnableAlertPolice = true --Alert that car is choping to police
Config.CooldownMinutes = 12
Config.CountDownTime = 60000 --How much fast will count down deafult 1 Minute = 60000 miliseconds
-- Set the time (in minutes) during the player is markered
--Police--
Config.CopsRequired = 0 --Min. polices man on server to chop
Config.EnablePoliceChop = true
Config.WhitelistedJob = {
    'police'
}
Config.BlackListedJobs = {
    'police'
}
--Sell Parts--
Config.EnableSell = true --Enable Sell
Config.EnablePed = true --If Config.EnableSell is true then ped shows
Config.Black = false --black cash at sell
Config.Ped = {
	{-55.30, 6392.88, 30.49,"Sell", 52.13 , 0xC99F21C4, "a_m_y_business_01"}
}

--Chop Shop--
Config.AnyCarChop = true --Npc cars can get choped!
Config.ChopShop = {
    Chopshop = {coords = vector3(-555.22, - 1697.99, 18.75 + 0.99), name = 'ChopShop', color = 49, sprite = 225, radius = 100.0, Pos = { x = -555.22, y = -1697.99, z = 19.13 - 0.95 }, Size = { x = 5.0, y = 5.0, z = 0.5 }, }
}

Config.SellShop = {
    SellShop = {coords = vector3(-55.42, 6392.8, 30.5), name = 'Sell Parts', color = 50, sprite = 120, radius = 25.0, Pos = { x = -55.42, y = 6392.8, z = 30.5}, Size = { x = 3.0, y = 3.0, z = 1.0 }, }
}

Config.NeedItem = true --Need item for chop
Config.RemoveItem = true
Config.ItemName = 'grinder'
Config.WaitTime = 1000

Config.Items = {
    -- Item and Price $
    "battery",
    "muffler",
    "hood",
    "trunk",
    "doors",
    "engine",
    "waterpump",
    "oilpump",
    "speakers",
    "radio",
    "rims",
    "subwoofer",
    "steeringwheel"
}

Config.ItemsForSell = {
    -- Item and Price $
    Items = {
		{
			name = "battery",
			label = "Battery",
			price = 100
		},
		{
			name = "muffler",
			label = "Muffler",
			price = 700
		},
		{
			name = "hood",
			label = "Hood",
			price = 1200
		},
		{
			name = "doors",
			label = "Doors",
			price = 750
		},
		{
			name = "engine",
			label = "Engine",
			price = 3500
		},
		{
			name = "waterpump",
			label = "Water Pump",
			price = 120
		},
		{
			name = "oilpump",
			label = "Oil Pump",
			price = 120
		},
		{
			name = "speakers",
			label = "Speakers",
			price = 220
		},
		{
			name = "radio",
			label = "Radio",
			price = 50
		},
		{
			name = "rims",
			label = "Rims",
			price = 120
		},
		{
			name = "subwoofer",
			label = "Subwoofer",
			price = 890
		},
		{
			name = "steeringwheel",
			label = "Steering wheel",
			price = 350
		},
	}
}



