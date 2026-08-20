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
rm -rf /data/vendor/gpu/qgl_config.txt
