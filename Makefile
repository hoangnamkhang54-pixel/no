TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ScreenTimeUnlocker

ScreenTimeUnlocker_FILES = Tweak.xm
ScreenTimeUnlocker_CFLAGS = -fobjc-arc

# Chỉ định rõ đường dẫn PrivateFrameworks để linker nạp đúng PSSpecifier
ScreenTimeUnlocker_LDFLAGS = -F$(THEOS_TARGET_SDK)/System/Library/PrivateFrameworks -framework Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
