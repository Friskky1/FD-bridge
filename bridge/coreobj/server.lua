local Core
local ESX
friskkydev_lib = friskkydev_lib or {}

if Config.CoreObj == "auto" then
    while true do
        if GetResourceState('qb-core') == 'started' then
            Core = exports['qb-core']:GetCoreObject()
            break
        elseif GetResourceState('qbx_core') == 'started' then
            Core = exports.qbx_core
            break
        elseif GetResourceState('es_extended') == 'started' then
            ESX = exports['es_extended']:getSharedObject()
            Core = ESX
            break
        end
        Wait(1000)
    end
elseif Config.CoreObj == "qbcore" then
    Core = exports['qb-core']:GetCoreObject()
elseif Config.CoreObj == "qbx_core" then
    Core = exports.qbx_core
elseif Config.CoreObj == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
    Core = ESX
end

---@param source integer
---@param msg string
---@param type? string
---@param duration? number
---@param position? string
function friskkydev_lib.Notify(source, msg, type, duration, position)
    if GetResourceState('ox_lib') == 'started' then
        local data = {
            description = msg,
            type = type,
            duration = duration,
            position = position or 'top-right'
        }
        TriggerClientEvent('ox_lib:notify', source, data)
    elseif GetResourceState('es_extended') == 'started' then
        TriggerClientEvent("ESX:Notify", source, type or "info", duration or 5000, msg)
    else
        Core.Functions.Notify(source, msg, type, duration)
    end
end

---@param source integer
function friskkydev_lib.GetPlayer(source)
    if Config.Debug then print(source) end
    if GetResourceState('qb-core') == 'started' then
        local Player = Core.Functions.GetPlayer(source)
        return Player
    elseif GetResourceState('qbx_core') == 'started' then
        local Player = Core:GetPlayer(source)
        return Player
    elseif GetResourceState('es_extended') == 'started' then
        local Player = Core.GetPlayerFromId(source)
        return Player
    end
end

---@param source integer
---@return table|nil PlayerData (QB/QBX) or xPlayer (ESX)
function friskkydev_lib.GetPlayerData(source)
    local Player = friskkydev_lib.GetPlayer(source)
    if not Player then return nil end
    if GetResourceState('es_extended') == 'started' then
        return Player
    end
    return Player.PlayerData
end

-- ESX uses 'money' for cash; QB/QBX use 'cash'
local function esxAccount(moneytype)
    if not moneytype or moneytype == 'cash' then return 'money' end
    return moneytype
end

function friskkydev_lib.getAllPlayers()
    if GetResourceState('qb-core') == 'started' then
        return Core.Functions.GetQBPlayers()
    elseif GetResourceState('es_extended') == 'started' then
        return Core.GetExtendedPlayers()
    elseif GetResourceState('qbx_core') == 'started' then
        return Core:GetQBPlayers()
    end
end

---@param source integer
function friskkydev_lib.GetPlayerJob(source)
    if Config.Debug then print(source) end
    local Player = friskkydev_lib.GetPlayerData(source)
    return Player.job
end

---@param source integer
---@return string
function friskkydev_lib.GetPlayerJobName(source)
    local Player = friskkydev_lib.GetPlayerData(source)
    return Player.job.name
end

---@param source integer
function friskkydev_lib.GetPlayerGang(source)
    if Config.Debug then print(source) end
    local Player = friskkydev_lib.GetPlayerData(source)
    return Player.gang
end

---@param source integer
---@return boolean
function friskkydev_lib.isBoss(source)
    if Config.Debug then print(source) end
    local player = friskkydev_lib.GetPlayerJob(source)
    return player.isboss
end

---@param source source
---@return vector3
function friskkydev_lib.getPlayerCoords(source)
    if Config.Debug then print(source) end
    return GetEntityCoords(GetPlayerPed(source))
end

---@param source integer
---@return boolean
function friskkydev_lib.getJobDuty(source)
    if Config.Debug then print(source) end
    local player = friskkydev_lib.GetPlayerJob(source)
    return player.onduty
end

---@param source integer
---@param location vector3
---@param distance number
---@return boolean
function friskkydev_lib.checkDistance(source, location, distance)
    if Config.Debug then print(source, location, distance) end
    local pcoords = friskkydev_lib.getPlayerCoords(source)
    local location = vector3(location.x, location.y, location.z)
    return #(pcoords - location) <= distance
end

