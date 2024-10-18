#!/bin/bash

echo "請選擇一個選項："
echo "1. 下載並執行 akvana.sh"
echo "2. 下載並執行 v3.sh"
echo "3. 下載並執行 aknexus.sh"
echo "4. 下載並執行 akbrinxai.sh"
echo "5. 退出"

read -p "輸入選項號碼: " option

case $option in
    1)
        wget -O akvana.sh https://raw.githubusercontent.com/akton0208/node/main/akvana.sh
        chmod +x akvana.sh
        ./akvana.sh
        ;;
    2)
        wget -O v3.sh https://raw.githubusercontent.com/akton0208/node/main/v3.sh
        chmod +x v3.sh
        ./v3.sh
        ;;
    3)
        wget -O aknexus.sh https://raw.githubusercontent.com/akton0208/node/main/aknexus.sh
        chmod +x aknexus.sh
        ./aknexus.sh
        ;;
    4)
        wget -O akbrinxai.sh https://raw.githubusercontent.com/akton0208/node/main/akbrinxai.sh
        chmod +x akbrinxai.sh
        ./akbrinxai.sh
        ;;
    5)
        echo "退出程序"
        exit 0
        ;;
    *)
        echo "無效的選項，請重新運行腳本並選擇有效的選項。"
        ;;
esac
