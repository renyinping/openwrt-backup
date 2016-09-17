# /bin/sh

DL_DIR="/www/dl";
rm -rf ${DL_DIR};

BAK_FILE="/tmp/backup";
[ ! -z "$1" ] && BAK_FILE="${BAK_FILE}-$1";
BAK_FILE="${BAK_FILE}-`cat /proc/sys/kernel/hostname`";
BAK_FILE="${BAK_FILE}-15.05.1-ar71xx-nand-wndr3700v4";
BAK_FILE="${BAK_FILE}-`date +%F`";
BAK_FILE="${BAK_FILE}.tar.gz";

EXCLUDE="--exclude=root";
BAK_LIST="bin etc lib mnt sbin usr www";

cd /overlay/upper;
tar -zcf "${BAK_FILE}" ${EXCLUDE} ${BAK_LIST};
cd /root;

./aes-256-cfb.sh ${BAK_FILE};
mkdir -p ${DL_DIR};
mv ${BAK_FILE}.aes-256-cfb ${DL_DIR}/;
rm -rf ${BAK_FILE};
