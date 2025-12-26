# openwrt-tutuicmptunnel-kmod

使用方法

下载`openwrt-sdk`或者`openwrt`仓库，解压后进入子目录

```sh
cd packages
git clone https://github.com/hrimfaxi/openwrt-tutuicmptunnel-kmod tutuicmptunnel
cd ..
./scripts/feeds update -a
./scripts/feeds install libmnl
make menuconfig # 进入menuconfig选中tutuicmptunnel
make package/tutuicmptunnel/compile V=s

find . -name "*tutu*.ipk" # 找到ipk上传路由器
```
