#!/usr/bin/bash

# set -x

#
# Script creado por Alex Callejas
# fecha: 26-Mar-2022
# versión: 0.1
# versión: 0.2 → Agregue creacion de directorios
# versión: 0.3 → Fix if statment
# versión: 0.4 → Agregue creacion de archivo de procesos y de usuarios
# versión: 0.5 → Fix a la creacion de archivos
# versión: 0.6 → Fix a la creacion de archivos, agregue comilla doble
# versión: 0.7 → Agregue creacion de respaldo
# versión: 1.0
# fecha: 27-Mar-2022
# versión: 1.1 → Agregue formato a log (Alex Callejas)
#

# VARIABLES
# 
NODO_KEY=/home/alex/id_lab
NODO=nodo
NODO_USER=user13
NODO_USER_HOME=/home/user13
NODO_USER_WDIR=$NODO_USER_HOME/workdir
NODO_USER_PFILE=$NODO_USER_WDIR/procesos.$(date +'%H%M%S').log
NODO_USER_UFILE=$NODO_USER_WDIR/usuarios.$(date +'%H%M%S').log
NODO_USER_BKPDIR=$NODO_USER_HOME/respaldos
NODO_USER_BKP=$NODO_USER_BKPDIR/workdir.bkp.$(date +'%H%M%S').tar.gz
SCRIPT_HOME=/home/alex/workdir/scripts
LOGS_HOME=$SCRIPT_HOME/logs
LOG=$LOGS_HOME/prueba.log
#

# COMANDOS
#
echo "++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOG
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Inicio de Ejecucion" >> $LOG
echo "++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOG
#echo "Testeando la conexion a $NODO" >> $LOG
#ssh -i $NODO_KEY $NODO_USER@$NODO hostname >> $LOG

# Validacion de existencia de directorios
# Este comando lista remotamente el directorio
# y proporciona la salida de la variable de entorno
# para su evaluacion.

for i in $NODO_USER_WDIR $NODO_USER_BKPDIR
do
	ssh -i $NODO_KEY $NODO_USER@$NODO "ls -d $i 2> /dev/null"
	if [ $? == 0 ]
	then
		echo "$(date +'%d-%m-%Y %H:%M') [WARN] El directorio $i existe" >> $LOG
	else
		echo "$(date +'%d-%m-%Y %H:%M') [INFO] Creando directorio $i" >> $LOG
		ssh -i $NODO_KEY $NODO_USER@$NODO mkdir -p $i
	fi
done

# Creación de archivos de procesos y usuarios

# Procesos
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Creando archivo de procesos" >> $LOG
ssh -i $NODO_KEY $NODO_USER@$NODO "ps auxf > $NODO_USER_PFILE 2> /dev/null"

# Usuarios
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Creando archivo de usuarios" >> $LOG
ssh -i $NODO_KEY $NODO_USER@$NODO  "cat /etc/passwd | cut -d: -f1 > $NODO_USER_UFILE 2> /dev/null"

# Creación de respaldo
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Creando respaldo de $NODO_USER_WDIR" >> $LOG
ssh -qi $NODO_KEY $NODO_USER@$NODO "tar czf $NODO_USER_BKP $NODO_USER_WDIR 2> /dev/null"

# Notificacion de fin
echo "$(date +'%d-%m-%Y %H:%M') [INFO] Fin de Ejecucion" >> $LOG
