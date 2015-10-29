# force floating point division. Can still use integer with //
from __future__ import division
# This file is used for importing the common utilities classes.
import numpy as np
import matplotlib.pyplot as plt
# need to add the utilities class. Want 'home' to be platform independent
from os.path import expanduser
home = expanduser("~")
# get the utilties directory (assume it lives in ~/utilities/python)
# but simple to change
path= home +"/utilities/python"
import sys
sys.path.append(path)
# import the patrick-specific utilities
import GenUtilities  as pGenUtil
import PlotUtilities as pPlotUtil
import CheckpointUtilities as pCheckUtil

from scipy.optimize import linprog

def ExpModel(x,y,n):
    """Use linprog to calculate an approximate exponential model to y versus x

    :param x: the independent data
    :param y: the dependent data, assumed normalized between 1 (at x[0]) and 0
    :param n: the order of the fit
    :return: nothing
    """
    # generate a matrix for fitting
    nPoints = x.size
    MyFitter = np.zeros((nPoints,n+1))
    for i in range(n+1):
        MyFitter[:,i] = np.power(x,i)
        print(i)
    # for L1 fitting, use doc from hw4
    tMat = np.identity(nPoints)
    print(nPoints)
    # make [ [+A, -I_n],[-A,-I_n]]
    finalMatTop = np.hstack((MyFitter,-tMat))
    finalMatBottom = np.hstack((-MyFitter,-tMat))
    finalMat = np.vstack((finalMatTop,finalMatBottom))
    print(finalMat.size)
    # full b is [y,-y]
    finalB = np.vstack((y,-y))
    # c is 'n' zeros, followed by 'm' negations
    c = np.zeros((2*nPoints,1))
    c[nPoints:] = -1
    # call lin prog
    xSol = 0#linProg(c,A_ub=finalMat,b_ub=finalB)
    

