(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-cpp-generator))

(in-package :cl-cpp-generator)


(defmacro e (&body body)
  `(statements (<< "std::cout" ,@(loop for e in body collect
                                      (cond ((stringp e) `(string ,e))
                                            (t e))) "std::endl")))

(defmacro er (&body body)
  `(statements (<< "std::cerr" ,@(loop for e in body collect
                                      (cond ((stringp e) `(string ,e))
                                            (t e))) "std::endl")))

(defun replace-all (string part replacement &key (test #'char=))
"Returns a new string in which all the occurences of the part 
is replaced with replacement."
    (with-output-to-string (out)
      (loop with part-length = (length part)
            for old-pos = 0 then (+ pos part-length)
            for pos = (search part string
                              :start2 old-pos
                              :test test)
            do (write-string string out
                             :start old-pos
                             :end (or pos (length string)))
            when pos do (write-string replacement out)
            while pos))) 


(defun dox (&key brief usage params return)
  `(
    (raw " ")
    (raw ,(format nil "//! @brief ~a" brief)) (raw "//! ")
    (raw ,(format nil "//! @usage ~a" usage)) (raw "//! ")
    ,@(loop for (name desc) in params collect
         `(raw ,(format nil "//! @param ~a ~a" name desc)))
    (raw "//! ")
    (raw ,(format nil "//! @return ~a" return))
    (raw " ")))


(defparameter *facts*
  `((10 "")))



(defmacro with-open-fstream ((f fn &key (dir "/dev/shm")) &body body)
  `(let ((,f :type "std::ofstream" :ctor (comma-list (string ,(format nil "~a/~a" dir fn)))))
     ,@body))

