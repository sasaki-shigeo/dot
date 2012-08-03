#
# csh startup program
#
#     $prompt $DISPLAY $EDITOR invokation
#	yes	-	yes	csh -i		; to source only .aliases
#	yes	-	no	login		; to source .cshenv & .login
# 	no	-	yes	csh script	; nothing to source
#	-	yes	no	xdm/xterm via xrsh ; to source only .cshenv
#	no	no	no	rsh		; to set only path
#

if ($?prompt && $?EDITOR) then
    source ~/.aliases		# interactive csh
else if (! $?EDITOR && ($?prompt || $?DISPLAY)) then
    set path = ($path /usr/ucb)
    source ~/.cshenv		# xdm/xrsh/xterm -l
else if (! $?prompt && ! $?DISPLAY && ! $?EDITOR) then
    umask 022			# rsh
    set path = (~/bin ~/bin/common /usr/local/bin \
		/usr/local/bin/X11 /usr/bin/X11 \
		/usr/sbin # SystemV  \
		/usr/ucb /usr/bin /bin /usr/etc)
endif
