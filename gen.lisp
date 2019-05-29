(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))

;; https://www.youtube.com/watch?v=Zz_6P5qAJck
(in-package :cl-py-generator)

;(start-python)

(let ((code
       `(do0
	 (imports (sys
		   os
                   (np numpy)
		   numpy.fft
		   (pd pandas)
		   (plt matplotlib.pyplot)))
	 (plt.ion)
	 (setf df (pd.read_csv (string ;"/home/martin/sat-data/headers.csv"
				"/home/martin/stage/satellite-plot/headers.csv"
				)))
	 (setf n (* 2 (dot (aref df (string "NUMBER-OF-QUADS"))
			   (aref iloc 0))))
	 ;; df['SAB-SSB-ELEVATION-BEAM-ADDRESS'].unique() => array([ 6, 11,  7, 12,  8, 15,  9, 10])
	 #+nil (setf q (aref (aref df (== 6 (aref df (string "SAB-SSB-ELEVATION-BEAM-ADDRESS"))))
		       (string "SAB-SSB-AZIMUTH-BEAM-ADDRESS")))
	 ;; find index where elev beam address changes
	 ;;df.iloc[np.diff(df[df['SAB-SSB-ELEVATION-BEAM-ADDRESS']==6].index)!=1][0]
	 (setf w (aref (dot (aref df.iloc
			      (!= 1 (np.diff
				     (dot
				      (aref df
					    (== 6
						(aref df
						      (string "SAB-SSB-ELEVATION-BEAM-ADDRESS"))))
				      index))))
			    index) 0))
	 #-nil
	 (do0
          (setf a (dot (np.fromfile (string "/home/martin/sat-data/chunk0")
				    :dtype np.complex64
				    :count (* w n))
		       (reshape (tuple w n)))
		win (np.hamming n)
					; k (np.fft.fft2 (* win a) :axes (list 0))
					;(aref k (slice 0 20) ":") 0
		)
	  (setf ax (plt.subplot2grid (tuple 1 1) (tuple 0 0)))
	  (plt.imshow (np.real a)
					;(np.real (* a (+ 1 (* 0 win))))
					;(np.log (+ .001 (np.abs k)))
		      )
	  (ax.set_aspect (string "auto"))))
	))
  ;(run code)
  (write-source "/home/martin/stage/satellite-plot/source/code" code))


