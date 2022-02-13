#!/bin/bash

echo ''
echo '############################################################'
echo '#         ______     ____                           #   /  #'
echo '#        |   _  \   |--- \                          #  /   #'
echo '#        |  | |  |      \ \       ___               # /  / #'
echo '#        |  \_|  /      / /      /     |  |         #   /  #'
echo '#        |  ----/       \ \  ___ \__   |__|         #  /  /#'
echo '#        |  |        ___/ /  ---  --\  |--|         # /  / #'
echo '#        |  |       |    /       ___/  |  |         #   /  #'
echo '#--------|--/-------\---/----------/---|--|-------- #  /  /#'
echo '#                                                   # /  / #'
echo '############################################################'
echo ''

read -p 'Enter POP3 Server Name: ' SERVERNAME
read -p 'Enter USER: ' USER
read -p 'Enter PASS: ' PASS

echo '1) 110 port (default)'
echo '2) 995 port (secure)'

read -p 'Select Connection Type: ' CONNECTION_TYPE

case "${CONNECTION_TYPE}" in
        1|1\))
                PORT=110
                ;;

        2|2\))
                PORT=995
                ;;

        *)
                echo "Wrong option: $1"
                exit 1
                ;;
esac

default() {
        exec 7<>"/dev/tcp/${SERVERNAME}/${PORT}"

        read resp text <&7
        echo "> Connecting to POP3 Server..."
        echo "< ${resp} ${text}"

        echo "USER ${USER}" >&7
        read resp1 <&7
        echo "> Sending USER..."
        echo "< ${resp1}"

        echo "PASS ${PASS}" >&7
        read resp2 text2 <&7
        echo "> Sending PASS..."
        echo "< ${resp2} ${text2}"

        echo "STAT" >&7
        read resp3 mnum size <&7
        echo "> Sending STAT"
        echo "< ${resp3}"
        echo "< Number of messages: ${mnum}"
        echo "< Mailbox size in bytes: ${size}"

        echo "QUIT" >&7
        read quit <&7
        echo "> Sending QUIT"
        echo "< ${quit}"
}

secure() {
        echo "Currently unsupported..."
        exit 1
}

if [[ "${PORT}" -eq 110 ]]; then
        default
fi

if [[ "${PORT}" -eq 995 ]]; then
        secure
fi
