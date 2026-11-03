# Useable Functions to use and how to use them.

### Dependencies are [ox_lib](https://github.com/overextended/ox_lib) and [oxmysql](https://github.com/CommunityOx/oxmysql) (oxmysql is pre-installed with every framework)

## Make sure you import all the functions using

- `local friskkydev_lib = exports['FD-bridge']:import()` at the top of your client and server scripts

## CoreObj Client

- `friskkydev_lib.Notify(msg, type, duration)`
- `friskkydev_lib.GetPlayerData()`
- `friskkydev_lib.GetPlayerJob()`
- `friskkydev_lib.GetPlayerJobName()`
- `friskkydev_lib.IsJobBoss()`
- `friskkydev_lib.GetPlayerGang()`
- `friskkydev_lib.IsGangLeader()`
- `friskkydev_lib.GetMetadata(meta)` Example: friskkydev_lib.GetMetadata('isdead')
- `friskkydev_lib.GetIdentifier()` Returns CitizenID
- `friskkydev_lib.GetPlayer()` Returns PlayerPedID
- `friskkydev_lib.GetIdentifierCID()`
- `friskkydev_lib.isDead()`
- `friskkydev_lib.getCoords()`

## CoreObj Server

- `friskkydev_lib.Notify(source, msg, type, duration)`
- `friskkydev_lib.GetPlayer(source)`
- `friskkydev_lib.GetPlayerData()`
- `friskkydev_lib.getAllPlayers()`
- `friskkydev_lib.GetPlayerJob(source)`
- `friskkydev_lib.GetPlayerJobName(source)`
- `friskkydev_lib.GetPlayerGang(source)`
- `friskkydev_lib.isBoss(source)`
- `friskkydev_lib.getPlayerCoords(source)`
- `friskkydev_lib.getJobDuty(source)`
- `friskkydev_lib.checkDistance(source, location, distance)`
- `friskkydev_lib.GetMetaData(source, metadataname)`
- `friskkydev_lib.SetMetadata(source, metadata, value)`
- `friskkydev_lib.GetIdentifierCID(source)`
- `friskkydev_lib.GetJobCount(source, job, amount)`
- `friskkydev_lib.hasJob(source)`
- `friskkydev_lib.AddMoney(source, moneytype, amount)`
- `friskkydev_lib.RemoveMoney(source, moneytype, amount)`
- `friskkydev_lib.getMoney(source, type)`
- `friskkydev_lib.vehicleOwner(licensePlate)` Returns CitizenID of vehicle owner

## Inventory Client

- `N/A`

## Inventory Server

- `friskkydev_lib.AddItem(src, item, amount, metadata, slot, cb)`
- `friskkydev_lib.RemoveItem(src, item, amount)`
- `friskkydev_lib.HasItem(src, item, amount)`
- `friskkydev_lib.DoesItemExist(item)` Returns `true` when the item is registered in the active framework/inventory item table; otherwise returns `false`.
- `friskkydev_lib.GetItemImage(item)` Returns the active inventory's real item-image URL when one exists, otherwise `nil`. Supports configurable QB, OX, PS, and common inventory image paths.
- `friskkydev_lib.CreateStash(id, label, slots, maxWeight, group, coords)` id =  string or number
- `friskkydev_lib.forceOpenInventory(src, invType, plyID)` invType = 'player' or 'stash' or 'container'or 'drop' or 'glovebox' or 'trunk' or 'dumpster' MUST BE A STRING

## VehicleKeys Client

- `N/A`

## VehicleKeys Server

- `friskkydev_lib.AddKeys(source, plate)`
- `friskkydev_lib.RemoveKeys(source, plate)`

## Target Client

- `friskkydev_lib.disableTargeting(state)` state = boolean 
- `friskkydev_lib.addBoxZone(name, coords, label, icon, distance, job, onSelect, itemreq, type, size, length, width, minZ, maxZ, heading, debug)` All variables have to be in the function but dont have to be used
- `friskkydev_lib.addLocalEntity(models, name, label, icon, distance, job, onSelect, itemreq, type)` All variables have to be in the function but dont have to be used

## Target Server

- `N/A`
