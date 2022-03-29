#!/bin/bash
set -x
#
# Script creado por Alex Callejas
# fecha: 14-Apr-2021
# versión: 1.0
#
# VARIABLES
HOME_SCRIPT=/home/user/script
LOG=$HOME_SCRIPT/script.log
DIR=$HOME_SCRIPT/clase
DATA_FILE=$HOME_SCRIPT/datos
COMPRESS_FILE=$HOME_SCRIPT/users.tar.bzip2
PASSWORD=12345678
GROUP=USERS
GID=5000
# COMANDOS
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOG
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Iniciando la ejecución de script.sh" >> $LOG
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOG
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Creando directorio $DIR" >> $LOG
mkdir $DIR
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Creando archivos de IPs" >> $LOG
for i in {1..5}
do
	for j in $(cat $DATA_FILE | cut -d: -f2)
	do
		echo $j >> $DIR/file$i
	done
done	
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Comprimiendo $DIR" >> $LOG
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Creando archivo $COMPRESS_FILE" >> $LOG
tar cjf $COMPRESS_FILE clase
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Creando usuarios" >> $LOG
for i in $(cat $DATA_FILE | cut -d: -f3)
do
	echo "$(date +'%d-%m-%Y %H:%M') [INFO] Creando usuario $i" >> $LOG
	useradd -G $GID -c "Usuario $i" -d /home/$i -m -s /bin/bash $i
	echo "$(date +'%d-%m-%Y %H:%M') [INFO] Asignando contraseña a usuario $i" >> $LOG
	echo "$i:$PASSWORD" | chpasswd
done
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Copiando archivos en home de usuarios" >> $LOG
for i in $(cat $DATA_FILE | cut -d: -f3)
do
	cp $COMPRESS_FILE /home/$i
	tar xjf /home/$i/users.tar.bzip2 -C /home/$i
	chown -R $i:$i /home/$i
done
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Finalizando la ejecución de script.sh" >> $LOG
