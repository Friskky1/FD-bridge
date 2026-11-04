local Core
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
            Core = exports['es_extended']:getSharedObject()
            break
        elseif GetResourceState('kora_core') == 'started' then
            Core = exports['kora_core']
            break
        end
        Wait(1000)
    end
elseif Config.CoreObj == "qbcore" then
    Core = exports['qb-core']:GetCoreObject()
elseif Config.CoreObj == "qbx_core" then
    Core = exports.qbx_core
elseif Config.CoreObj == "ESX" then
    Core = exports['es_extended']:getSharedObject()
elseif Config.CoreObj == "Kora" then
    Core = exports['kora_core']
end

---@param msg string
---@param type? string
---@param duration? number
function friskkydev_lib.Notify(msg, type, duration)
    if GetResourceState('ox_lib') == 'started' then 
        lib.notify({ description = msg, type = type, position = 'top-right', duration = duration})
    elseif GetResourceState('es_extended') == 'started' and GetResourceState('ox_lib') ~= 'started' then
        exports['esx_notify']:Notify(type or "info", duration or 5000, msg)
    elseif GetResourceState('qb-core') == 'started' then 
        Core.Functions.Notify(msg, type, duration)
    elseif GetResourceState('kora_core') == 'started' then
        Core.notify.send({message = msg, duration = duration, type = type })
    end
end

function friskkydev_lib.GetPlayerData()
    if GetResourceState('qb-core') == 'started' then
        return Core.Functions.GetPlayerData()
    elseif GetResourceState('qbx_core') == 'started' then
        return Core:GetPlayerData()
    elseif GetResourceState('es_extended') == 'started' then
        return Core.GetPlayerData()
    elseif GetResourceState('kora_core') == 'started' then
        return Core:getPlayerData()
    end
end

---@return string
function friskkydev_lib.GetPlayerJob()
    local Player = friskkydev_lib.GetPlayerData()
    return Player.job
end

---@return string|nil
function friskkydev_lib.GetPlayerJobName()
    local Player = friskkydev_lib.GetPlayerData()
    return Player.job.name
end

---@return boolean
function friskkydev_lib.IsJobBoss()
    local job = friskkydev_lib.GetPlayerJob()
    return job.isboss
end

---@return table
function friskkydev_lib.GetPlayerGang()
    local Player = friskkydev_lib.GetPlayerData()
    return Player.gang
end

---@return boolean
function friskkydev_lib.IsGangLeader()
    local Player = friskkydev_lib.GetPlayerData()
    return Player.gang.isboss
end

---@param meta string
---@return any
function friskkydev_lib.GetMetadata(meta)
    return friskkydev_lib.GetPlayerData().metadata[meta]
end

---@return string|nil
function friskkydev_lib.GetIdentifier()
    return friskkydev_lib.GetPlayerData().citizenid
end

function friskkydev_lib.GetPlayer()
    return PlayerPedId()
end

---@return string
function friskkydev_lib.GetIdentifierCID()
    return friskkydev_lib.GetPlayerData().citizenid
end

---@return boolean
function friskkydev_lib.isDead()
    if friskkydev_lib.GetMetadata('isdead') or friskkydev_lib.GetMetadata('inlaststand') then
        return true
    else
        return false
    end
end

---@return vector3
function friskkydev_lib.getCoords()
    return GetEntityCoords(PlayerPedId())
end

---@param model string|integer model name or hash
---@param timeout? integer ms to wait before giving up (default 10000)
---@return integer|nil modelHash, nil if the model is invalid or timed out
function friskkydev_lib.requestModel(model, timeout)
    local modelHash = type(model) == 'number' and model or joaat(model)
    if not IsModelInCdimage(modelHash) then
        print(('^1[FD-bridge] invalid model: %s^0'):format(model))
        return nil
    end
    RequestModel(modelHash)
    local giveUpAt = GetGameTimer() + (timeout or 10000)
    while not HasModelLoaded(modelHash) do
        if GetGameTimer() > giveUpAt then return nil end
        Wait(10)
    end
    return modelHash
end

---@param dict string animation dictionary
---@param timeout? integer ms to wait before giving up (default 10000)
---@return string|nil dict, nil if the dictionary is invalid or timed out
function friskkydev_lib.requestAnimDict(dict, timeout)
    if not DoesAnimDictExist(dict) then
        print(('^1[FD-bridge] invalid anim dict: %s^0'):format(dict))
        return nil
    end
    RequestAnimDict(dict)
    local giveUpAt = GetGameTimer() + (timeout or 10000)
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() > giveUpAt then return nil end
        Wait(10)
    end
    return dict
end




















exports("import", function()
    return friskkydev_lib
end)
