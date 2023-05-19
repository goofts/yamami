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
        char *cmd = "cp -rf /humsys/hub.d/kibana.yml /usr/share/kibana/config/&&cd /usr/share/kibana/bin&&./kibana";
        execl("/usr/bin/su", "su", "elastic", "-s", "/bin/bash", "-c", cmd, (char*)0);
    }

    waitpid(pid, &status, 0);
    sleep(5);

    return 0;
}