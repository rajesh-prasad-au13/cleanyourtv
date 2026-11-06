# CleanYourTV Guide: Xiaomi MiTV-AXSO0 (dangal)

This document explains what was configured on your Xiaomi MiTV-AXSO0 (Mi TV 4C Pro / 4A Pro, Android TV 9), how to customize the launcher, how to re-enable any disabled package, and how to safely close ADB debugging.

---

## What was done

### 1. Backups Saved
Untouched state before making changes is preserved in `backup/`:
- `backup/packages.txt` & `backup/packages-full.txt`: Full installed package lists.
- `backup/packages-disabled.txt`: Disabled packages baseline (empty out of the box).
- `backup/getprop.txt`: Device build, hardware, and system properties.
- `backup/settings-global.txt`, `settings-secure.txt`, `settings-system.txt`: All Android settings.

### 2. Debloated Packages
The following 25 system packages were safely disabled (`pm disable-user --user 0`):
- **Xiaomi & Google Telemetry**: `com.miui.tv.analytics`, `com.xiaomi.statistic`, `com.google.android.feedback`, `com.google.android.tv.bugreportsender`
- **PatchWall & Ads / Sponsored Content**: `com.mitv.tvhome.atv`, `com.xm.webcontent`, `com.xiaomi.floatingframe`, `com.google.android.tvrecommendations`, `com.google.android.leanbacklauncher.recommendations`, `android.autoinstalls.config.xioami.dangal`, `com.mitv.tvhome.mitvplus`, `co.sensara.tv.mitv`
- **Unused Background Services & Cleaners**: `com.xiaomi.mitv.tvmanager`, `com.xiaomi.mitv.handbook`, `com.xiaomo.tv.milegal`
- **Preloaded Bloat Apps**: `com.xiaomi.mimusic2`, `com.google.android.play.games`, `com.google.android.videos`, `com.mitv.gallery`
- **Miracast / Mi Cast**: `com.mitv.milinkservice`, `com.xiaomi.mitv.smartshare`, `com.xiaomi.wfdsinkhelperservice`
- **Unused Stock Streaming Apps**: `com.netflix.ninja`, `com.google.android.youtube.tv`, `com.google.android.youtube.tvmusic`
- **Stock Launcher**: `com.google.android.tvlauncher`

### 3. Kept by User Preference
- **Chromecast built-in**: `com.google.android.apps.mediashell`
- **Google Assistant & Voice Search**: `com.google.android.katniss`, `com.google.android.speech.pumpkin`
- **System Firmware Updates**: `com.xiaomi.mitv.updateservice`
- **Installed Apps**: SmartTube (`org.smarttube.stable`), Prime Video (`com.amazon.amazonvideo.livingroom`), Disney+ Hotstar (`in.startv.hotstar`), Sony LIV (`com.sonyliv`), Zee5 (`com.graymatrix.did`)
- **Core TV & Hardware Services**: All `com.droidlogic.*` TV input services, Live TV app (`com.android.tv`), Gboard keyboard (`com.android.inputmethod.latin`), Bluetooth, Wi-Fi, Google Play Store, and Play Services.

### 4. Apple TV 4K Style Launcher Installed
- Reference native launcher (`com.gathin.tvhome`) built and installed as default Home.
- **Dock row**: 4 slots pinned with SmartTube, Prime Video, Disney+ Hotstar, and Sony LIV.
- **Appearance**: Frosted glass dock band (`dock_glass: true`), dynamic ambient glow sampled from app banners (`ambient_glow: true`, `app_glow: true`), concentric even padding (`dock_even_padding: true`), and top-bar frosted pills for Inputs, Wi-Fi network name, and Settings.
- **Inputs**: Integrated TV input dropdown for HDMI 1, HDMI 2, HDMI 3, AV 1, and Live TV.

### 5. AdGuard Private DNS
- Configured Private DNS specifier: `dns.adguard-dns.com` in `hostname` mode.
- Blocks known tracking and ad serving domains across the TV.

---

## How to Customize

### Change Dock Apps & Number of Slots
Edit `launcher/app/src/main/res/values/config.xml`:
1. Find `<string-array name="dock_apps">`:
   ```xml
   <string-array name="dock_apps">
       <item>org.smarttube.stable</item>
       <item>com.amazon.amazonvideo.livingroom</item>
       <item>in.startv.hotstar</item>
       <item>com.sonyliv</item>
   </string-array>
   ```
2. Rearrange the `<item>` tags or add new package names (find package names with `TV_HOST=<tv ip> tools/tv.py 'pm list packages'`).
3. To change the number of columns (4, 5, 6, or 7), update `<integer name="columns">4</integer>`.
4. Rebuild and reinstall by running:
   ```bash
   TV_HOST=192.168.0.158 ./build-and-install-mitv.sh
   ```

### Apply a Wallpaper or Pre-made Theme
You can apply any theme from `themes/` (e.g. `dock-glass`, `glass`, `aurora`, `scenes`) without rebuilding:
```bash
TV_HOST=192.168.0.158 tools/theme.sh themes/dock-glass
```
To set a custom wallpaper photo, place a 1920x1080 or 1280x720 JPG image named `wallpaper.jpg` and push it:
```bash
TV_HOST=192.168.0.158 tools/theme.sh --wallpaper path/to/my-wallpaper.jpg
```

---

## How to Re-enable Any App

### Re-enable a Single Package
If you ever want to restore an individual app (for example, Netflix or stock YouTube):
```bash
TV_HOST=192.168.0.158 tools/tv.py 'pm enable --user 0 com.netflix.ninja'
```

### Full Restore (Revert Everything)
To undo the entire debloat, restore the stock Google TV Launcher as Home, and reset DNS:
```bash
./restore-mitv.sh
```

---

## Closing ADB on the TV (Security)

Leaving port 5555 open allows anyone on your local network to access a shell on the TV. Now that setup is complete:
1. On the TV, go to: **Settings → Device Preferences → Developer options**.
2. Turn **OFF** **Network debugging** / **Wireless debugging** (if present).
3. Turn **OFF** **USB debugging** (unless you deliberately keep it enabled).
4. Select **Revoke USB debugging authorizations**.
5. Reboot the TV.
6. Test that port 5555 is closed from your computer:
   ```bash
   tools/venv/bin/python3 tools/adb-closed.py 192.168.0.158
   ```
