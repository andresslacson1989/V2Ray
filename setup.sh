#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
export DEBIAN_FRONTEND=noninteractive
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# =========================================
#Domain
DOMAIN="https://panel.meteorvpn.site"
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
IZIN=$(wget -qO- ipinfo.io/ip);
clear
mkdir /var/lib/akbarstorevpn;
mkdir /var/lib/crot;
mkdir /etc/xray;
echo "IP=" >> /var/lib/crot/ipvps.conf
echo "IP=" >> /var/lib/akbarstorevpn/ipvps.conf
cd
#
# Add Domain
apt install -y curl;
curl -sb -X POST $DOMAIN/api/server/install -H "Content-Type: application/x-www-form-urlencoded" -d "status=Domain&ip=$MYIP"
wget https://raw.githubusercontent.com/andresslacson1989/V2Ray/main/updated/adddomain.sh && chmod +x adddomain.sh && ./adddomain.sh
#
#install tools/alat
curl -sb -X POST $DOMAIN/api/server/install -H "Content-Type: application/x-www-form-urlencoded" -d "status=Tools&ip=$MYIP"
wget https://raw.githubusercontent.com/andresslacson1989/V2Ray/main/install-tools.sh && chmod +x install-tools.sh && ./install-tools.sh
#
#Instal Xray
curl -sb -X POST $DOMAIN/api/server/install -H "Content-Type: application/x-www-form-urlencoded" -d "status=V2Ray&ip=$MYIP"
wget https://raw.githubusercontent.com/andresslacson1989/V2Ray/main/install-xray.sh && chmod +x install-xray.sh && ./install-xray.sh
#install xmenu
curl -sb -X POST $DOMAIN/api/server/install -H "Content-Type: application/x-www-form-urlencoded" -d "status=Finalizing&ip=$MYIP"
wget https://raw.githubusercontent.com/andresslacson1989/V2Ray/main/menu/updatedll.sh && chmod +x updatedll.sh && ./updatedll.sh
#
#install config for default user
#rm /etc/xray/config.json
wget https://raw.githubusercontent.com/andresslacson1989/V2Ray/main/files/user.sh && chmod +x user.sh && ./user.sh
rm user.sh
#SELESAI
# collor statusf
error1="${RED} [ERROR] ${NC}"
success="${GREEN} [OK] ${NC}"
# Cek Domain
source /var/lib/akbarstorevpn/ipvps.conf
if [[ "$IP" = "" ]]; then
	clear
    echo -e " ${error1}Installation Failed!!"
	rm -rf updatedll
	rm -rf updatedll.sh
	rm -rf setup.sh
	rm -rf install-xray.sh
	rm -rf install-tools.sh
	rm -rf adddomain.sh
	echo " Reboot 15 Sec"
	sleep 15
	reboot
else
	clear
	echo "${success}Installation has been completed!!"
	sleep 3
	clear
	echo " "
	echo "============================================================================" | tee -a log-install.txt
	echo "" | tee -a log-install.txt
	echo "----------------------------------------------------------------------------" | tee -a log-install.txt
	echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"  | tee -a log-install.txt
	echo -e "    SCRIPT MANTAP-XRAY Multi Port"  | tee -a log-install.txt
	echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"  | tee -a log-install.txt
	echo ""  | tee -a log-install.txt
	echo "   >>> Service & Port"  | tee -a log-install.txt
	echo "   - Nginx                      : 89"  | tee -a log-install.txt
	echo "   - XRAYS TROJAN WS TLS        : 443"  | tee -a log-install.txt
	echo "   - XRAYS SHADOWSOCKS WS TLS   : 443"  | tee -a log-install.txt
	echo "   - XRAYS VLESS WS TLS         : 443"  | tee -a log-install.txt
	echo "   - XRAYS VMESS WS TLS         : 443"  | tee -a log-install.txt
	echo "   - XRAYS TROJAN WS HTTP       : 80"  | tee -a log-install.txt
	echo "   - XRAYS SHADOWSOCKS WS HTTP  : 80"  | tee -a log-install.txt
	echo "   - XRAYS VLESS WS HTTP        : 80"  | tee -a log-install.txt
	echo "   - XRAYS VMESS WS HTTP        : 80"  | tee -a log-install.txt
	echo "   - XRAYS TROJAN GRPC          : 443"  | tee -a log-install.txt
	echo "   - XRAYS SHADOWSOCKS GRPC     : 443"  | tee -a log-install.txt
	echo "   - XRAYS VMESS GRPC           : 443"  | tee -a log-install.txt
	echo "   - XRAYS VLESS GRPC           : 443"  | tee -a log-install.txt
	echo ""  | tee -a log-install.txt
	echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
	echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
	echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
	echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
	echo "   - IPtables                : [ON]"  | tee -a log-install.txt
	echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
	echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
	echo "   - Autoreboot On 05.00 GMT +7" | tee -a log-install.txt
	echo "   - Autobackup Data" | tee -a log-install.txt
	echo "   - Restore Data" | tee -a log-install.txt
	echo "   - Auto Delete Expired Account" | tee -a log-install.txt
	echo "   - Full Orders For Various Services" | tee -a log-install.txt
	echo "   - White Label" | tee -a log-install.txt
	echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
 curl -sb -X POST $DOMAIN/api/server/install -H "Content-Type: application/x-www-form-urlencoded" -d "status=Rebooting&ip=$MYIP"
	echo " Reboot 15 Sec"
 curl -sb -X POST $DOMAIN/api/server/install -H "Content-Type: application/x-www-form-urlencoded" -d "status=done&ip=$MYIP"
	sleep 15
	cd
	rm -rf updatedll
	rm -rf updatedll.sh
	rm -rf setup.sh
	rm -rf install-xray.sh
	rm -rf install-tools.sh
	rm -rf adddomain.sh
	sleep 1
	reboot
fi
