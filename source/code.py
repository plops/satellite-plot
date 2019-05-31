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
df["rx_gain_hr_dB"]=df["rx_gain"].apply(lambda code: (((-5.e-1))*(code)))
df["sampling_window_start_time_hr_us"]=df["sampling_window_start_time"].apply(lambda code: ((code)/(f_ref_MHz)))
df["sampling_window_length_hr_us"]=df["sampling_window_length"].apply(lambda code: ((code)/(f_ref_MHz)))
df["old_tx_pulse_length_hr_us"]=df["old_tx_pulse_length"].apply(lambda code: ((code)/(f_ref_MHz)))
df["pulse_repetition_intervall_hr_us"]=df["pulse_repetition_intervall"].apply(lambda code: ((code)/(f_ref_MHz)))
df["old_tx_ramp_rate_magnitude_hr_MHz_per_us"]=df["old_tx_ramp_rate_magnitude"].apply(lambda code: ((code)*(((((f_ref_MHz)**(2)))/(((2)**(21)))))))
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