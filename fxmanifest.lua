fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name "f-bridge"
author "Friskky"
version "1.0.2"
description  "A library of functions and a bridge for Friskky Developments scripts"

shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script {
    'client/main.lua',
    'bridge/target/client.lua',
    'bridge/coreobj/client.lua',
    'bridge/inventory/client.lua',
    'bridge/keys/client.lua',
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/versionchecker.lua',
    'bridge/inventory/server.lua',
    'bridge/coreobj/server.lua',
    'bridge/keys/server.lua',
    'bridge/target/server.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}