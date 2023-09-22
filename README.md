# ReinstallGuard for macos
OnGuard often malfunctions, making it impossible to access the school network, only for Santa Clara University now. 

To resolve this issue, it is necessary to reinstall OnGuard. 

In fact, once OnGuard turns green, the authentication is successful and it does not need to be run for a long time. 

Therefore, this project automatically installs and uninstalls OnGuard for a one-time OnGuard authentication. 

Simply paste the following command in a macOS Terminal to setup:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/yongkangchen/ReinstallGuard/main/install.sh)"
```

After that, you don't need to do anything. Because this tool will automatically check and fix the WIFI network for you.