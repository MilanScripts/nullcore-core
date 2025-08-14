fx_version 'cerulean'
game 'gta5'

author 'Nullcore / Milanscripts'
version '1.0.0'

server_scripts {
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}

shared_scripts {
    "config.lua",
    "shared.lua"
}

files {
    'init.lua'
}

lua54 'yes'
