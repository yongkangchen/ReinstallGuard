rm -f /Users/Shared/bin/onguard.sh
launchctl unload ~/Library/LaunchAgents/onguard.plist >> /dev/null 2>&1
rm -f ~/Library/LaunchAgents/onguard.plist
rm -f /Library/LaunchDaemons/onguard.plist
rm -f /Users/Shared/bin/ClearPassOnGuardInstall.dmg
rm -f /Users/Shared/bin/ClearPassOnGuardInstall.txt
