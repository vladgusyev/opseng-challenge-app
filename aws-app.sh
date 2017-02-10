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
/usr/bin/virtualenv pvenv
source "$ROOT_DIR/$PYTHON_VENV/bin/activate" 
$ROOT_DIR/$PYTHON_VENV/bin/easy_install gunicorn flask
$ROOT_DIR/$PYTHON_VENV/bin/python $ROOT_DIR/$APP_NAME &>/dev/null
$ROOT_DIR/$PYTHON_VENV/bin/gunicorn app:app &>/dev/null
}


if [[ -f $PIP_PATH ]];then
	if [[ $APP_FILE_DEP -eq 0 ]];then
		case $VIRTUALENV_DEP in
			0 ) echo "APP_FILE_DEP and VIRTUALENV_DEP are good, will continue";STARTAPP;;
			1 ) echo "VIRTUALENV_DEP is status 1";;
			* ) printf "Failed to get virtualenv dependency status";exit;;
		esac
	else
		printf "Failed to find $APP_NAME in $ROOT_DIR, cannot continue";exit;
	fi
else
	printf "Could not locate $PIP_PATH, cannot continue";exit;
fi

ECHOURL




#/usr/bin/pip install virtualenv
#/usr/bin/virtualenv pvenv
#source pvenv/bin/activate
#pvenv/bin/easy_install gunicorn flask
#python app.py
#gunicorn app:app
#dig +short myip.opendns.com @resolver1.opendns.com.
