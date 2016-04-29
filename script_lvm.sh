#!/bin/bash
## Vérifier bien que lvm2 soit installé avant d'éxécuter le script ##
echo -e "==== Disques disponibles ==== \n"
fdisk -l | grep /dev/sd
echo -e "\n Quel disque voulez-vous formater ? Exemple: /dev/sdb"
read cfdisk
cfdisk $cfdisk
echo -e "==== Actualisation des partitions ===== \n"
fdisk -l | grep /dev/sd
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
#test=$(vgdisplay | grep Name) if[test = vg]
#	then
		vgextend $vg $disk_to_add
#	else
#		echo "Vous avez entré un mauvais Volume Group "
#fi
lvscan
echo -e " \n Veuillez saisir le chemin complet du Logical Volume Ex:/dev/debian-vg/home \n"
read lv_path
echo "De combien voulez-vous étendre" $vg "? Exemple : 2,5G - Ne pas utiliser de points !" 
read lenght
lvextend -L+$lenght $lv_path
lvdisplay | grep 'LV Name\|LV Size'
echo -e "\n ==== Actualisation du système de fichiers... ==== "
resize2fs $lv_path

exit 0
