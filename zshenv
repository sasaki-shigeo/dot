#
# ~/.zshenv
#

umask 002
limit coredumpsize 0
#limit maxproc 100

#fpath=(. ~ ~/bin/lib)

# general favorites
export EXINIT='set autoindent autowrite showmatch shiftwidth=4
	map ; :'
export CVSROOT=$HOME/CVS
export BLOCKSIZE=1k
if [ -x /usr/local/bin/jless ]; then
    export PAGER=/usr/local/bin/jless JLESSCHARSET=japanese LESS=-e 
elif [ -x /usr/local/bin/less -o -x /usr/bin/less ]; then
    export PAGER=less LESS=-e JLESSCHARSET=japanese
else
    export PAGER=more
fi
export EDITOR=emacsclient
if [ "$UID" = 0 ]; then
    export EDITOR=vi
    bindkey -e
fi


# site local
export TEXINPUTS=.:$HOME/tex/inputs:
#export XDVIFONTS=/usr/TeX/fonts/PK:/usr/TeX/fonts/PKams300
export MAILHOST=mailer.is.akita-u.ac.jp
test x"$UID" = x0 || export MAIL=$HOME/Mail/inbox
export JSERVER=samba.is.akita-u.ac.jp HONYAKUSERVER=junsai
export ORGANIZATION='Computer Science Laboratory, Akita University'
#export CDR_DEVICE=5,0 CDR_SPEED=6
export ADOBE_LANG=JPN

# particular to OS
case $OSTYPE in
    freebsd*)   # FreeBSD
        osbin=()
        sbin=(/usr/local/sbin /usr/sbin /sbin)
	miscbin=(/usr/local/{jdk1.5.0,jdk1.4.1,jdk1.3.1,jdk1.2.2,jdk1.1.8}/bin)
	export WRKDIRPREFIX=/var/tmp DISTDIR=/pub/distfiles
        ;;
    linux*)     # Linux
        osbin=()
        sbin=(/usr/sbin /sbin)
        ;;
    solaris*)   # Solaris
        osbin=(/usr/ccs/bin /usr/ucb)
        sbin=(/usr/sbin /sbin)
        ;;
    hpux*)	$ HP-UX
	osbin=(/usr/bin/xpg4 /usr/bin /usr/ccs/bin /usr/contrib/bin)
	x11bin=(/usr/bin/X11 /usr/contrib/bin/X11)
	miscbin=(/usr/local/bin/* /opt/*/bin)
esac

# Several machines forget to register the kterm entry
# to TERMCAP and/or TERMINFO
#test "$TERM" = kterm && TERM=xterm
