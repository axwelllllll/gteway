# Etape 1 : Template

## Installation debian 

Je crée une nouvelle machine en debian sur VirtualBox

### Type de VM 
Je choisi l'option Install pour ne pas créer d'interface graphique a ma VM

### Langue
Je choisi la langue "English"

### Localisation
Je choisi de me localiser aux Etat-Unis car c'est l'option que l'on nous avait demander lors de la piscine

### Clavier
Je choisi de prendre la Keymap en France pour avoir un clavier en Azerty

### Hostname, Domain name et Root password
On me demande de donner un nom a mon Host, a un domaine et un mot de passe. Je choisi template comme nom d'hote, laisse vide le nom de domaine et entre mon mot de passe

### Full name, username et mot de passe de l'utilisateur
Je crée un profil utilisateur au quel je donne Maxime comme nom, maxime en pseudonyme et un mot de passe

### Fuseau horaire
Je choisi de mettre ma boussole en "Eastern"

### Disk partition
Je choisi comme options : "Guided - Use the entire disk"
puis "SCSI1 (0,0,0)  (sda) - 8.6 GB ATA VBOX HARDDISK"
et enfin "All files in one partition (recommended for new users)"

### Finalisations
Je choisi premierement United States puis ftp.us.debian.org. Je laisse le proxy vide

# Etape 2 : Clone 

## Gateway

Je clone une premiere fois ma VM template en lui donnant le nom "Gateway"

### Cartes réseaux

Je met la premiere carte reseau de Gateway en host-only
J'ajoute une seconde carte que je met en bridged 

## Web, Manager

Je crée ensuite deux nouveaux clones sur lesquels je met une carte réseau en host-only.
# Etape 2.1 : Hostname

Je modifie les fichier /etc/hosts et /etc/hostname pour changer les hostname de mes vm et leur donner le bon.

# Etape 3 : IP

## Gateway

### Statique

Je lance ma gateway, et j'ouvre le fichier de configuration réseau /etc/network/interfaces

Je retire les lignes déjà présentes pour y mettre les suivante : 

"source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

auto enp0s3
 iface enp0s3 inet static
		address 192.168.0.2
		netmask 255.255.255.128

 auto enp0s8
 iface enp0s8 inet dhcp"

Je choisi de mettre un netmask a 255.255.255.128 car je dois etre capable d'acceuillir 100 clients en plus des mes serveurs et qu'avec ce mask j'ai acces a 128 ips.

### Redemmarage du service /etc/init.d/networking

Je rentre la commande /etc/init.d/networking restart, qui me permet de redemmarer le service et de verifier si mes changements sont bien pris en compte et fonctionnel.

Je reçois la reponse: [ok] Restarting networking (via systemctl): networking.service

## Web

### /etc/network/interfaces

Je lance ensuite la VM "Web" et j'ouvre a nouveau le fichier /etc/network/interfaces

dans lequel je met cette fois ci : 

"auto enp0s3
 iface enp0s3 inet static
		address 192.168.0.5
		netmask 255.255.255.128
		gateway 192.168.0.2"

### /etc/inti.d/networking

Je rentre la commande /etc/init.d/network restart a nouveau et obtient a nouveau la reponsé : [ok] Restarting networking (via systemctl): networking.service. Encore une

## Manager

Je répete l'action pour la derniere VM Manager en remplacant la ligne "address" par l'ip qui est attribuée a Manager.

# Etape 4 : Script IP

J'écris les scripts destinés a modifier les fichiers /etc/network/interfaces de chacune de mes vm que je nomme main.sh et que je met dans le dossiers qui leur est déstiné.

# Etape 5 : Enregistement des iptables et interface

## Modification de /etc/network/interfaces

En dessous du netmask, j'ai ajouter les lignes :
-post-up iptables-restore 
-allow-hotplug enp0s8
-iface enp0s8 inet dhcp

## Iptables

Sur la vm gateway, je crée des iptables avec les commandes: 
"sudo iptables -F"
"sudo iptables -t nat -F"
"sudo iptables -t mangle -F "
"sudo iptables -X"

et enfin, avec la commande "sudo iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE"

Je met le postrouting enp0s8 car c'est avec cette ip que je me connecte a internet

# Etape 6 : Mise en place du serveur DHCP sur Manager  

## Installation du serveur DHCP

Avec la commande "sudo apt-get install isc-dhcp-server", j'installer le serveur DHCP sur la VM Manager

## Configuration

Je me rend ensuite dans le fichier /etc/dhcp/dhcpd.conf et je modifie les lignes 7 et 8 avec : 

"option domain-name "res1.local"
"option domain-name-server 192.168.0.3"




















