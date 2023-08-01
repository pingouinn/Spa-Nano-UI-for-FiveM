--- Event listener for an lvc broadcast event that updates the siren state of the vehicle that takes values and update the panel siren state
--- @param data <table> : the data sent by the broadcast event
local fields = {'state_lxsiren', 'state_airmanu', 'state_pwrcall'}
RegisterNetEvent('lvc:UpdateThirdParty')
AddEventHandler('lvc:UpdateThirdParty', function(data)
    if data['actv_manu'] then sirenOn = true return end

    local allStates = {}
    for i = 1, #fields do
        if data[fields[i]] then allStates[i] = data[fields[i]] end
    end

    sirenOn = not wideEqualityCheck(isEqual, false, allStates)
end)

--- Event listener from client side of the script, that updates the panel state on demand
--- @param id <int> : an extra id
RegisterNetEvent('ccs:display')
AddEventHandler('ccs:display', function(toggle)
    if toggle then act = "open" else act = "close" end
	SendNUIMessage({action = act})
end)

--- Event listener from lvc server side, that receive the current LVC version installed
--- @param version <int> : the lvc repo version
RegisterNetEvent('lvc:SendRepoVersion_c')
AddEventHandler('lvc:SendRepoVersion_c', function(version)
	repoVersion = version
end)
