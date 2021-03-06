# Use bash for additional echo fancyness
SHELL = /bin/bash

####################################################################################################
## defines

# Build for Jellybean 
#--yd BUILD_ANDROID_JELLYBEAN = $(shell test -d $(ANDROID_ROOT)/frameworks/native && echo 1)

# Build for Lollipop
# ANDROID version check
BUILD_ANDROID_LOLLIPOP = $(shell test -d $(ANDROID_ROOT)/bionic/libc/kernel/uapi && echo 1)
#ANDROID version check END

PRODUCT = generic_arm64
TARGET = android

## libraries ##
LIB_PREFIX = lib

STATIC_LIB_EXT = a
SHARED_LIB_EXT = so

# normally, overridden from outside 
# ?= assignment sets it only if not already defined
TARGET ?= android

MLLITE_LIB_NAME     ?= mllite
#MLLITE_LIB_NAME     ?= mllite_64
MPL_LIB_NAME        ?= mplmpu

## applications ##
SHARED_APP_SUFFIX = -shared
STATIC_APP_SUFFIX = -static

####################################################################################################
## compile, includes, and linker

ifeq ($(BUILD_ANDROID_JELLYBEAN),1)
ANDROID_COMPILE = -DANDROID_JELLYBEAN=1
endif

ANDROID_LINK  = -nostdlib
#ANDROID_LINK += -fpic
ANDROID_LINK += -Wl,--gc-sections 
ANDROID_LINK += -Wl,--no-whole-archive 
ANDROID_LINK += -L$(ANDROID_ROOT)/out/target/product/$(PRODUCT)/obj/lib
#--yd ANDROID_LINK += -L$(ANDROID_ROOT)/out/target/product/$(PRODUCT)/system/lib
#for arm64 --yd 
#--yd ANDROID_LINK += -Bdynamic -pie -Wl,-dynamic-linker,/system/bin/linker64 -Wl,-z,nocopyreloc
#--yd ANDROID_LINK += -Wl,-rpath-link=out/target/product/generic_arm64/obj/lib
#--yd ANDROID_LINK += -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,--warn-shared-textrel -Wl,--fatal-warnings -Wl,-maarch64linux -Wl,--no-undefined
#--yd ANDROID_LINK += $(ANDROID_ROOT)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/lib/gcc/aarch64-linux-android/4.9/libgcc.a
#--yd ANDROID_LINK += $(ANDROID_ROOT)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/aarch64-linux-android/lib64/libatomic.a

ANDROID_LINK_EXECUTABLE  = $(ANDROID_LINK)
ANDROID_LINK_EXECUTABLE += -Wl,-dynamic-linker,/system/bin/linker64
ifneq ($(BUILD_ANDROID_JELLYBEAN),1)
#--yd ANDROID_LINK_EXECUTABLE += -Wl,-T,$(ANDROID_ROOT)/build/core/armelf.x
#--yd ANDROID_LINK_EXECUTABLE += -Wl,-T,$(ANDROID_ROOT)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/aarch64-linux-android/lib/ldscripts/armelf.x
ANDROID_LINK_EXECUTABLE += -Wl,-T,$(ANDROID_ROOT)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/aarch64-linux-android/lib/ldscripts/aarch64linux.x
endif
ANDROID_LINK_EXECUTABLE += $(ANDROID_ROOT)/out/target/product/$(PRODUCT)/obj/lib/crtbegin_dynamic.o
ANDROID_LINK_EXECUTABLE += $(ANDROID_ROOT)/out/target/product/$(PRODUCT)/obj/lib/crtend_android.o

ANDROID_INCLUDES  = -I$(ANDROID_ROOT)/system/core/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/hardware/libhardware/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/hardware/ril/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/dalvik/libnativehelper/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/frameworks/base/include   # ICS
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/frameworks/native/include # Jellybean
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/external/skia/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/out/target/product/generic/obj/include
#--yd ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libc/arch-arm/include

ifeq ($(BUILD_ANDROID_LOLLIPOP),1)
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libc/kernel/uapi #LP
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libc/kernel/uapi/asm-arm64 #LP
endif
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libc/arch-arm64/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libc/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libstdc++/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libc/kernel/common
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libc/kernel/arch-arm64
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libm/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libm/include/arch/arm64
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libthread_db/include
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libm/arm64
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/bionic/libm
ANDROID_INCLUDES += -I$(ANDROID_ROOT)/out/target/product/generic/obj/SHARED_LIBRARIES/libm_intermediates
ANDROID_INCLUDES += -DHAVE_SYS_UIO_H

KERNEL_INCLUDES  = -I$(KERNEL_ROOT)/include


INV_INCLUDES  = -I$(INV_ROOT)/software/core/driver/include
INV_INCLUDES += -I$(MLLITE_DIR)
INV_INCLUDES += -I$(MLLITE_DIR)/linux

INV_DEFINES += -DINV_CACHE_DMP=1

####################################################################################################
## macros

ifndef echo_in_colors
define echo_in_colors
	echo -ne "\e[1;32m"$(1)"\e[0m"
endef 
endif



