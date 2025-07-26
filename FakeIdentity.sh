#!/usr/bin/bash

#EXECUTE AS SUDO
if [ "$EUID" -ne 0 ]; then
  echo "🔐 Este script necesita permisos de administrador. Ejecutando con sudo..."
  exec sudo "$0" "$@"
  exit
fi

#COLORS
ORANGE='\033[38;5;214m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
RESET='\033[0m'

#clear
clear

#CREDITS
echo "Signature: RussianBoy"
echo "This program use the API of mail.tm to get the email of the user https://api.mail.tm "

#BANNER
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

#HOME
cleaning_state=false
DB=/etc/FakeIdentity/identities.csv 


check_and_install_dependencies() {
    local deps=("curl" "jq")
    local missing_deps=()
    local package_manager=""

    # Detect package manager
    if command -v apt >/dev/null 2>&1; then
        package_manager="apt"
    else
        package_manager="unknown"
    fi

    # Check each dependency silently
    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done

    # Install missing dependencies if any
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${YELLOW}Missing dependencies detected: ${missing_deps[*]}${RESET}"
        if [ "$package_manager" = "apt" ]; then
            # Check internet connectivity
            if ! ping -c 1 google.com >/dev/null 2>&1; then
                echo -e "${RED}Error: No internet connection. Please connect to the internet and try again.${RESET}"
                exit 1
            fi
            echo -e "${YELLOW}Installing dependencies: ${missing_deps[*]}${RESET}"
            # Update package list and install silently
            if sudo apt update -y >/dev/null 2>&1 && sudo apt install -y "${missing_deps[@]}" >/dev/null 2>&1; then
                echo -e "${GREEN}Successfully installed dependencies: ${missing_deps[*]}${RESET}"
                # Verify installation
                for cmd in "${missing_deps[@]}"; do
                    if ! command -v "$cmd" >/dev/null 2>&1; then
                        echo -e "${RED}Error: Failed to install $cmd. Please install it manually.${RESET}"
                        exit 1
                    fi
                done
            else
                echo -e "${RED}Error: Failed to install dependencies using apt. Please install ${missing_deps[*]} manually.${RESET}"
                exit 1
            fi
        else
            echo -e "${RED}No supported package manager (apt) found. Please install manually: ${missing_deps[*]}${RESET}"
            echo -e "${YELLOW}For example, on Fedora use: sudo dnf install ${missing_deps[*]}${RESET}"
            echo -e "${YELLOW}On macOS with Homebrew use: brew install ${missing_deps[*]}${RESET}"
            exit 1
        fi
    fi
}

init(){
    while true
    do
        echo -e "$GREEN"
        read -p ">>>  " choice

        if [ "$choice" == "h" ]; then
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
            echo -e "                                     $YELLOW|cl   | ${CYAN}CLEAR                 ${YELLOW}|"
            echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
            echo -e "                                     $YELLOW|m    | ${CYAN}MODIFY AN IDENTITY    ${YELLOW}|"
            echo -e "                                     $YELLOW└ - - ┴ - - - - - - - - - - - ┘$RESET"

        elif [ "$choice" == "q" ]; then
            cleanup

        elif [ "$choice" == "c" ]; then
            verify_folders
            new_name
            new_gmail
            new_phone
            new_adress
            save_in_DB
            del_info
        
        elif [ "$choice" == "l" ]; then
            list_identities

        elif [ "$choice" == "d" ]; then
            del_identity

        elif [ "$choice" == "cl" ]; then
            clean

        elif [ "$choice" == "s" ]; then
            select1

        elif [ "$choice" == "m" ]; then
            list_identities
            modify_identity

        else
            echo ""
            echo -e "$RED OPTION NOT VALID"
            echo -e "$RESET"
        fi

    done
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

    # Display current information
    line=$(grep "^$id," "$DB")
    IFS=',' read -r id name EMAIL TOKEN phone address <<< "$line"
    echo -e "${CYAN}Current information:${RESET}"
    printf "%-4s | %-30s | %-30s | %-15s | %-40s\n" "$id" "$name" "$EMAIL" "$phone" "$address"

    # Menu to choose what to modify
    echo -e "${ORANGE}Select the field to modify:${RESET}"
    echo "1. Name"
    echo "2. Email"
    echo "3. Phone"
    echo "4. Address"
    read -p "Option (1-4): " field_choice

    case $field_choice in
        1)
            new_name
            sed -i "s/^$id,[^,]*,\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\)/$id,$name,\1,\2,\3,\4/" "$DB"
            echo -e "${GREEN}Name updated successfully.${RESET}"
            ;;
        2)
            new_gmail
            sed -i "s/^$id,\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\)/$id,\1,$EMAIL,$TOKEN,\4,\5/" "$DB"
            echo -e "${GREEN}Email updated successfully.${RESET}"
            ;;
        3)
            new_phone
            sed -i "s/^$id,\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\)/$id,\1,\2,\3,$random_number,\5/" "$DB"
            echo -e "${GREEN}Phone updated successfully.${RESET}"
            ;;
        4)
            new_adress
            sed -i "s/^$id,\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\)/$id,\1,\2,\3,\4,$address/" "$DB"
            echo -e "${GREEN}Address updated successfully.${RESET}"
            ;;
        *)
            echo -e "${RED}Invalid option.${RESET}"
            ;;
    esac
}

