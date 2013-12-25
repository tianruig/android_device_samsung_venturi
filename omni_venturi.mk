# Copyright (C) 2013 OmniROM Project
# Copyright (C) 2012 The CyanogenMod Project
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

# Inherit from our omni product configuration
$(call inherit-product, vendor/omni/config/common.mk)

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Inherit device configuration
$(call inherit-product, device/samsung/venturi/full_venturi.mk)

# Discard inherited values and use our own instead.
PRODUCT_NAME := omni_venturi
PRODUCT_DEVICE := venturi
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := Samsung
PRODUCT_MODEL := YP-G70
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=YP-G70 TARGET_DEVICE=YP-G70 BUILD_FINGERPRINT=samsung/YP-G70/YP-G70:2.3.5/GINGERBREAD/UEKI8:user/release-keys PRIVATE_BUILD_DESC="YP-G70-user 2.3.5 GINGERBREAD UEKI8 release-keys"
