#!/bin/sh

INTERFACE=$1
ACTION=$2
SSID='111111TMU'
CONFIG_FILE="$HOME/Projects/111111fastlogin/config.conf"
LOG_FILE="$HOME/Projects/111111fastlogin/111111fastlogin.log"

LOGIN_ID=''
LOGIN_PASSWORD=''

### 日時付きでログファイルへ流し込む
exec &> >(awk '{print strftime("[%Y/%m/%d %H:%M:%S] "),$0 } { fflush() } ' >> $LOG_FILE)

echo "プログラムを開始しました。"

### 設定ファイルの読み込み
if [ ! -f $CONFIG_FILE ]; then
    echo "設定ファイルが見つかりませんでした。"
    exit 1
fi

while IFS= read -r line || [ -n "$line" ]; do
    key=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2)

    if [ "$key" = "LOGIN_ID" ]; then
        LOGIN_ID="$value"
    fi

    if [ "$key" = "LOGIN_PASSWORD" ]; then
        LOGIN_PASSWORD="$value"
    fi
done < "$CONFIG_FILE"

### POSTする
# if [ "$INTERFACE" = "wlp2s0" ] && [ "$ACTION" = "up" ]; then
    CURRENT_SSID=$(iwgetid -r)
    if [ "$CURRENT_SSID" = "$SSID" ]; then
        curl -X POST -d "name=$LOGIN_ID&pass=$LOGIN_PASSWORD" https://gnml.tmu.ac.jp:10040/cgi-bin/adeflogin.cgi
    fi
# fi
