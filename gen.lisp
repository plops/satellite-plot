(eval-when (:compile-toplevel :execute :load-toplevel)
  (ql:quickload :cl-py-generator))

;; https://www.youtube.com/watch?v=Zz_6P5qAJck
(in-package :cl-py-generator)

					;(start-python)

;; TODO: parse ancillary data

(let ((code
       `(do0
	 (imports (sys
		   os
		   (np numpy)
		   numpy.fft
		   (pd pandas)
		   (plt matplotlib.pyplot)))
	 (plt.ion)
	 (setf df_ (pd.read_csv (string ;"/home/martin/sat-data/headers.csv"
				 "/home/martin/stage/satellite-plot/headers.csv"
				 )))

	 (do0
	  "# rename columns to _ instead of -"
	  (setf new_names "{}")
	  (for (c df_.columns)
	       (setf (aref new_names c) (dot c
					     (replace (string "-")
						      (string "_"))
					     (lower))))
	  (setf df (df_.rename new_names :axis (string "columns"))))
	 

	 (do0
	  "# collect sub-commutated data"
	  (setf sub_start (aref (aref df.index (== df.sub_commutated_index 1)) 0))
	  (setf sub_data (dot
			  (aref (aref df (list (string "sub_commutated_index")
					       (string "sub_commutated_data")))
				(slice sub_start
				       (+ sub_start 64)))
			  (set_index (string "sub_commutated_index"))))
	  (setf pvt_data (aref sub_data (slice 0 22)))
	  (setf attitude_data (aref sub_data (slice 22 41)))
	  (setf temperature_hk_data (aref sub_data (slice 41 64))))
	 
	 (setf n (* 2 (dot df.number_of_quads
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
						    df.sab_ssb_elevation_beam_address
						    #+nil
						    (aref df
							  (string "SAB-SSB-ELEVATION-BEAM-ADDRESS"))))
					  index))))
			    index) 0))
	 (do0
	  "# relate to tx pulse definition (which is rank pulse repititions before)"
	  ;; sampling window start
	  ,@(let ((l `(tx_ramp_rate_magnitude
		       ;tx_ram_rate_polarity
		       )))
	      (loop for e in l collect
		   (let ((name (format nil "old_~a" e)))
		    `(do0
		      (setf (aref df (string ,name)) 0)
		      (for ((ntuple idx row) (df.iterrows))
			   (print idx)
			   (setf (dot (aref df (string ,name)) (aref iloc idx))
				 (dot (aref df (string ,e)) (aref iloc (- idx (aref row (string "rank")))))))))))))))
  ;(run code)
  (write-source "/home/martin/stage/satellite-plot/source/code" code))

;; SC packet-sequence-count, starts with 0, wraps around at 16383



#+nil
(do0
	 #+nil
	 (do0
	  (imports ((pg pyqtgraph)
		    ))
	  "from pyqtgraph.Qt import QtCore, QtGui"

	  (setf app (QtGui.QApplication (list))
		widget (pg.TableWidget :sortable False))
	  (widget.show)
	  (widget.resize 500 500)
	  (widget.setWindowTitle (string "satellite data header"))
	  (setf font (QtGui.QFont))
	  (font.setPointSize 5)
	  (widget.setFont font))

	 #+nil
	 (do0
	  (setf type_header (list)
		short_names (list))
	  (for (c ("list" df.columns))
	       #+nil (do0 (print (+ (string "col: ") c) )
			  (print (+ (string "        ") (str (aref (aref df c) 0))))
			  (print (+ (string "        ") (str (type (aref (aref df c) 0))))))
	       (setf example (aref (aref df c) 0)
		     example_type (type example)
		     short_name (dot (string "")
				     (join (map (lambda (x) (aref x 0))
						(dot c
						     (split (string "_"))))))
		     new_short_name short_name
		     count 0)
	       (while (in new_short_name short_names)
		 (setf count (+ 1 count))
		 (setf new_short_name (+ short_name (str count))))
	       (print (dot (string "{} .. {}")
			   (format new_short_name c)))
	       (short_names.append new_short_name)
	       (setf v (tuple ;c ;
			new_short_name
			example_type))
	       
	       (type_header.append v))
	  (do0 ;; FIXME: ECC-NUMBER is a string but is not copied
	   (setf contents (list)
		 )
	   (setf df1 (aref df
			   (!= 0.0 (dot df.sab_ssb_elevation_beam_address
					#+nil (aref df
						    (string "SAB-SSB-ELEVATION-BEAM-ADDRESS"))
					(diff))))
		 ;; also get index behind and before change
		 df1i (aref (sorted (+ ("list"
					(- df1.index 1)
					)
				       ("list"
					df1.index
					)
				       ("list"
					(+ df1.index 1)
					)))
			    "1:-1"))
	   (for ((ntuple idx row)
		 (dot (aref df.iloc df1i) (iterrows)) )
		(contents.append ("tuple" row))
		#+nil (if (< 1000 idx)
			  break)))
	  (setf data (np.array contents
			       :dtype type_header))

	  )
	 (widget.setData data)
	 
	 
	 
	 
	 
	 #+nil
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
