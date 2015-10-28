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
import ProjUtil as pProjUtil
import CheckpointUtilities as pCheckUtil
from HDF5Util import GetTimeSepForce

#from scipy.signal import savgol_filter,welch

def filter(inData,nSmooth = None,degree=2):
    if (nSmooth is None):
        nSmooth = int(len(inData)/200)
        if (nSmooth % 2 == 0):
            # must be odd
            nSmooth += 1
    # get the filtered version of the data
    return inData

def MyModel(x,tau):
    return np.exp(-x/tau)

def run(inDir,limit=1):
    mFiles = pProjUtil.GetDataFiles(inDir)
    lim = min(len(mFiles),limit)
    for i in range(lim):
        tmpFile = mFiles[i]
        time,sep,force = GetTimeSepForce(tmpFile)
    # convert to nm and pN for ploting
    sepNm = sep*1e9
    forcePn = force*1e12
    forcePnFiltered = filter(forcePn)
    # offset sep to its minimum
    minSep = min(sepNm)
    sepNm -= minSep
    # get a median-filtered norm one version
    # minimum sep index and median should give what we want
    mMedian = np.median(forcePn)
    minIdx = np.argmin(sepNm)
    mMax = forcePn[minIdx]
    rangeFit = mMax-mMedian
    toFit = (forcePn -mMedian)/rangeFit
    toFit = toFit[minIdx:][::-1]
    sepFit = sepNm[minIdx:][::-1]
    print(sepFit)
    params,paramsStd,pred = pGenUtil.GenFit(sepFit,toFit,model=MyModel)
    print(params)
    # denormialize the fit.
    # save out just the last one
    nPlots = 3
    fig = pPlotUtil.figure(ySize=14,xSize=10)
    plt.subplot(nPlots,1,1)
    plt.plot(sepNm,forcePn,'k-',alpha=0.3,linewidth=0.5,label="Data (Raw)")
    plt.plot(sepNm,forcePnFiltered,'r-',linewidth=1.5,label="Data (Filtered)")
    minX = min(sepNm)
    maxX = max(sepNm)
    rangeV = (maxX-minX)
    fullPlotRange = [minX,maxX]
    zoomRange = [minX,minX+0.1*rangeV]
    plt.xlim(fullPlotRange)
    pPlotUtil.lazyLabel("Separation [nm]","Force [pN]","Force-Extension Curve")
    plt.subplot(nPlots,1,2)
    plt.plot(sepNm,forcePn,'k-',alpha=0.3,linewidth=0.5,label="Data (Raw)")
    plt.plot(sepNm,forcePnFiltered,'r-',linewidth=1.5,label="Data (Filtered)")
    pPlotUtil.lazyLabel("Separation [nm]","Force [pN]",
                        "Zoomed in around surface touchoff")
    # show just 10% of the x range
    plt.xlim(zoomRange)
    plt.subplot(nPlots,1,3)
    plt.plot(sepFit,toFit)
    plt.plot(sepFit,pred,'g',linewidth=4)
    plt.xlim(zoomRange)
    pPlotUtil.lazyLabel("Separation [nm]","Force [pN]",
                        "Exponential Fit")
    pPlotUtil.savefig(fig,"./PlotDemoReadData.png")

if __name__ == "__main__":
    run(inDir="../TestData/")
