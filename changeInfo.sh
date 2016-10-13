#!/bin/bash
echo "Dans quel subnet va se trouver la machine ?"
echo "1) 164.132.82.32/27"
echo "2) 37.59.237.160/27 "
read choice

if [ $choice -eq 1 ]
then

echo "Renseigner l'adresse IP du serveur"
    read ip_addr

    cat >> /etc/network/interfaces << _EOF_
    auto eth0
      iface eth0 inet static
        address $ip_addr
        netmask 255.255.255.224
        network 164.132.82.32
        broadcast 164.132.82.63
        gateway 164.132.82.62

        dns-nameservers 213.186.33.99
        dns-search itserver.fr

_EOF_

elif [ $choice -eq 2 ]
then

     echo "Renseigner l'adresse IP du serveur"
     read ip_addr

             cat >> /etc/network/interfaces << _EOF_
          auto eth0
          iface eth0 inet static
          address $ip_addr
          netmask 255.255.255.224
          network 37.59.237.160
          broadcast 37.59.237.191
          gateway 37.59.237.190


          dns-nameservers 213.186.33.99
          dns-search itserver.fr

_EOF_

else

  echo "Choisir une bonne option"
  exit 1

fi

echo "Renseigner le nom de la machine"
read name
echo "${name}" > /etc/hostname
sed -i 's/template/'"${name}"'/g' /etc/hosts
service hostname.sh
echo "Renseigner le nouveau mot de passe root"
read -s root_password

while [ "${root_password}" != "${root_password2}" ]
do
   echo -e "Password don't match\n"
   echo "Mot de passe UNIX pour root"
   read -s root_password
   echo "Confirmer le mot de passe"
   read -s root_password2
done
echo "root:$root_password" | chpasswd

echo "Think to ifup eth0"
exit 0
