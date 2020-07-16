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


# drop nfc
rm -rf $1/app/NQNfcNci

cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh

sed -i 's/<bool name="support_round_corner">true/<bool name="support_round_corner">true/' $1/etc/device_features/*


# Wifi fix
cp -fpr $thispath/bin/* $1/bin/
cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh
