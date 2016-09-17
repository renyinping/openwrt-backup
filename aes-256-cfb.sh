# /bin/sh

PASSWD=$2
FILE=$1
FILE_EX=${FILE##*.}

if [ -z "${FILE}" ]; then
	echo "Invalid parameter: file and password"
	exit 1
fi

if [ ! -f "${FILE}" ]; then
	echo "File Not Found ${FILE}"
	exit 2
fi

if [ -z "${PASSWD}" ]; then
	if [ -f "passwd" ]; then
		PASSWD=`cat passwd`
	else
		echo "Invalid parameter: password"
		exit 3
	fi
fi

if [ "${FILE_EX}"x = "aes-256-cfb"x ]; then
	# 解密
	echo "decrypt(解密)"
	openssl aes-256-cfb -d -k ${PASSWD} -in ${FILE} -out ${FILE%.aes-256-cfb}
else
	# 加密
	echo "encrypt(加密)"
	openssl aes-256-cfb    -k ${PASSWD} -in ${FILE} -out ${FILE}.aes-256-cfb
fi

echo Password: ${PASSWD}
