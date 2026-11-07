TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ScreenTimeUnlocker

ScreenTimeUnlocker_FILES = Tweak.xm
ScreenTimeUnlocker_CFLAGS = -fobjc-arc

# Chỉ định đường dẫn tuyệt đối đến PrivateFrameworks của iOS SDK để bộ liên kết nhận diện PSSpecifier
ScreenTimeUnlocker_LDFLAGS = -F$(THEOS_SDK_DIR)/System/Library/PrivateFrameworks -framework Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
