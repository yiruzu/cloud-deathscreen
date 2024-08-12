fx_version "cerulean"
game "gta5"

lua54 "yes"
use_experimental_fxv2_oal "yes"

author "yiruzu"
description "Cloud Service - Deathscreen"
version "1.1.0"

discord "https://discord.gg/jAnEnyGBef"
repository "https://github.com/yiruzu/cloud-deathscreen"
license "CC BY-NC"

shared_scripts { "@ox_lib/init.lua", "config.lua" }
server_scripts { "bridge/server/**.lua", "server.lua" }
client_scripts { "bridge/client/**.lua", "client.lua" }

ui_page { "web/index.html" }
files { "web/**/*" }
