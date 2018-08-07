;; martin@localhost ~/quicklisp/local-projects
;; $ git clone https://github.com/heegaiximephoomeeghahyaiseekh/lisp-binary

(ql:quickload :lisp-binary)

(defpackage :g
  (:use :cl :lisp-binary))

(in-package :g)

(defparameter *fn* (elt (directory "/dev/shm/S*/*-??????.dat") 0))
;; https://github.com/heegaiximephoomeeghahyaiseekh/lisp-binary/wiki/DEFBINARY

(defbinary packet-primary-header (:byte-order :big-endian)
  (version 0 :type 3)
  (type 0 :type 1)
  (flag 0 :type 1)
  (application-process-id 0 :type 11)
  (sequence-flags 0 :type 2)
  (sequence-count 0 :type 14)
  (data-length 0 :type 16))

(with-open-binary-file (in *fn* :direction :input)
  (let* ((file-size (file-length in)))
    (read-binary 'packet-primary-header in)))

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


