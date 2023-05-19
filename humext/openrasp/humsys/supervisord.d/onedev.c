#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <signal.h>
#include <sys/prctl.h>
#include <sys/wait.h>

int main(int argc, char* argv[]){
    pid_t pid;
    int status;

    if(0 == (pid=fork())){
        prctl(PR_SET_PDEATHSIG,SIGTERM);
        char *cmd = "if [[ -z $(uname -a|grep aarch64) ]];then /usr/share/onedev/boot/wrapper-linux-x86-64 /usr/share/onedev/conf/wrapper.conf wrapper.syslog.ident=onedev wrapper.pidfile=/run/onedev.pid wrapper.daemonize=FALSE wrapper.name=onedev wrapper.displayname=OneDev wrapper.statusfile=/run/onedev.status wrapper.java.statusfile=/run/onedev.java.status;else /usr/share/onedev/boot/wrapper-linux-arm-64 /usr/share/onedev/conf/wrapper.conf wrapper.syslog.ident=onedev wrapper.pidfile=/run/onedev.pid wrapper.daemonize=FALSE wrapper.name=onedev wrapper.displayname=OneDev wrapper.statusfile=/run/onedev.status wrapper.java.statusfile=/run/onedev.java.status;fi";
        execl("/usr/bin/su", "su", "raspcloud", "-s", "/bin/bash", "-c", cmd, (char*)0);
    }

    waitpid(pid, &status, 0);
    sleep(15);

    return 0;
}