#!/bin/bash

# Filename : script_lvm.sh
# Version  : 2.0
# Author   : Aurélien DUBUS 
# Contrib  : 
# Description :
#  . Add a disk to an existent VG&LV , format the LV in ext4 and mount it permanently
#  . Vérifier bien que lvm2 soit installé avant d'éxécuter le script ##
echo -e "==== Disques disponibles ==== \n"
lsblk
echo -e "\n Quel disque voulez-vous formater ? Exemple: /dev/sdb"
read cfdisk
cfdisk $cfdisk
echo -e "==== Actualisation des partitions ===== \n"
lsblk
echo -e "\n Quel disque voulez-vous taguer ? Exemple /dev/sdc1"
read pv_create
echo -e "==== Création du PhysicalVolume ==== \n"
pvcreate $pv_create

echo "==== Volume Groups disponibles ===="
pvdisplay | grep $pv_create
vgdisplay |grep Name | awk '{print $3}'

echo -e "\n Quel Volume Group voulez-vous étendre? Exemple: debian-vg"
read vg
echo -e "Ajouter le disque tagué au VG ? Exemple: /dev/sdb2 \n"
read disk_to_add

vgextend $vg $disk_to_add
lvscan
echo -e " \n Veuillez saisir le chemin complet du Logical Volume Ex:/dev/debian-vg/home \n"
read lv_path
echo "De combien voulez-vous étendre" $vg "? Exemple : 2,5G - Ne pas utiliser de points !" 
read lenght
lvextend -L+$lenght $lv_path
lvdisplay | grep 'LV Name\|LV Size'
echo -e "\n ==== Actualisation du système de fichiers... ==== "
resize2fs $lv_path

##Format and Mount LV
echo -e "\n ==== Formatage en Ext4... ==== "
mkfs.ext4 $lv_path
mkdir /mnt/$vg
mount $lv_path /mnt/$vg
e2label $lv_path $vg

#Edition of fstab file to permanently mount the LV
cp /etc/fstab /etc/fstab.bak
echo -e "LABEL=$vg\t /mnt/$vg\t ext4 defaults 0 0" >> /etc/fstab


exit 0
