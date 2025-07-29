#!/usr/bin/env bash

# File path variables (configurable)
IDENTITIES_DIR="${IDENTITIES_DIR:-$HOME/FakeIdentity}"
DB="${IDENTITIES_DIR}/identities.csv"
NUMBERS_FILE="${NUMBERS_FILE:-$HOME/numbers.txt}"
ADDRESSES_FILE="${ADDRESSES_FILE:-$PWD/addresses.txt}"

# Colors
ORANGE='\033[38;5;214m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
RESET='\033[0m'

# Clear screen
clear

# Credits
echo "Signature: RussianBoy"
echo "This program uses the API of mail.tm to get the email of the user https://api.mail.tm"

# Banner (unchanged)
echo -e "$RED       ┌$RED- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ┐ $RESET"
echo -e "$RED       |$RED       ⢀⣤⡄⠀⠀⠀⠀⠀⠀ ⠀⢤⣤⡀                                                               ⠀⠀ ⠀|"
echo -e "   $RED    |    ⠀⠀⣰⣿⣿⠀⠀⠀⠀⠀⠀    ⢻⣿⣆⠀⠀                                                                |"
echo -e "   $RED    |    ⠀⣰⣿⣿⠃⠀⠀⠀⠀⠀     ⠈⣿⣿⣇⠀                                                                |"
echo -e "   $RED    |    ⢀⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀    ⢼⣿⣿⣿⡄                                                                |"
echo -e "   $RED    |    ⢸⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀  ⠀⣠⣿⣿⣿⣿⡇                                                                |"
echo -e "   $RED    |    ⠘⣿⣿⣿⣿⣿⣦      ⣼⣿⣿⣿⣿⣿⠇                                                                |"
echo -e "   $RED    |    ⠀⢿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⡟⠀                                                                 |"
echo -e "   $RED    |    ⠀⠀⠙⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠋⠀⠀                                                                 |"
echo -e "$RED       |$MAGENTA▄▄▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄   ▄ ▄▄▄▄▄▄▄ $ORANGE▄▄▄ ▄▄▄▄▄▄  ▄▄▄▄▄▄▄ ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄  $RED|"
echo -e "$RED       |$MAGENTA█       █      █   █ █ █       $ORANGE█   █      ██       █  █  █ █       █   █       █  █ █  █$RED|"
echo -e "$RED       |$MAGENTA█    ▄▄▄█  ▄   █   █▄█ █    ▄▄▄$ORANGE█   █  ▄    █    ▄▄▄█   █▄█ █▄     ▄█   █▄     ▄█  █▄█  █$RED|"
echo -e "$RED       |$MAGENTA█   █▄▄▄█ █▄█  █      ▄█   █▄▄▄$ORANGE█   █ █ █   █   █▄▄▄█       █ █   █ █   █ █   █ █       █$RED|"
echo -e "$RED       |$MAGENTA█    ▄▄▄█      █     █▄█    ▄▄▄$ORANGE█   █ █▄█   █    ▄▄▄█  ▄    █ █   █ █   █ █   █ █▄     ▄█$RED|"
echo -e "$RED       |$MAGENTA█   █   █  ▄   █    ▄  █   █▄▄▄$ORANGE█   █       █   █▄▄▄█ █ █   █ █   █ █   █ █   █   █   █  $RED|"
echo -e "$RED       |$MAGENTA█▄▄▄█   █▄█ █▄▄█▄▄▄█ █▄█▄▄▄▄▄▄▄$ORANGE█▄▄▄█▄▄▄▄▄▄██▄▄▄▄▄▄▄█▄█  █▄▄█ █▄▄▄█ █▄▄▄█ █▄▄▄█   █▄▄▄█  $RED|"
echo -e "$RED       └$RED- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ┘ $RESET"
echo ""
echo ""
echo ""
echo -e "   WELCOME, YOU CAN WRITE '${YELLOW}h${RESET}' TO RECEIVE A LIST OF COMMANDS...$RESET"
echo ""
echo ""
echo ""

