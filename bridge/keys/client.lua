local Keys
friskkydev_lib = friskkydev_lib or {}

local function VehKeysNotSetup()
    while true do 
        Wait(5000)
        if Config.Debug then
            print("Please Set You Config Properly in "..GetCurrentResourceName())
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
            Keys = exports['vehicles_keys']
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
if Config.Debug then print("CLIENT PRINT VEHICLEKEYS ^2" ..json.encode(Keys).. "^0") end

exports("import", function()
    return friskkydev_lib
end)
