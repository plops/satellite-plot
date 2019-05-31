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