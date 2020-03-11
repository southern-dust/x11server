

#### What's new:
- base image updated to debian:buster
- could restart x11server container(bugfix?), so you just need to restart your x11client container after x11server restart.


#### What I did:


#### How to use:

First run the x11server:
```
docker run --name display -d -it -e XFB_SCREEN=1920x1080x24 -e VNC_PASSWORD=PASSWD -p 5900:5900 southern-dust/x11server:latest /bin/bash
```
this will run with a shell detached. If you need to get attach the shell, run:
```
docker exec -it display /bin/bash
```
or
```
docker exec -u 0 -it display /bin/bash
```
to get a root shell.


Then run the x11client:
```
docker run --name xclient -it --link display:xserver --volumes-from display southern-dust/x11client /bin/bash
```

Okay, let's enjoy this!
