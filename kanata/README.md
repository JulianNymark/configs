# Kanata

useful utility to remap keys (config uses LISP)

## MacOS

To run Karabiner-VirtualHIDDevice-Daemon on login, you’ll need to configure launchd, macOS’s system service manager.

1. Create a launchd plist file: In the /Library/LaunchDaemons directory, create a new file named org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist (you may need to use sudo to create the file). Add the following contents:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.pqrs.Karabiner-VirtualHIDDevice-Daemon</string>
    <key>ProgramArguments</key>
    <array>
      <string>sh</string>
      <string>-c</string>
      <string>/Library/Application\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>ProcessType</key>
    <string>Interactive</string>
  </dict>
</plist>
```

This plist file specifies the daemon’s label, program arguments (the executable path), and settings for running at login and as an interactive process.
You can also copy the file from this repo, or symlink into it (not added to the symlink.sh script, since it's not "universal enough")

2. Load the launchd daemon: Run the following command in Terminal:

```
sudo launchctl load /Library/LaunchDaemons/org.pqrs.Karabiner-VirtualHIDDevice-Daemon.plist
```

This loads the daemon into launchd.

3. Enable the daemon to run at login: Go to System Preferences > Users & Groups > [Your User] > Login Items. Click the “+” button and select /Applications/Karabiner-VirtualHIDDevice-Daemon.app to add it to your login items.

After completing these steps, Karabiner-VirtualHIDDevice-Daemon should run automatically when you log in to your Mac.

4. add & enable (same as above) the following plist to run kanata on login as well (as root as a daemon)

filename `com.example.kanata.plist`

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.example.kanata</string>

    <key>ProgramArguments</key>
    <array>
        <string>/Users/username/.cargo/bin/kanata</string>
        <string>-c</string>
        <string>/Users/username/Repos/configs/kanata/kanata.kbd</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/Library/Logs/Kanata/kanata.out.log</string>

    <key>StandardErrorPath</key>
    <string>/Library/Logs/Kanata/kanata.err.log</string>

    <key>UserName</key>
    <string>root</string>
</dict>
</plist>
```

5. ensure that the kanata executable is allowed `Input Monitoring`. To do this go to Settings > Privacy & Security > Input Monitoring, and click the `+` icon, navigate to the place your kanata executable is (should match the same path in the `*.plist` above, `~/.cargo/bin/kanata`), and add it.
