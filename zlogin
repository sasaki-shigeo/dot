#
# This is a ZSH startup file that runs when login
#

# Setting Terminal
eval `tset -s`
stty -istrip

echo 'Which is the erase key on your keyboard?'
echo -n 'Type here: '
read -k erase
stty erase $erase 
echo ...OK.
