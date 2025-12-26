include $(TOPDIR)/rules.mk

PKG_NAME:=tutuicmptunnel
PKG_VERSION:=git
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/hrimfaxi/tutuicmptunnel-kmod.git
PKG_SOURCE_VERSION:=HEAD
PKG_HASH:=skip

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define Build/Configure
	cd $(PKG_BUILD_DIR) && \
	cmake . \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_SYSTEM_NAME=Linux \
		-DCMAKE_C_COMPILER="$(TARGET_CC)"
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)

	$(MAKE) -C "$(LINUX_DIR)" \
		M="$(PKG_BUILD_DIR)/kmod" \
		ARCH="$(LINUX_KARCH)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		modules
endef

define Build/Clean
	-$(MAKE) -C "$(PKG_BUILD_DIR)/kmod" clean
	-$(MAKE) -C "$(PKG_BUILD_DIR)" clean
endef

define KernelPackage/tutuicmptunnel
  SUBMENU:=Network Support
  TITLE:=tutuicmptunnel kernel module
  DEPENDS:=
  FILES:=$(PKG_BUILD_DIR)/kmod/tutuicmptunnel.ko
  AUTOLOAD:=$(call AutoLoad,99,tutuicmptunnel)
endef

define Package/tutuicmptunnel
  SECTION:=net
  CATEGORY:=Network
  TITLE:=tutuicmptunnel user tools(ktuctl tuctl_server tuctl_client)
  DEPENDS:=+kmod-tutuicmptunnel +libmnl
endef

define Package/tutuicmptunnel/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ktuctl/ktuctl \
		$(1)/usr/sbin/
endef

$(eval $(call KernelPackage,tutuicmptunnel))
$(eval $(call BuildPackage,tutuicmptunnel))
