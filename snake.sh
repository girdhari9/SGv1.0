#!/bin/bash

Username=$1 # Don't use 'let' here

terminal_Settings_on(){
	stty_orig=`stty -g`
	stty -echo
	stty -icanon
	tput civis -- invisible
}

terminal_Settings_off(){
	stty $stty_orig
	tput cnorm -- normal
	tput clear
	exit
}

header(){
	for((i=0;i<=$1;i++))
	do
		tput cup 0 $i
		echo -e "-\c"
	done
	tput cup 1 1
	echo -e "Username: $2\c"
	let pos=$1/2
	tput cup 1 $pos
	echo -e "SNAKE GAME\c"
	let pos=$1-21
	tput cup 1 $pos
	echo -e "-Giridhari Lal Gupta\c"
	for((i=0;i<=$1;i++))
	do
		tput cup 2 $i
		echo "-"
	done
}

body(){
	let left_pos=5
	let right_pos=$2-5
	for((i=left_pos;i<right_pos;i++))
	do
		tput cup $left_pos $i
		echo -e "-\c"
	done

	let up_pos=4
	let down_pos=$1-6
	for((i=up_pos+2;i<down_pos;i++))
	do
		tput cup $i $((up_pos+1))
		echo -e "|\c"
	done

	let z=$2-6
	for((i=up_pos+2;i<down_pos;i++))
	do
		tput cup $i $((z+1))
		echo -e "|\c"
	done

	let z=$1-6
	for((i=left_pos;i<right_pos;i++))
	do
		tput cup $z $i
		echo -e "-\c"
	done
}

footer(){
	let z=$1-3
	for((i=0;i<$2;i++))
	do
		tput cup $z $i
 		echo "-"
	done
	((z++))
	let pos=$2-65
	tput cup $z $pos
	echo -e "Press q or Q to quit game! \c"
	echo -e "To move snake press arrow keys...\c"
	((z++))
	for((i=0;i<$2;i++))
	do
		tput cup $z $i
 		echo -e "-\c"
	done
}

screen_set(){
	#Header
	header $2 $3
	#Body
	body $1 $2
	# Footer
	footer $1 $2
}

snake_start(){
	terminal_Settings_on
	count_sleep=1
	sleep_time=1
	increase_time=5
	score=0
	flag=4
	cols=`tput cols`
	rows=`tput lines`
	tput clear
	screen_set $rows $cols $Username
	let x=cols/2
	let y=rows/2
	tput cup $y $x
	snake_print_right=">"
	snake_print_left="<"
	snake_print_up="^"
	snake_print_down="v"
	snake_remove="*"
	blue=`tput setaf 4`
}

#Infinite loop to run snake
while [ 1 ]
do
	let z=$rows-2
	tput cup $z 1
	echo -e "Score: $score\c"
	((count_sleep++))
	if [[ $count_sleep -gt $increase_time ]];
	then
		let count_sleep=1
		((score++))
		sleep_time=`echo "scale=4;$sleep_time/2" | bc`
	fi
	read -t 0.05 -N 1 key

	let border_col=$cols-5
	let border_row=$rows-6
	let start=5
	let end=5 #error

	if [[ $x -eq $start ]] || [[ $x -eq $border_col ]] || [[ $y -eq $end ]] || [[ $y -eq $border_row ]];
	then
		# let mid_x=$cols/2
		# let mid_y=$rows/2
		# tput cup $mid_y $mid_x
		# echo "GAME OVER!"
		# echo "Your Score is : $score"
		# sleep 5
		snake_start
	fi
    if [[ $key = "q" ]] || [[ $key = "Q" ]];
    then
    	terminal_Settings_off
    else
		case "$key" in
		    'A')flag=1 ;
				tput cup $y $x ;
				GREEN=`tput setaf 2`;
				echo -e "${GREEN}${NC}";;
		    'B')flag=2 ;
				orange=`tput setaf 3`;
				echo -e "${orange}${NC}";
				tput cup $y $x ;;
		    'C')flag=3 ;
				RED=`tput setaf 1`;
				echo -e "${RED}${NC}";
				tput cup $y $x ;;
		    'D')flag=4 ;
				blue=`tput setaf 4`;
				echo -e "${blue}${NC}";
				tput cup $y $x ;;
			*) if [[ $flag -eq 1 ]];
				then
					tput cup $y $x ;
					echo "$snake_remove" ;
					((--y))
				elif [[ $flag -eq 2 ]];
				then
					tput cup $y $x ;
					echo "$snake_remove" ;
					((++y))
				elif [[ $flag -eq 3 ]];
				then
					tput cup $y $x ;
					echo "$snake_remove" ;
					((++x))
				else
					tput cup $y $x ;
					echo "$snake_remove" ;
					((--x))
				fi
				tput cup $y $x 
				if [[ $flag -eq 1 ]]; then
					echo "$snake_print_up"
				elif [[ $flag -eq 2 ]]; then
					echo "$snake_print_down"
				elif [[ $flag -eq 3 ]]; then
					echo "$snake_print_right"
				elif [[ $flag -eq 4 ]]; then
					echo "$snake_print_left"
				fi
				sleep $sleep_time
		esac
	fi
done

snake_start