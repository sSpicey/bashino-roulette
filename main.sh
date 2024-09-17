#!/usr/bin/env bash

icons=("@" "#" "&")
payouts=(10 20 30)
credits=100
icon_count=${#icons[@]}
jackpot_count=0
total_runs=0

if ! command -v figlet &> /dev/null; then
       echo "Error: figlet is not installed. Please install it before running the script."
       exit 1
fi

highlight_yellow() {
  echo -e "\033[1;7;36m$*\033[0m"
}
highlight_cyan() {
  echo -e "\033[1;7;34m$*\033[0m"
}
highlight_green() {
  echo -e "\033[1;7;32m$*\033[0m"
}
highlight_red() {
  echo -e "\033[1;7;31m$*\033[0m"
}

figlet -f slant "Welcome Slot Machine!"

while true; do
    highlight_cyan "You have $credits credits left"
    highlight_green "Place your wager: "
    read -r wager

    if ! [[ $wager =~ ^[0-9]+$ ]] || [[ $wager -le 0 || $wager -gt $credits ]]; then
        highlight_red "Invalid wager. Please enter a valid wager."
        continue
    fi

    # Spin the slot machine
    index1=$((RANDOM % icon_count))
    index2=$((RANDOM % icon_count))
    index3=$((RANDOM % icon_count))

    echo "${icons[index1]} ${icons[index2]} ${icons[index3]}"

    # Check for win
    if [ $index1 -eq $index2 ] && [ $index1 -eq $index3 ]; then
        highlight_yellow "Congratulations! You won ${payouts[index1]} credits."
        credits=$((credits + payouts[index1]))
        jackpot_count=$((jackpot_count + 1))
    else
        highlight_red "Sorry, you didn't win this time."
        credits=$((credits - wager))
    fi

    total_runs=$((total_runs + 1))

    if [ $credits -le 0 ]; then
        highlight_red "YOU'VE BEEN WIPED CLEAN!"
        highlight_red "The pit boss has escorted you out of the casino. Don't come back until you've got more cash to burn!"
        break
    fi
done

while true; do
    highlight_green "Would you like to print out the results of your run? (yes/no)"
    read -r response
    case $response in
        [yY][eE][sS]|[yY])
            echo "Jackpot count: $jackpot_count" > results.txt
            echo "Total runs: $total_runs" >> results.txt
            highlight_yellow "Results printed to results.txt"
            break
            ;;
        [nN][oO]|[nN])
            highlight_red "Results not printed"
            break
            ;;
        *)
            highlight_red "Invalid response. Please enter yes or no."
            ;;
    esac
done