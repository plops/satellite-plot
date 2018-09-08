;; martin@localhost ~/quicklisp/local-projects
;; $ git clone https://github.com/heegaiximephoomeeghahyaiseekh/lisp-binary
(declaim (optimize
	  (speed 0) (safety 3) (debug 3
				      )))
(ql:quickload :lisp-binary)
(ql:quickload :structy-defclass)



(defpackage :g
  (:use :cl :lisp-binary :structy-defclass))

(in-package :g)

;; S1A_IW_RAW__0SSH_20180819T144551_20180819T144623_023316_02892E_DDA9.zip
;; https://scihub.copernicus.eu/apihub/odata/v1/Products('87b645f0-852a-4b27-ae05-829b09622da5')/$value
(defparameter *fn* (elt (directory "/home/martin/Downloads/S*/*-??????.dat") 0))
;; https://github.com/heegaiximephoomeeghahyaiseekh/lisp-binary/wiki/DEFBINARY

;; https://sentinel.esa.int/documents/247904/685163/Sentinel-1-SAR-Space-Packet-Protocol-Data-Unit.pdf

(define-enum ecc-number-type 1 ()
	     contingency-0
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
	     Noise-Characterisation-Wave)

(defbinary space-packet1 (:byte-order :big-endian)
  ;; start of packet primary header
  (packet-version-number 0 :type 3)
  (packet-type 0 :type 1)
  (secondary-header-flag 0 :type 1)
  (application-process-id-process-id 0 :type 7)
  (application-process-id-packet-category 0 :type 4) 
  (sequence-flags 0 :type 2)
  (sequence-count 0 :type 14) ;; 0 at start of measurement, wraps after 16383
  (data-length 0 :type 16) ;; (number of octets in packet data field)
  ;; - 1, includes 62 octets of secondary
  ;; header and the user data field of
  ;; variable length start of packet data
  ;; field datation service p. 15
  (coarse-time 0 :type 32)
  (fine-time 0 :type 16)
  ;; fixed ancillary data service
  (sync-marker #x352EF853
	       :type (magic :actual-type (unsigned-byte 32)
			    :value #x352EF853))
  (data-take-id 0 :type 32)
  (ecc-number 0 :type ecc-number-type)
  (ignore-0 0 :type 1)
  (test-mode 0 :type 3)
  (rx-channel-id 0 :type 4)
  (instrument-configuration-id 0 :type 32)
  ;; sub-commutation ancillary data service
  (sub-commutated-index 0 :type 8) ;; 1..64 slowly fills datastructure
  ;; on p23,24,25 0 indicates invalid data word consistent set only
  ;; after contiguous sequence 1..22 (pvt), 23..41 (attitude) or
  ;; 42..64 (temperatures)
  (sub-commutated-data 0 :type 16) 
  ;; counters service
  (space-packet-count 0 :type 32) ;; from beginning of data take
  (pri-count 0 :type 32)
  ;; radar configuration support service
  (error-flag 0 :type 1)
  (ignore-1 0 :type 2)
  (baq-mode 0 :type 5)
  (baq-block-length 0 :type 8)
  (ignore-2 0 :type 8)
  (range-decimation 0 :type 8)
  (rx-gain 0 :type 8)
  ;;(tx-ramp-rate 0 :type 16)
  (tx-ramp-rate-polarity 0 :type 1)
  (tx-ramp-rate-magnitude 0 :type 15)
  (tx-pulse-start-frequency-polarity 0 :type 1)
  (tx-pulse-start-frequency-magnitude 0 :type 15)
  (tx-pulse-length 0 :type 24)
  (ignore-3 0 :type 3)
  (rank 0 :type 5)
  (pulse-repetition-intervall 0 :type 24)
  (sampling-window-start-time 0 :type 24)
  (sampling-window-length 0 :type 24)
  ;;(sab-ssb-message 0 :type 24)
  (sab-ssb-calibration-p 0 :type 1)
  (sab-ssb-polarisation 0 :type 3)
  (sab-ssb-temp-comp 0 :type 2)
  (sab-ssb-ignore-0 0 :type 2)
  (sab-ssb-elevation-beam-address 0 :type 4) ;; if calibration-p=1 sastest caltype
  (sab-ssb-ignore-1 0 :type 2)
  (sab-ssb-azimuth-beam-address 0 :type 10)
  ;;(ses-ssb-message 0 :type 24)
  (ses-ssb-cal-mode 0 :type 2)
  (ses-ssb-ignore-0 0 :type 1)
  (ses-ssb-tx-pulse-number 0 :type 5)
  (ses-ssb-signal-type 0 :type 4)
  (ses-ssb-ignore-1 0 :type 3)
  (ses-ssb-swap 0 :type 1)
  (ses-ssb-swath-number 0 :type 8)
  ;; radar sample count service
  (number-of-quads 0 :type 16)
  (ignore-4 0 :type 8)
  )


(with-open-binary-file (in *fn* :direction :input)
  (let* (;(file-size (file-length in))
	 (header (read-binary 'space-packet1 in)))
    (with-slots (data-length) header
      (let* ((pdl data-length)
	     (len-sh 62)
	     (len-ud (+ pdl (- len-sh) 1)))
	(declare (type fixnum data-length len-sh len-ud))
	(file-position in (+ (file-position in) len-ud))
	(let ((header1 (read-binary 'space-packet1 in)))
	  (list (file-position in) len-ud data-length header header1))))))

(deftclass space-packet
  header
  filename 
  header-position
  user-data-position)

(defparameter *headers*
  (with-open-binary-file (in *fn* :direction :input)
    (let ((n (file-length in)))
      (loop while (< (file-position in) n) collect 
	   (let* ((current-header-position (file-position in))
		  (header (read-binary 'space-packet1 in)))
	     (with-slots (data-length) header
	       (let* ((pdl data-length)
		      (len-sh 62)
		      (len-ud (+ pdl (- len-sh) 1))
		      (current-user-data-position (file-position in)))
		 (file-position in (+ current-user-data-position len-ud))
		 (make-space-packet :header header
				    :filename *fn*
				    :header-position current-header-position
				    :user-data-position current-user-data-position))))))))


(defmethod csv-header ((o space-packet1) s)
  (format s "~{~a~^,~}~%"
	  (mapcar #'sb-mop:slot-definition-name
		  (sb-mop:class-direct-slots (class-of o)))))

(defmethod csv-line ((o space-packet1) s)
  (let* ((slots (mapcar #'sb-mop:slot-definition-name
			(sb-mop:class-direct-slots (class-of o))))
	 (vals (mapcar #'(lambda (x) (slot-value o x))
		       slots)))
    (format s "~{~a~^,~}~%"
	    vals)))

(with-open-file (s "/dev/shm/headers.csv" :direction :output
		   :if-exists :supersede)
  (csv-header (slot-value (elt *headers* 0) 'header) s)
  (loop for e in *headers* do
       (csv-line (slot-value e 'header) s)))

(defmethod get-user-data ((o space-packet))
  (with-slots (filename user-data-position) o
    (with-open-file (in filename :direction :input :element-type '(unsigned-byte 8))
      (let* (;(file-size (file-length in))
	     )
	(file-position in user-data-position)
	(read-byte in)))))

(defmethod get-user-data-bit ((o space-packet) n)
  "go to the first octet of the user data. then go to the n//8-th byte
and return the nth bit "
  (declare (number n))
  ;; FIXME: this can be optimized, close over the open file
  (with-slots (filename user-data-position) o
    (with-open-file (in filename :direction :input :element-type '(unsigned-byte 8))
      (let* (;(file-size (file-length in))
	     )
	(multiple-value-bind (byte-nr bit-nr) (floor n 8)
	  (file-position in (+ user-data-position byte-nr))
	  (ldb (byte 1 (- 7 bit-nr)) (read-byte in)))))))


(defmacro with-sequential-bit-function ((o &key (name 'next-bit) (start-byte 0)) &body
										   body)
  (let ((current-byte (gensym "CURRENT-BYTE"))
	(in (gensym "IN"))
	(filename (gensym "FILENAME"))
	(user-data-position (gensym "USER-DATA-POSITION"))
	(current-bit-count (gensym "CURRENT-BIT-COUNT")))
    `(with-slots ((,filename filename)
		  (,user-data-position user-data-position)) ,o
       (with-open-file (,in ,filename :direction :input :element-type
			    '(unsigned-byte 8))
	 (file-position ,in (+ ,user-data-position ,start-byte))
	 (let ((,current-byte (read-byte ,in))
	       (,current-bit-count 0))
	   (labels ((,name ()
		      (prog1
			  (ldb (byte 1 (- 7 ,current-bit-count)) ,current-byte)
			(incf ,current-bit-count)
			(when (< 7 ,current-bit-count)
			  (setf ,current-bit-count 0
				,current-byte (read-byte ,in))))))
	     ,@body))))))

(defmacro gen-huffman-decoder (name huffman-tree)
  "given a huffman tree generate a state machine that reads a symbol
dependent number of consecutive bits using the function next-bit-fun
and returns one decoded symbol."
  (labels ((frob (tree)
	     (cond ((null tree)
		    (error "null"))
		   ((atom tree) tree)
		   ((null (cdr tree))
		    (car tree))
		   (t `(if (funcall next-bit-fun)
			   
			   ,(frob (cadr tree))
			   ,(frob (car tree))
			   )))))
    `(defun ,(intern (format nil "DECODE-~a" name))
	 (next-bit-fun)
       (declare (type function next-bit-fun))
       ,(frob huffman-tree))))

(gen-huffman-decoder brc0 (0 (1 (2 (3))))) ;; page 71 in space packet protocol data unit
(gen-huffman-decoder brc1 (0 (1 (2 (3 (4))))))
(gen-huffman-decoder brc2 (0 (1 (2 (3 (4 (5 (6))))))))
(gen-huffman-decoder brc3 ((0 1) (2 (3 (4 (5 (6 (7 (8 (9))))))))))
(gen-huffman-decoder brc4 ((0 (1 2)) ((3 4) ((5 6) (7 (8 (9 ((10 11) ((12 13) (14 15))))))))))




(defparameter *decoder* (let ((l '(decode-brc0
				   decode-brc1
				   decode-brc2
				   decode-brc3
				   decode-brc4)))
			  (make-array (length l) :initial-contents l)))

(defmethod get-brc ((o space-packet))
  (loop for j below 3 sum
       (* (expt 2 (- 2 j)) (get-user-data-bit o j))))

;; flexible dynamic block adaptive quantization (fdbaq)
;; Guccione Sentinel-1 FDBAQ Performances (2012) 10.1109/TyWRRS.2012.6381096
;; quantization follows thermal snr of block
;; more quality is assigned for the best targets (based on antenna input power)

;; on-ground the optimal quantizers and rate selection thresholds are
;; selected by predicting system performance for specific missions

;; 3 bits followed by 128 hcodes
;; 3 bits ...
;; repeats until number-of-quads hcodes were sent
;; padding until the last 16bit
;; don't forget the sign bits
;; the overall package length (with header) a multiple of 32bit (4 octets p.13)
#+nil
(defparameter *quads*
  (let* ((pkg (elt *headers* 0))
	 (current-bit 0)
	 (brc-list ())
	 (thidx-list ())
	 (verbose t))
    ))



(defmethod decompress ((pkg space-packet) &key (verbose nil))
  (let* ((pkg (elt *headers* 0))
	 (current-bit 0)
	 (brc-list ())
	 (thidx-list ()))
    (with-slots (number-of-quads data-length) (slot-value pkg 'header)
      (let (#+nil
	    (number-of-baq-blocks (ceiling (* 2 number-of-quads)
					   256)))
	(with-sequential-bit-function (pkg :name next-bit)
	  (labels (#+nil (next-bit ()
			   (prog1
			       (get-user-data-bit pkg current-bit)
			     (incf current-bit)))
			 (next-bit-p ()
			   (= 1 (next-bit)))
			 (get-brc ()
			   (loop for j below 3 sum
				(* (expt 2 (- 2 j)) (next-bit))))
			 (get-thidx ()
			   (loop for j below 8 sum
				(* (expt 2 (- 7 j)) (next-bit))))
			 (consume-padding-bits ()
			   (let ((pad (- 16 (mod current-bit 16))))
			     (dotimes (i pad)
			       ;; consume padding bits until next 16bit word boundary
			       (next-bit))
			     (when verbose
			       (format t "consuming ~a padding bits.~%" pad))
			     pad)))
	    (let ((ie-symbols
		   (let ((decoded-symbols 0))
		     (prog1
			 (loop while (< decoded-symbols number-of-quads) collect
			      (let* ((current-brc (get-brc))
				     (dec (elt *decoder* current-brc)))
				(push current-brc brc-list)
				(when verbose
				  (format t "~a~%" (list :ie-start-block :brc current-brc
							 :quad decoded-symbols
							 :16bit-word-and-rest
							 (multiple-value-list (floor current-bit 16)))))
				(prog1
				    (loop for i below 128 while (< decoded-symbols number-of-quads) collect
					 (prog1
		      			     (* (if (next-bit-p) 
						    -1
						    1)
						(funcall dec #'next-bit-p))
					   (incf decoded-symbols)))
				  (when verbose
				    (format t "~a~%" (list :ie-end-block :brc current-brc
							   :quad decoded-symbols
							   :16bit-word-and-rest
							   (multiple-value-list (floor current-bit 16))))))))
		       (consume-padding-bits)
		       (when verbose
			 (format t "~a~%" (list :ie-end-all 
						:16bit-word-and-rest
						(multiple-value-list (floor current-bit 16))))))))
		  (io-symbols
		   (let ((decoded-symbols 0))
		     (prog1
			 (loop for block from 0 while (< decoded-symbols number-of-quads) collect
			      (let* ((current-brc (elt brc-list block))
				     (dec (elt *decoder* current-brc)))
				(when verbose
				  (format t "~a~%" (list :io-start-block :brc current-brc
							 :block block
							 :quad decoded-symbols
							 :16bit-word-and-rest
							 (multiple-value-list (floor current-bit 16)))))
				(prog1
				    (loop for i below 128 while (< decoded-symbols number-of-quads) collect
					 (prog1
		      			     (* (if (next-bit-p) 
						    -1
						    1)
						(funcall dec #'next-bit-p))
					   (incf decoded-symbols)))
				  (when verbose
				    (format t "~a~%" (list :io-end-block :brc current-brc
							   :block block
							   :quad decoded-symbols
							   :16bit-word-and-rest
							   (multiple-value-list (floor current-bit 16))))))))
		       (consume-padding-bits)
		       (when verbose
			 (format t "~a~%" (list :io-end-all 
						:16bit-word-and-rest
						(multiple-value-list (floor current-bit 16))))))))
		  (qe-symbols
		   (let ((decoded-symbols 0))
		     (prog1
			 (loop for block from 0 while (< decoded-symbols number-of-quads) collect
			      (let* ((current-brc (elt brc-list block))
				     (current-thidx (get-thidx))
				     (dec (elt *decoder* current-brc)))
				(push current-thidx thidx-list)
				(when verbose
				  (format t "~a~%" (list :qe-start-block :brc current-brc
							 :block block
							 :thidx current-thidx
							 :quad decoded-symbols
							 :16bit-word-and-rest
							 (multiple-value-list (floor current-bit 16)))))
				(prog1
				    (loop for i below 128 while (< decoded-symbols number-of-quads) collect
					 (prog1
		      			     (* (if (next-bit-p) 
						    -1
						    1)
						(funcall dec #'next-bit-p))
					   (incf decoded-symbols)))
				  (when verbose
				    (format t "~a~%" (list :qe-end-block :brc current-brc
							   :block block
							   :thidx current-thidx
							   :quad decoded-symbols
							   :16bit-word-and-rest
							   (multiple-value-list (floor current-bit 16))))))))
		       (consume-padding-bits)
		       (when verbose
			 (format t "~a~%" (list :qe-end-all 
						:16bit-word-and-rest
						(multiple-value-list (floor current-bit 16))))))))
		  (qo-symbols
		   (let ((decoded-symbols 0))
		     (prog1
			 (loop for block from 0 while (< decoded-symbols number-of-quads) collect
			      (let* ((current-brc (elt brc-list block))
				     (dec (elt *decoder* current-brc)))
				(when verbose
				  (format t "~a~%" (list :qo-start-block :brc current-brc
							 :block block
							 :quad decoded-symbols
							 :16bit-word-and-rest
							 (multiple-value-list (floor current-bit 16)))))
				(prog1
				    (loop for i below 128 while (< decoded-symbols number-of-quads) collect
					 (prog1
		      			     (* (if (next-bit-p) 
						    -1
						    1)
						(funcall dec #'next-bit-p))
					   (incf decoded-symbols)))
				  (when verbose
				    (format t "~a~%" (list :qo-end-block :brc current-brc
							   :block block
							   :quad decoded-symbols
							   :16bit-word-and-rest
							   (multiple-value-list (floor current-bit 16))))))))
		       (consume-padding-bits)
		       (when verbose
			 (format t "~a~%" (list :qo-end-all 
						:16bit-word-and-rest
						(multiple-value-list (floor current-bit 16))
						:8bit-word (floor current-bit 8)
						;; current-bit counts from the beginning of the variable length 'user data field'
						;; data-length contains additional an 62 octets of the secondary packet header
						;; data-length-62+1 is the number of octets in the variable length 'user data field'
						:remaining-user-data-bits (- (* 8 (+ data-length 1 -62)) current-bit)
						:data-length data-length))))))
		  )
	      (list ie-symbols
		    io-symbols
		    qe-symbols
		    qo-symbols
		    ))))))))

(time (defparameter *quads* (decompress (elt *headers* 1))))
;; 5.5s

;; 4.72s 760MB consed
;; 0.016s 0.65MB consed

(defun decode-ie ()
  (let ((decoded-symbols 0))
    (prog1
	(loop while (< decoded-symbols number-of-quads) collect
	     (let* ((current-brc (get-brc))
		    (dec (elt *decoder* current-brc)))
	       (push current-brc brc-list)
	       (prog1
		   (loop for i below 128 while (< decoded-symbols number-of-quads) collect
			(prog1
		      	    (* (if (next-bit-p) 
				   -1
				   1)
			       (funcall dec #'next-bit-p))
			  (incf decoded-symbols))))))
      (consume-padding-bits))))

(defun decode-io ()
  (let ((decoded-symbols 0))
    (prog1
	(loop for block from 0 while (< decoded-symbols number-of-quads) collect
	     (let* ((current-brc (elt brc-list block))
		    (dec (elt *decoder* current-brc)))
	       (prog1
		   (loop for i below 128 while (< decoded-symbols number-of-quads) collect
			(prog1
		      	    (* (if (next-bit-p) 
				   -1
				   1)
			       (funcall dec #'next-bit-p))
			  (incf decoded-symbols))))))
      (consume-padding-bits))))

(defun decode-qe (&key verbose thidx)
  (let ((decoded-symbols 0))
    (prog1
	(loop for block from 0 while (< decoded-symbols number-of-quads) collect
	     (let* ((current-brc (elt brc-list block))
		    (current-thidx (get-thidx))
		    (dec (elt *decoder* current-brc)))
	       (push current-thidx thidx-list)
	       (when verbose
		 (format t "~a~%" (list :qe-start-block :brc current-brc
					:block block
					:thidx current-thidx
					:quad decoded-symbols
					:16bit-word-and-rest
					(multiple-value-list (floor current-bit 16)))))
	       (prog1
		   (loop for i below 128 while (< decoded-symbols number-of-quads) collect
			(prog1
		      	    (* (if (next-bit-p) 
				   -1
				   1)
			       (funcall dec #'next-bit-p))
			  (incf decoded-symbols)))
		 (when verbose
		   (format t "~a~%" (list :qe-end-block :brc current-brc
					  :block block
					  :thidx current-thidx
					  :quad decoded-symbols
					  :16bit-word-and-rest
					  (multiple-value-list (floor current-bit 16))))))))
      (consume-padding-bits)
      (when verbose
	(format t "~a~%" (list :qe-end-all 
			       :16bit-word-and-rest
			       (multiple-value-list (floor current-bit
							   16))))))))




(defun decode-qo ()
  (let ((decoded-symbols 0))
    (prog1
	(loop for block from 0 while (< decoded-symbols number-of-quads) collect
	     (let* ((current-brc (elt brc-list block))
		    (dec (elt *decoder* current-brc)))
	       (when verbose
		 (format t "~a~%" (list :qo-start-block :brc current-brc
					:block block
					:quad decoded-symbols
					:16bit-word-and-rest
					(multiple-value-list (floor current-bit 16)))))
	       (prog1
		   (loop for i below 128 while (< decoded-symbols number-of-quads) collect
			(prog1
		      	    (* (if (next-bit-p) 
				   -1
				   1)
			       (funcall dec #'next-bit-p))
			  (incf decoded-symbols)))
		 (when verbose
		   (format t "~a~%" (list :qo-end-block :brc current-brc
					  :block block
					  :quad decoded-symbols
					  :16bit-word-and-rest
					  (multiple-value-list (floor current-bit 16))))))))
      (consume-padding-bits)
      (when verbose
	(format t "~a~%" (list :qo-end-all 
			       :16bit-word-and-rest
			       (multiple-value-list (floor current-bit 16))
			       :8bit-word (floor current-bit 8)
			       ;; current-bit counts from the beginning of the variable length 'user data field'
			       ;; data-length contains additional an 62 octets of the secondary packet header
			       ;; data-length-62+1 is the number of octets in the variable length 'user data field'
			       :remaining-user-data-bits (- (* 8 (+ data-length 1 -62)) current-bit)
			       :data-length data-length))))))

(defparameter *verbose* nil)

(defun decode-quads (n &key (stage 0) get-brc verbose brc-list
			 get-thidx thidx-list consume-padding-bits next-bit-p)
  "stage=0 name=ie .. brc=true
   stage=1 name=io
   stage=2 name=qe .. thidx=true thidx-list=thidx-list
   stage=3 name=ie"
  (let ((decoded-symbols 0))
    (macrolet ((debug (step &key brc block thidx)
		 (when *verbose*
		   `(let ((names #.(let ((l '("ie" "io" "qe" "ie")))
				     (make-array (length l)
						 :element-type 'string
						 :initial-contents l))))
		      (format t "~a~%" (list :step step
					     :stage stage
					     :stage-name (elt names stage)
					     :brc brc
					     :block block
					     :thidx thidx
					     :quad decoded-symbols))))))
      (prog1
	  (debug :start-all)
	(loop for block from 0 while (< decoded-symbols n) collect
	     (let* ((current-brc (if get-brc
				     (let ((c (funcall get-brc)))
				       (push c brc-list)
				       c)
				     (elt brc-list block)))
		    (dec (elt *decoder* current-brc)))
	       (if get-thidx
		   (progn
		     (push (funcall get-thidx) thidx-list)
		     (debug :start :brc current-brc :block block
			    :thidx (car (last thidx-list))))
		   (debug :start :brc current-brc :block block))
	       
	       (prog1
		   (loop for i below 128 while (< decoded-symbols n) collect
			(prog1
		      	    (* (if (funcall next-bit-p) 
				   -1
				   1)
			       (funcall dec #'next-bit-p))
			  (incf decoded-symbols)))
		 (debug :stop :brc current-brc :block block))))
	(funcall consume-padding-bits)
	(debug :stop-all)))))

;;((ie-symbols (decode-quads number-of-quads :stage 0
;; 			   :get-brc #'get-brc
;; 			   :brc-list brc-list

;; 			   :verbose verbose
;; 			   :next-bit-p #'next-bit-p
;; 			   :consume-padding-bits #'consume-padding-bits
;; 			   ))
;; (io-symbols
;;  (decode-quads number-of-quads :stage 1
;; 		:brc-list brc-list
;; 		:verbose verbose
;; 		:next-bit-p #'next-bit-p
;; 		:consume-padding-bits #'consume-padding-bits))
;; (qe-symbols
;;  (decode-quads number-of-quads :stage 2
;; 		:brc-list brc-list
;; 		:get-thidx #'get-thidx
;; 		:thidx-list thidx-list
;; 		:verbose verbose
;; 		:next-bit-p #'next-bit-p
;; 		:consume-padding-bits #'consume-padding-bits))
;; (qo-symbols
;;  (decode-quads number-of-quads :stage 3
;; 		:brc-list brc-list
;; 		:verbose verbose
;; 		:next-bit-p #'next-bit-p
;; 		:consume-padding-bits #'consume-padding-bits)))


(defmethod decompress ((pkg space-packet) &key (verbose nil))
  (let* ((pkg (elt *headers* 0))
	 (current-bit 0)
	 (brcs ())
	 (thidxs ()))
    (with-slots (number-of-quads data-length) (slot-value pkg 'header)
      (let (#+nil
	    (number-of-baq-blocks (ceiling (* 2 number-of-quads)
					   256)))
	(with-sequential-bit-function (pkg :name next-bit)
	  (labels (#+nil (next-bit ()
			   (prog1
			       (get-user-data-bit pkg current-bit)
			     (incf current-bit)))
			 (next-bit-p ()
			   (= 1 (next-bit)))
			 (get-brc ()
			   (loop for j below 3 sum
				(* (expt 2 (- 2 j)) (next-bit))))
			 (get-thidx ()
			   (loop for j below 8 sum
				(* (expt 2 (- 7 j)) (next-bit))))
			 (consume-padding-bits ()
			   (let ((pad (- 16 (mod current-bit 16))))
			     (dotimes (i pad)
			       ;; consume padding bits until next 16bit word boundary
			       (next-bit))
			     (when verbose
			       (format t "consuming ~a padding bits.~%" pad))
			     pad))
			 (decode-quads (n &key (stage 0))
			   "stage=0 name=ie .. brc=true
   stage=1 name=io
   stage=2 name=qe .. thidx=true thidx-list=thidx-list
   stage=3 name=ie
   4 stages of data are sent
   every baq block contains 128 symbols.
   in the first stage (stage 0) every baq block contains a 3bit brc in the front
   in stage 2 every baq bloack contains an 8bit thidx in the front
    "
			   (let ((decoded-symbols 0)
				 (number-of-baq-blocks (ceiling (* 2 n)
								256))
				 (decoded-symbols-a (make-array n
								:element-type '(signed-byte 8))))
			     (case stage
			       (0 (setf brcs (make-array number-of-baq-blocks
							 :element-type '(unsigned-byte 8))))
			       (2 (setf thidxs (make-array number-of-baq-blocks
							   :element-type '(unsigned-byte 8)))))
			     (prog1
				 (loop for block from 0 while (< decoded-symbols n) do
				      (let* ((current-brc (if (= 0 stage)
							      (setf (aref brcs block)
								    (get-brc))
							      (aref brcs block)))
					     (dec (elt *decoder* current-brc)))
					(when (= 2 stage)
					  (setf (aref thidxs block) (get-thidx)))
					(prog1
					    (loop for i below 128 while (< decoded-symbols n) do
						 (prog1
						     (setf (aref
							    decoded-symbols-a decoded-symbols)
		      					   (* (if (next-bit-p) -1 1)
							      (funcall dec #'next-bit-p)))
						   (incf decoded-symbols))))))
			       (consume-padding-bits))
			     decoded-symbols-a)))
	    (let ((ie-symbols (decode-quads number-of-quads :stage 0))
		  (io-symbols (decode-quads number-of-quads :stage 1))
		  (qe-symbols (decode-quads number-of-quads :stage 2))
		  (qo-symbols (decode-quads number-of-quads :stage 3)))
	      (list ie-symbols
		    io-symbols
		    qe-symbols
		    qo-symbols))))))))


(time (defparameter *quads* (decompress (elt *headers* 0))))

;; 0.011s 29.2kB

;; https://sentinels.copernicus.eu/c/document_library/get_file?folderId=349449&name=DLFE-4502.pdf

;; measurement data component binary file
;; containing stream of downlinked instrument source packets (ISPs) details in 3.3.1.1.2 (p.64)
;; big-endian
;; isp-packet = packet-primary-header + packet-data-field
;;              6 bytes                 <= 65534 bytes
;; packet-primary-header =
;;   packet-version-number (3bits) +
;;   packet-id (13bits) + packet-sequence-control (2bytes) + packet-data-length (2bytes)
;; packet-secondary-header (62bytes) = user-data-field (<= 65472 bytes)

;;  S1 SAR SPPDU [CFI-06] shows further details of the ISP structure
;;  Sentinel-1 SAR Space Packet Protocol Data Unit   S1-IF-ASD-PL-0007
;; https://sentinel.esa.int/documents/247904/685163/Sentinel-1-SAR-Space-Packet-Protocol-Data-Unit.pdf