(defparameter *space-packet* ;; byte-order big-endion
   `(
     ;; start of packet primary header
     (packet-version-number 0 :bits 3)
     (packet-type 0 :bits 1)
     (secondary-header-flag 0 :bits 1)
     (application-process-id-process-id 0 :bits 7)
     (application-process-id-packet-category 0 :bits 4) 
     (sequence-flags 0 :bits 2)
     (sequence-count 0 :bits 14) ;; 0 at start of measurement, wraps after 16383
     (data-length 0 :bits 16) ;; (number of octets in packet data field)
     ;; - 1, includes 62 octets of secondary
     ;; header and the user data field of
     ;; variable length start of packet data
     ;; field datation service p. 15
     (coarse-time 0 :bits 32)
     (fine-time 0 :bits 16)
     ;; fixed ancillary data service
     (sync-marker #x352EF853
		  :bits 32)
     (data-take-id 0 :bits 32)
     (ecc-number 0 :bits 8)
     (ignore-0 0 :bits 1)
     (test-mode 0 :bits 3)
     (rx-channel-id 0 :bits 4)
     (instrument-configuration-id 0 :bits 32)
     ;; sub-commutation ancillary data service
     (sub-commutated-index 0 :bits 8) ;; 1..64 slowly fills datastructure
     ;; on p23,24,25 0 indicates invalid data word consistent set only
     ;; after contiguous sequence 1..22 (pvt), 23..41 (attitude) or
     ;; 42..64 (temperatures)
     (sub-commutated-data 0 :bits 16) 
     ;; counters service
     (space-packet-count 0 :bits 32) ;; from beginning of data take
     (pri-count 0 :bits 32)
     ;; radar configuration support service
     (error-flag 0 :bits 1)
     (ignore-1 0 :bits 2)
     (baq-mode 0 :bits 5)
     (baq-block-length 0 :bits 8)
     (ignore-2 0 :bits 8)
     (range-decimation 0 :bits 8)
     (rx-gain 0 :bits 8)
     ;;(tx-ramp-rate 0 :bits 16)
     (tx-ramp-rate-polarity 0 :bits 1)
     (tx-ramp-rate-magnitude 0 :bits 15)
     (tx-pulse-start-frequency-polarity 0 :bits 1)
     (tx-pulse-start-frequency-magnitude 0 :bits 15)
     (tx-pulse-length 0 :bits 24)
     (ignore-3 0 :bits 3)
     (rank 0 :bits 5)
     (pulse-repetition-interval 0 :bits 24)
     (sampling-window-start-time 0 :bits 24)
     (sampling-window-length 0 :bits 24)
     ;;(sab-ssb-message 0 :bits 24)
     (sab-ssb-calibration-p 0 :bits 1)
     (sab-ssb-polarisation 0 :bits 3)
     (sab-ssb-temp-comp 0 :bits 2)
     (sab-ssb-ignore-0 0 :bits 2)
     (sab-ssb-elevation-beam-address 0 :bits 4) ;; if calibration-p=1 sastest caltype
     (sab-ssb-ignore-1 0 :bits 2)
     (sab-ssb-azimuth-beam-address 0 :bits 10)
     ;;(ses-ssb-message 0 :bits 24)
     (ses-ssb-cal-mode 0 :bits 2)
     (ses-ssb-ignore-0 0 :bits 1)
     (ses-ssb-tx-pulse-number 0 :bits 5)
     (ses-ssb-signal-type 0 :bits 4)
     (ses-ssb-ignore-1 0 :bits 3)
     (ses-ssb-swap 0 :bits 1)
     (ses-ssb-swath-number 0 :bits 8)
     ;; radar sample count service
     (number-of-quads 0 :bits 16)
     (ignore-4 0 :bits 8)
     ))


(defparameter slot-idx (position 'data-length *space-packet* :key #'first))

(elt *space-packet* slot-idx)


(defparameter preceding-bits
 (reduce #'+
	 (mapcar #'(lambda (x)
		     (destructuring-bind (name_ default-value &key bits) x
		       bits))
		 (subseq *space-packet* 0 (position ;'sync-marker
						    'test-mode
						    *space-packet* :key #'first)))))

(floor 169 8)
(floor 96 8)

(defun space-packet-slot-get (slot-name data8)
  (let* ((slot-idx (position slot-name *space-packet* :key #'first))
	 (preceding-slots (subseq *space-packet* 0 slot-idx))
	 (sum-preceding-bits (reduce #'+
				     (mapcar #'(lambda (x)
						 (destructuring-bind (name_ default-value &key bits) x
						   bits))
					     preceding-slots)))
	 )
    (multiple-value-bind (preceding-octets preceding-bits) (floor sum-preceding-bits 8) 
      (destructuring-bind (name_ default-value &key bits) (elt *space-packet* slot-idx)
	
	(format t "~a ~a ~a ~a" preceding-octets preceding-bits bits default-value)
	(let ((mask 0))
	  (setf (ldb (byte bits (- 8 preceding-bits)) mask) #xff)
	 `(>> (&
	       (hex ,mask)
	       (aref ,data8 (+ 1 ,preceding-octets)))
	      (- 8 (+ bits preceding-bits))))))))

(space-packet-slot-get 'test-mode 'data8)

