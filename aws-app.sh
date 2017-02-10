#!/bin/bash
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYTHON_VENV='pvenv'
APP_NAME='app.py'
EXTERNAL_IP="$(dig +short myip.opendns.com @resolver1.opendns.com.)"
PIP_PATH='/usr/local/bin/pip'

if [[ ! -f $ROOT_DIR/$APP_NAME ]]; then APP_FILE_DEP='1';else APP_FILE_DEP='0';fi
if [[ ! -z `$PIP_PATH list 2>/dev/null| grep virtualenv` ]];then VIRTUALENV_DEP='0';else VIRTUALENV_DEP='1';fi
ECHOURL(){
printf "Visit the following URL: http://$EXTERNAL_IP \n"
}

STARTAPP(){
/usr/bin/virtualenv pvenv &>/dev/null
source "$ROOT_DIR/$PYTHON_VENV/bin/activate" &>/dev/null
$ROOT_DIR/$PYTHON_VENV/bin/easy_install gunicorn flask &> $ROOT_DIR/easy_install.log &
$ROOT_DIR/$PYTHON_VENV/bin/gunicorn app:app &> $ROOT_DIR/gunicorn.log &
}


if [[ -f $PIP_PATH ]];then
	if [[ $APP_FILE_DEP -eq 0 ]];then
		case $VIRTUALENV_DEP in
			0|1 ) /usr/bin/virtualenv pvenv >/dev/null;
				STARTAPP;
				ECHOURL;
				;;
			* ) printf "Failed to get virtualenv dependency status";exit;;
		esac
	else
		printf "Failed to find $APP_NAME in $ROOT_DIR, cannot continue";exit;
	fi
else
	printf "Could not locate $PIP_PATH, cannot continue";exit;
fi
