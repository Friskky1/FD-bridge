local Inventory
local ESX
friskkydev_lib = friskkydev_lib or {}

local function InventoryNotSetup()
    while true do 
        Wait(5000)
        if Config.Debug then
            print("Please Set You Config Properly in "..GetCurrentResourceName())
        end
    end
end

if Config.Inventory == "auto" then
    while true do
        if GetResourceState('ox_inventory') == 'started' then 
            Inventory = exports.ox_inventory
            break
        elseif GetResourceState('qb-inventory') == 'started' then
            Inventory = exports['qb-inventory']
            break
        elseif GetResourceState('ps-inventory') == 'started' then
            Inventory = exports['ps-inventory']
            break
        elseif GetResourceState('es_extended') == 'started' and GetResourceState('ox_inventory') ~= 'started' then
            Inventory = exports['es_extended']:getSharedObject()
            break
        end
        Wait(1000)
    end
elseif Config.Inventory == "ox_inventory" then
    Inventory = exports.ox_inventory
elseif Config.Inventory == "qb-inventory" then
    Inventory = exports['qb-inventory']
elseif Config.Inventory == "ps-inventory" then
    Inventory = exports['ps-inventory']
elseif Config.Inventory == "esx_inventory" then
    Inventory = exports['es_extended']:getSharedObject()
else
    InventoryNotSetup()
end
if Config.Debug then print("SERVER PRINT INVENTORY "..json.encode(Inventory).."^2 If its a empty [] then its correct ^0") end


---@param src integer
---@param item string
---@param amount number
---@param metadata? table<string, any>
---@param slot? number
---@param cb? function
---@return any
function friskkydev_lib.AddItem(src, item, amount, metadata, slot, cb)
    if Config.Debug then print("friskkydev_lib.AddItem() "..src, item, amount, metadata, slot, cb) end
    if GetResourceState('es_extended') == 'started' and GetResourceState('ox_inventory') ~= 'started' then
        local xPlayer = Inventory.GetPlayerFromId(src)
        return xPlayer.addInventoryItem(item, amount) 
    elseif GetResourceState('ox_inventory') == 'started' then
        return Inventory:AddItem(src, item, amount, metadata, slot, cb)
    else
        -- qb/ps-inventory take slot before info: AddItem(identifier, item, amount, slot, info, reason)
        return Inventory:AddItem(src, item, amount, slot, metadata, GetInvokingResource() or 'FD-bridge')
    end
end

---@param src integer
---@param item string
---@param amount number
---@return any
function friskkydev_lib.RemoveItem(src, item, amount)
    if Config.Debug then print("friskkydev_lib.RemoveItem() "..src, item, amount) end
    if GetResourceState('es_extended') == 'started' and GetResourceState('ox_inventory') ~= 'started' then
        local xPlayer = Inventory.GetPlayerFromId(src)
        return xPlayer.removeInventoryItem(item, amount) 
    else
        return Inventory:RemoveItem(src, item, amount)
    end
end

---@param src integer
---@param item string
---@param amount? number
---@return boolean
function friskkydev_lib.HasItem(src, item, amount)
    if Config.Debug then print("friskkydev_lib.HasItem() "..src, item, amount) end
    if GetResourceState('ox_inventory') == 'started' then 
        return Inventory:GetItemCount(src, item, amount)
    elseif GetResourceState('es_extended') == 'started' and GetResourceState('ox_inventory') ~= 'started' then
        local xPlayer = Inventory.GetPlayerFromId(src)
        local invItem = xPlayer.getInventoryItem(item)
        return invItem ~= nil and invItem.count >= (amount or 1)
    else
        return Inventory:HasItem(src, item, amount)
    end
end