(progn
  (progn
 (defparameter *ecc-uint8-number-type-enum*
   `(contingency-0
     Stripmap-1
     Stripmap-2
     Stripmap-3
     Stripmap-4
     Stripmap-5n
     Stripmap-6
     contingency-7
     Interferometric-Wide-Swath
     Wave-Leapfrog-mode
     Stripmap-5s
     Stripmap-1-wo-interl-cal
     Stripmap-2-wo-interl-cal
     Stripmap-3-wo-interl-cal
     Stripmap-4-wo-interl-cal
     RFC-mode
     Test-Mode
     Elevation-Notch-S3
     Azimuth-Notch-S1
     Azimuth-Notch-S2
     Azimuth-Notch-S3
     Azimuth-Notch-S4
     Azimuth-Notch-S5n
     Azimuth-Notch-S5s
     Stripmap-5n-wo-interl-cal
     Stripmap-5s-wo-interl-cal
     Stripmap-6-wo-interl-cal
     contingency-28
     contingency-29
     contingency-30
     Elevation-Notch-S3-wo-interl-cal
     Extra-Wide-Swath
     Azimuth-Notch-S1-wo-interl-cal
     Azimuth-Notch-S3-wo-interl-cal
     Azimuth-Notch-S6-wo-interl-cal
     contingency-36
     Noise-Characterisation-S1
     Noise-Characterisation-S2
     Noise-Characterisation-S3
     Noise-Characterisation-S4
     Noise-Characterisation-S5n
     Noise-Characterisation-S5s
     Noise-Characterisation-S6
     Noise-Characterisation-EWS
     Noise-Characterisation-IWS
     Noise-Characterisation-Wave))


 
 )
  (let* ((code `(with-compilation-unit
		    (with-compilation-unit
			(raw "//! \\file main.c "))
		  
		  ;(include <iostream>)
					;(include <array>)

		  ,@(loop for e in `(<stdio.h>
				     <string.h>
				     <sys/mman.h>
				     <unistd.h>
				     <assert.h>
				     <sys/stat.h>
				     <fcntl.h>
				     <stdint.h>
				     <sys/types.h>) collect
			 `(include ,e))
		  
		  
		  
		  (raw " ")
		  
		  (raw " ")
		  (raw "//! \\mainpage safe parser")
		  (raw "//! \\section Introduction")
		  (raw "//! this is a parser for level 0 synthetic aperture radar data")
		  (raw "//! \\section Dependencies ")
		  (raw "//! - gcc or clang to compile c code")
		  (raw "//! - sbcl to generate c code")
		  (raw " ")
		  (raw "//! - For the documentation (optional for use):")
		  (raw "//!   + doxygen")
		  (raw " ")
		  (raw " ")
		  (raw "//! \\section References ")
		  
		  
		  ,@(loop for i from 1 and e in
			 '(""
			   )
		       collect
			 `(raw ,(format nil "//! ~a. ~a" i e)))
		  (raw " ")


		  (function (get_file_size ((filename :type "const char*"))
					   size_t)
			    (let ((st :type "struct stat"))
			      (funcall stat filename &st)
			      (return st.st_size)))
		  
		  
		  ,@(dox :brief "main function"
			 :usage "main program"
			 :params '((argc "input number of command line arguments")
				   (argv "input"))
			 :return "Integer")
		  		  
		  (function (main ((argc :type int)
				   (argv :type char**)) int)
			    (let ((fn :type "const char*" :init (string "/home/martin/Downloads/S1A_IW_RAW__0SDV_20190601T055817_20190601T055849_027482_0319D1_537D.SAFE/s1a-iw-raw-s-vv-20190601t055817-20190601t055849-027482-0319d1.dat"))
				  (filesize :type size_t :init (funcall get_file_size fn))
				  (fd :type int :init (funcall open fn O_RDONLY 0))
				  )
			      (funcall assert (!= fd -1))
			      (let ((mmapped_data
				     :type void*
				     :init
				     (funcall mmap NULL filesize PROT_READ
					      MAP_PRIVATE
					      #+nil(|\|| MAP_PRIVATE
						    MAP_POPULATE ;; let kernel preload parts
						    )
					      fd
					      0)))
				(funcall assert (!= mmapped_data MAP_FAILED))

				(let ((dat16 :type "const uint16_t * const"
					     :init (cast "const uint16_t * const"
							 mmapped_data)))
				  (funcall printf (string "sequence-flags=0x%x\\n") (& (hex #xc000) (aref dat16 1)))
				  (funcall printf (string "packet-sequence-count=0x%x\\n") (& (hex #x3fff) (aref dat16 1)))
				  (funcall printf (string "packet-data-length-octets=%d\\n") (aref dat16 2))
				  (funcall printf (string "sync-marker=0x%x\\n") (aref dat16 6)))
				
				(let ((rc :type int :init (funcall munmap mmapped_data filesize)))
				  (funcall assert (== rc 0))))
			      (funcall close fd))
			    
			    (return 0)))))
    (write-source "stage/satellite-plot/source/main_safe" "c" code)))


  
#x352ef853
