#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

sed -i "/miui.notch/d" $1/build.prop

# build.prop
echo "ro.bluetooth.library_name=libbluetooth_qti.so" >> $1/build.prop


# Copy system files
rsync -ra $thispath/system/ $systempath

#fix systemui crash because of FOD
echo "DEVICE_PROVISIONED=1" >> $1/build.prop

#fix notch
echo "ro.miui.notch=1" >> $1/build.prop

#fix BT
echo "persist.bluetooth.bluetooth_audio_hal.disabled=true" >> $1/build.prop
echo "persist.bluetooth.bluetooth_audio_hal.enabled=false" >> $1/build.prop
echo "persist.vendor.btstack.a2dp_offload_cap=sbc-aptx-aptxhd-aac" >> $1/build.prop
echo "vendor.bluetooth.soc=cherokee" >> $1/build.prop



echo "ro.product.cert=DAISY01PORTS" >> $1/build.prop

echo "
#
# system property determining camera HAL to be used for a Video call
#
# 1 is camera1
# 2 or anything else is camera2
persist.radio.VT_CAM_INTERFACE=2



#hwui properties
ro.hwui.texture_cache_size=72
ro.hwui.layer_cache_size=48
ro.hwui.r_buffer_cache_size=8
ro.hwui.path_cache_size=32
ro.hwui.gradient_cache_size=1
ro.hwui.drop_shadow_cache_size=6
ro.hwui.texture_cache_flushrate=0.4
ro.hwui.text_small_cache_width=1024
ro.hwui.text_small_cache_height=1024
ro.hwui.text_large_cache_width=2048
ro.hwui.text_large_cache_height=2048


#Expose aux camera for below packages
camera.aux.packagelist=org.codeaurora.snapcam,com.android.camera,com.qualcomm.qti.qmmi,com.longcheertel.cit
vendor.camera.aux.packagelist=org.codeaurora.snapcam,com.android.camera,com.qualcomm.qti.qmmi,com.longcheertel.cit

#disable UBWC for camera
#persist.vendor.camera.preview.ubwc=0
#persist.vendor.camera.isp.clock.optmz=0
#persist.vendor.camera.isp.turbo=1
#persist.vendor.camera.imglib.usefdlite=1
#persist.vendor.camera.expose.aux=1
#persist.vendor.camera.HAL3.enabled=1

# add for exif info
#persist.vendor.camera.manufacturer=Xiaomi
#persist.vendor.camera.model=Redmi Note 7



#add for dirac algo tsx 9/12
persist.dirac.acs.controller=qem
persist.dirac.acs.storeSettings=1
persist.dirac.acs.ignore_error=1

#set for xiaomi headset effect
ro.audio.soundfx.dirac=true


#use camera2 api
persist.sys.camera.camera2=true

#disable awb sync in bokeh mode
persist.vendor.camera.awb.sync=2

#add for color invert
ro.vendor.df.effect.conflict=1
persist.sys.df.extcolor.proc=0
#paper mode
sys.paper_mode_max_level=255
sys.tianma_nt36672a_offset=6
sys.tianma_nt36672a_length=42
sys.boe_td4320_offset=-9
sys.boe_td4320_length=42
sys.shenchao_nt36672a_offset=-10
sys.shenchao_nt36672a_length=38

#Netflix custom property
ro.netflix.bsp_rev=Q660-13149-1

#add for screen fliker
debug.gralloc.gfx_ubwc_disable=1
debug.gralloc.enable_fb_ubwc=0
sdm.debug.rotator_disable_ubwc=1
dev.pm.dyn_samplingrate=1
persist.demo.hdmirotationlock=false
#Disable Skip Validate
sdm.debug.disable_skip_validate=1
ro.colorpick_adjust=true



# Audio
ro.config.safe_vol_default=8
ro.config.media_vol_default=10
ro.config.alarm_vol_default=3

# Bluetooth SOC type
persist.vendor.btstack.enable.splita2dp=false

# DPM
persist.vendor.dpm.feature=1
persist.dpm.feature=1

# Game Detection Feature
vendor.debug.enable.gamed=0


# Media
av.debug.disable.pers.cache=1
media.aac_51_output_enabled=true
media.msm8956hw=0
media.stagefright.audio.sink=280
media.stagefright.thumbnail.prefer_hw_codecs=true
mm.enable.sec.smoothstreaming=true
mmp.enable.3g2=true

# Memperf
ro.memperf.lib=libmemperf.so
ro.memperf.enable=true

# Qualcomm
ro.vendor.qti.va_aosp.support=1

# Radio
keyguard.no_require_sim=true
ril.subscription.types=NV,RUIM
rild.libargs=-d/dev/smd0
rild.libpath=/vendor/lib64/libril-qc-qmi-1.so
ro.telephony.iwlan_operation_mode=legacy
ro.telephony.call_ring.multiple=false
ro.telephony.default_network=20,20
persist.sys.fflag.override.settings_network_and_internet_v2=true
service.qti.ims.enabled=1
telephony.lteOnCdmaDevice=1

# Trim Properties
ro.vendor.qti.sys.fw.use_trim_settings=true
ro.vendor.qti.sys.fw.empty_app_percent=50
ro.vendor.qti.sys.fw.trim_empty_percent=100
ro.vendor.qti.sys.fw.trim_cache_percent=100
ro.vendor.qti.sys.fw.trim_enable_memory=2147483648

# WFD
persist.debug.wfd.enable=1
persist.sys.wfd.virtual=0
persist.hwc.enable_vds=1


sys.thermal.data.path=/data/thermal/" >> $1/build.prop

# drop nfc
rm -rf $1/app/NQNfcNci

cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh

sed -i 's/<bool name="support_round_corner">true/<bool name="support_round_corner">true/' $1/etc/device_features/*


# Wifi fix
cp -fpr $thispath/bin/* $1/bin/
cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh
