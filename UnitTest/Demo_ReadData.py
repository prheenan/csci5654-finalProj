# force floating point division. Can still use integer with //
from __future__ import division
# This file is used for importing the common utilities classes.
import numpy as np
import matplotlib.pyplot as plt
import sys
sys.path.append('../util')
# import the patrick-specific utilities
import GenUtilities  as pGenUtil
import PlotUtilities as pPlotUtil
import CheckpointUtilities as pCheckUtil
from HDF5Util import GetTimeSepForce

from scipy.signal import savgol_filter,welch

def filter(inData,nSmooth = None,degree=2):
    if (nSmooth is None):
        nSmooth = int(len(inData)/400)
        if (nSmooth % 2 == 0):
            # must be odd
            nSmooth += 1
    # get the filtered version of the data
    return savgol_filter(inData,nSmooth,degree)

def run(inDir,limit=1):
    # get all the hdf files
    mFiles = pGenUtil.getAllFiles(inDir,"hdf")
    # get the labels for them
    mLabelArr = pGenUtil.getAllFiles(inDir,"csv")
    if (len(mLabelArr) != 1):
        print("Error, cant figure out which label file to read.")
    mLabels = np.loadtxt(mLabelArr[0])
    lim = min(len(mFiles),limit)
    for i in range(lim):
        tmpFile = mFiles[i]
        time,sep,force = GetTimeSepForce(tmpFile)
    fig = pPlotUtil.figure()
    # convert to nm and pN for ploting
    sepNm = sep*1e9
    forcePn = force*1e12
    forcePnFiltered = filter(forcePn)
    locNm = mLabels[i] * 1e9
    # offset sep to its minimum
    minSep = min(sepNm)
    sepNm -= minSep
    locNm -= minSep
    # save out just the last one
    plt.subplot(2,1,1)
    plt.plot(sepNm,forcePn,'k-',alpha=0.3,linewidth=0.5,label="Data (Raw)")
    plt.plot(sepNm,forcePnFiltered,'r-',linewidth=1.5,label="Data (Filtered)")
    plt.axvline(locNm,label="Manual Touchoff Location",color='g')
    minX = min(sepNm)
    maxX = max(sepNm)
    rangeV = (maxX-minX)
    plt.xlim([minX,maxX])
    pPlotUtil.lazyLabel("Separation [nm]","Force [pN]","Force-Extension Curve")
    plt.subplot(2,1,2)
    plt.plot(sepNm,forcePn,'k-',alpha=0.3,linewidth=0.5,label="Data (Raw)")
    plt.plot(sepNm,forcePnFiltered,'r-',linewidth=1.5,label="Data (Filtered)")
    pPlotUtil.lazyLabel("Separation [nm]","Force [pN]",
                        "Zoomed in around surface touchoff")
    plt.axvline(locNm,label="Manual Touchoff Location",color='g')
    # show just 10% of the x range
    plt.xlim([minX,minX+0.1*rangeV])
    pPlotUtil.savefig(fig,"./PlotDemoReadData.png")

if __name__ == "__main__":
    run(inDir="../TestData/")
