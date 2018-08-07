(defparameter *fn* (elt (directory "/dev/shm/S*/*-??????.dat") 0))

(defparameter *f*
 (open *fn* :direction :input :element-type '(unsigned-byte 8)))
;; https://sentinels.copernicus.eu/c/document_library/get_file?folderId=349449&name=DLFE-4502.pdf

;; measurement data component binary file
;; containing stream of downlinked ISPs details in 3.3.1.1.2 (p.64)
