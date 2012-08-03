#
# ~/.zshenv
#

umask 002
limit coredumpsize 0
limit maxproc 100	# 40 is default

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
#export CLASSPATH=.:/usr/local/share/java/classes.zip:/usr/local/share/java/swat.zip:/usr/local/share/kaffe/biss.zip
export TEXINPUTS=.:$HOME/tex/inputs:
#export XDVIFONTS=/usr/TeX/fonts/PK:/usr/TeX/fonts/PKams300
export NNTPSERVER=news
export MAILHOST=mailer.is.akita-u.ac.jp
test x"$UID" = x0 || export MAIL=$HOME/Mail/inbox
export JSERVER=samba.is.akita-u.ac.jp HONYAKUSERVER=junsai
export ORGANIZATION='Computer Science Laboratory, Akita University'
export SHOGIDIR=/tmp
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

# particular to Host
case $HOST in
    maple*)	# FreeBSD
	export DISTDIR=/exp/distfiles
	;;
    inukko*)	# FreeBSD
	hostbin=(/opt/bin)
	miscbin=(/usr/games /usr/local/{jdk1.4.1,jdk1.3.1,jdk1.2.2,jdk1.1.8}/bin)
	export WRKDIRPREFIX=/usr/tmp
    ;;
    junsai*)	# FreeBSD
	hostbin=()
	miscbin=(/usr/games /usr/local/jdk1.2.2/bin)
    ;;
esac

# OS depend
if [ -z "$sbin" ]; then
    if [ -d /sbin ]; then
	sbin=(/sbin /usr/sbin)		# new fashion UNIX
    elif [ -d /usr/etc ]; then
	sbin=(/usr/etc)			# SunOS 4, NeXT
    else
	sbin=(/etc)			# old fashion UNIX
    fi
fi

if [ -z "$x11bin" ]; then
    if [ -d /usr/bin/X11 ]; then
	x11bin=/usr/bin/X11
    elif [ -d /usr/local/bin/X11 ]; then
	x11bin=/usr/local/bin/X11
    elif [ -d /usr/X11R6/bin ]; then
	x11bin=/usr/X11R6/bin
    fi
fi


path=(~/bin ~/bin/$CPUTYPE ~/local/bin $hostbin /usr/local/bin $x11bin
      /usr/ucb /usr/bin /bin
      $sbin $miscbin)

# Several machines forget to register the kterm entry
# to TERMCAP and/or TERMINFO
#test "$TERM" = kterm && TERM=xterm