---@param source integer
---@param metadataname string
---@return string
function friskkydev_lib.GetMetaData(source, metadataname)
    if Config.Debug then print(source, metadataname) end
    local Player = friskkydev_lib.GetPlayerData(source)
    if not Player then return nil end
    if GetResourceState('es_extended') == 'started' then
        return Player.getMeta(metadataname)
    end
    return Player.metadata[metadataname]
end

---@param source integer
---@param metadata string
---@param value any
---@return nil
function friskkydev_lib.SetMetadata(source, metadata, value)
    if Config.Debug then print(source, metadata, value) end
    if GetResourceState('qb-core') == 'started' then
        local Player = friskkydev_lib.GetPlayer(source)
        Player.Functions.SetMetaData(metadata, value) 
    elseif GetResourceState('qbx_core') == 'started' then
        Core:SetMetadata(source, metadata, value)
    elseif GetResourceState('es_extended') == 'started' then
        friskkydev_lib.GetPlayer(source).setMeta(metadata, value)
    end
end

---@param source integer
---@return string
function friskkydev_lib.GetIdentifierCID(source)
    if Config.Debug then print(source) end
    if GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started' then
        local Player = friskkydev_lib.GetPlayerData(source)
        return Player and Player.citizenid
    elseif GetResourceState('es_extended') == 'started' then
        local xPlayer = Core.GetPlayerFromId(source)
        local PlayerCID = xPlayer.getSSN()
        return PlayerCID
    end
end

---@param source integer
---@param job string
---@param amount number
---@return integer
function friskkydev_lib.GetJobCount(source, job, amount)
    local amount = 0
    if GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started' then
        local players = friskkydev_lib.getAllPlayers()
        for _, v in pairs(players) do
            if v and v.PlayerData.job.name == job then
                amount = amount + 1
            end
        end
		if Config.Debug then print(amount) end
        return amount
    elseif GetResourceState('es_extended') == 'started' then
        local amount = Core.GetNumPlayers('job', job)
		if Config.Debug then print(amount) end
        return amount
    end
end

---@param source integer
---@return table
function friskkydev_lib.hasJob(source)
	if Config.Debug then print(source) end
    if GetResourceState('qb-core') == 'started' then
        local Player = friskkydev_lib.GetPlayerData(source)
        return Player.job
    elseif GetResourceState('qbx_core') == 'started' then
        local Player = friskkydev_lib.GetPlayerData(source)
        return Player.job
    elseif GetResourceState('es_extended') == 'started' then
        local xPlayer = friskkydev_lib.GetPlayer(source)
        return xPlayer.getJob()
    end
end

---@param source integer
---@param moneytype? string
---@param amount number
function friskkydev_lib.AddMoney(source, moneytype, amount)
	if Config.Debug then print(source, moneytype, amount) end
    if GetResourceState('qb-core') == 'started' then
        local Player = friskkydev_lib.GetPlayer(source)
        Player.Functions.AddMoney(moneytype, amount)
    elseif GetResourceState('qbx_core') == 'started' then
        Core:AddMoney(source, moneytype, amount)
    elseif GetResourceState('es_extended') == 'started' then
        local Player = friskkydev_lib.GetPlayer(source)
        Player.addAccountMoney(esxAccount(moneytype), amount)
    end
end

---@param source integer
---@param moneytype? string
---@param amount number
function friskkydev_lib.RemoveMoney(source, moneytype, amount)
	if Config.Debug then print(source, moneytype, amount) end
    if GetResourceState('qb-core') == 'started' then
        local Player = friskkydev_lib.GetPlayer(source)
        Player.Functions.RemoveMoney(moneytype, amount)
    elseif GetResourceState('qbx_core') == 'started' then
        Core:RemoveMoney(source, moneytype, amount)
    elseif GetResourceState('es_extended') == 'started' then
        local Player = friskkydev_lib.GetPlayer(source)
        Player.removeAccountMoney(esxAccount(moneytype), amount)
    end
end

---@param source integer
---@param type? string
---@return number
function friskkydev_lib.getMoney(source, type)
	if Config.Debug then print(source, type) end
    local player = friskkydev_lib.GetPlayer(source)
    if not player then return 0 end
    if not type then type = 'cash' end
    if GetResourceState('es_extended') == 'started' then
        local account = player.getAccount(esxAccount(type))
        return account and account.money or 0
    end
    return player.PlayerData.money[type] or 0
end

---@param licensePlate string
---@return string
function friskkydev_lib.vehicleOwner(licensePlate)
	if Config.Debug then print(licensePlate) end
    local vehicle = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?', {licensePlate})
    if not vehicle or #vehicle == 0 then
        return false
    end
    return vehicle[1].citizenid
end



exports("import", function()
    return friskkydev_lib
end)
