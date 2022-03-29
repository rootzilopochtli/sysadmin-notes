#!/bin/bash

home=/home/student
dir_proc=/home/student/procesados

## Script del ciclo de trabajo automatizado

# 1. Creando archivos
for i in {1..100}; do echo "Soy el archivo $i" > $home/file00$i; done

# 2. Transferencia de archivos a server
scp -P 18622 $home/file00.* centos.example-rh.com:/home/student/

# 3. Borrar archivos locales
rm -rf $home/file00.*

# 4. Procesar archivos en server
ssh -q -p 18622 centos.example-rh.com /home/student/script.sh

# 4.1 Esperar a que los archivos sean procesados (5 seg)
sleep 5

# 5. Recuperar archivos

# 5.1 Obtener el ultimo directorio
last_dir_files=$(ssh -q -p 18622 centos.example-rh.com ls -ltr | grep ^d | tail -1 | awk '{ print $9 }')

# 5.2 Crear directorio de archivos procesados
mkdir $dir_proc/$last_dir_files

# 5.3 Recuperar archivos procesados
scp -P 1822 centos.example-rh.com:/home/student/$last_dir_files/file00* $dir_proc/$last_dir_files/
