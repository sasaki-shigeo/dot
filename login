#
# login shell start up program
#	by SASAKI,S.
#

# If we have any other more convenient shell,
# $SHELL was set at .cshenv
# Now I exec it
if ("$shell" != "$SHELL") exec $SHELL -l

if ( $cwd != $home ) then
    set home = ~    				# when home dir is automounted
endif

tset -r				# terminal type
set noglob
eval `tset -s`			# set termcap
stty intr ^C kill ^U erase ^H quit ^\ susp ^Z

if ("$term" == kterm) set term = xterm

switch ($term)
case vt98:
    set term = vt100
case vt100:
    set autologout = 20		# tcsh only
    set ignoreeof
    stty erase ^H
    breaksw
case *term:	# remote rlogin
    setenv TERM xterm
    if (-f /etc/motd) cat /etc/motd
    breaksw
endsw

# X window
if (`tty` != /dev/console) exit		# starting session

alias x 'xinit >& ~/.CONSOLE; logout'
alias o 'openwin >& ~/.CONSOLE; logout'
echo ''
echo "Type 'x' to start X Windows"
echo "or   'o' to start OepnWindows"
echo ''
