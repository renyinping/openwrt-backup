# /bin/bash

wget -O yplib.sh https://github.com/renyinping/linux-scripts/raw/share/yplib.sh
. yplib.sh

# 安装64位系统兼容32位应用包
# 安装开发工具包
install()
{
	sudo apt-get install -y ${DEB_X86_64} ${DEB_DEV_KIT} ${DEB_VER_CTRL} ${DEB_TOOLS}
}

UNPACK_DIR=${HOME}/wndr3700v4/OpenWrt-ImageBuilder-15.05.1-ar71xx-nand.Linux-x86_64

# 安装openwrt-imagebuilder
image_build_system()
{
	VERSION=15.05.1
	DL_URL=https://downloads.openwrt.org/chaos_calmer/15.05.1/ar71xx/nand/OpenWrt-ImageBuilder-15.05.1-ar71xx-nand.Linux-x86_64.tar.bz2
	DL_FILE=${DL_URL##*/}
	
	unpack_tar_bz2 "${UNPACK_DIR}" "${DL_URL}";
	
	# 完整使用 128M flash
	pushd ${UNPACK_DIR};
	OLD='wndr4300_mtdlayout=mtdparts=ar934x-nfc:256k(u-boot)ro,256k(u-boot-env)ro,256k(caldata),512k(pot),2048k(language),512k(config),3072k(traffic_meter),2048k(kernel),23552k(ubi),25600k@0x6c0000(firmware),256k(caldata_backup),-(reserved)'
	NEW='wndr4300_mtdlayout=mtdparts=ar934x-nfc:256k(u-boot)ro,256k(u-boot-env)ro,256k(caldata),512k(pot),2048k(language),512k(config),3072k(traffic_meter),2048k(kernel),121856k(ubi),123904k@0x6c0000(firmware),256k(caldata_backup),-(reserved)'
	EDIT_FILE="${UNPACK_DIR}/target/linux/ar71xx/image/Makefile"
	sed -i "s/${OLD}/${NEW}/g" ${EDIT_FILE};
	popd;
}

# 包清单
LUCI='luci luci-i18n-base-zh-cn luci-i18n-firewall-zh-cn ca-certificates'
USB='kmod-usb-storage kmod-usb-storage-extras kmod-scsi-core block-mount usbutils blkid fdisk e2fsprogs hdparm kmod-fs-ext4'
SMB='luci-app-samba luci-i18n-samba-zh-cn'
FAT32='kmod-fs-vfat kmod-nls-cp437 kmod-nls-iso8859-1'
NTFS='kmod-fs-ntfs'
BT='luci-app-transmission luci-i18n-transmission-zh-cn transmission-web'
XXNET='pyopenssl'

luci()
{
	if [ ! -d "${UNPACK_DIR}" ]; then
		image_build_system;
	fi;
	
	pushd ${UNPACK_DIR};
	make image PROFILE=WNDR4300 PACKAGES="${LUCI}";
	popd;
}

smb()
{
	if [ ! -d "${UNPACK_DIR}" ]; then
		image_build_system;
	fi;
	
	pushd ${UNPACK_DIR};
	make image PROFILE=WNDR4300 PACKAGES="${LUCI} ${USB} ${SMB} ${FAT32} ${NTFS}";
	popd;
}

bt()
{
	if [ ! -d "${UNPACK_DIR}" ]; then
		image_build_system;
	fi;
	
	pushd ${UNPACK_DIR};
	make image PROFILE=WNDR4300 PACKAGES="${LUCI} ${USB} ${SMB} ${FAT32} ${NTFS} ${BT}";
	popd;
}

# 安装openwrt-sdk
sdk_build_system()
{
	VERSION=15.05.1
	DL_URL=https://downloads.openwrt.org/chaos_calmer/15.05.1/ar71xx/nand/OpenWrt-SDK-15.05.1-ar71xx-nand_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2
	DL_FILE=${DL_URL##*/}
	UNPACK_DIR=${HOME}/wndr3700v4/OpenWrt-SDK-15.05.1-ar71xx-nand_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64
	
	unpack_tar_bz2 "${UNPACK_DIR}" "${DL_URL}";
}

################################################################
if [ -z "$1" ]; then
	cat $0 | grep \(\)$
else
	if [ `cat $0 | grep ^$1\(\)$ | wc -l` -eq 1 ]; then
		$*
	else
		echo "Invalid parameter"
	fi
fi