#VERIFY
verify_folders(){
    if [ ! -e "/tmp/numbers.txt" ]; then
        touch /tmp/numbers.txt
    fi

    if [ ! -d "/etc/FakeIdentity/" ]; then
        mkdir "/etc/FakeIdentity/"
    fi

    if [ ! -f "/etc/FakeIdentity/identities.csv" ]; then
        touch "/etc/FakeIdentity/identities.csv"
        echo "id,name,gmail,token,phone,addres" >> "/etc/FakeIdentity/identities.csv"
    fi

}

new_name(){
    response=$(curl -s https://randomuser.me/api/?nat=mx)
    last_name1=$(echo "$response" | jq -r '.results[0].name.last')

    response2=$(curl -s https://randomuser.me/api/?nat=mx)
    last_name2=$(echo "$response2" | jq -r '.results[0].name.last')

    first_name=$(echo "$response" | jq -r '.results[0].name.first')

    name="$first_name $last_name1 $last_name2"
    
}

new_gmail(){
    domain=$(curl -s https://api.mail.tm/domains | jq -r '.["hydra:member"][0].domain')
    EMAIL="$(cat /proc/sys/kernel/random/uuid | cut -c1-10)@$domain"
    PASSWORD="RANDOMpassword010"
    #CREATE ACCOUNT
    curl -s -X POST https://api.mail.tm/accounts \
    -H "Content-Type: application/json" \
    -d "{\"address\": \"$EMAIL\", \"password\": \"$PASSWORD\"}" > /dev/null
    TOKEN=$(curl -s -X POST https://api.mail.tm/token \
      -H "Content-Type: application/json" \
      -d "{\"address\": \"$EMAIL\", \"password\": \"$PASSWORD\"}" | jq -r '.token')

}

new_phone(){
    echo ""
    curl -s https://receive-smss.com | tr '\n' ' ' | tr -s ' ' | \
    grep -oP '<div class="number-boxes-itemm-number" style="color:black">\+\d+</div>|<div[^>]+class="number-boxes-item-country[^"]*"[^>]*>[^<]+' | \
    sed 's#<div class="number-boxes-itemm-number" style="color:black">##; s#</div>##; s#<div[^>]*>##; s#</div>##' | \
    paste - - > /tmp/numbers.txt 

    FILE="/tmp/numbers.txt"

    
    mapfile -t countries < <(awk '{$1=""; sub(/^ +/, ""); print}' "$FILE" | sort -u)
    echo -e "$ORANGE┌-------------------------┐"
    echo -e "$ORANGE|$BLUE     Choose a country:$ORANGE   |"
    echo "├-------------------------┤"
    for i in "${!countries[@]}"; do
      echo -e "$ORANGE $((i+1)).$GREEN ${countries[i]}"
    done

    echo -e "$ORANGE└-------------------------┘$RESET"

    read -rp "Chose the prefix: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#countries[@]} )); then
      echo "Invalid Option"
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
    ' "$FILE")

    if (( ${#numbers[@]} == 0 )); then
      echo "There's no numbers for $selected_country"
      exit 1
    fi

    # Choose random number
    random_number=${numbers[RANDOM % ${#numbers[@]}]}
    echo "Number: $random_number"

}

new_adress() {
    # 1. Extract country name from /tmp/numbers.txt using full number
    country_name=$(grep "^$random_number" /tmp/numbers.txt | awk '{$1=""; sub(/^ +/, ""); sub(/ +$/, ""); print}')

    # 2. If full match fails, try matching by prefix
    if [ -z "$country_name" ]; then
        for prefix_length in 4 3 2 1; do
            prefix=${random_number:0:$prefix_length}
            country_name=$(grep "^$prefix" /tmp/numbers.txt | awk '{$1=""; sub(/^ +/, ""); sub(/ +$/, ""); print}')
            [ -n "$country_name" ] && break
        done
    fi

    # 3. If still not found, exit with error
    if [ -z "$country_name" ]; then
        echo "Country not detected from phone number: $random_number" >&2
        return 1
    fi

    # 4. Get a random address from addresses.txt for that country
    address=$(awk -v RS="" -v country="--- $country_name ---" '
        $0 ~ country {
            gsub(/\r/, "")              # remove carriage returns if present
            n = split($0, lines, "\n")
            for (i = 2; i <= n; i++) a[i-1] = lines[i]
            count = i - 1
            srand()
            print a[int(rand()*count)+1]
            exit
        }
    ' addresses.txt)

    # 5. Output the address (or return error if not found)
    if [ -z "$address" ]; then
        echo "No address found for $country_name" >&2
        return 1
    fi

}

save_in_DB(){
    # Obtener el siguiente ID
    get_next_id() {
      tail -n +2 "/etc/FakeIdentity/identities.csv" | awk -F',' '{print $1}' | sort -n | tail -1 | awk '{print $1 + 1}'
    }
    id=$(get_next_id)
    if [ -z "$id" ]; then id=1; fi
    echo "$id,$name,$EMAIL,$TOKEN,$random_number,$address" >> "$DB"

}
#email
# Show identities
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
    read -p "ID a eliminar: " id
    if [ -z "$id" ] || ! [[ "$id" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Error: El ID debe ser un número válido.${RESET}"
        return 1
    fi
    if grep -q "^$id," "$DB"; then
        sed -i "/^$id,/d" "$DB"
        echo -e "${GREEN}Usuario con ID $id eliminado correctamente.${RESET}"
    else
        echo -e "${RED}Error: No se encontró el ID $id.${RESET}"
    fi
}

del_info(){
    grep "^$id," "$DB"
    EMAIL=""
    random_number=""
    address=""
    name=""
}

clean(){
    clear

}

select1(){

    current_info(){
        line=$(grep "^$id," /etc/FakeIdentity/identities.csv)
        IFS=',' read -r id name EMAIL TOKEN phone_number address <<< "$line"
        clean_number="${phone_number#+}"

    }

    help1(){
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
        echo -e "                                     $YELLOW|cl   | ${CYAN}CLEAR                 ${YELLOW}|"
        echo -e "                                     $YELLOW├ - - ┼ - - - - - - - - - - - ┤"
        echo -e "                                     $YELLOW|ch   | ${CYAN}CHANGE IDENTITY       ${YELLOW}|"
        echo -e "                                     $YELLOW└ - - ┴ - - - - - - - - - - - ┘$RESET"
    }

    mailbox(){
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


    del_current(){
      if grep -q "^$id," "$DB"; then
        sed -i "/^$id,/d" "$DB"
        echo "User with $id has been deleted."
      fi
    }

    echo ""
    echo ""
    list_identities
    read -p "ID: " id
    resultado=$(grep "^$id," "$DB")
    if [ -z "$resultado" ]; then
      echo "No se encontró ese ID."
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
            echo "LAST 5 MESSAGES"
            mailbox
        elif [ "$option" = "ms" ]; then
            echo "LAST 5 MESSAGES"
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
            echo -e " ${RED}INVALID OPTION $RESET"
        fi
    done

}


#CLEANUP
cleanup() {
    if [ "$cleaning_state" == "false" ]; then
        cleaning_state=true
        echo ""
        echo -e "${YELLOW}[*] Cleaning up...${RESET}"
        sleep 2
        clear
        exit 0
    else
        :
    fi

}

trap cleanup SIGINT SIGTERM 
#REGISTER

#INIT
init
