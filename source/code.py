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
n=((2)*(df.number_of_quads.iloc[0]))
w=df.iloc[((1)!=(np.diff(df[((6)==(df.sab_ssb_elevation_beam_address))].index)))].index[0]
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
    v=(c,example_type,)
    type_header.append(v)
contents=[]
df1=df[(((0.0e+0))!=(df.sab_ssb_elevation_beam_address.diff()))]
df1i=sorted(((list(((df1.index)-(1))))+(list(df1.index))+(list(((df1.index)+(1))))))[1:-1]
for idx, row in df.iloc[df1i].iterrows():
    contents.append(tuple(row))
data=np.array(contents, dtype=type_header)
widget.setData(data)