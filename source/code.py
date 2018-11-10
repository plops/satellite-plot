import sys
import os
import numpy as np
import numpy.fft
import pandas as pd
import matplotlib.pyplot as plt

plt.ion()
df=pd.read_csv("/home/martin/sat-data/headers.csv")

n=((2)*(df["NUMBER-OF-QUADS"].iloc[0]))

a=np.fromfile("/home/martin/sat-data/chunk0", dtype=np.complex64, count=((600)*(n))).reshape((600, n))
win=np.hamming(n)
k=np.fft.fft2(((win)*(a)), axes=[0])

ax=plt.subplot2grid((1, 1), (0, 0))

plt.imshow(np.real(((a)*(((1)+(((0)*(win))))))))
ax.set_aspect("auto")
