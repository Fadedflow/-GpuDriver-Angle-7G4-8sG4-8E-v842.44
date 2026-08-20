description=/data/adb/modules/adreno_gpu_driver/module.prop
mustbe="V@0842.44"
installed=$(strings /vendor/lib64/egl/libGLESv2_adreno.so | grep -i 'V@0')

sed -i '/description/d' /data/adb/modules/adreno_gpu_driver/module.prop

if [[ "$installed" == *"$mustbe"* ]]; then
  echo "description=Reach the potential of your GPU Adreno! / Full of V@0842.44 from Qualcomm® / Status: Installed ✔️" >> $description
else
  echo "description=Reach the potential of your GPU Adreno! / Full of V@0842.44 from Qualcomm® / Status: Not installed ✖️" >> $description
fi