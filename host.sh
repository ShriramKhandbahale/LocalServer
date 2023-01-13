#! /bin/bash

#variables
invalidOption=false
YELLOW='\033[1;33m'
RED='\033[1;31m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

while [ $invalidOption ]; do
    clear
    echo "[1] Host website"
    echo "[2] Host files"
    echo -e "[0] Exit\n"
    read -p "Enter your choice [1-2]: " CHOICE

    case $CHOICE in

    1)
        echo -e "\n${YELLOW}N:${NC} Add your website files to the 'server' directory\nwith index.html being in the root (i.e the server directory)\n"
        read -p "Continue [Y] : "

        if [[ -f server/index.html ]]; then
            cd server/
            echo -e "\nCreating a server..." && sleep 3
            tree . | while read -r line; do
                printf '%s\n' "$line"
                sleep 0.05
            done
            echo "--------------------------------"
            {
                python3 -m http.server 8000 &
                cd ..
                ssh -R 80:localhost:8000 localhost.run | tee .resources/.tee.txt &
            } &>/dev/null

            sleep 5 && cat .resources/.tee.txt | sed 's/^.*https/https/' >.resources/.link.txt

            LINK=$(cat .resources/.link.txt)

            wget -q --spider http://google.com
            if [[ $LINK = h* && $? -eq 0 ]]; then
                echo -e "${WHITE}Sharable link :${NC}" "$(cat .resources/.link.txt)" && sleep 2
                echo -en "\n${YELLOW}N:${NC} Use command \"killall host.sh\" to terminate the server | "
            else
                echo -e "\n${RED}Error:${NC} Something went wrong."
                echo -e "Please check your internet connection or try again\n" && sleep 5
                exit 1
            fi

            >.resources/.tee.txt
            >.resources/.link.txt

            read
        else
            sleep 2 && echo -e "\n${RED}Error:${NC} unable to create server"
            sleep 2 && echo -e "\nThe 'server' directory is empty or index.html is not\nin the root (i.e the server directory)\n" && sleep 5
        fi
        ;;

    2)
        echo -e "\n${YELLOW}N:${NC} Add all the files you wnat to host to the 'server' directory"
        read -p "Continue [Y] : "

        if [ "$(ls server)" ]; then
            cd server && ls --block-size=K -s >../.resources/.files.txt
            sed -i -e '/LocalServer_file.zip/d' ../.resources/.files.txt
            echo -e "\n-------------------"
            zip LocalServer_file.zip * -r | while read -r line; do
                printf '%s\n' "$line"
                sleep 0.05
            done
            mv LocalServer_file.zip ../.resources/.LocalServer/
            echo -e "-------------------\n" && sleep 2

            cd ../.resources/
            ./.message_input

            sleep 2 && echo -e "\nCreating a server...\n" && sleep 2
            {
                python3 -m http.server 8080 &
                cd ..
                ssh -R 80:localhost:8080 localhost.run | tee .resources/.tee.txt &
            } &>/dev/null

            if [[ -s .resources/.message.txt ]]; then
                sed -i "s/$(cat .resources/.current_content.txt)/$(cat .resources/.message.txt)/" .resources/index.html
                cat .resources/.message.txt >.resources/.current_content.txt
            fi

            sleep 5 && cat .resources/.tee.txt | sed 's/^.*https/https/' >.resources/.link.txt

            LINK=$(cat .resources/.link.txt)

            wget -q --spider http://google.com
            if [[ $LINK = h* && $? -eq 0 ]]; then
                echo -e "${WHITE}Sharable link :${NC}" "$(cat .resources/.link.txt)" && sleep 2
                echo -en "\n${YELLOW}N:${NC} Use command \"killall host.sh\" to terminate the server | "
            else
                echo -e "\n${RED}Error:${NC} Something went wrong."
                echo -e "Please check your internet connection or try again\n" && sleep 5
                exit 1
            fi

            >.resources/.tee.txt
            >.resources/.link.txt
            read
        else
            echo -e "\n${RED}Error:${NC} unable to create server"
            echo -e "The 'server' directory is empty.\n" && sleep 3
        fi
        ;;

    0)
        exit 1
        ;;

    *)
        echo -n "Invalid Option"
        sleep 2
        invalidOption=true
        clear
        ;;
    esac
done
