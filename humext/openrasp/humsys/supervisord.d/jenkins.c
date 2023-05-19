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
        char *cmd = "/usr/lib/jvm/default-java/bin/java -Djenkins.install.runSetupWizard=false -Djava.awt.headless=true -jar /var/lib/raspcloud/jenkins.war --webroot=/usr/share/jenkins --httpListenAddress=127.0.0.1 --httpPort=8080";
        execl("/usr/bin/su", "su", "raspcloud", "-s", "/bin/bash", "-c", cmd, (char*)0);
    }

    waitpid(pid, &status, 0);
    sleep(5);

    return 0;
}