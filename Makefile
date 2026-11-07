TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ScreenTimeUnlocker

ScreenTimeUnlocker_FILES = Tweak.xm
ScreenTimeUnlocker_CFLAGS = -fobjc-arc

# Ép trình biên dịch tìm trong thư mục PrivateFrameworks của SDK hiện tại thay vì bắt buộc có file stub
ScreenTimeUnlocker_LDFLAGS = -F$(THEOS_TARGET_SDK)/System/Library/PrivateFrameworks

include $(THEOS_MAKE_PATH)/tweak.mk
