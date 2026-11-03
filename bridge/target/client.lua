local Target
local targetZones = {}
friskkydev_lib = friskkydev_lib or {}

if Config.Target == "auto" then
    while true do
        if GetResourceState('ox_target') == 'started' then 
            Target = exports.ox_target
            break
        elseif GetResourceState('qb-target') == 'started' then
            Target = exports['qb-target']
            break
        end
        Wait(1000)
    end
elseif Config.Target == "ox_target" then
    Target = exports.ox_target
elseif Config.Target == "qb-target" then
    Target = exports['qb-target']
end
if Config.Debug then print("CLIENT PRINT TARGET "..tostring(Target).."^2 If its a table (string of random shit) then its correct ^0") end

function friskkydev_lib.disableTargeting(state)
    if Config.Debug then print("IF TRUE THEN YOU CANT TARGET " ..json.encode(state)) end
    if GetResourceState('ox_target') == 'started' then 
        if state then
            Target:disableTargeting(true)
            state = true
        else
            Target:disableTargeting(false)
            state = false
        end
    else
        if state then
            Target:AllowTargeting(false)
            state = false
        else
            Target:AllowTargeting(true)
            state = true
        end
    end
    return state
end

---@param name string
---@param coords vector3
---@param label string
---@param icon? string
---@param distance? number
---@param job? string
---@param onSelect? function
---@param event? string
---@param itemreq? string
---@param targetType? string
---@param size? vector3
---@param length? float
---@param width? float
---@param minZ? float
---@param maxZ? float
---@param heading? float
---@param debug? boolean
function friskkydev_lib.addBoxZone(name, coords, label, icon, distance, job, onSelect, itemreq, targetType, size, length, width, minZ, maxZ, heading, debug)
    if Config.Debug then print(name, coords, label, icon, distance, job, onSelect, itemreq, targetType, size, length, width, minZ, maxZ, heading, debug) end
    local action = type(onSelect) == 'function' and onSelect or nil
    local event = type(onSelect) == 'string' and onSelect or nil
    if GetResourceState('ox_target') == 'started' then 
        Target:addBoxZone({
            coords = coords,
            name = name,
            size = size,
            rotation = heading or 0,
            debug = debug or false,
            options = {
                {
                    label = label or name,
                    icon = icon or "fa-solid fa-file-circle-exclamation",
                    distance = distance or 1,
                    items = itemreq or nil,
                    onSelect = action,
                    event = event,
                    groups = job or nil,
                },
            }
        })
    else
        Target:AddBoxZone(name, coords, length, width, {
            name = name,
            heading = heading or 0,
            debugPoly = debug or false,
            minZ = minZ,
            maxZ = maxZ
            }, {
            options = {
                {
                    type = targetType,
                    icon = icon or "fa-solid fa-file-circle-exclamation",
                    label = label or name,
                    item = itemreq or false,
                    action = action,
                    event = event,
                    job = job or false,
                }
            },
            distance = distance or 1
        })
    end
    table.insert(targetZones, { name = name, id = name, kind = 'zone', creator = GetInvokingResource() })
end

---@param models integer
---@param name string
---@param label? string
---@param icon? string
---@param distance? number
---@param job? string
---@param onSelect? function
---@param itemreq? string
---@param targetType? string
function friskkydev_lib.addLocalEntity(models, name, label, icon, distance, job, onSelect, itemreq, targetType)
    if Config.Debug then print(models, name, label, icon, distance, job, onSelect, itemreq, targetType) end
    local action = type(onSelect) == 'function' and onSelect or nil
    local event = type(onSelect) == 'string' and onSelect or nil
    if GetResourceState('ox_target') == 'started' then 
        Target:addLocalEntity(models, {
            {
                label = label or name,
                icon = icon or "fa-solid fa-file-circle-exclamation",
                distance = distance or 1,
                items = itemreq or nil,
                onSelect = action,
                event = event,
                groups = job or nil,
            },
        })
    else
        Target:AddTargetEntity(models, {
            options = {
                {
                    type = targetType,
                    icon = icon or "fa-solid fa-file-circle-exclamation",
                    label = label or name,
                    item = itemreq or false,
                    action = action,
                    event = event,
                    job = job or false,
                }
            },
            distance = distance or 1
        })
    end
    table.insert(targetZones, { name = models, id = models, kind = 'entity', creator = GetInvokingResource() })
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then
        local removed = 0
        -- iterate backwards so table.remove doesn't skip the next entry
        for index = #targetZones, 1, -1 do
            local target = targetZones[index]
            if target.creator == resource then
                if GetResourceState('ox_target') == 'started' then 
                    if target.kind == 'entity' then
                        Target:removeLocalEntity(target.id)
                    else
                        Target:removeZone(target.id)
                    end
                else
                    if target.kind == 'entity' then
                        Target:RemoveTargetEntity(target.id)
                    else
                        Target:RemoveZone(target.id)
                    end
                end
                table.remove(targetZones, index)
                removed = removed + 1
            end
        end
        if removed > 0 and Config.Debug then print('[DEBUG] - removed targets for:', resource) end
    end
end)








exports("import", function()
    return friskkydev_lib
end)
