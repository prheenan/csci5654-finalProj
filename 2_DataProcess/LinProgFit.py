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
from scipy.misc import factorial
from scipy.optimize import linprog

def ExpModel(x,y,deg):
    """Use linprog to calculate an approximate exponential model to y versus x

    :param x: the independent data
    :param y: the dependent data, assumed normalized between 1 (at x[0]) and 0
    :param n: the order of the fit (0: constant, 1: linear, etc)
    :return: nothing
    """
    # generate a matrix for fitting
    m = y.size
    A = np.zeros((m,deg+1))
    for i in range(deg,-1,-1):
        print(i)
        prefactor = 1/factorial(deg)
        prefactor *= -1 if (deg % 2) != 0 else 1
        A[:,deg-i] = prefactor * np.power(x,i)
    # number of columns (n) is number of decision vars
    n = A.shape[1]
    # for L1 fitting, use doc from hw4
    tMat = np.identity(m)
    # make [ [+A, -I_n],[-A,-I_n]]
    finalMatTop = np.hstack((-A,-tMat))
    finalMatBottom = np.hstack((A,-tMat))
    finalMat = np.vstack((finalMatTop,finalMatBottom))
    print(finalMat)
    print(finalMat.shape)
    # full b is [y,-y]
    finalB = np.hstack((-y,y))
    # c is 'n' zeros, followed by 'm' negations
    c = np.zeros((n+m,))
    c[n:] = 1
    # call lin prog
    ret = linprog(c,A_ub=finalMat,b_ub=finalB)
    print(ret)
    xSol = ret['x'][0:n]
    print(xSol)
    return xSol
    
