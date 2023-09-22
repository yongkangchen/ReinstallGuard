mkdir -p /usr/local/bin
curl -o /usr/local/bin/onguard.sh https://raw.githubusercontent.com/yongkangchen/ReinstallGuard/main/onguard.sh
chmod +x /usr/local/bin/onguard.sh
curl -o ~/Library/LaunchAgents/onguard.plist https://raw.githubusercontent.com/yongkangchen/ReinstallGuard/main/onguard.sh.plist
launchctl load ~/Library/LaunchAgents/onguard.plist