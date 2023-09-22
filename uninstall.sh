rm -f /usr/local/bin/onguard.sh
launchctl unload ~/Library/LaunchAgents/onguard.plist >> /dev/null 2>&1
rm -f ~/Library/LaunchAgents/onguard.plist
rm -f ClearPassOnGuardInstall.dmg
rm -f ClearPassOnGuardInstall.txt