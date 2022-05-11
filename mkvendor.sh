#!/bin/sh

SYSTEMDIR=/system
VENDOR=samsung
DEVICE=f22
OUTDIR=vendor/$VENDOR/$DEVICE


mkdir -p $OUTDIR/proprietary

(cat << EOF) > $OUTDIR/$DEVICE-vendor-blobs.mk
# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Prebuilt libraries that are needed to build open-source libraries
#PRODUCT_COPY_FILES := \\
#    \$(LOCAL_PATH)/proprietary/lib/libcamera.so:obj/lib/libcamera.so \\
#    \$(LOCAL_PATH)/proprietary/lib/libaudio.so:obj/lib/libaudio.so \\
#    \$(LOCAL_PATH)/proprietary/lib/libaudiopolicy.so:obj/lib/libaudiopolicy.so \\
#    \$(LOCAL_PATH)/proprietary/lib/libseccameraadaptor.so:obj/lib/libseccameraadaptor.so

PRODUCT_COPY_FILES += \\
EOF


LINEEND=" \\"
COUNT=`wc -l proprietary-files.txt | awk {'print $1'}`
for FILE in `cat proprietary-files.txt`; do
    COUNT=`expr $COUNT - 1`
    if [ $COUNT = "0" ]; then
        LINEEND=""
    fi
    if [ -f $SYSTEMDIR/$FILE ]; then
        if [ ! -d $(dirname $OUTDIR/proprietary/$FILE)  ]; then
            mkdir -p $(dirname $OUTDIR/proprietary/$FILE)
        fi
        cp $SYSTEMDIR/$FILE $OUTDIR/proprietary/$FILE

        echo "    \$(LOCAL_PATH)/proprietary/$FILE:system/$FILE$LINEEND" >> $OUTDIR/$DEVICE-vendor-blobs.mk
    else
        echo "File not exist: system/$FILE"
    fi
done




(cat << EOF) > $OUTDIR/$DEVICE-vendor.mk
# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Pick up overlay for features that depend on non-open-source files
DEVICE_PACKAGE_OVERLAYS := \$(LOCAL_PATH)/overlay

\$(call inherit-product, \$(LOCAL_PATH)/$DEVICE-vendor-blobs.mk)
EOF

(cat << EOF) > $OUTDIR/BoardConfigVendor.mk
# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

USE_CAMERA_STUB := false
EOF

