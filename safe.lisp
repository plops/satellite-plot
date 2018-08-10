;; martin@localhost ~/quicklisp/local-projects
;; $ git clone https://github.com/heegaiximephoomeeghahyaiseekh/lisp-binary

(ql:quickload :lisp-binary)
(ql:quickload :structy-defclass)

(defpackage :g
  (:use :cl :lisp-binary :structy-defclass))

(in-package :g)

(defparameter *fn* (elt (directory "/dev/shm/S*/*-??????.dat") 0))
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

;; p21
#+nil
(define-enum test-mode-type 1 ()
	     (default 0)
	     (contingency-operational-test #b100)
	     (contingency-bypass-test #b101)
	     (oper #b110)
	     (bypass #b111))
(defbinary space-packet1 (:byte-order :big-endian)
  ;; start of packet primary header
  (packet-version-number 0 :type 3)
  (packet-type 0 :type 1)
  (secondary-header-flag 0 :type 1)
  (application-process-id-process-id 0 :type 7)
  (application-process-id-packet-category 0 :type 4) 
  (sequence-flags 0 :type 2)
  (sequence-count 0 :type 14) ;; 0 at start of measurement, wraps after 16383
  (data-length 0 :type 16) ;; number of octets in packet data field - 1
  ;; start of packet data field
  ;; datation service p. 15
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
  (let* ((file-size (file-length in))
	 (header (read-binary 'space-packet1 in)))
    (with-slots (data-length) header
      (let* ((pdl data-length)
	     (len-sh 62)
	     (len-ud (+ pdl (- len-sh) 1)))
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
     (let* ((file-size (file-length in)))
       (file-position in user-data-position)
       (read-byte in)))))

(defmethod get-user-data-bit ((o space-packet) n)
  (with-slots (filename user-data-position) o
   (with-open-file (in filename :direction :input :element-type '(unsigned-byte 8))
     (let* ((file-size (file-length in)))
       (multiple-value-bind (byte-nr bit-nr) (floor n 8)
	 (file-position in (+ user-data-position byte-nr))
	 (ldb (byte 1 bit-nr) (read-byte in)))))))

(0 (1 (2 (3))))

(0 (1 (2 (3 (4)))))

(0 (1 (2 (3 (4 (5 (6)))))))

((0 1) (2 (3 (4 (5 (6 (7 (8 (9)))))))))

()

(dotimes (i 3)
  (format t "~{~d~}~%" (loop for j below 3 collect
			    (get-user-data-bit (elt *headers* i) j))))

;;  11101
;; 110011
;;      1
;;    111
;;     10
;;  11000
;;   1011

1

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


