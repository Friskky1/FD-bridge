local Keys
friskkydev_lib = friskkydev_lib or {}

local function VehKeysNotSetup()
    while true do 
        Wait(5000)
        if Config.Debug then
            print("Please Set Your Config Properly in "..GetCurrentResourceName())
        end
    end
end

if Config.VehicleKeys == "auto" then
    while true do
        if GetResourceState('qb-vehiclekeys') == 'started' then 
            Keys = exports['qb-vehiclekeys']
            break
        elseif GetResourceState('qbx_vehiclekeys') == 'started' then
            Keys = exports.qbx_vehiclekeys
            break
        elseif GetResourceState('Renewed-VehicleKeys') == 'started' then
            Keys = exports['Renewed-VehicleKeys']
            break
        elseif GetResourceState('wasabi_carlock') == 'started' then
            Keys = exports.wasabi_carlock
            break
        elseif GetResourceState('jaksam_vehiclekeys') == 'started' then
            Keys = exports['jaksam_vehiclekeys']
            break
        elseif GetResourceState('vehicles_keys') == 'started' then
            Keys = exports["vehicles_keys"]
            break
        end
        Wait(1000)
    end
elseif Config.VehicleKeys == "qb-vehiclekeys" then
    Keys = exports['qb-vehiclekeys']
elseif Config.VehicleKeys == "qbx_vehiclekeys" then
    Keys = exports.qbx_vehiclekeys
elseif Config.VehicleKeys == "Renewed-VehicleKeys" then
    Keys = exports['Renewed-VehicleKeys']
elseif Config.VehicleKeys == "wasabi_carlock" then
    Keys = exports.wasabi_carlock
elseif Config.VehicleKeys == "jaksam_vehiclekeys" then
    Keys = exports['jaksam_vehiclekeys']
else
    VehKeysNotSetup()  
end
if Config.Debug then print("SERVER PRINT VEHICLEKEYS " ..json.encode(Keys).. "^2 If its a empty [] then its correct ^0") end

---@param source integer
---@param plate string
function friskkydev_lib.AddKeys(source, plate)
    if GetResourceState('qb-vehiclekeys') == 'started' then
        Keys:GiveKeys(source, plate)
    elseif GetResourceState('qbx_vehiclekeys') == 'started' then
        Keys:GiveKeys(source, plate)
    elseif GetResourceState('Renewed-VehicleKeys') == 'started' then
        Keys:addKey(source, plate)
    elseif GetResourceState('wasabi_carlock') == 'started' then
        Keys:GiveKey(source, plate)
    elseif GetResourceState('vehicles_keys') == 'started' then
        Keys:giveVehicleKeysToPlayerId(source, plate)
    end
end

---@param source integer
---@param plate string
function friskkydev_lib.RemoveKeys(source, plate)
    if GetResourceState('qb-vehiclekeys') == 'started' then
        Keys:RemoveKeys(source, plate)
    elseif GetResourceState('qbx_vehiclekeys') == 'started' then
        Keys:RemoveKeys(source, plate)
    elseif GetResourceState('Renewed-VehicleKeys') == 'started' then
        Keys:removeKey(source, plate)
    elseif GetResourceState('wasabi_carlock') == 'started' then
        Keys:RemoveKey(source, plate)
    elseif GetResourceState('vehicles_keys') == 'started' then
        Keys:removeKeysFromPlayerId(source, plate)
    end
end

exports("import", function()
    return friskkydev_lib
end)
