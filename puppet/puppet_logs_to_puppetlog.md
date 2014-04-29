puppet logs to puppet.log
=========================

this project explains how to seperate out the puppet logs and provides information on how to set up easy aliases to look up puppet restart and its logs


To get puppet to its own file a few things needs to be done:

In order to get puppet to log to its own file the following should be outputted as part of the init.d/puppet file needs to show when puppet is running on any machine :

            /usr/bin/ruby /usr/sbin/puppetd --autoflush --logdest=/var/log/puppet.log
            


How to make puppet start up do this?

On your master puppet server you should be pushing out the init.d/puppet script to all the hosts: the following needs to be done



           # Source function library.
           . /etc/rc.d/init.d/functions
            #### Under below ensure you have the autoflush option:


               PUPPET_OPTS=" --autoflush "
               [ -n "${PUPPET_SERVER}" ] && PUPPET_OPTS="--server=${PUPPET_SERVER}"
               [ -n "$PUPPET_LOG" ] && PUPPET_OPTS="${PUPPET_OPTS} --logdest=${PUPPET_LOG}"
               [ -n "$PUPPET_PORT" ] && PUPPET_OPTS="${PUPPET_OPTS} --masterport=${PUPPET_PORT}"


vi /etc/sysconfig/puppet

                      # Where to log to. Specify syslog to send log messages to the system log.
                      
                      PUPPET_LOG=/var/log/puppet.log
                      
This file now needs to go to your sysconfig-puppet file (to be sent to all hosts)
                    
                    cp /etc/sysconfig/puppet /etc/puppet/{your_folder}/modules/puppet/sysconfig-puppet/files/sysconfig-puppet






----------------------------------------------------------------------------------------------------

Within a few hours all the hosts should start logging puppet stuff to /var/log/puppet.log


Now your own configuration:

vi ~/.bashrc

         alias s='echo start'
         alias t='echo stop'
         alias r='echo restart'
         function ss { /sbin/service "$@"; }
         export ss
         function tf { tail -f "$1";  }
         export tf
         function lss { less "$@"; }
         export lss
         alias pl='echo /var/log/puppet.log'
         function prp { ss puppet $(r) && tf $(pl); }
         export prp
         
         
         

now when you do sudo bash
and run

           prp


           
This will stop/start puppet and tail -f /var/log/puppet.log