# Check and install dependencies
check_and_install_dependencies() {
    local deps=("curl" "jq")
    local missing_deps=()
    local package_manager=""
    local os_type="$(uname -s)"

    # Detect package manager and OS
    if [ "$os_type" = "Linux" ]; then
        if command -v apt >/dev/null 2>&1; then
            package_manager="apt"
        elif command -v pkg >/dev/null 2>&1; then
            package_manager="pkg" # Termux
        else
            package_manager="unknown"
        fi
    elif [ "$os_type" = "MSYS_NT" ] || [ "$os_type" = "CYGWIN_NT" ] || [ "$os_type" = "MINGW" ]; then
        if command -v winget >/dev/null 2>&1; then
            package_manager="winget"
        else
            package_manager="manual"
        fi
    else
        package_manager="unknown"
    fi

    # Check for missing dependencies
    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done

    # Install missing dependencies
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}Missing dependencies: ${missing_deps[*]}${RESET}"
        # Check internet connectivity
        if ! ping -c 1 google.com >/dev/null 2>&1; then
            echo -e "${RED}Error: No internet connection. Please connect and try again.${RESET}"
            exit 1
        fi

        case "$package_manager" in
            "apt")
                echo -e "${YELLOW}Installing dependencies with apt...${RESET}"
                if apt update -y && apt install -y "${missing_deps[@]}"; then
                    echo -e "${GREEN}Successfully installed: ${missing_deps[*]}${RESET}"
                else
                    echo -e "${RED}Failed to install dependencies with apt. Please install ${missing_deps[*]} manually.${RESET}"
                    exit 1
                fi
                ;;
            "pkg")
                echo -e "${YELLOW}Installing dependencies with pkg (Termux)...${RESET}"
                if pkg install "${missing_deps[@]}" -y; then
                    echo -e "${GREEN}Successfully installed: ${missing_deps[*]}${RESET}"
                else
                    echo -e "${RED}Failed to install dependencies with pkg. Please install ${missing_deps[*]} manually.${RESET}"
                    exit 1
                fi
                ;;
            "winget")
                echo -e "${YELLOW}Installing dependencies with winget (Windows)...${RESET}"
                for dep in "${missing_deps[@]}"; do
                    if [ "$dep" = "curl" ]; then
                        winget install --id cURL.cURL --silent
                    elif [ "$dep" = "jq" ]; then
                        winget install --id jqlang.jq --silent
                    fi
                    if command -v "$dep" >/dev/null 2>&1; then
                        echo -e "${GREEN}Successfully installed $dep${RESET}"
                    else
                        echo -e "${RED}Failed to install $dep. Please install it manually.${RESET}"
                        exit 1
                    fi
                done
                ;;
            "manual")
                echo -e "${RED}No package manager detected on Windows. Please install manually:${RESET}"
                echo -e "${YELLOW}Download curl from https://curl.se/windows/ and jq from https://jqlang.github.io/jq/download/${RESET}"
                echo -e "${YELLOW}Add their paths to the system PATH environment variable.${RESET}"
                exit 1
                ;;
            *)
                echo -e "${RED}No supported package manager found. Please install manually: ${missing_deps[*]}${RESET}"
                echo -e "${YELLOW}For Termux: pkg install ${missing_deps[*]}${RESET}"
                echo -e "${YELLOW}For Windows: Download curl from https://curl.se/windows/ and jq from https://jqlang.github.io/jq/download/${RESET}"
                exit 1
                ;;
        esac
    fi
}

# Verify folders and files
verify_folders() {
    if [ ! -f "$NUMBERS_FILE" ]; then
        mkdir -p "$(dirname "$NUMBERS_FILE")"
        touch "$NUMBERS_FILE"
    fi

    if [ ! -d "$IDENTITIES_DIR" ]; then
        mkdir -p "$IDENTITIES_DIR"
    fi

    if [ ! -f "$DB" ]; then
        touch "$DB"
        echo "id,name,gmail,token,phone,addres" > "$DB"
    fi

    if [ ! -f "$ADDRESSES_FILE" ]; then
        echo -e "${RED}Error: addresses.txt not found at $ADDRESSES_FILE. Please provide the file or specify its path using ADDRESSES_FILE variable.${RESET}"
        exit 1
    fi
}

