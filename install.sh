# /bin/sh

base()
{
	opkg install luci-i18n-base-zh-cn luci-i18n-firewall-zh-cn ca-certificates wget tar openssl-util

	SCRIPTS=https://github.com/renyinping/openwrt-backup/raw/wndr3700v4-15.05
	wget -O backup.sh      ${SCRIPTS}/backup.sh
	wget -O aes-256-cfb.sh ${SCRIPTS}/aes-256-cfb.sh
	chmod a+x *.sh
}

ss()
{
	PACKAGES=https://github.com/renyinping/openwrt-backup/raw/wndr3700v4-15.05/packages
	SS=shadowsocks-libev_2.5.2-1_ar71xx.ipk
	SS_LUCI=luci-app-shadowsocks_1.3.5-1_all.ipk
	LIST=update_ignore_list.sh
	wget -O ${SS}      ${PACKAGES}/${SS}
	wget -O ${SS_LUCI} ${PACKAGES}/${SS_LUCI}
	wget -O ${LIST}    ${PACKAGES}/${LIST}
	opkg install ${SS} ${SS_LUCI}
	rm -rf ${SS} ${SS_LUCI}
	chmod a+x ${LIST}
	./${LIST}
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

