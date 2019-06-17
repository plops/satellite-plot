//! \file main.c
#include <assert.h>
#include <fcntl.h>
#include <stdint.h>
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
      void *mmapped_data = mmap(NULL, filesize, PROT_READ, MAP_PRIVATE, fd, 0);
      assert((mmapped_data != MAP_FAILED));
      {
        const uint16_t *const dat16 = ((const uint16_t *const)(mmapped_data));
        const uint8_t *const data8 = ((const uint8_t *const)(mmapped_data));
        {
          uint64_t offset = 0;
          size_t count = 0;
          while ((offset < filesize)) {
            {
              const uint8_t *const dat8 = (data8 + offset);
              printf("count=%d\n", count);
              printf("  offset=%d\n", offset);
              printf("  packet-sequence-count=%d\n",
                     ((1 * dat8[3]) + (256 * (0x3F & dat8[2]))));
              printf("  packet-data-length-octets=%d\n",
                     ((1 * dat8[5]) + (256 * (0xFF & dat8[4]))));
              printf("  all-length-octets=%d\n",
                     (6 + 1 + ((1 * dat8[5]) + (256 * (0xFF & dat8[4])))));
              offset = (offset +
                        (6 + 1 + ((1 * dat8[5]) + (256 * (0xFF & dat8[4])))));
              assert((((1 * dat8[15]) + (256 * dat8[14]) + (65536 * dat8[13]) +
                       (16777216 * (0xFF & dat8[12]))) == 0x352EF853));
              printf("  test-mode=0x%x\n",
                     ((0x70 & dat8[(1 + 21)]) >> (8 - (3 + 1))));
              printf("  tx-pulse-start-frequency-magnitude=%d\n",
                     ((1 * dat8[45]) + (256 * (0x7F & dat8[44]))));
            }
            count = (count + 1);
          }
        }
      }
      {
        int rc = munmap(mmapped_data, filesize);
        assert((rc == 0));
      }
    }
    close(fd);
  }
  return 0;
}