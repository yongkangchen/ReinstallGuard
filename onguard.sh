#!/bin/bash

# exec 1>/dev/null 2>/dev/null

check_url="https://login.scu.edu"
app_name="ClearPassOnGuardInstall"
dmg_url="https://clearpass.scu.edu/agent/installer/mac/$app_name.dmg"

if [ -z "$1" ]; then
    sleep 2
fi

cd /Users/Shared/bin/
uninstallpath="/Applications/Aruba Networks/Uninstaller.app/Contents/Resources/clearpassonguarduninstaller.sh"
uninstall() {
    pkill "ClearPass\ OnGuard"
    if [ -f "$uninstallpath" ]; then
        uninstallpath_escaped=$(echo "$uninstallpath" | sed 's/ /\\\\ /g')
        osascript -e 'do shell script "/bin/sh '"$uninstallpath_escaped"' " with administrator privileges with prompt "Tring to uninstall ClearPassOnGuard:"'
    fi
}

show_dialog() {
    local dialogText="$1"
    local retryButton="$2"
    local user_choice
    user_choice=$(osascript <<EOD
        set buttonRetry to "$retryButton"
        set buttonQuit to "Quit"
        set dialogResult to button returned of (display dialog "$dialogText" buttons {buttonRetry, buttonQuit} default button buttonRetry)
        return dialogResult
EOD
    )
    
    if [ "$user_choice" == "Quit" ]; then
        exit 0
    fi
}

check_eduroam() {
    SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | awk -F ' SSID: ' '/ SSID:/ {print $2}'`
    if [ "$SSID" = "eduroam" ]; then
        curl -sL --head --connect-timeout 3 "$check_url" > /dev/null
        if [[ $? -eq 0 ]]; then
            uninstall
            return 0
        fi
        return 1
    fi
    uninstall
    return 0
}

if check_eduroam; then
    exit 0
fi

while true; do
    if [[ -d "/Applications/BitdefenderVirusScanner.app" ]]; then
        echo "BitDefender already installed."
        break
    elif [[ -d "/Applications/BitdefenderVirusScanner.appdownload" ]]; then
        echo "BitDefender is downloading..."  
        #TODO: check if download paused
    elif ! pgrep -q "App Store"; then
        show_dialog "Press OK to install BitDefender in App Store." "OK"
        open macappstore://apps.apple.com/app/bitdefender-virus-scanner/id500154009
    fi
done

filename="$app_name.dmg"
mountpoint="/Volumes/$app_name"
etag_file="$app_name.txt"

while true; do
    curl -L -z $filename --remote-time --tcp-fastopen --compressed --etag-compare $etag_file --etag-save $etag_file -f -o $filename $dmg_url

    if [ $? -eq 0 ]; then
        hdiutil attach "$filename" -mountpoint "$mountpoint"
        if [ $? -ne 0 ]; then
            rm -f "$filename"
            rm -f "$etag_file"
            continue
        fi

        shell_command=$(cat <<EOD
            /usr/sbin/installer -pkg "$mountpoint/ClearPassOnGuard.pkg" -target /
            if [ \$? -ne 0 ]; then
                rm -f "$filename"
                rm -f "$etag_file"
                exit 1
            fi
            
            uninstall() {
                if [ -f "$uninstallpath" ]; then
                    /bin/sh "$uninstallpath"
                else
                    echo $uninstallpath not found.
                fi
            }

            check_eduroam() {
                SSID=\$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | awk -F ' SSID: ' '/ SSID:/ {print \$2}')
                if [ "\$SSID" = "eduroam" ]; then
                    curl -sL --head --connect-timeout 3 "$check_url" > /dev/null
                    if [[ \$? -eq 0 ]]; then
                        return 0
                    fi
                    return 1
                fi
                return 0
            }
            max_loop_count=60
            loop_count=0
            err=""
            while true; do
                if check_eduroam; then
                    uninstall
                    exit 0
                fi
                sleep 2
                
                loop_count=\$((loop_count + 1))
                if [ \$loop_count -ge \$max_loop_count ]; then
                    exit 1
                fi
            done
EOD
)

        shell_command_escaped=$(echo "$shell_command" | sed 's/\"/\\"/g')
        osascript <<EOD
            do shell script "$shell_command_escaped" with administrator privileges with prompt "Trying to reinstall ClearPassOnGuard"
EOD
        installer_exit_code=$?
        echo "installer exit code: $installer_exit_code"
        if [[ $installer_exit_code -ne 0 ]]; then
            hdiutil detach "$mountpoint"
            uninstall
            if check_eduroam; then
                exit 0
            fi
            show_dialog "Failed to reinstall." "Retry"
            DIR="$(cd "$(dirname "$0")" && pwd)"
            exec "$DIR/$(basename "$0")" "1"

            exit 0
        fi

        hdiutil detach "$mountpoint"
        break
    else
        if check_eduroam; then
            exit 0
        fi
        show_dialog "Download OnGuard failed. Please check your WIFI connection named eduroam." "Retry"
    fi
done

# osascript -l JavaScript <<EOD
# EOD
exit 0
