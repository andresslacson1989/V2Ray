#!/bin/bash
#install default user
clear
source /var/lib/crot/ipvps.conf
$IP=""
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
uuid=$(cat /proc/sys/kernel/random/uuid)
user="bytes"
duration="9999"
exp=`date -d "$duration days" +"%Y-%m-%d"`
sed -i '/#trojanws$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#trojangrpc$/a\#! '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

sed -i '/#vless$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vlessgrpc$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

sed -i '/#vmess$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#vmessgrpc$/a\#& '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json


#
systemctl restart xray
#buatvless
vlesslinkws="vless://${uuid}@${domain}:443?path=/xrayws&security=tls&encryption=none&type=ws#${user}"
vlesslinknon="vless://${uuid}@${domain}:80?path=/xrayws&encryption=none&type=ws#${user}"
vlesslinkgrpc="vless://${uuid}@${domain}:443?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${user}"

#buattrojan
trojanlinkgrpc="trojan://${uuid}@${domain}:443?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${user}"
trojanlinkws="trojan://${uuid}@${domain}:443?path=/xraytrojanws&security=tls&host=bug.com&type=ws&sni=bug.com#${user}"

#buatshadowsocks
#
cipher="aes-128-gcm"
sed -i '/#ssws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /etc/xray/config.json
sed -i '/#ssgrpc$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","method": "'""$cipher""'","email": "'""$user""'"' /etc/xray/config.json
echo $cipher:$uuid > /tmp/log
shadowsocks_base64=$(cat /tmp/log)
echo -n "${shadowsocks_base64}" | base64 > /tmp/log1
shadowsocks_base64e=$(cat /tmp/log1)
shadowsockslink="ss://${shadowsocks_base64e}@$domain:$tls?plugin=xray-plugin;mux=0;path=/xrayssws;host=$domain;tls#${user}"
shadowsockslink1="ss://${shadowsocks_base64e}@$domain:$tls?plugin=xray-plugin;mux=0;serviceName=ss-grpc;host=$domain;tls#${user}"
systemctl restart xray
rm -rf /tmp/log
rm -rf /tmp/log1
cat > /home/vps/public_html/ss-ws-$user.txt <<-END
{
 "dns": {
    "servers": [
      "8.8.8.8",
      "8.8.4.4"
    ]
  },
 "inbounds": [
   {
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "none"
  },
  "outbounds": [
    {
      "mux": {
        "enabled": true
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "$domain",
            "level": 8,
            "method": "$cipher",
            "password": "$uuid",
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "isi_bug_disini"
        },
        "wsSettings": {
          "headers": {
            "Host": "$domain"
          },
          "path": "/xrayssws"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "policy": {
    "levels": {
      "8": {
        "connIdle": 300,
        "downlinkOnly": 1,
        "handshake": 4,
        "uplinkOnly": 1
      }
    },
    "system": {
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "Asls",
"rules": []
  },
  "stats": {}
}
END
cat > /home/vps/public_html/ss-grpc-$user.txt <<-END
{
    "dns": {
    "servers": [
      "8.8.8.8",
      "8.8.4.4"
    ]
  },
 "inbounds": [
   {
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "none"
  },
  "outbounds": [
    {
      "mux": {
        "enabled": true
      },
      "protocol": "shadowsocks",
      "settings": {
        "servers": [
          {
            "address": "$domain",
            "level": 8,
            "method": "$cipher",
            "password": "$uuid",
            "port": 443
          }
        ]
      },
      "streamSettings": {
        "grpcSettings": {
          "multiMode": true,
          "serviceName": "ss-grpc"
        },
        "network": "grpc",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "isi_bug_disini"
        }
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {},
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "policy": {
    "levels": {
      "8": {
        "connIdle": 300,
        "downlinkOnly": 1,
        "handshake": 4,
        "uplinkOnly": 1
      }
    },
    "system": {
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  },
  "routing": {
    "domainStrategy": "Asls",
"rules": []
  },
  "stats": {}
}
END

#
#buatvmess
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /etc/log-create-user.log
echo -e "====== XRAY MANTAP Multi Port=======" | tee -a /etc/log-create-user.log
echo -e "INFORMASI AKUN VPN XRAY" | tee -a /etc/log-create-user.log
echo -e "IP: $MYIP" | tee -a /etc/log-create-user.log
echo -e "Host/Domain: $domain" | tee -a /etc/log-create-user.log
echo -e "Password/ID: $uuid" | tee -a /etc/log-create-user.log
echo -e "====== Service Port =======" | tee -a /etc/log-create-user.log
echo -e "Websocket TLS  : 443" | tee -a /etc/log-create-user.log
echo -e "Websocket HTTP : 80" | tee -a /etc/log-create-user.log
echo -e "GRPC TLS       : 443" | tee -a /etc/log-create-user.log
echo -e "*Note OPOK: opok only supports coremeta"
echo -e "*Note SHADOWSOCKS: gunakan custom config atau plugin xray"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /etc/log-create-user.log

echo -e "Protokol VPN: TROJAN" | tee -a /etc/log-create-user.log
echo -e "Network: WS/GRPC" | tee -a /etc/log-create-user.log
echo -e "====== Path =======" | tee -a /etc/log-create-user.log
echo -e "=> WS TLS : /xraytrojanws" | tee -a /etc/log-create-user.log
echo -e "=> GRPC   : trojan-grpc" | tee -a /etc/log-create-user.log
echo -e "=> OPOK   : ws://bugcom/xraytrojanws" | tee -a /etc/log-create-user.log
echo -e "====== Import Config From Clipboard =======" | tee -a /etc/log-create-user.log
echo -e "Link Config WS TLS   : $trojanlinkws" | tee -a /etc/log-create-user.log
echo -e "Link Config GRPC TLS : $trojanlinkgrpc" | tee -a /etc/log-create-user.log
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /etc/log-create-user.log

echo -e "Protokol VPN: SHADOWSOCKS" | tee -a /etc/log-create-user.log
echo -e "Network: WS/GRPC" | tee -a /etc/log-create-user.log
echo -e "Method Cipers : aes-128-gcm" | tee -a /etc/log-create-user.log
echo -e "====== Path =======" | tee -a /etc/log-create-user.log
echo -e "=> WS TLS : /xrayssws" | tee -a /etc/log-create-user.log
echo -e "=> GRPC   : ss-grpc" | tee -a /etc/log-create-user.log
echo -e "=> OPOK   : ws://bugcom/xrayssws" | tee -a /etc/log-create-user.log
echo -e "======Custom Import Config From URL =======" | tee -a /etc/log-create-user.log
echo -e "URL Custom Config WS TLS   : http://${domain}:89/ss-ws-$user.txt" | tee -a /etc/log-create-user.log
echo -e "URL Custom Config GRPC TLS : http://${domain}:89/ss-grpc-$user.txt" | tee -a /etc/log-create-user.log
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /etc/log-create-user.log

echo -e "Protokol VPN: VLESS" | tee -a /etc/log-create-user.log
echo -e "Network: WS/GRPC" | tee -a /etc/log-create-user.log
echo -e "====== Path =======" | tee -a /etc/log-create-user.log
echo -e "=> WS TLS : /xrayws" | tee -a /etc/log-create-user.log
echo -e "=> GRPC   : vless-grpc" | tee -a /etc/log-create-user.log
echo -e "=> OPOK   : ws://bugcom/xrayws" | tee -a /etc/log-create-user.log
echo -e "====== Import Config From Clipboard =======" | tee -a /etc/log-create-user.log
echo -e "Link Config WS TLS    : $vlesslinkws" | tee -a /etc/log-create-user.log
echo -e "Link Config GRPC TLS  : $vlesslinkgrpc" | tee -a /etc/log-create-user.log
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /etc/log-create-user.log
echo -e "Protokol VPN: VMESS" | tee -a /etc/log-create-user.log
echo -e "Alter ID: 0" | tee -a /etc/log-create-user.log
echo -e "Network: WS/GRPC" | tee -a /etc/log-create-user.log
echo -e "====== Path =======" | tee -a /etc/log-create-user.log
echo -e "=> WS TLS : /xrayvws" | tee -a /etc/log-create-user.log
echo -e "=> GRPC   : vmess-grpc" | tee -a /etc/log-create-user.log
echo -e "=> OPOK   : ws://bugcom/xrayvws" | tee -a /etc/log-create-user.log
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a /etc/log-create-user.log
echo -e "SCRIPT MANTAP XRAY" | tee -a /etc/log-create-user.log
echo "" | tee -a /etc/log-create-user.log
cd