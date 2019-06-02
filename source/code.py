import sys
import os
import numpy as np
import numpy.fft
import pandas as pd
import matplotlib.pyplot as plt
plt.ion()
df_=pd.read_csv("/home/martin/stage/satellite-plot/headers.csv")
# rename columns to _ instead of -
new_names={}
for c in df_.columns:
    new_names[c]=c.replace("-", "_").lower()
df=df_.rename(new_names, axis="columns")
# collect sub-commutated data
sub_start=df.index[((df.sub_commutated_index)==(1))][0]
sub_data=df[["sub_commutated_index", "sub_commutated_data"]][sub_start:((sub_start)+(64))].set_index("sub_commutated_index")
pvt_data=sub_data[0:22]
attitude_data=sub_data[22:41]
temperature_hk_data=sub_data[41:64]
n=((2)*(df.number_of_quads.iloc[0]))
w=df.iloc[((1)!=(np.diff(df[((6)==(df.sab_ssb_elevation_beam_address))].index)))].index[0]
# relate to tx pulse definition (which is rank pulse repititions before)
df["old_tx_ramp_rate_polarity"]=df.tx_ramp_rate_polarity.iloc[((df.index)-(df["rank"]))].values
df["old_tx_ramp_rate_magnitude"]=df.tx_ramp_rate_magnitude.iloc[((df.index)-(df["rank"]))].values
df["old_tx_pulse_start_frequency_polarity"]=df.tx_pulse_start_frequency_polarity.iloc[((df.index)-(df["rank"]))].values
df["old_tx_pulse_start_frequency_magnitude"]=df.tx_pulse_start_frequency_magnitude.iloc[((df.index)-(df["rank"]))].values
df["old_tx_pulse_length"]=df.tx_pulse_length.iloc[((df.index)-(df["rank"]))].values
df["old_ses_ssb_tx_pulse_number"]=df.ses_ssb_tx_pulse_number.iloc[((df.index)-(df["rank"]))].values
# compute human readable values from the transmitted codes
f_ref_MHz=(3.7534721374511715e+1)
# compute columns that only access one other column with coded data
df["rx_gain_hr_dB"]=df["rx_gain"].apply(lambda code: (((-5.e-1))*(code)))
df["sampling_window_start_time_hr_us"]=df["sampling_window_start_time"].apply(lambda code: ((code)/(f_ref_MHz)))
df["sampling_window_length_hr_us"]=df["sampling_window_length"].apply(lambda code: ((code)/(f_ref_MHz)))
df["sampling_window_length_hr_n1_rx_samples_at_adc_output"]=df["sampling_window_length"].apply(lambda code: ((8)*(code)))
df["sampling_window_length_hr_n2_rx_complex_samples_at_ddc_output"]=df["sampling_window_length"].apply(lambda code: ((4)*(code)))
df["old_tx_pulse_length_hr_us"]=df["old_tx_pulse_length"].apply(lambda code: ((code)/(f_ref_MHz)))
df["pulse_repetition_interval_hr_us"]=df["pulse_repetition_interval"].apply(lambda code: ((code)/(f_ref_MHz)))
df["old_tx_ramp_rate_magnitude_hr_MHz_per_us"]=df["old_tx_ramp_rate_magnitude"].apply(lambda code: ((code)*(((((f_ref_MHz)**(2)))/(((2)**(21)))))))
df["old_tx_pulse_start_frequency_magnitude_hr_MHz"]=df["old_tx_pulse_start_frequency_magnitude"].apply(lambda code: ((code)*(((f_ref_MHz)/(((2)**(14)))))))
# compute columns that need to access several other columns for decoding
# no pre
df["old_tx_ramp_rate_hr_MHz_per_us"]=df.apply(lambda row: ((((-1)**(((1)-(row["old_tx_ramp_rate_polarity"])))))*(row["old_tx_ramp_rate_magnitude"])), axis=1)
# no pre
df["old_tx_pulse_start_frequency_hr_MHz"]=df.apply(lambda row: ((((row["old_tx_ramp_rate_hr_MHz_per_us"])/(((4)*(f_ref_MHz)))))+(((((-1)**(((1)-(row["old_tx_pulse_start_frequency_polarity"])))))*(row["old_tx_pulse_start_frequency_magnitude_hr_MHz"])))), axis=1)
# no pre
df["range_decimation_ratio_hr_l"]=df.apply(lambda row: np.array([3, 2, 0, 5, 4, 3, 1, 1, 3, 5, 3, 4])[row["range_decimation"]], axis=1)
# no pre
df["range_decimation_ratio_hr_m"]=df.apply(lambda row: np.array([4, 3, 0, 9, 9, 8, 3, 6, 7, 16, 26, 11])[row["range_decimation"]], axis=1)
# no pre
df["range_decimation_freq_hr_MHz"]=df.apply(lambda row: ((4)*(f_ref_MHz)*(((row["range_decimation_ratio_hr_l"])/(row["range_decimation_ratio_hr_m"])))), axis=1)
# no pre
df["old_tx_pulse_length_hr_n1_tx_samples_at_adc"]=df.apply(lambda row: ((8)*(row["old_tx_pulse_length"])), axis=1)
# no pre
df["old_tx_pulse_length_hr_n2_tx_complex_samples_at_ddc_output"]=df.apply(lambda row: ((4)*(row["old_tx_pulse_length"])), axis=1)
# no pre
df["old_tx_pulse_length_hr_n3_tx_complex_samples_after_decimation"]=df.apply(lambda row: np.ceil(((row["range_decimation_freq_hr_MHz"])*(row["old_tx_pulse_length_hr_us"]))), axis=1)
# no pre
df["filter_output_offset_hr_samples"]=df.apply(lambda row: np.array([87, 87, 0, 88, 90, 92, 93, 103, 89, 97, 110, 91, 0, 0, 0, 0, 0])[row["range_decimation"]], axis=1)
# no pre
df["sampling_window_length_b_hr_samples"]=df.apply(lambda row: ((((2)*(row["sampling_window_length"])))-(row["filter_output_offset_hr_samples"])-(17)), axis=1)
# no pre
df["sampling_window_length_c_hr_samples"]=df.apply(lambda row: ((row["sampling_window_length_b_hr_samples"])-(((row["range_decimation_ratio_hr_m"])*(((row["sampling_window_length_b_hr_samples"])//(row["range_decimation_ratio_hr_m"])))))), axis=1)
sampling_window_length_d_lut=np.array([[1, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [1, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [1, 1, 2, 2, 3, 3, 4, 4, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 1, 2, 2, 3, 3, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 1, 1, 2, 2, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 1, 2, 2, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3], [0, 1, 1, 1, 2, 2, 3, 3, 3, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]])
df["sampling_window_length_d_hr_samples"]=df.apply(lambda row: sampling_window_length_d_lut[row["sampling_window_length_c_hr_samples"],row["range_decimation"]], axis=1)
# no pre
df["sampling_window_length_hr_n3_rx_complex_samples_after_decimation"]=df.apply(lambda row: ((2)*(((1)+(row["sampling_window_length_d_hr_samples"])+(((row["range_decimation_ratio_hr_l"])*(((row["sampling_window_length_b_hr_samples"])//(row["range_decimation_ratio_hr_m"])))))))), axis=1)
df3=df[((((df.sab_ssb_elevation_beam_address)==(7))) & (((df.sab_ssb_azimuth_beam_address)==(240))))]
# read first packet with calibration data
cal=df[((df.sab_ssb_calibration_p)==(1))].iloc[0]
print("user_data_position={} (first byte in the file with compressed echo data)".format(cal["user_data_position"]))
print("data_length={} (number of octets storing the compressed echo)".format(cal["data_length"]))
print("sampling_window_start_time_hr_us={}".format(cal["sampling_window_start_time_hr_us"]))
print("rank={}".format(cal["rank"]))
print("sampling_window_length_hr_us={}".format(cal["sampling_window_length_hr_us"]))
print("sampling_window_length_hr_n3_rx_complex_samples_after_decimation={}".format(cal["sampling_window_length_hr_n3_rx_complex_samples_after_decimation"]))
print("range_decimation_freq_hr_MHz={}".format(cal["range_decimation_freq_hr_MHz"]))
print("old_tx_ramp_rate_hr_MHz_per_us={}".format(cal["old_tx_ramp_rate_hr_MHz_per_us"]))
print("old_tx_pulse_start_frequency_hr_MHz={}".format(cal["old_tx_pulse_start_frequency_hr_MHz"]))
print("old_tx_pulse_length_hr_us={}".format(cal["old_tx_pulse_length_hr_us"]))
print("old_tx_pulse_length_hr_n3_tx_complex_samples_after_decimation={}".format(cal["old_tx_pulse_length_hr_n3_tx_complex_samples_after_decimation"]))
print("number_of_quads={} (number of iq data sample pairs)".format(cal["number_of_quads"]))
print("pulse_repetition_interval_hr_us={}".format(cal["pulse_repetition_interval_hr_us"]))
n=19380
w=129
a=np.fromfile("/home/martin/sat-data/chunk0", dtype=np.complex64, count=((w)*(n))).reshape((w,n,))
win=np.hamming(n)
import pyqtgraph as pg
from pyqtgraph.Qt import QtCore, QtGui
app=QtGui.QApplication([])
widget=pg.TableWidget(sortable=False)
widget.show()
widget.resize(500, 500)
widget.setWindowTitle("satellite data header")
font=QtGui.QFont()
font.setPointSize(5)
widget.setFont(font)
type_header=[]
short_names=[]
for c in list(df.columns):
    example=df[c][0]
    example_type=type(example)
    short_name="".join(map(lambda x: x[0], c.split("_")))
    new_short_name=short_name
    count=0
    while ((new_short_name in short_names)):
        count=((1)+(count))
        new_short_name=((short_name)+(str(count)))
    print("{} .. {}".format(new_short_name, c))
    short_names.append(new_short_name)
    v=(new_short_name,example_type,)
    type_header.append(v)
contents=[]
df1=df[(((0.0e+0))!=(df.sab_ssb_elevation_beam_address.diff()))]
df1i=sorted(((list(((df1.index)-(1))))+(list(df1.index))+(list(((df1.index)+(1))))))[1:-1]
for idx, row in df.iloc[df1i].iterrows():
    contents.append(tuple(row))
data=np.array(contents, dtype=type_header)
widget.setData(data)