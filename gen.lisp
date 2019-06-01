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
	  ,@(let ((l `(tx_ramp_rate_polarity
		       tx_ramp_rate_magnitude
		       tx_pulse_start_frequency_polarity
		       tx_pulse_start_frequency_magnitude
		       tx_pulse_length
		       ses_ssb_tx_pulse_number
		       )))
	      (loop for e in l collect
		   (let ((name (format nil "old_~a" e)))
		     `(do0
		       (setf
			(aref df (string ,name))
			(dot df ,e
			     (aref iloc (- df.index (aref df (string "rank"))))
			     values)))))))

	 (do0
	  "# compute human readable values from the transmitted codes"
	  (setf f_ref_MHz 37.53472224)
	  "# compute columns that only access one other column with coded data"
	  ,@(let ((l `((rx_gain dB (lambda (code) (* -.5 code)))
		       (sampling_window_start_time us (lambda (code) (/ code f_ref_MHz)))
		       (sampling_window_length us (lambda (code) (/ code f_ref_MHz)))
		       (sampling_window_length n1_rx_samples_at_adc_output (lambda (code) (* 8 code)))
		       (sampling_window_length n2_rx_complex_samples_at_ddc_output (lambda (code) (* 4 code)))
		       (old_tx_pulse_length us (lambda (code) (/ code f_ref_MHz)))
		       (pulse_repetition_intervall us (lambda (code) (/ code f_ref_MHz))) ;; vary between swath
		       (old_tx_ramp_rate_magnitude MHz_per_us (lambda (code) (* ; (** -1 (~ (& code 1)))
									    code
									    (/ (** f_ref_MHz 2)
									       (** 2 21)) 
									    )))
		       (old_tx_pulse_start_frequency_magnitude MHz (lambda (code)
								     (* code
									    (/ f_ref_MHz
									       (** 2 14)))))
		       )))
	      (loop for e in l collect
		   (destructuring-bind (name unit fun) e
		     (let ((hr-name (format nil "~a_hr_~a" name unit)))
		      `(do0
			(setf (aref df (string ,hr-name))
			      (dot (aref df (string ,name)) (apply ,fun ; :axis 1
								   ))))))))
	  "# compute columns that need to access several other columns for decoding"
	  ,@(let ((l `((old_tx_ramp_rate MHz_per_us (lambda (row)
						      (* (** -1 (- 1 (aref row (string "old_tx_ramp_rate_polarity"))))
							 (aref row (string "old_tx_ramp_rate_magnitude")))))
		       (old_tx_pulse_start_frequency MHz (lambda (row)
							   (+ (/ (aref row (string "old_tx_ramp_rate_hr_MHz_per_us"))
								 (* 4 f_ref_MHz))
							      (* (** -1 (- 1
									   (aref row (string "old_tx_pulse_start_frequency_polarity"))))
								 (aref row (string "old_tx_pulse_start_frequency_magnitude_hr_MHz"))))))
		       ;; 3.2.5.4
		       (range_decimation_ratio l (lambda (row) (aref (np.array (list 3 2 0 5 4 3 1 1 3  5  3  4))
								     (aref row (string "range_decimation")))))
		       (range_decimation_ratio m (lambda (row) (aref (np.array (list 4 3 0 9 9 8 3 6 7 16 26 11))
								     (aref row (string "range_decimation")))))
		       ;; table 5.1-2 filter output offset
		       (filter_output_offset samples (lambda (row) (aref (np.array (list 87 87 0 88 90 92 93 103 89 97 110 91 0 0 0 0 0))
									 (aref row (string "range_decimation")))))
		       
		       ;; 3.2.5.12
		       (sampling_window_length_b samples (lambda (row) (- (* 2 (aref row (string "sampling_window_length")))
									  (aref row (string "filter_output_offset_hr_samples"))
									  17)))
		       (sampling_window_length_c samples (lambda (row) (- (aref row (string "sampling_window_length_b_hr_samples"))
				1					  (* (aref row (string "range_decimation_ratio_hr_m"))
									     (// (aref row (string "sampling_window_length_b_hr_samples"))
										 (aref row (string "range_decimation_ratio_hr_m")))))))
		       ;; table 5.1-1 tables of value d as function of c and range decimation
		       (sampling_window_length n3_rx_complex_samples_after_decimation
					       ;; rgdec .. range_decimation = filter_number [ 9,  0,  8, 11]
					       ;; l m
					       ;; filter_output_offset
					       ,(let ((tbl `((1 1 2 3) ;; range_decimation = 0, c = 0,1,2,3
							     (1 1 2) ;; range_decimation = 1, c = 0,1,2
							     ()
							     (1 1 2 2 3 3 4 4 5)
							     (0 1 1 2 2 3 3 4 4)
							     (0 1 1 1 2 2 3 3)
							     (0 0 1)
							     (0 0 0 0 0 1)
							     (0 1 1 2 2 3 3)
							     (0 0 1 1 1 2 2 2 2 3 3 3 4 4 4 5)
							     (0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 2 2 2 2  2 2 2 2  3 3)
							     (0 1 1 1 2 2 3 3 3 4 4)
							     ()
							     ()
							     ()
							     ()
							     ())))
						  `(lambda (row)
						     (dot
						      (pd.DataFrame
						       (list ,@(loop for col in tbl and range_decimation from 0 upto 16 collect
								    (loop for d in col and c from 0 upto 25  collect
									 `(dict ((string "c") ,c)
										((string "range_decimation") ,d)
										((string "d") ,d))))))
						      (set_index (string "c"))))))
		       )))
	      (loop for e in l collect
		   (destructuring-bind (name unit fun) e
		     (let ((hr-name (format nil "~a_hr_~a" name unit)))
		      `(do0
			(setf (aref df (string ,hr-name))
			      (dot df (apply ,fun  :axis 1)))))))))
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
	   (setf contents (list))
	   (setf df1 (aref df
			   (!= 0.0 (dot df.sab_ssb_elevation_beam_address
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
		))
	  (setf data (np.array contents
			       :dtype type_header))
	  (widget.setData data)

	  )
	 
	 )))

  (write-source "/home/martin/stage/satellite-plot/source/code" code))

;; SC packet-sequence-count, starts with 0, wraps around at 16383



#+nil
(do0
	 	 
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
