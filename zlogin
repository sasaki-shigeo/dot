#
# This is a ZSH startup file that runs when login
#

# Setting HOME
#export HOME=`/bin/pwd`; cd $HOME

# Setting Terminal
eval `tset -s`
stty -istrip
bindkey -em

echo 'Which is the erase key on your keyboard?'
echo -n 'Type here: '
read -k erase
stty erase $erase 
echo ...OK.

#case $TERM in
#    *term) export TERM=xterm
#	   # test -z "$DISPLAY" -a ! -z "$fromhost" && DISPLAY=$fromhost':0'
#	   test -f /etc/motd && cat /etc/motd ;;
#esac

# X window starting
case `tty` in
    /dev/console|/dev/ttyv[0-9]) alias x='xinit >& ~/.CONSOLE; for i in 3 2 1 clear; do echo -n ...$i; sleep 1; done; clear; logout'
esac
