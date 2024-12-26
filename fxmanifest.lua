fx_version "cerulean"
game "gta5"

lua54 "yes"
use_experimental_fxv2_oal "yes"

author "yiruzu"
description "Cloud Resources - Deathscreen"
version "2.5.0"

discord "https://discord.gg/jAnEnyGBef"
documentation "https://cloud-resources.gitbook.io/docs/free-resources/cloud-deathscreen"

repository "https://github.com/yiruzu/cloud-deathscreen"
license "CC BY-NC"

file { "shared/sh_config.lua", "shared/sh_locales.lua" }
shared_scripts { "@ox_lib/init.lua", "shared/sh_functions.lua" }
server_scripts { "bridge/server/*.lua", "server/*.lua" }
client_scripts { "bridge/client/*.lua", "client/*.lua" }

ui_page { "web/build/index.html" }
files { "web/build/**/*" }
