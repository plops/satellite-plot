(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))

;; https://www.youtube.com/watch?v=Zz_6P5qAJck
(in-package :cl-py-generator)

(start-python)

(let ((code
       `(do0
	 (imports (sys
		   os
                   (np numpy)
		   (pd pandas)
		   (plt matplotlib.pyplot)))
	 (plt.ion)
	 (setf df (pd.read_csv (string "/home/martin/sat-data/headers.csv")))
	 (setf n (* 2 (dot (aref df (string "NUMBER-OF-QUADS"))
		       (aref iloc 0))))
         (setf a (dot (np.fromfile (string "/home/martin/sat-data/chunk0")
			       :dtype np.complex64
			       :count (* 600 n))
		      (reshape (tuple 600 n))))
	 (setf ax (plt.subplot2grid (tuple 1 1) (tuple 0 0)))
	 (plt.imshow (np.real a))
	 (ax.set_aspect (string "auto")))))
  ;(run code)
  (write-source "/home/martin/stage/satellite-plot/source/code" code))


