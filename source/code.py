import sys
import os
import numpy as np
import numpy.fft
import pandas as pd
import matplotlib.pyplot as plt
plt.ion()
df=pd.read_csv("/home/martin/stage/satellite-plot/headers.csv")
n=((2)*(df["NUMBER-OF-QUADS"].iloc[0]))
w=df.iloc[((1)!=(np.diff(df[((6)==(df["SAB-SSB-ELEVATION-BEAM-ADDRESS"]))].index)))].index[0]
import pyqtgraph as pg
from pyqtgraph.Qt import QtCore, QtGui
app=QtGui.QApplication([])
widget=pg.TableWidget()
widget.show()
widget.resize(500, 500)
widget.setWindowTitle("satellite data header")
type_header=[]
for c in list(df.columns):
    example=df[c][0]
    example_type=type(example)
    v=(c,example_type,)
    type_header.append(v)
contents=[]
for idx, row in df.iterrows():
    contents.append(tuple(row))
    if ( ((100)<(idx)) ):
        break
data=np.array(contents, dtype=type_header)
widget.setData(data)