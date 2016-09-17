# /bin/sh

DL_DIR="www/dl";
BAK_FILE="${DL_DIR}/backup-`cat /proc/sys/kernel/hostname`";
BAK_FILE="${BAK_FILE}-15.05.1-ar71xx-nand-wndr3700v4";
[ ! -z "$1" ] && BAK_FILE="${BAK_FILE}-$1";
BAK_FILE="${BAK_FILE}-`date +%F`";
BAK_FILE="${BAK_FILE}.tar.gz";
EXCLUDE="--exclude=${DL_DIR} --exclude=root";
BAK_LIST="bin etc lib mnt sbin usr www";

cd /overlay/upper;
mkdir -p /${DL_DIR};
tar -zcf "${BAK_FILE}" ${EXCLUDE} ${BAK_LIST};
cd /root;

./aes-256-cfb.sh /${BAK_FILE}
