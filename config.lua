Config = Config or {}

Config.Banner = [[

 _____     _     _    _                                          
|  ___| __(_)___| | _| | ___   _                                 
| |_ | '__| / __| |/ / |/ / | | |                                
|  _|| |  | \__ \   <|   <| |_| |                                
|_|__|_|  |_|___/_|\_\_|\_\\__, |                        _       
|  _ \  _____   _____| | __|___/__  _ __ ___   ___ _ __ | |_ ___ 
| | | |/ _ \ \ / / _ \ |/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __/ __|
| |_| |  __/\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_\__ \
|____/ \___| \_/ \___|_|\___/| .__/|_| |_| |_|\___|_| |_|\__|___/
                             |_|                                 
]]

Config.CoreObj = "auto" -- qbcore, qbx_core, ESX, Kora (client side only) or auto

Config.Inventory = "auto" -- ox_inventory, qb-inventory, esx_inventory, ps-inventory or auto

-- Inventory image locations used by friskkydev_lib.GetItemImage().
-- Add or override a resource here if your inventory stores images elsewhere.
Config.InventoryImagePaths = {
    ['qb-inventory'] = { 'html/images/%s.png', 'html/images/%s.webp' },
    ['ox_inventory'] = { 'web/images/%s.png', 'web/images/%s.webp' },
    ['ps-inventory'] = { 'html/images/%s.png', 'html/images/%s.webp' },
    ['lj-inventory'] = { 'html/images/%s.png', 'html/images/%s.webp' },
    ['qs-inventory'] = { 'html/images/%s.png', 'html/images/%s.webp' },
    ['core_inventory'] = { 'html/images/%s.png', 'html/images/%s.webp' },
    ['codem-inventory'] = { 'html/images/%s.png', 'html/images/%s.webp' },
    ['tgiann-inventory'] = { 'html/images/%s.png', 'html/images/%s.webp' },
}

Config.Target = "auto" -- ox_target, qb-target or auto

Config.VehicleKeys = "auto" -- qb-vehiclekeys, qbx_vehiclekeys, Renewed-VehicleKeys, wasabi_carlock, jaksam_vehiclekeys or auto

Config.Debug = true -- set to true to enable F-bridge debug output on client/server