# Modified new_adress to handle file path variable
new_adress() {
    country_name=$(grep "^$random_number" "$NUMBERS_FILE" | awk '{$1=""; sub(/^ +/, ""); sub(/ +$/, ""); print}')
    if [ -z "$country_name" ]; then
        for prefix_length in 4 3 2 1; do
            prefix=${random_number:0:$prefix_length}
            country_name=$(grep "^$prefix" "$NUMBERS_FILE" | awk '{$1=""; sub(/^ +/, ""); sub(/ +$/, ""); print}')
            [ -n "$country_name" ] && break
        done
    fi

    if [ -z "$country_name" ]; then
        echo -e "${RED}Country not detected from phone number: $random_number${RESET}" >&2
        return 1
    fi

    address=$(awk -v RS="" -v country="--- $country_name ---" '
        $0 ~ country {
            gsub(/\r/, "")
            n = split($0, lines, "\n")
            for (i = 2; i <= n; i++) a[i-1] = lines[i]
            count = i - 1
            srand()
            print a[int(rand()*count)+1]
            exit
        }
    ' "$ADDRESSES_FILE")

    if [ -z "$address" ]; then
        echo -e "${RED}No address found for $country_name in $ADDRESSES_FILE${RESET}" >&2
        return 1
    fi
}

# Update paths in other functions
new_phone() {
    echo ""
    curl -s https://receive-smss.com | tr '\n' ' ' | tr -s ' ' | \
    grep -oP '<div class="number-boxes-itemm-number" style="color:black">\+\d+</div>|<div[^>]+class="number-boxes-item-country[^"]*"[^>]*>[^<]+' | \
    sed 's#<div class="number-boxes-itemm-number" style="color:black">##; s#</div>##; s#<div[^>]*>##; s#</div>##' | \
    paste - - > "$NUMBERS_FILE"

    mapfile -t countries < <(awk '{$1=""; sub(/^ +/, ""); print}' "$NUMBERS_FILE" | sort -u)
    echo -e "$ORANGE┌-------------------------┐"
    echo -e "$ORANGE|$BLUE     Choose a country:$ORANGE   |"
    echo "├-------------------------┤"
    for i in "${!countries[@]}"; do
      echo -e "$ORANGE $((i+1)).$GREEN ${countries[i]}"
    done
    echo -e "$ORANGE└-------------------------┘$RESET"

    read -rp "Choose the prefix: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#countries[@]} )); then
      echo -e "${RED}Invalid Option${RESET}"
      exit 1
    fi

    selected_country="${countries[choice-1]}"
    mapfile -t numbers < <(awk -v country="$selected_country" '
    {
      num = $1;
      $1 = "";
      sub(/^ +/, "");
      if ($0 == country) print num;
    }
    ' "$NUMBERS_FILE")

    if (( ${#numbers[@]} == 0 )); then
      echo -e "${RED}No numbers available for $selected_country${RESET}"
      exit 1
    fi

    random_number=${numbers[RANDOM % ${#numbers[@]}]}
    echo -e "${GREEN}Number: $random_number${RESET}"
}

save_in_DB() {
    get_next_id() {
      tail -n +2 "$DB" | awk -F',' '{print $1}' | sort -n | tail -1 | awk '{print $1 + 1}'
    }
    id=$(get_next_id)
    if [ -z "$id" ]; then id=1; fi
    echo "$id,$name,$EMAIL,$TOKEN,$random_number,$address" >> "$DB"
}

list_identities() {
    echo ""
    echo -e "${ORANGE}                                    =================⣠[List of Identities]⠦================${RESET}"
    echo ""
    printf "%-4s | %-30s | %-30s | %-5s | %-15s | %-40s\n" "ID" "Name" "Email" "Tok" "Phone" "Address"
    echo "---------------------------------------------------------------------------------------------------------------"
    tail -n +2 "$DB" | while IFS=',' read -r id name EMAIL TOKEN phone address; do
        printf "%-4s | %-30s | %-30s | %-5s | %-15s | %-40s\n" "$id" "$name" "$EMAIL" "TRUE" "$phone" "$address"
    done
    echo ""
    echo -e "${ORANGE}                                    =================⠲[   End of List   ]⠖=================${RESET}"
    echo ""
}

del_identity() {
    echo ""
    read -p "ID to delete: " id
    if [ -z "$id" ] || ! [[ "$id" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: ID must be a valid number.${RESET}"
        return 1
    fi
    if grep -q "^$id," "$DB"; then
        sed -i.bak "/^$id,/d" "$DB" # Create backup for safety
        echo -e "${GREEN}User with ID $id deleted successfully.${RESET}"
    else
        echo -e "${RED}Error: ID $id not found.${RESET}"
    fi
}

del_info() {
    grep "^$id," "$DB"
    EMAIL=""
    random_number=""
    address=""
    name=""
}

clean() {
    clear
}

modify_identity() {
    echo ""
    read -p "ID to modify: " id
    if [ -z "$id" ] || ! [[ "$id" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: The ID must be a valid number.${RESET}"
        return 1
    fi
    if ! grep -q "^$id," "$DB"; then
        echo -e "${RED}Error: ID $id not found.${RESET}"
        return 1
    fi

    line=$(grep "^$id," "$DB")
    IFS=',' read -r id name EMAIL TOKEN phone address <<< "$line"
    echo -e "${CYAN}Current information:${RESET}"
    printf "%-4s | %-30s | %-30s | %-15s | %-40s\n" "$id" "$name" "$EMAIL" "$phone" "$address"

    echo -e "${ORANGE}Select the field to modify:${RESET}"
    echo "1. Name"
    echo "2. Email"
    echo "3. Phone"
    echo "4. Address"
    read -p "Option (1-4): " field_choice

    case $field_choice in
        1)
            new_name
            sed -i.bak "s/^$id,[^,]*,\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\)/$id,$name,\1,\2,\3,\4/" "$DB"
            echo -e "${GREEN}Name updated successfully.${RESET}"
            ;;
        2)
            new_gmail
            sed -i.bak "s/^$id,\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\)/$id,\1,$EMAIL,$TOKEN,\4,\5/" "$DB"
            echo -e "${GREEN}Email updated successfully.${RESET}"
            ;;
        3)
            new_phone
            sed -i.bak "s/^$id,\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\)/$id,\1,\2,\3,$random_number,\5/" "$DB"
            echo -e "${GREEN}Phone updated successfully.${RESET}"
            ;;
        4)
            new_adress
            sed -i.bak "s/^$id,\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\)/$id,\1,\2,\3,\4,$address/" "$DB"
            echo -e "${GREEN}Address updated successfully.${RESET}"
            ;;
        *)
            echo -e "${RED}Invalid option.${RESET}"
            ;;
    esac
}

select1() {
    current_info() {
        line=$(grep "^$id," "$DB")
        IFS=',' read -r id name EMAIL TOKEN phone_number address <<< "$line"
        clean_number="${phone_number#+}"
    }

    help1() {
        echo ""
        echo -e "                                     $YELLOW┌ - - - - - - - - - - - - - - ┐"
        echo -e "                                     $YELLOW|       LIST OF COMMANDS      |"
        echo -e "                                     $YELLOW├ - - ┬ - - - - - - - - - - - ┤"
        echo -e "                                     $YELLOW|h    | ${CYAN}DISPLAY THIS MESSAGE  ${YELLOW}|"
        echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
        echo -e "                                     $YELLOW|ml   | ${CYAN}DISPLAY MAILBOX       ${YELLOW}|"
        echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
        echo -e "                                     $YELLOW|i    | ${CYAN}INFO OF USER          ${YELLOW}|"
        echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
        echo -e "                                     $YELLOW|d    | ${CYAN}DEL CURRENT IDENTITY  ${YELLOW}|"
        echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
        echo -e "                                     $YELLOW|q    | ${CYAN}TO GO BACK            ${YELLOW}|"
        echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
        echo -e "                                     $YELLOW|cl   | ${CYAN}CLEAR                 ${YELLOW}|"
        echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
        echo -e "                                     $YELLOW|ms   | ${CYAN}DISPLAY MESSAGES      ${YELLOW}|"
        echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
        echo -e "                                     $YELLOW|ch   | ${CYAN}CHANGE IDENTITY       ${YELLOW}|"
        echo -e "                                     $YELLOW└ - - ┴ - - - - - - - - - - - ┘$RESET"
    }

    mailbox() {
        curl -s -X GET "https://api.mail.tm/messages?_limit=5" \
        -H "Authorization: Bearer $TOKEN" | jq '.["hydra:member"][] | {id, from: .from.address, subject, intro}'
    }

    messages() {
        URL="https://receive-smss.com/sms/${clean_number}/"
        html=$(curl -s -A "Mozilla/5.0" "$URL" | tr '\n' ' ')
        echo "$html" | grep -oP '<div class="col-md-6 msgg".*?<label>Time</label><br>.*?</div>' | head -n 5 | while read -r block; do
            message=$(echo "$block" | grep -oP '<label>Message</label><br><span>.*?</span>' | sed -E 's/.*<span>//; s#</span>##; s/<[^>]*>//g')
            time=$(echo "$block" | grep -oP '<label>Time</label><br>[^<]*' | sed -E 's/.*<br>//')
            echo -e "📩 Message: $message\n🕒 Time: $time\n---"
        done
    }

    del_current() {
        if grep -q "^$id," "$DB"; then
            sed -i.bak "/^$id,/d" "$DB"
            echo -e "${GREEN}User with ID $id has been deleted.${RESET}"
        fi
    }

    echo ""
    echo ""
    list_identities
    read -p "ID: " id
    resultado=$(grep "^$id," "$DB")
    if [ "$id" == "q" ]; then
        init
    elif [ -z "$resultado" ]; then
        echo -e "${RED}No ID found.${RESET}"
        init
    fi
    current_info
    echo ""
    echo ""
    echo -e "WRITE '${ORANGE}h${RESET}' TO DISPLAY COMMAND PANEL "
    while true; do
        read -p "[s]>: " option
        if [ "$option" = "h" ]; then
            echo ""
            help1
            echo ""
        elif [ "$option" = "ml" ]; then
            echo -e "${CYAN}LAST 5 MESSAGES${RESET}"
            mailbox
        elif [ "$option" = "ms" ]; then
            echo -e "${CYAN}LAST 5 MESSAGES${RESET}"
            messages
        elif [ "$option" = "cl" ]; then
            clean
        elif [ "$option" = "q" ]; then
            break
        elif [ "$option" = "i" ]; then
            echo "$resultado"
        elif [ "$option" = "d" ]; then
            del_current
            break
        elif [ "$option" = "ch" ]; then
            select1
        else
            echo -e "${RED}INVALID OPTION${RESET}"
        fi
    done
}

new_name() {
    response=$(curl -s https://randomuser.me/api/?nat=mx)
    last_name1=$(echo "$response" | jq -r '.results[0].name.last')
    response2=$(curl -s https://randomuser.me/api/?nat=mx)
    last_name2=$(echo "$response2" | jq -r '.results[0].name.last')
    first_name=$(echo "$response" | jq -r '.results[0].name.first')
    name="$first_name $last_name1 $last_name2"
}

new_gmail() {
    domain=$(curl -s https://api.mail.tm/domains | jq -r '.["hydra:member"][0].domain')
    EMAIL="$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen 2>/dev/null || powershell -command '[guid]::NewGuid().ToString()' | cut -c1-10)@$domain"
    PASSWORD="RANDOMpassword010"
    curl -s -X POST https://api.mail.tm/accounts \
    -H "Content-Type: application/json" \
    -d "{\"address\": \"$EMAIL\", \"password\": \"$PASSWORD\"}" > /dev/null
    TOKEN=$(curl -s -X POST https://api.mail.tm/token \
      -H "Content-Type: application/json" \
      -d "{\"address\": \"$EMAIL\", \"password\": \"$PASSWORD\"}" | jq -r '.token')
}

cleanup() {
    if [ "$cleaning_state" = "false" ]; then
        cleaning_state=true
        echo ""
        echo -e "${YELLOW}[*] Cleaning up...${RESET}"
        sleep 2
        clear
        exit 0
    fi
}

init() {
    check_and_install_dependencies
    verify_folders
    cleaning_state=false
    while true; do
        echo -e "$GREEN"
        read -p ">>>  " choice
        case "$choice" in
            h)
                echo ""
                echo -e "                                     $YELLOW┌ - - - - - - - - - - - - - - ┐"
                echo -e "                                     $YELLOW|       LIST OF COMMANDS      |"
                echo -e "                                     $YELLOW├ - - ┬ - - - - - - - - - - - ┤"
                echo -e "                                     $YELLOW|h    | ${CYAN}DISPLAY THIS MESSAGE  ${YELLOW}|"
                echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
                echo -e "                                     $YELLOW|c    | ${CYAN}CREATE A NEW IDENTITY ${YELLOW}|"
                echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
                echo -e "                                     $YELLOW|l    | ${CYAN}LIST IDENTITIES       ${YELLOW}|"
                echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
                echo -e "                                     $YELLOW|d    | ${CYAN}DELETE AN IDENTITY    ${YELLOW}|"
                echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
                echo -e "                                     $YELLOW|q    | ${CYAN}TO EXIT THE PROGRAM   ${YELLOW}|"
                echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
                echo -e "                                     $YELLOW|cl   | ${CYAN}CLEAR                 ${YELLOW}|"
                echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
                echo -e "                                     $YELLOW|s    | ${CYAN}SELECT AN IDENTITY    ${YELLOW}|"
                echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
                echo -e "                                     $YELLOW|m    | ${CYAN}MODIFY AN IDENTITY    ${YELLOW}|"
                echo -e "                                     $YELLOW└ - - ┴ - - - - - - - - - - - ┘$RESET"
                ;;
            q)
                cleanup
                ;;
            c)
                verify_folders
                new_name
                new_gmail
                new_phone
                new_adress
                save_in_DB
                del_info
                ;;
            l)
                list_identities
                ;;
            d)
                del_identity
                ;;
            cl)
                clean
                ;;
            s)
                select1
                ;;
            m)
                list_identities
                modify_identity
                ;;
            *)
                echo ""
                echo -e "${RED}OPTION NOT VALID${RESET}"
                echo -e "$RESET"
                ;;
        esac
    done
}

trap cleanup SIGINT SIGTERM
init