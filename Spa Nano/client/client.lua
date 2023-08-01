----------
-- Vars --
----------

-- World related variables

local ped
vehSelect = nil
local tVeh = {}

-- State related variables

siren = false 
local beaconUI = false	
show = true

-- Data related variables

local actionSets = {
	{"defgOff", "defg"},
	{"defmOff", "defm"},
	{"defdOff", "defd"},
	{"projOff", "proj"},
}
repoVersion = nil

-----------------
-- Main thread --
-----------------

Citizen.CreateThread(function()
	Wait(50)
	TriggerServerEvent('lvc:GetRepoVersion_s')
	while repoVersion == nil do 
		Citizen.Wait(100)
	end

	if tonumber(tostring(repoVersion['major'])..tostring(repoVersion['minor'])..tostring(repoVersion['patch'])) < 329 then
		print("~r~ FATAL ERROR : UNCOMPATIBLE LVC VERSION. Please download the latest stable branch of LVC (not the last release)")
		return
	end

	while true do
		if show == true then
			ped = GetPlayerPed(-1)		
			if IsPedInAnyVehicle(ped, false) then	
				local veh = GetVehiclePedIsUsing(ped)	
				local NetId = NetworkGetNetworkIdFromEntity(veh)
				
				local tempTable = cfg.hashVeh[GetEntityModel(veh)]
				if tempTable ~= nil and GetPedInVehicleSeat(veh, -1) == ped then
					vehSelect = veh         
					tVeh = tempTable  

					TriggerEvent('ccs:display', true)
					while GetVehiclePedIsUsing(ped)	== veh do
						if sirenOn and not siren then
							SendNUIMessage({action = "jour",})
							PlaySound('ccs', 0.5)
							siren = true
						elseif not sirenOn and siren then
							SendNUIMessage({action = "jourOff",})
							PlaySound('ccs', 0.5)
							siren = false
						end

						if IsVehicleSirenOn(vehSelect) and not beaconUI then
							PlaySound('ccs', 0.5)
							SendNUIMessage({action = "siren",})
							beaconUI = true
						elseif not IsVehicleSirenOn(vehSelect) and beaconUI then
							PlaySound('ccs', 0.5)
							SendNUIMessage({action = "sirenOff",})
							beaconUI = false
						end

						for i = 1, #cfg.keys do 
							if IsDisabledControlJustReleased(0, cfg.keys[i]) and tVeh[i] ~= nil then ExtrasRoutine(vehSelect, tVeh, i) end
							ExtrasUIChecker(i, vehSelect, tVeh, actionSets[i])
						end

						-- End case
						if not show then break end

						Citizen.Wait(2)
					end
					SdRoutine()
				end
			end
		end
		Citizen.Wait(2)
	end
end)