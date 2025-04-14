#
# ~/.profile
#

export EXINIT='set autoindent autowrite showmatch shiftwidth=4
	map ; :'
export EDITOR=vi
export BLOCKSIZE=1k
if [ -x /usr/local/bin/lv -o /opt/homebrew/bin/lv ]; then     # Mac
    export PAGER=lv LV=-Ou
elif [ -x /usr/local/bin/jless ]; then          # FreeBSD
    export PAGER=/usr/local/bin/jless JLESSCHARSET=japanese LESS=-e 
elif [ -x /usr/local/bin/less -o -x /usr/bin/less ]; then
    export PAGER=less LESS=-e JLESSCHARSET=japanese
else
    export PAGER=more
fi
