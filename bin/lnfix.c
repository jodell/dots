// http://stackoverflow.com/questions/1432540/creating-directory-hard-links-in-macos-x

#include <unistd.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
  if (argc != 3) {
    fprintf(stderr,"Use: hlink <src_dir> <target_dir>\n");
    return 1; 
  }
  int ret = link(argv[1],argv[2]);
  if (ret != 0) perror("link");
  return ret;
}