-- Turns any inventory item table (qb slot map, ox list, ESX list or ESX { name = count }) into
-- a list of { name, label, amount, slot, metadata } sorted by slot.
function friskkydev_lib.NormalizeItems(items)
    local list = {}
    for key, item in pairs(items or {}) do
        if type(item) == 'table' and item.name then
            local amount = tonumber(item.amount or item.count) or 0
            if amount > 0 then
                list[#list + 1] = { name = item.name, label = item.label, amount = amount, slot = tonumber(item.slot), metadata = item.info or item.metadata }
            end
        elseif type(item) == 'number' and item > 0 then
            list[#list + 1] = { name = key, amount = item }
        end
    end
    table.sort(list, function(first, second)
        if (first.slot or math.huge) ~= (second.slot or math.huge) then return (first.slot or math.huge) < (second.slot or math.huge) end
        return first.name < second.name
    end)
    return list
end

---@param src integer
---@return table|nil items list of { name, label, amount, slot, metadata }, nil if the player is not loaded
function friskkydev_lib.GetInventoryItems(src)
    if Config.Debug then print("friskkydev_lib.GetInventoryItems() "..src) end
    if GetResourceState('ox_inventory') == 'started' then
        local items = Inventory:GetInventoryItems(src)
        return items and friskkydev_lib.NormalizeItems(items)
    elseif GetResourceState('es_extended') == 'started' then
        local xPlayer = Inventory.GetPlayerFromId(src)
        return xPlayer and friskkydev_lib.NormalizeItems(xPlayer.getInventory())
    else
        local playerData = friskkydev_lib.GetPlayerData(src) -- qb-inventory / ps-inventory keep items in PlayerData
        return playerData and friskkydev_lib.NormalizeItems(playerData.items)
    end
end

---@param id string
---@param label string
---@param slots number
---@param maxWeight number
---@param group? string
---@param coords? vector3
---@return any
function friskkydev_lib.CreateStash(id, label, slots, maxWeight, group, coords)
    if Config.Debug then print("friskkydev_lib.CreateStash() "..id, label, slots, maxWeight, group, coords) end
    if GetResourceState('ox_inventory') == 'started' then 
        return Inventory:RegisterStash(id, label, slots, maxWeight, group, coords)
    else
        return Inventory:CreateInventory(id, { label = label, maxweight = maxWeight, slots = slots })
    end
end

---@param src integer
---@param invType? string
---@param plyID integer
---@return any
function friskkydev_lib.forceOpenInventory(src, invType, plyID)
    if Config.Debug then print("friskkydev_lib.forceOpenInventory() "..src, invType, plyID) end
    if GetResourceState('ox_inventory') == 'started' then 
        return Inventory:forceOpenInventory(src, invType, plyID)
    elseif invType == 'player' or not invType then
        return Inventory:OpenInventoryById(src, plyID)
    else
        return Inventory:OpenInventory(src, tostring(plyID))
    end
end

-- Checks whether an item is registered by the active framework/inventory.
-- This prevents scripts from treating an unknown item as an inventory-space error.
---@param item string
---@return boolean
function friskkydev_lib.DoesItemExist(item)
    if type(item) ~= 'string' or item == '' then
        return false
    end

    -- ox_inventory owns its item registry, even when it is being used with
    -- QBCore or another framework. Check it before framework item tables.
    if GetResourceState('ox_inventory') == 'started' then
        local ok, itemInfo = pcall(function()
            return exports.ox_inventory:Items(item)
        end)
        return ok and itemInfo ~= nil and itemInfo ~= false
    elseif GetResourceState('qb-core') == 'started' then
        local QBCore = exports['qb-core']:GetCoreObject()
        return QBCore.Shared
            and QBCore.Shared.Items
            and QBCore.Shared.Items[item] ~= nil
    elseif GetResourceState('qbx_core') == 'started' then
        local ok, items = pcall(function()
            return exports.qbx_core:GetItems()
        end)
        return ok and items and items[item] ~= nil
    end

    return false
end

-- Returns the inventory's real item image as a browser-safe NUI URL.
-- Returns nil when the active inventory does not contain a matching image.
---@param item string
function friskkydev_lib.GetItemImage(item)
    if type(item) ~= 'string' or item == '' then
        return nil
    end

    local resources = {}
    local seenResources = {}
    local configuredInventory = Config.Inventory

    local function addResource(resource)
        if resource and not seenResources[resource] then
            seenResources[resource] = true
            resources[#resources + 1] = resource
        end
    end

    if configuredInventory and configuredInventory ~= 'auto' then
        addResource(configuredInventory)
    end

    for _, resource in ipairs({
        'qb-inventory',
        'ox_inventory',
        'ps-inventory',
        'lj-inventory',
        'qs-inventory',
        'core_inventory',
        'codem-inventory',
        'tgiann-inventory',
    }) do
        addResource(resource)
    end

    local itemNames = { item }
    local underscored = item:gsub('%s+', '_')
    if underscored ~= item then itemNames[#itemNames + 1] = underscored end
    local dashed = item:gsub('%s+', '-')
    if dashed ~= item and dashed ~= underscored then itemNames[#itemNames + 1] = dashed end

    for _, resource in ipairs(resources) do
        if GetResourceState(resource) == 'started' then
            local pathTemplates = Config.InventoryImagePaths[resource]
            if pathTemplates then
                for _, itemName in ipairs(itemNames) do
                    for _, template in ipairs(pathTemplates) do
                        local path = template:format(itemName)
                        if LoadResourceFile(resource, path) then
                            return ('https://cfx-nui-%s/%s'):format(resource, path)
                        end
                    end
                end
            end
        end
    end

    return nil
end

---@param src integer
---@param item string
---@param action? string
---@param amount? number
function friskkydev_lib.ItemBox(src, item, action, amount)
    if GetResourceState('qb-inventory') ~= 'started' then
        return false
    end

    if GetResourceState('qb-core') ~= 'started' then
        return false
    end

    local QBCore = exports['qb-core']:GetCoreObject()
    local itemInfo = QBCore.Shared.Items[item]
    if not itemInfo then
        return false
    end

    TriggerClientEvent('qb-inventory:client:ItemBox', src, itemInfo, action or 'add', amount)
    return true
end

-- Normalised item event: items created in or removed from an inventory by a script (not moves between inventories).
-- Listen with: AddEventHandler('FD-bridge:server:itemChanged', function(inventoryId, itemName, amount, action, origin, reason) end)
-- inventoryId is a player server id (number) or a stash/inventory name. action is 'add' or 'remove'.
local function emitItemChanged(inventoryId, itemName, amount, action, origin, reason)
    if not itemName then return end
    TriggerEvent('FD-bridge:server:itemChanged', inventoryId, itemName, tonumber(amount) or 0, action, origin, reason)
end

if GetResourceState('ox_inventory') == 'started' then
    -- shortcut: ox_inventory has no removal hook, so on ox only items entering the economy are reported.
    exports.ox_inventory:registerHook('createItem', function(payload)
        emitItemChanged(payload.inventoryId, payload.item and payload.item.name, payload.count, 'add', 'ox_inventory')
    end, {})
elseif GetResourceState('qb-inventory') == 'started' then
    exports['qb-inventory']:AddListener('ItemAdded', function(data)
        emitItemChanged(data.toId, data.item and data.item.name, data.amount, 'add', data.resource, data.reason)
    end)
    exports['qb-inventory']:AddListener('ItemRemoved', function(data)
        emitItemChanged(data.fromId, data.item and data.item.name, data.amount, 'remove', data.resource, data.reason)
    end)
end

-- ESX default inventory
AddEventHandler('esx:onAddInventoryItem', function(playerId, itemName, count)
    emitItemChanged(playerId, itemName, count, 'add', 'es_extended')
end)
AddEventHandler('esx:onRemoveInventoryItem', function(playerId, itemName, count)
    emitItemChanged(playerId, itemName, count, 'remove', 'es_extended')
end)

exports("import", function()
    return friskkydev_lib
end)
