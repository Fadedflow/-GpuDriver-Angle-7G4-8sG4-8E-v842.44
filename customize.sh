# info
androidsdk=$(getprop ro.system.build.version.sdk)
gpu=$(cat /sys/class/kgsl/kgsl-3d0/gpu_model)
abi=$(getprop ro.vendor.product.cpu.abilist)

#
echo ""
echo "    ___       __                    ";
echo "   /   | ____/ /_______  ____  ____ ";
echo "  / /| |/ __  / ___/ _ \/ __ \/ __ |";
echo " / ___ / /_/ / /  /  __/ / / / /_/ /";
echo "/_/ _|_\__,_/_/_  \___/_/ /_/\____/";
echo "   / __ \_____(_)   _____  _____ ";
echo "  / / / / ___/ / | / / _ \/ ___/    ";
echo " / /_/ / /  / /| |/ /  __/ /        ";
echo "/_____/_/  /_/ |___/\___/_/    ";
echo ""
sleep 1
ui_print ""
sleep 1
ui_print " ~ Installing Adreno™ GPU Drivers! ~ "
sleep 1
ui_print ""

ui_print " ~ MAKE SURE YOU HAVE UNINSTALLED OLD DRIVER AND REBOOTED BEFORE PROCEEDING ~ "
sleep 1
ui_print " ~ YOU HAVE 10 SECS TO CANCEL ~ "
sleep 12

# Check gpu adreno model
ui_print "Checking the Adreno GPU model..."
if [[ "$gpu" == "Adreno8"* ]] || [[ "$gpu" == "Adreno722"* ]]; then
  ui_print "Your GPU Adreno supported by this package!"
  sleep 1
  ui_print "Continuing..."
else
  ui_print "Your GPU Adreno is not supported by this package!"
  sleep 1
  ui_print "Try another package!"
  abort
fi 
sleep 1

# Check android version
ui_print ""
ui_print "Checking the Android version..."
sleep 1
if [[ $androidsdk -lt 36 ]]; then
    ui_print "Your Android version is not supporting!"
    sleep 1
    ui_print "please update ROM!"
    abort
else
   ui_print "Your Android version is supporting!"
   sleep 1
   ui_print "Continuing..."
fi

sleep 1
# Check abi support on your rom
ui_print ""
ui_print "Checking the supported ABI of your ROM..."
sleep 1
if [[ "$abi" == "arm64-v8a" ]]; then
  rm -rf "$MODPATH/system/vendor/lib"
  ui_print "Your Vendor is arm64-v8a only, continuing..."
else
  ui_print "Your Vendor is not arm64-v8a only, continuing..."
fi

sleep 1
ui_print ""
ui_print "Copying QGL to enable some Vulkan extensions..."
mkdir /data/vendor/gpu/
chmod 755 /data/vendor/gpu/
cp -r "$MODPATH/qgl_config.txt" "/data/vendor/gpu/qgl_config.txt"
rm -rf "$MODPATH/qgl_config.txt"

sleep 1
ui_print ""
ui_print "Applying permission patch..."
# Add patch permissions for paths and files
if command -v set_perm_recursive >/dev/null 2>&1; then
  set_perm_recursive "$MODPATH" 0 0 0755 0644 || true
  set_perm_recursive "/data/vendor/gpu/qgl_config.txt" 0 0 0755 0644 u:object_r:same_process_hal_file:s0 || true
  set_perm_recursive "$MODPATH/system/vendor/lib*/*.so" 0 0 0755 0644 u:object_r:same_process_hal_file:s0 || true
  set_perm_recursive "$MODPATH/system/vendor/lib*/*/*.so" 0 0 0755 0644 u:object_r:same_process_hal_file:s0 || true
  set_perm_recursive "$MODPATH/system/lib*/*.so" 0 0 0644 u:object_r:system_lib_file:s0 || true
  set_perm_recursive "$MODPATH/system/vendor/etc/permissions/*.xml" 0 0 0755 0644 u:object_r:system_file:s0 || true
  set_perm_recursive "$MODPATH/system/product/etc/permissions/*.xml" 0 0 0755 0644 u:object_r:system_file:s0 || true
  set_perm_recursive "$MODPATH/system/product/priv-app/ANGLE_settings/*.apk" 0 0 0755 0644 u:object_r:system_file:s0 || true
else
  chmod -R 0755 "$MODPATH" 2>/dev/null || true
fi

sleep 1
ui_print ""
ui_print "Add GraphicsDriverPreference support"
agd_folder=$(find /vendor/app/ -type d -name "com.qualcomm.qti.gpudrivers.*" 2>/dev/null | head -n 1)
if [ -z "$agd_folder" ]; then
  echo "unsupported device"
else
  packagename=$(basename "$agd_folder")
  echo "ro.gfx.driver.0=${packagename}" >> "${MODPATH}/system.prop"
  echo "Game Driver option is enabled in Developer Mode"
fi

sleep 1
ui_print ""
ui_print "Drivers successfully installed!"
sleep 1

# Cache Cleaner - credit to Peter Noël Muller
ui_print ""
ui_print "Running graphics cache and dalvik cleaners..."
find /data/user_de/*/*/*cache/* -iname "*shader*" -exec rm -rf {} +
find /data/data/* -iname "*shader*" -exec rm -rf {} +
find /data/data/* -iname "*graphitecache*" -exec rm -rf {} +
find /data/data/* -iname "*gpucache*" -exec rm -rf {} +
find /data_mirror/data*/*/*/*/* -iname "*shader*" -exec rm -rf {} +
find /data_mirror/data*/*/*/*/* -iname "*graphitecache*" -exec rm -rf {} +
find /data_mirror/data*/*/*/*/* -iname "*gpucache*" -exec rm -rf {} +
find /data/data/* -type d \( -iname "*camera*" -o -iname "*snapcam*" \) -exec sh -c 'rm -rf "$1"/*' _ {} \;
rm -rf /data/system/graphicsstats/*/*/*
rm -rf /data/dalvik-cache/*/*
rm -rf /data/cache/*
rm -rf /data/system/package_cache/*
rm -rf /data/resource-cache/*
sleep 1

ui_print "Done!"
rm -r "/data/adb/modules/gpu_driver_free"
rm -r "/data/adb/modules/gpu_driver"
rm -r "/data/adb/modules/adreno_driver"
rm -r "/data/adb/modules/adreno_vk_gpu_driver"
rm -r "/data/adb/modules/adreno_gl_gpu_driver"



sleep 3

ui_print ""
ui_print "Now, please reboot device!"
ui_print ""
