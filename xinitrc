#!/bin/sh
cd $HOME

# xset fp= tcp/127.0.0.1:7100

sh $HOME/.xconfig

#xterm -sb -ls -bg black -fg white -geometry 78x12+5-5 -title Console
afterstep # -f $HOME/system.steprc

#sleep 3
clear
