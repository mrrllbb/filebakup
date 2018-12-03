#!/bin/bash
# Install daemon tools
if [ "$UID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
if [ ! -e /usr/bin/gcc ] || [ ! -e /usr/bin/make ]; then
  echo gcc or make not installed going to install dev tools in 5 seconds press ^C to exit
  sleep 6
  yum -y groupinstall 'Development Tools'
fi

## Install daemon tools

if [ ! -e /command/svc ]; then

        mkdir /opt/daemontools
        cd /opt/daemontools
        wget http://cr.yp.to/daemontools/daemontools-0.76.tar.gz
        tar -xf daemontools-0.76.tar.gz
        cd /opt/daemontools/admin/daemontools-0.76
        
        # This is the fix to the issue that makes the build fail
        
        echo "gcc -O2 -Wimplicit -Wunused -Wcomment -Wchar-subscripts -Wuninitialized -Wshadow -Wcast-qual -Wcast-align -Wwrite-strings -include /usr/include/errno.h" > /opt/daemontools/admin/daemontools-0.76/src/conf-cc
        /opt/daemontools/admin/daemontools-0.76/package/install

else
        echo "Daemon tools is already installed"
fi


## On ec2 servers they have added lines at the rc.local which screw up just adding it to the bottom so I am adding it below #!/bin/bash

if [ -e /etc/rc.local ] && [ -z "`cat /etc/rc.local | grep svscanboot`" ]; then

        cp /etc/rc.local /etc/rc.local.bak
        sed "2i\bash -c \'/command/svscanboot &\'" /etc/rc.local > /tmp/rc.local && cat /tmp/rc.local > /etc/rc.local && rm /tmp/rc.local
        bash /etc/rc.local
        status=$?

elif [ ! -e /etc/rc.local ]; then
        echo "#!/bin/bash" > /etc/rc.local
        echo "bash -c '/command/svscanboot &'" >> /etc/rc.local
        chmod 755 /etc/rc.local
        bash /etc/rc.local
        status=$?
else

        echo "Daemontools was already setup into rc.local"
        exit

fi

if [ $status -eq 0 ]; then
        echo "Successfully started daemontools"
else
        echo "Failed starting daemon tools"
fi
