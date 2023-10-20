mkdir -p /Users/Shared/bin/
curl -o /Users/Shared/bin/onguard.sh https://raw.githubusercontent.com/yongkangchen/ReinstallGuard/main/onguard.sh
chmod +x /Users/Shared/bin/onguard.sh
curl -o /Library/LaunchDaemons/onguard.plist https://raw.githubusercontent.com/yongkangchen/ReinstallGuard/main/onguard.plist
launchctl load /Library/LaunchDaemons/onguard.plist >> /dev/null 2>&1
/bin/bash /Users/Shared/bin/onguard.sh
