#!/system/bin/sh - credit to NLSound project for this action script base

vulkandriver=$(strings /vendor/lib64/hw/vulkan.adreno.so | grep -E '0[0-9]{3}\.[0-9]+')
opengldriver=$(strings /vendor/lib64/egl/libGLESv2_adreno.so | grep -i 'V@0';)
gpu=$(cat /sys/class/kgsl/kgsl-3d0/gpu_model)
handle_input() {
  while true; do
    case $(getevent -lqc "/dev/input/event2" 2>/dev/null | grep -m1 'DOWN') in
      *KEY_VOLUMEUP*) echo "up"; return ;;
      *KEY_VOLUMEDOWN*) echo "down"; return ;;
    esac
  done
}

show_menu() {
  local selected=1
  local total=$#
  while true; do
    eval "local current=\"\$$selected\""
    echo "➔ $current"
    echo " "
    case $(handle_input) in
      "up") selected=$((selected % total + 1)) ;;
      "down") return $selected ;;
    esac
  done
}

  echo " "
  echo "   1. Currently OpenGL build installed"
  echo "   2. Currently OpenCL build installed"
  echo "   3. Currently Vulkan build installed"
  echo "   4. Check full model and version of Adreno"
  echo "   5. Check a working API as UI now"
  echo "   6. Clear all graphics caches"
  echo "   7. Clear dalvik caches"
  echo "   8. Visit our Telegram channel"
  echo "   9. Exit"
  echo " "
  text='"Currently OpenGL build installed" "Currently OpenCL build installed" "Currently Vulkan build installed" "Check full model and version of Adreno" "Check a working API as UI now" "Clear all graphics caches" "Clear dalvik caches" "Visit our Telegram channel" "Exit"'

BASE_DIR="/data/adb/modules/adreno_gpu_driver"
eval show_menu "$text"
case $? in
  1) echo "Installed OpenGL driver version: "; echo 'Driver Version:' $opengldriver ; strings /vendor/lib64/egl/libGLESv2_adreno.so | grep -i 'Compiler Version'; strings /vendor/lib64/egl/libGLESv2_adreno.so | grep -i 'Branch'; sleep 1 ;;
  2) echo "Installed OpenCL driver version: "; strings /vendor/lib64//libCB.so | grep -i 'QUALCOMM build'; sleep 1 ;;
  3) echo "Installed Vulkan driver version: "; echo "Driver Version:" $vulkandriver ; strings /vendor/lib64//hw/vulkan.adreno.so | grep -i 'Driver Build'; strings /vendor/lib64//hw/vulkan.adreno.so | grep -i 'Build Date'; strings /vendor/lib64//hw/vulkan.adreno.so | grep -i 'Compiler Version'; strings /vendor/lib64//hw/vulkan.adreno.so | grep -i 'Branch'; sleep 1 ;;
  4) echo "Your GPU Adreno model and version: "; echo $gpu; sleep 1 ;;
  5) echo "Currently used API as UI: "; dumpsys gfxinfo com.android.systemui | grep Pipeline | awk -F '=' '{print $2}'; sleep 1 ;;
  6) echo "Clearing graphics caches..."; find /data/user_de/*/*/*cache/* -iname "*shader*" -exec rm -rf {} +; find /data/data/* -iname "*shader*" -exec rm -rf {} +; find /data/data/* -iname "*graphitecache*" -exec rm -rf {} +; find /data/data/* -iname "*gpucache*" -exec rm -rf {} +; find /data_mirror/data*/*/*/*/* -iname "*shader*" -exec rm -rf {} +; find /data_mirror/data*/*/*/*/* -iname "*graphitecache*" -exec rm -rf {} +; find /data_mirror/data*/*/*/*/* -iname "*gpucache*" -exec rm -rf {} +; echo "Done!"; sleep 1; exit 0 ;;
  7) echo "Clearing dalvik caches..."; rm -rf /data/dalvik-cache/*/*; rm -rf /data/cache/*; rm -rf /data/system/package_cache/*; rm -rf /data/resource-cache/*; echo "Done!"; sleep 1; exit 0 ;;
  8) echo "Redirecting..."; nohup am start -a android.intent.action.VIEW -d https://t.me/adrenolaboratory >/dev/null; sleep 1; exit 0 ;;
  9) exit 0 ;;
esac
