#!/bin/bash

## Vérifier bien que lvm2 soit installé avant d'éxécuter le script ##

fdisk -l | grep /dev/sd
echo "Quel disque voulez-vous formater ? Exemple: /dev/sdb"
read cfdisk
cfdisk $cfdisk

echo "Actualisation des partitions... "
fdisk -l | grep /dev/sd
echo "Quel disque voulez-vous taguer ? Exemple /dev/sdc1"
read pv_create
echo "Création du Physical Volume..."
pvcreate $pv_create

pvdisplay | grep $pv_create

vgdisplay | grep Name | awk '{print $3}'

echo "Quel Volume Group voulez-vous étendre ? Exemple: debian-vg "
read vg
echo "Ajouter le disque tagué au VG ? Exemple: /dev/sdb2"
read disk_to_add

#test=$(vgdisplay | grep Name)

#if[test = vg]
#	then
		vgextend $vg $disk_to_add
#	else
#		echo "Vous avez entré un mauvais Volume Group "
#fi
lvscan

echo " Veuillez saisir le chemin complet du Logical Volume Ex:/dev/debian-vg/home"
read lv_path
echo "De combien voulez-vous étendre" $vg "? Exemple : 2,5G - Ne pas utiliser de points !" 
read lenght
lvextend -L+$lenght $lv_path

lvdisplay | grep 'LV Name\|LV Size'

echo "Actualisation du système de fichiers... "
resize2fs $lv_path

exit 0
