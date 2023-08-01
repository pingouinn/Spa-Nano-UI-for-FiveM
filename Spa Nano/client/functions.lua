--- Shutdown routine resetting all variables and sending a message to the html at closing
function SdRoutine()
	sirene = false
	SendNUIMessage({action = "jourOff"})
	SendNUIMessage({action = "nuitOff"})
	vehSelect = nil                   
	TriggerEvent('ccs:display', false)
end

--- Plays a given sound witha html howl
--- @param soundFile <string> : a sound file
--- @param soundVolume <float> : a volume
function PlaySound(soundFile, soundVolume)
    SendNUIMessage({
		transactionType = 'playSound',
		transactionFile  = soundFile,
		transactionVolume = soundVolume
	})
end

--- Setting html images state based on the extra state in game
--- @param id <int> : an extra id
--- @param actionSet <list> : a set of actions to be sent to the html
local previousStates = {}
function ExtrasUIChecker(id, veh, tVeh, actionSet)
	local e = IsVehicleExtraTurnedOn(veh, tVeh[id])
	if previousStates[id] ~= e then
		if e then 
			SendNUIMessage({action = actionSet[2]})
		else
			SendNUIMessage({action = actionSet[1]})
		end
		previousStates[id] = e
	end
end

--- Setting extras on a vehicle
--- @param id <int> : an extra id.
function ExtrasRoutine(veh, tVeh, id)
	PlaySound('ccs', 0.5)
	SetVehicleAutoRepairDisabled(veh, true)
	if IsVehicleExtraTurnedOn(veh, tVeh[id]) then
		SetVehicleExtra(veh, tVeh[id], 1)
	else
		SetVehicleExtra(veh, tVeh[id], 0)
	end
end

--- Dichotomic list equality search
--- @param f <func> : a function that takes two arguments and returns a single value
--- @param x <any> : initial value to be used in first call to f
--- @param t <table> : the list to reduce
function wideEqualityCheck(f, x, t)
	for _,v in pairs(t) do x = f(x,intToBool(v)) end
  	return x
end

--- Converts a value to a boolean expression 
--- @param v <int> : a value to be converted
function intToBool(v)
	if v == 0 then return false end
	return true
end

--- Equality check wrapped in a func, necessary bc operators are not callable natively, tweaked to return true if any of the two values is different of 0
isEqual = function (a,b) return a == b end

-- Command to manually toggle the panel and displays a scaleform hint 
RegisterCommand(cfg.togglePanelCommand, function()
	show = not show
	SetTextComponentFormat("STRING")
    AddTextComponentString("~y~"..cfg.lang.panelStateChanged)
    DisplayHelpTextFromStringLabel(0, 0, 1, 2000)
end, false)