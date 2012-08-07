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
stty intr ^C kill ^U erase ^? quit ^\ susp ^Z

switch ($term)
case vt100:
    set autologout = 20		# tcsh only
    set ignoreeof
    breaksw
case *term:	# remote rlogin
    setenv TERM xterm
    if (-f /etc/motd) cat /etc/motd
    breaksw
endsw
