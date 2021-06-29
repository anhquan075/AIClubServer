# Written by adoggman@github

echo off
#setlocal enableDelayedExpansion

# Check [ we ] && already have a filter up
#findstr /m "server-config-filter" %~dp0/.git/config

# THIS IS SO STUPID but it works - make sure there's a tab after the =
TAB=	

if [ $errorLevel==0 ] 
	# We found an existing filter
	echo on
	echo "Already ran this script."
	echo "Go into the .git/config text file and make changes there."
then
	# Get input for server.cfg
	/p steamAPIKey="Enter your steam web API key: "
	/p steamID="Enter your (hex) steam ID: "
	/p licenseKey="Enter your FiveM server license key (from keymaster.fivem.net): "
	
	# Add the filter for server.cfg
	echo. >> %~dp0/.git/config
	echo [filter "server-config-filter"] >> %~dp0/.git/config
	echo $TABsmudge = "wsl sed -e 's/your_steam_web_api_key/!steamAPIKey!/' -e 's/your_steam_id/!steamID!/' -e 's/your_license_key/!licenseKey!/'" >> %~dp0/.git/config
	echo $TABclean = "wsl sed -e 's/!steamAPIKey!/your_steam_web_api_key/' -e 's/!steamID!/your_steam_id/' -e 's/!licenseKey!/your_license_key/'" >> %~dp0/.git/config
		
	# Get input for database config
	echo.
	/p dbUser="Enter your database user: "
	/p dbPassword="Database user password: "
	
	# Add the filter for the database config
	echo [filter "sql-config-filter"] >> %~dp0/.git/config
	echo $TABsmudge = "wsl sed -e 's/your_db_password/!dbPassword!/' -e 's/your_db_user/!dbUser!/'" >> %~dp0/.git/config
	echo $TABclean = "wsl sed -e 's/!dbPassword!/your_db_password/' -e 's/!dbUser!/your_db_user/'" >> %~dp0/.git/config
	
	# Now add the values to the actual files
	wsl cp server.cfg server.cfg.clean
	wsl sed -e 's/your_steam_web_api_key/!steamAPIKey!/' -e 's/your_steam_id/!steamID!/' -e 's/your_license_key/!licenseKey!/' server.cfg > server.cfg.smudge
	wsl mv server.cfg.smudge server.cfg

	wsl cp resources/ghmattimysql/config.json resources/ghmattimysql/config.json.clean
	wsl sed -e 's/your_db_password/!dbPassword!/' -e 's/your_db_user/!dbUser!/' resources/ghmattimysql/config.json > resources/ghmattimysql/config.json.smudge
	wsl mv resources/ghmattimysql/config.json.smudge resources/ghmattimysql/config.json
	
	echo on
	echo.
	echo Done!
fi