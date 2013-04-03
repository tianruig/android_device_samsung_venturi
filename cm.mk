## Specify phone tech before including full_phone
#$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := GalaxyPlayer5

# Inherit some common CM stuff.
#$(call inherit-product, vendor/cm/config/common_full_phone.mk)
$(call inherit-product, vendor/cm/config/common_full_tablet_wifionly.mk)

# Inherit device configuration
$(call inherit-product, device/samsung/venturi_usa/full_venturi_usa.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := venturi_usa
PRODUCT_NAME := cm_venturi_usa
PRODUCT_BRAND := Samsung
PRODUCT_MODEL := YP-G70

TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 480

# Build fingerprint / ID / Product name etc.
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=YP-G70 TARGET_DEVICE=YP-G70 BUILD_FINGERPRINT=samsung/YP-G70/YP-G70:2.3.5/GINGERBREAD/UEKI8:user/release-keys PRIVATE_BUILD_DESC="YP-G70-user 2.3.5 GINGERBREAD UEKI8 release-keys"
