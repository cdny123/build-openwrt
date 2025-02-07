#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: main
#========================================================================================================================

# 添加自定义feeds
echo "src-git helloworld https://github.com/fw876/helloworld" >> feeds.conf.default
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall" >> feeds.conf.default

# 更新feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 设置内核版本为6.6
sed -i 's/^# CONFIG_KERNEL_PATCHVER=.*/CONFIG_KERNEL_PATCHVER="6.6"/' target/linux/x8ag6/config-6.6

# go版本到1.22后，编译碰到的问题
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

# 添加 openwrt-package
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default
echo 'src-git cdny https://github.com/cdny123/openwrt-package1.git' >>feeds.conf.default

# 添加 APP 插件
git clone https://github.com/sirpdboy/chatgpt-web.git package/luci-app-chatgpt      # chatgpt-web
git clone https://github.com/sirpdboy/luci-theme-kucat.git package/luci-app-kucat   # kucat主题
git clone https://github.com/lq-wq/luci-app-quickstart.git package/luci-app-quickstart   # iStoreOS-web
git clone https://github.com/sirpdboy/luci-app-lucky.git package/lucky      # luci-app-lucky 端口转发

# 添加额外插件
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
