mkdir -p ~/bin
curl -o ~/bin/onguard.sh https://raw.githubusercontent.com/yongkangchen/ReinstallGuard/main/onguard.sh
chmod +x ~/bin/onguard.sh
curl -o ~/Library/LaunchAgents/onguard.plist https://raw.githubusercontent.com/yongkangchen/ReinstallGuard/main/onguard.plist
launchctl load ~/Library/LaunchAgents/onguard.plist