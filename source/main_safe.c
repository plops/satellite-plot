//! \file main.c
#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

//! \mainpage safe parser
//! \section Introduction
//! this is a parser for level 0 synthetic aperture radar data
//! \section Dependencies
//! - gcc or clang to compile c code
//! - sbcl to generate c code

//! - For the documentation (optional for use):
//!   + doxygen

//! \section References
//! 1.

size_t get_file_size(const char *filename) {
  {
    struct stat st;
    stat(filename, &st);
    return st.st_size;
  }
}

//! @brief main function
//!
//! @usage main program
//!
//! @param argc input number of command line arguments
//! @param argv input
//!
//! @return Integer

int main(int argc, char **argv) {
  {
    const char *fn =
        "/home/martin/Downloads/"
        "S1A_IW_RAW__0SDV_20190601T055817_20190601T055849_027482_0319D1_537D."
        "SAFE/"
        "s1a-iw-raw-s-vv-20190601t055817-20190601t055849-027482-0319d1.dat";
    size_t filesize = get_file_size(fn);
    int fd = open(fn, O_RDONLY, 0);
    assert((fd != -1));
    {
      void *mmapped_data =
          mmap(NULL, filesize, PROT_READ, (MAP_PRIVATE | MAP_POPULATE), fd, 0);
      assert((mmapped_data != MAP_FAILED));
      {
        int rc = munmap(mmapped_data, filesize);
        assert((rc == 0));
      }
    }
    close(fd);
  }
  return 0;
}