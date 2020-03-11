#!/bin/bash

if [ -z "$VNC_PASSWORD" ]; then
	echo >&2 'error: No password for VNC connection set.'
	echo >&2 '  Did you forget to add -e VNC_PASSWORD=... ?'
	exit 1
fi

if [ -z "$XFB_SCREEN" ]; then
	XFB_SCREEN=1024x768x24
fi

if [ ! -z "$XFB_SCREEN_DPI" ]; then
	DPI_OPTIONS="-dpi $XFB_SCREEN_DPI"
fi


# we should determine whether the xserver.xauth exist
if [ -z "$(xauth list)" ] || [ "$(xauth list)" != "$(cat /Xauthority/xserver.xauth)" ]; then

	# first we need our security cookie and add it to user's .Xauthority
	mcookie | sed -e 's/^/add :0 MIT-MAGIC-COOKIE-1 /' | xauth -q

	# now place the security cookie with FamilyWild on volume so client can use it
	# see http://stackoverflow.com/25280523 for details on the following command
	xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f /Xauthority/xserver.xauth nmerge -

	echo "MIT-MAGIC-COOKIE refreshed, plz restart your xclient"
fi

# now boot X-Server, tell it to our cookie and give it sometime to start up
# Xvfb :0 -auth ~/.Xauthority $DPI_OPTIONS -screen 0 $XFB_SCREEN >>~/xvfb.log 2>&1 &
Xvfb :0 -auth ~/.Xauthority -listen tcp $DPI_OPTIONS -screen 0 $XFB_SCREEN >>~/xvfb.log 2>&1 &
sleep 2

# finally we can run the VNC-Server based on our just started X-Server
# x11vnc -forever -passwd $VNC_PASSWORD -display :0

exec "$@"
