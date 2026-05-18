fx_version 'cerulean'
game 'gta5'

author 'KERRYGAMER'
description 'Realistic Pills System for QBX/QBCore'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'shared/config.lua',
}

client_scripts {
    'client/client.lua',
    'client/effects.lua',
}

server_scripts {
    'server/server.lua',
    'server/logs.lua',
}

lua54 'yes'
