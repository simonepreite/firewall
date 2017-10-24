#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <pwd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <execs.h>
#include <sys/time.h>
#include <assert.h>

struct timeval tv;

char* alloc_cmd(char *dst, char *src1, char *src2){
	dst = (char*)malloc(strlen(src1)+strlen(src2));
	strcpy(dst, src1);
	strcat(dst, src2);
	return dst;
}

int main(int argc, char** argv) {
    char *create_tap = "./create_tap.sh ";
    char *start_vdens = "vdens tap:/\/";
    char *del_tap = "./delete_tap.sh ";
    int *status, euid, ruid, rgid, tap_name_len;
    register struct passwd *pw;
    char *buf, *tap_name, *creation, *execution, *destroy;
    
    ruid = getuid();
    rgid = getgid();
    euid = geteuid();

    seteuid(ruid);
    setegid(rgid); //dropping root privileges

    /*root privileges are available only into child to
    create/destroy network interfaces */

    gettimeofday(&tv,NULL);

    pw = getpwuid (ruid);

    const int n = snprintf(NULL, 0, "%lu", tv.tv_sec);
    assert(n > 0);
    buf = (char*)malloc((n+1)*sizeof(char));

    int c = snprintf(buf, n+1, "%lu", tv.tv_sec);
    assert(buf[n] == '\0');
    assert(c == n);
    
    tap_name_len = strlen(pw->pw_name);

    
    tap_name = (char*)malloc((tap_name_len + n + 1)*sizeof(char));

    strcpy(tap_name, pw->pw_name);

    strcat(tap_name, buf);

    creation = alloc_cmd(creation, create_tap, tap_name);
    execution = alloc_cmd(execution, start_vdens, tap_name);
    destroy = alloc_cmd(destroy, del_tap, tap_name);

    /*creation = (char*)malloc(strlen(create_tap)+strlen(tap_name));
	strcpy(creation, create_tap);
	strcat(creation, tap_name);
    execution = (char*)malloc(strlen(start_vdens)+strlen(tap_name));
	strcpy(execution, start_vdens);
	strcat(execution, tap_name);
    destroy = (char*)malloc(strlen(del_tap)+strlen(tap_name));
	strcpy(destroy, del_tap);
	strcat(destroy, tap_name);*/

	free(buf);
   	free(tap_name);

    switch(fork()){
      case 0:
      	seteuid(euid); // set root to create tap
      	execsp(creation);
	break;
      default:
        wait(status);
        break;
     }
     switch(fork()){
       case 0:
         execsp(execution);
         break;
       default:
	  wait(status);
	  break;
     }
     switch(fork()){
       case 0:
	 seteuid(euid); // set root to destroy tap
         execsp(destroy);
	 break;
	default:
	  wait(status);
	  break;
     }

    free(creation);
    free(execution);
    free(destroy);

return 0;
}


