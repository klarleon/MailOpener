INSTALL_TARGET_PROCESSES = SpringBoard

# TARGET = iphone:clang:latest:9.3

ARCHS = armv7 arm64 

include theos/makefiles/common.mk

TWEAK_NAME = MailOpener
MailOpener_FILES = MailOpener.xm
MailOpener_INSTALL_PATH = /Library/Opener
MailOpener_FRAMEWORKS = UIKit
MailOpener_EXTRA_FRAMEWORKS = Opener
MapsOpener_PRIVATE_FRAMEWORKS = MobileCoreServices
MapsOpener_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"




test::
	install.exec "cycript -p SpringBoard" < test.cy
