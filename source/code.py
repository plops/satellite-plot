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
res=[]
for c in list(df.columns):
    print((("col: ")+(c)))
    print(df[c][0])
    print(type(df[c][0]))
    example=df[c][0]
    example_type=type(example)
    v=(c,example_type,)
    res.append(v)
data=np.array(df.values, dtype=res)
widget.setData(data)