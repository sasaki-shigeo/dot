#! /usr/local/bin/zsh -x

#xset fp= tcp/lambda.is.akita-u.ac.jp:7100

sh $HOME/.xconfig

#xterm -sb -ls -bg black -fg white -geometry 78x12+5-5 -title Console

# kinput2 &

wmlist=(/usr/X11R6/bin/afterstep
	/usr/X11R6/bin/twm)
for i in $wmlist
do
    if [ -x $i ]; then
	WM=$i
	break
    fi
done

if [ -x /usr/bin/ssh-agent ]; then
    /usr/bin/ssh-agent -t 20000 $WM
elif [ -f /usr/local/bin/ssh-agent ]; then
    /usr/local/bin/ssh-agent $WM
else
    $WM
fi
