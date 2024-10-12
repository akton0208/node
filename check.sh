
#!/bin/bash

# 返回主菜單的函數
function return_to_menu() {
    read -p "按任意鍵返回主菜單..." -n1 -s
    main_menu
}

# 選項1: 查看 NILLION 驗證者日誌
function view_nillion_logs() {
    echo "查看 NILLION 驗證者日誌..."
    if ! docker logs -f nillion_verifier --tail 100; then
        echo "無法查看 NILLION 驗證者日誌。請檢查 Docker 容器是否正在運行。"
    fi
    return_to_menu
}

# 選項2: 查看 VOI 狀態
function get_voi_status() {
    echo "查看 VOI 狀態..."
    if ! ~/voi/bin/get-node-status; then
        echo "無法查看 VOI 狀態。請檢查 VOI 是否正確安裝。"
    fi
    return_to_menu
}

# 選項3: 查看 SONARIC 信息
function get_sonaric_info() {
    echo "查看 SONARIC 信息..."
    if ! sonaric node-info; then
        echo "無法查看 SONARIC 信息。請檢查 SONARIC 是否正確安裝。"
    fi
    return_to_menu
}

# 選項4: 查看 Elixir V3 驗證者信息
function view_elixir_v3_logs() {
    echo "查看 Elixir V3 驗證者信息..."
    if ! docker logs -f v3; then
        echo "無法查看 Elixir V3 驗證者信息。請檢查 Elixir V3 容器是否正在運行。"
    fi
    return_to_menu
}

# 選項5: 查看 Rivalz 信息
function get_rivalz_info() {
    echo "查看 Rivalz 信息..."
    if ! rivalz info; then
        echo "無法查看 Rivalz 信息。請檢查 Rivalz 是否正確安裝。"
    fi
    return_to_menu
}

# 主菜單
function main_menu() {
    clear
    echo "請選擇一個選項："
    echo "1. 查看 NILLION 驗證者日誌"
    echo "2. 查看 VOI 狀態"
    echo "3. 查看 SONARIC 信息"
    echo "4. 查看 Elixir V3 驗證者信息"
    echo "5. 查看 Rivalz 信息"
    echo "6. 退出"
    read -p "輸入選項號碼 (1-6): " option

    case $option in
        1) view_nillion_logs ;;
        2) get_voi_status ;;
        3) get_sonaric_info ;;
        4) view_elixir_v3_logs ;;
        5) get_rivalz_info ;;
        6) exit 0 ;;
        *) echo "無效的選項，請輸入1到6之間的數字。" 
           return_to_menu ;;
    esac
}

# 啟動主菜單
main_menu
