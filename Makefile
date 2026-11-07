TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ScreenTimeUnlocker

ScreenTimeUnlocker_FILES = Tweak.xm
ScreenTimeUnlocker_CFLAGS = -fobjc-arc

# Bỏ qua kiểm tra ký hiệu lúc build, tự động liên kết khi chạy trên thiết bị thật
ScreenTimeUnlocker_LDFLAGS = -undefined dynamic_lookup

include $(THEOS_MAKE_PATH)/tweak.mk
