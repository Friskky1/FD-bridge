local Inventory
friskkydev_lib = friskkydev_lib or {}

local function inventoryNotSetup()
    while true do
        Wait(5000)
        if Config.Debug then
            print(("Please set your inventory configuration correctly in %s."):format(GetCurrentResourceName()))
        end
    end
end

---@param inventoryType string
---@return table|nil
local function getInventoryAdapter(inventoryType)
    if inventoryType == "ox_inventory" then
        return exports.ox_inventory
    elseif inventoryType == "qb-inventory" then
        return exports["qb-inventory"]
    elseif inventoryType == "ps-inventory" then
        return exports["ps-inventory"]
    elseif inventoryType == "esx_inventory" then
        return exports["es_extended"]:getSharedObject()
    end

    return nil
end

if Config.Inventory == "auto" then
    local supportedInventories = {
        { resource = "ox_inventory", type = "ox_inventory" },
        { resource = "qb-inventory", type = "qb-inventory" },
        { resource = "ps-inventory", type = "ps-inventory" },
        { resource = "es_extended", type = "esx_inventory" },
    }

    while not Inventory do
        for _, inventory in ipairs(supportedInventories) do
            if GetResourceState(inventory.resource) == "started" then
                Inventory = getInventoryAdapter(inventory.type)
                break
            end
        end

        if not Inventory then
            Wait(1000)
        end
    end
else
    Inventory = getInventoryAdapter(Config.Inventory)
end

if not Inventory then
    inventoryNotSetup()
end

if Config.Debug then
    print(("CLIENT PRINT INVENTORY %s^2 If it is an empty [] then it is correct.^0"):format(json.encode(Inventory)))
end

exports("import", function()
    return friskkydev_lib
end)
