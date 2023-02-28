
```AppleScript
on run {input, parameters}
	display dialog "OnGuard often malfunctions, making it impossible to access the school network. 
	
To resolve this issue, it is necessary to reinstall OnGuard. 

In fact, once OnGuard turns green, the authentication is successful and it does not need to be run for a long time. 

Therefore, this script automatically installs and uninstalls OnGuard for a one-time OnGuard authentication. (Note: after installing OnGuard, wait for it to turn green before confirming the uninstallation.)

Simply run this script whenever you cannot access the network." buttons {"Reinstall OnGuard"} default button "Reinstall OnGuard" with title "Confirmation" with icon caution
	return input
end run
```


```Shell
#!/bin/bash

echo "Step 1: Downloading OnGuard..."

# set download url
url="https://clearpass.scu.edu/agent/installer/mac/ClearPassOnGuardInstall.dmg"

filename="ClearPassOnGuardInstall.dmg"
mountpoint="/Volumes/ClearPassOnGuardInstall"
pkgpath="/Volumes/ClearPassOnGuardInstall/ClearPassOnGuard.pkg"

# download
curl -L -o "$filename" "$url"

echo "Downloading complete."

echo "Step 2: install OnGuard..."
# attach install file
hdiutil attach "$filename" -mountpoint "$mountpoint"

# install
osascript -e 'do shell script "/usr/sbin/installer -pkg '"$pkgpath"' -target /" with administrator privileges with prompt "Please input your password to install ClearPassOnGuard:"'

echo "Installing complete."

echo "Step 3: Delete Install file of OnGuard..."
# detach install file
hdiutil detach "$mountpoint"

# delte install file
rm "$filename"

echo "Clearing complete."

open /Applications/Aruba\ Networks/ClearPass\ OnGuard.app
```

```AppleScript
on run {input, parameters}
	display dialog "Please wait for the OnGuard icon in the menu bar to *turn green* before uninstalling OnGuard!" buttons {"Uninstall OnGuard"} default button "Uninstall OnGuard" with title "Confirmation" with icon caution
	return input
end run
```

```shell
open /Applications/Aruba\ Networks/Uninstaller.app
```
