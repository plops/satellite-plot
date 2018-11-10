import sys
import os
import numpy as np
import numpy.fft
import pandas as pd
import matplotlib.pyplot as plt

plt.ion()
df=pd.read_csv("/home/martin/sat-data/headers.csv")

n=((2)*(df["NUMBER-OF-QUADS"].iloc[0]))

w=df.iloc[((1)!=(np.diff(df[((6)==(df["SAB-SSB-ELEVATION-BEAM-ADDRESS"]))].index)))].index[0]

a=np.fromfile("/home/martin/sat-data/chunk0", dtype=np.complex64, count=((w)*(n))).reshape((w,n,))
win=np.hamming(n)

ax=plt.subplot2grid((1,1,), (0,0,))

plt.imshow(np.real(a))
ax.set_aspect("auto")
