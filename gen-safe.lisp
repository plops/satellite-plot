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

(progn
  (let* ((code `(with-compilation-unit
		    (with-compilation-unit
			(raw "//! \\file main.c "))
		  
		  ;(include <iostream>)
					;(include <array>)

		  (include <stdio.h>)
		  (include <string.h>)
		  (include <sys/mman.h>)
		  (include <unistd.h>)
		  
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
				  ))
			    
			    (return 0)))))
    (write-source "stage/satellite-plot/source/main_safe" "c" code)))


                                
