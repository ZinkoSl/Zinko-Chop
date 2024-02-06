fx_version 'adamant'
lua54 'yes'
game 'gta5'
description 'ESX Boilerplate'

server_scripts {
	'server/main.lua',
	'@mysql-async/lib/MySQL.lua',
}

client_scripts {
	'client/main.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua'
}


ui_page "html/index.html"
files {
	'html/index.html',
	'html/style.css',
	'html/app.js',
	'html/logo.png',
	'html/Roboto-Regular.ttf',
	'html/image/*.png'
}