# force floating point division. Can still use integer with //
from __future__ import division
# This file is used for importing the common utilities classes.
import numpy as np
import matplotlib.pyplot as plt
import sys
sys.path.append('../util')
sys.path.append('../2_DataProcess')
# import the patrick-specific utilities
import GenUtilities  as pGenUtil
import PlotUtilities as pPlotUtil
import CheckpointUtilities as pCheckUtil
import LinProgFit
import ProjUtil as pProjUtil
from HDF5Util import GetTimeSepForce

def run():
    # get the file names
    mFiles = pProjUtil.GetDataFiles()
    # read in just the first file
    time,sep,force = GetTimeSepForce(mFiles[0])
    sepNm = sep * 1e9
    forcePn = force * 1e12
    # get the force for fitting (normalized)
    minForce = min(forcePn)
    maxForce = max(forcePn)
    forceFit = (forcePn -minForce)/(maxForce)
    mParams = LinProgFit.ExpModel(sep,forceFit,10)
    
if __name__ == "__main__":
    run()
