#
# This is a ZSH startup file that prepares interaction settings
#

HISTSIZE=1000
#cdpath=(.. /usr/local /usr /)
fignore=('.o' '.ql' '~')
PROMPT='%n[%t]%# '
RPROMPT='%m:%~'
mailpath=(~/Mail/inbox)

setopt autocd automenu autolist correct nobeep nonomatch
setopt listtypes pushdsilent
setopt histignoredups #histignorespace histverify
setopt notify
setopt printexitvalue
# setopt sunkeyboardhack
# setopt nobanghist

stty -istrip erase 
bindkey -me	# enable meta-key
bindkey '\M-b'  vi-backward-word
bindkey '\M-e'  vi-forward-word-end
bindkey '\M-f'  vi-forward-word
bindkey '\M-^?' vi-backward-kill-word
bindkey '\eb'   vi-backward-word
bindkey '\ee'   vi-forward-word-end
bindkey '\ef'   vi-forward-word
bindkey '\e^?'  vi-backward-kill-word
bindkey '^w'    vi-backward-kill-word


autoload -U compinit
# compinit

limitargs=(cputime filesize datasize stacksize coredumpsize
		resident maxproc descripters)
makeargs=(all clean install default)
printers=(oki part news02 dewa)
hosts=( localhost 127.0.0.1
	158.215.64.1 158.215.80.1 158.215.93.1
	158.215.44.100 158.215.64.60
	akita-u.ac.jp 
	tazawa.ed.akita-u.ac.jp komachi.ed.akita-u.ac.jp
	quartet.ipc.akita-u.ac.jp octet.ipc.akita-u.ac.jp
	tegata.ipc.akita-u.ac.jp timpani.ipc.akita-u.ac.jp
	lambda.is.akita-u.ac.jp squid.is.akita-u.ac.jp
	namahage.is.akita-u.ac.jp kurikoma.is.akita-u.ac.jp
	cube.ed.akita-u.ac.jp
	snws-e4.akita-u.ac.jp dhcp80.ed.akita-u.ac.jp
	junsai.is.akita-u.ac.jp hatahata.is.akita-u.ac.jp
	is.tsukuba.ac.jp score.is.tsukuba.ac.jp
	gama.is.tsukuba.ac.jp maple.is.tsukuba.ac.jp
	symphony.score.is.tsukuba.ac.jp concerto.score.is.tsukuba.ac.jp
	octette.score.is.tsukuba.ac.jp viola1.score.is.tsukuba.ac.jp
	ftp.netlab.is.tsukuba.ac.jp ntp.netlab.is.tsukuba.ac.jp
	isl.educ.fukushima-u.ac.jp	# shinoda lab.
	casper.yz.yamagata-u.ac.jp	# afterstep mirror
	ftp.akita-u.ac.jp ftp.is.akita-u.ac.jp 
	ftp.jp.freebsd.org
	netbsd.tohoku.ac.jp
	ftp.u-aizu.ac.jp ftp.tut.ac.jp ftp.kuis.kyoto-u.ac.jp
	ftp.nacsis.ac.jp ftp.riken.go.jp
	sh.wide.ad.jp uunet.uu.net etlport.etl.go.jp)

urls=

compctl -c man jman which
compctl -l '' nice exec screen sudo
compctl -E printenv setenv
compctl -v -E vared unset
compctl -/ cd
compctl -/ -g '*.tex' + tex jtex ptex latex jlatex platex
compctl -/ -g '*.dvi' xdvi dviselect dvips dvi2ps
compctl -g '/var/db/pkg/*(:t)' pkg_info pkg_delete
compctl -k limitargs limit unlimit
compctl -k hosts  rlogin slogin telnet ftp ncftp ncftp2 ncftp3 ping nslookup traceroute xhost rup ruptime
compctl -f -k hosts rsh ssh
compctl -f -k urls -x 's[http://]' -k hosts -- w3m netscape
compctl -f -x 's[-P]' -k printers -- lpr lpq lprm prn
compctl -x 's[-]' -k signals -- kill
compctl -x 's[if=] , s[of=]' -f -- dd edd
compctl -v -x 's[DISPLAY=]' -k hosts -S ':0' -- export

rsync_urls=(rsync://rsync.is.akita-u.ac.jp/{src3,src4,src5,ports}/
	rsync://squid.is.akita-u.ac.jp/{src3,src4,src-current,ports}/)
compctl -f -k rsync_urls -x 's[-]' -k "(vr vtr vur)" -- rsync

function _folders () { reply=(`folders -recurse -fast`) }
compctl -x 's[+]' -K _folders -- folders folder scan packf

function _targets () { reply=(`sed -n '/^[a-zA-Z]/s/:.*$//p' [mM]akefile`) }
compctl -K _targets  make

alias ls='ls -F' la='ls -a' ll='ls -lg' le='less -e'
alias pd=pushd
alias j=jobs    sw='%-'   z=suspend	
alias g=egrep
alias unl=unlimit
alias up=uptime
alias his=history las='last -20'
alias clear="echo -n '\033(B\033[H\033[J'" 
alias jman='LANG=ja_JP.eucJP /usr/local/bin/jman'
alias xemacs='LC_MESSAGE=ja_JP xemacs'

alias h=scan s=show n=next p=prev # d=rmm
alias inc="mv $HOME/Mail/mlog $HOME/Mail/mlog.bak; touch $HOME/Mail/mlog"
if [ -f $HOME/Mail/mlog ]; then
    MAIL=$HOME/Mail/mlog
fi

if [ X$EMACS = X ] ; then
    alias gnus='emacs -f gnus'
    alias cmail='emacs -f cmail'
    alias smail='emacs -f mail'
    alias bytecompile='emacs -batch -f batch-byte-compile'
fi

alias ncftp2='NCFTPDIR=$HOME/.ncftp2 ncftp2'

lll ()	{ ls -lgw $@ | eval ${PAGER:-more} }
manroff () { nroff -man $* | eval ${PAGER:-more} }
ms  ()	{ nroff -ms $* | eval ${PAGER:-more} }
bt  ()	{ echo '\$c' | adb $* }
xtitle () { echo -n '];'$*'' }
setenv () { export $1=$2 }

burn-acd0 () { burncd -f /dev/acd0 -s max data $1 fixate }
w3m () {
    W3M=/usr/local/bin/w3m
    case "$TERM" in
	kterm*) $W3M -j $@ ;;
	*) $W3M $@ ;;
    esac
}
open() {
    if [ -d "$1" ]; then
	cd $1
    else
	case "$1" in
	    *.dvi) xdvi "$1" ;;
	    *.class) java `basename -s .class "$1"` ;;
	    *) /usr/local/bin/jless "$1"
	esac
    fi
}



if [ x$UID = x0 ]; then
    alias exportfs='kill -HUP `cat /var/run/mountd.pid`'
fi
