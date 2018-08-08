;; martin@localhost ~/quicklisp/local-projects
;; $ git clone https://github.com/heegaiximephoomeeghahyaiseekh/lisp-binary

(ql:quickload :lisp-binary)

(defpackage :g
  (:use :cl :lisp-binary))

(in-package :g)

(defparameter *fn* (elt (directory "/dev/shm/S*/*-??????.dat") 0))
;; https://github.com/heegaiximephoomeeghahyaiseekh/lisp-binary/wiki/DEFBINARY


;; https://sentinel.esa.int/documents/247904/685163/Sentinel-1-SAR-Space-Packet-Protocol-Data-Unit.pdf

(define-enum ecc-number-type 1
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
  Stripmap-1-w/o-interl.Cal
  Stripmap-2-w/o-interl.Cal
  Stripmap-3-w/o-interl.Cal
  Stripmap-4-w/o-interl.Cal
  RFC-mode
  Test-Mode
  Elevation-Notch-S3
  Azimuth-Notch-S1
  Azimuth-Notch-S2
  Azimuth-Notch-S3
  Azimuth-Notch-S4
  Azimuth-Notch-S5n
  Azimuth-Notch-S5s
  Stripmap-5n-w/o-interl.Cal
  Stripmap-5s-w/o-interl.Cal
  Stripmap-6-w/o-interl.Cal
  contingency-28
  contingency-29
  contingency-30
  Elevation-Notch-S3-w/o-interl.Cal
  Extra-Wide-Swath
  Azimuth-Notch-S1-w/o-interl.Cal
  Azimuth-Notch-S3-w/o-interl.Cal
  Azimuth-Notch-S6-w/o-interl.Cal
  contingency-36
  Noise-Characterisation-S1
  Noise-Characterisation-S2
  Noise-Characterisation-S3
  Noise-Characterisation-S4)

(defbinary space-packet (:byte-order :big-endian)
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
  (ecc-number 0 :type 8)
  (ignore-0 )
  (test-mode)
  (rx-channel-id)
  (instrument-configuration-id)
  ;; sub-commutation ancillary data service
  ;; counters service
  ;; radar configuration support service
  ;; radar sample count service
  )

(with-open-binary-file (in *fn* :direction :input)
  (let* ((file-size (file-length in)))
    (read-binary 'space-packet in)))

;; => #S(PACKET-PRIMARY-HEADER
;;       :VERSION 0
;;       :TYPE 0
;;       :FLAG 1
;;       :APPLICATION-PROCESS-ID 1052
;;       :SEQUENCE-FLAGS 3
;;       :SEQUENCE-COUNT 3780
;;       :DATA-LENGTH 15309), 6



(defparameter *f*
 (open *fn* :direction :input :element-type '(unsigned-byte 8)))
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


