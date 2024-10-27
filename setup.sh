#!/bin/bash

echo "請選擇一個選項："
echo "1. 下載並執行 akvana2.sh"
echo "2. 下載並執行 akv3.sh"
echo "3. 下載並執行 aknexus.sh"
echo "4. 下載並執行 akbrinxai.sh"
echo "5. 下載並執行 root.sh"
echo "6. 下載並執行 akvanaakc.sh"
echo "7. 退出"

read -p "輸入選項號碼: " option

case $option in
    1)
        wget -O akvana2.sh https://raw.githubusercontent.com/akton0208/node/main/akvana2.sh
        chmod +x akvana2.sh
        ./akvana2.sh
        ;;
    2)
        wget -O v3.sh https://raw.githubusercontent.com/akton0208/node/main/akv3.sh
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
        wget -O root.sh https://raw.githubusercontent.com/akton0208/node/main/root.sh
        chmod +x root.sh
        ./root.sh
        ;;
    6)
        wget -O akvanaakc.sh https://raw.githubusercontent.com/akton0208/node/main/akvanaakc.sh
        chmod +x akvanaakc.sh
        ./akvanaakc.sh
        ;;
    7)
        echo "退出程序"
        exit 0
        ;;
    *)
        echo "無效的選項，請重新運行腳本並選擇有效的選項。"
        ;;
esac
