#!/usr/bin/env python
# coding: utf-8

from tkinter import * #'used for the GUI'
from cdo import *
import numpy as np
import matplotlib as mpl #'used to set the main characteristic of plots'
import matplotlib.pyplot as plt
import warnings
import matplotlib.ticker as t #'used to set the tcks in plots'
from cartopy.util import add_cyclic_point
from mpl_toolkits.basemap import Basemap, shiftgrid, addcyclic
from mpl_toolkits.axes_grid1.axes_divider import make_axes_locatable #'used in graph_globe_zonal'
from netCDF4 import Dataset #'used to open netcdf files'

#'from matplotlib.colors import ListedColormap'
#'import matplotlib.patches as patches'
#'from PIL import ImageTk'
#'import PIL.Image'
#'import xarray as xr'
#'import struct'
#'import os'
#'from cartopy.mpl.gridliner import LONGITUDE_FORMATTER, LATITUDE_FORMATTER'
#"os.environ['PROJ_LIB'] = '/opt/conda/pkgs/proj4-5.2.0-he1b5a44_1003/share/proj'"
#"os.environ['PROJ_LIB'] = r'C:\Users\andrea\anaconda3\envs\Tesi\Library\share'"
#'import cartopy.crs as ccrs'


'set the main characteristic of plots'
mpl.rc("text", usetex=False)
mpl.rc('axes', titlesize=18, labelsize=15, linewidth=1.2, titleweight="bold")
mpl.rc('xtick', labelsize=11)
mpl.rc('ytick', labelsize=11)
mpl.rcParams['xtick.major.size'] = 2.5
mpl.rcParams['xtick.minor.size'] = 1.5
mpl.rcParams['ytick.major.size'] = 2.5
mpl.rcParams['ytick.minor.size'] = 1.5
warnings.filterwarnings("ignore")
cdo = Cdo()


class variable:
    '''

    The variable object contains the common features to define a variable and its plots


    Parameters
    ----------

        text_var : str
            name of the variable

        sim_par : list
            list of parameter that define the simulation
            [name of simulation, time of simulation,start time for data mean,
            stop time for data mean,latitudes,month,longitude,delta latitudes,
            lats_inv,path of the simulation]

        ylabel : str
            name of the ylabel

        unit : str
            variable unit

        step : int
            level in the contour/f plot

        contourf=False : bool
            choose between contour and contourf plot

        vmn=None : int/float
            set the minimum value for the contour/f plot

        vmx=None : int/float
            set the maximum value for the contour/f plot

        save=False : bool=False
            choose to saving the image in output/analisi/grafici

        cost=1 int/float
            value that multiplies the data

        fm="%1.1f" : str
            format for the number in the contour plot


    Attributes
    ----------

        text : str
            name of the variable

        sim_par : list
            list of parameter that define the simulation
            [name of simulation,time of simulation,start time for data mean,
            stop time for data mean,latitudes,month,longitude,delta latitudes,
            lats_inv,path of the simulation]

        ylabel : str
            name of the ylabel

        units : str
            variable unit

        step : int
            level in the contour/f plot

        contourf : bool
            choose between contour and contourf plot

        vmn : int/float
            set the minimum value for the contour/f plot

        vmx : int/float
            set the maximum value for the contour/f plot

        save : bool
            choose to saving the image in output/analisi/grafici

        cost : int/float
            value that multiplies the data

        fm : str
            format for the number in the contour plot

        time : list
            list of the duration time of the simulation

        lsm : matrix
            Land Sea Mask data

        file_analisi : str
            analisi path

        file_output : str
            output path
    '''

    def __init__(self, text_var, sim_par, ylabel, unit, step, contourf=False,
                vmn=None, vmx=None, save=False, cost=1, fm="%1.1f"):
        self.text = text_var
        self.sim_par = sim_par
        self.ylabel = ylabel
        self.units = unit
        self.step = step
        self.save = save
        self.contourf = contourf
        self.vmn = vmn
        self.vmx = vmx
        self.save = save
        self.cost = cost
        self.fm = fm
        self.time = [i for i in range(1, self.sim_par[1]+1)]
        #define the number of latitude and longitudes in function of the model resolution
        if self.sim_par[-1].split("/")[-1].split("_")[-1]=="T21":
            self.lat=32
            self.long=64
        else:
            self.lat=64
            self.long=128

        self.lsm, _ = read_graph_file("N0"+str(self.lat)+"_surf_0172.sra",
                      self.sim_par[-1]+"/",False, "Land Sea Mask", None, None,
                      'Fraction', 0, 1, plt.cm.get_cmap("Spectral_r"))
        self.file_analisi = self.sim_par[-1]+"/output/analisi/"
        self.file_output = self.sim_par[-1]+"/output/analisi/grafici/"


class single_variable(variable):
    '''

    The single_variable object let analyze the main feature of the variable


    Parameter
    ---------

        name : str
            variable name ECMWF

        color : colomap
            define the color of the plots

        ssn : str
            season selection (DJF, JJA)

        text_var : str
            name of the variable

        sim_par : list
            list of parameter that define the simulation
            [name of simulation, time of simulation,start time for data mean,
            stop time for data mean,latitudes,month,longitude,delta latitudes,
            lats_inv,path of the simulation]

        ylabel : str
            name of the ylabel

        unit : str
            variable unit

        step : int
            level in the contour/f plot

        **kwargs
            Parameters from the variable object


    Attributes
    ----------

        name : str
            variable name ECMWF

        color : colomap
            define the color of the plots

        season : str
            season selection (DJF, JJA)

        text : str
            name of the variable

        sim_par : list
            list of parameter that define the simulation
            [name of simulation,time of simulation,start time for data mean,
            stop time for data mean,latitudes,month,longitude,delta latitudes,
            lats_inv,path of the simulation]

        ylabel : str
            name of the ylabel

        units : str
            variable unit

        step : int
            level in the contour/f plot

        contourf : bool
            choose between contour and contourf plot

        vmn : int/float
            set the minimum value for the contour/f plot

        vmx : int/float
            set the maximum value for the contour/f plot

        save : bool
            choose to saving the image in output/analisi/grafici

        cost : int/float
            value that multiplies the data

        fm : str
            format for the number in the contour plot

        time : list
            list of the duration time of the simulation

        lsm : matrix
            Land Sea Mask data

        file_analisi : str
            analisi path

        file_output : str
            output path

        name_files : list
            defines the name files to take from the CDO analysis

        temp : bool
            identify if the variable is a temperature

        mean : float
            global mean of the last step year permormed using CDO

        err_std : float
            standard error over the last step year

        dev_std: float
            standard deviation over the last step year

        globe : float
            global mean of the last step year permormed using python

        land : float
            Mean over Land

        ocean : float
            Mean over Ocean

        antarctica : float
            mean over Antarctica

        land_area : float
            total area of land expressed in area grid units

        ocean_area :float
            total area of ocean expressed in area grid units

        antarctica_area : float
            total area of Antarctica expressed in area grid units

    '''

    def __init__(self, name, color, ssn, text_var, sim_par, ylabel, unit, step, **kwargs):
        super().__init__(text_var, sim_par, ylabel, unit, step, **kwargs)
        self.name = name
        self.color = color
        self.season = ssn
        self.set_name()
        self.print_value()

        if self.name == "tas" or self.name == "sst" or self.name == "ts" or\
        self.name == "tso" or self.name == "tsod" or self.name == "tso2" or\
        self.name == "tso3" or self.name == "tso4":
            self.temp = True
        else:
            self.temp = False

    def set_name(self):
            self.name_files=[self.file_analisi+self.sim_par[0]+"_YM_FM_"+str(self.sim_par[1])+"Y_"+self.name+".nc",\
                self.file_analisi+self.sim_par[0]+"_YM_"+str(self.sim_par[3])+"YM_ZM_"+str(self.sim_par[1])+"Y_"+self.name+".nc",\
                self.file_analisi+self.sim_par[0]+"_YM_ZM_"+str(self.sim_par[1])+"Y_"+self.name+".nc",\
                self.file_analisi+self.sim_par[0]+"_FM_"+str(self.sim_par[1])+"Y_"+self.name+".nc",\
                self.file_analisi+self.sim_par[0]+"_all_"+self.name+".nc",\
                self.file_analisi+self.sim_par[0]+"_YM_"+str(self.sim_par[3])+"YM_"+str(self.sim_par[1])+"Y_"+self.name+".nc",\
                self.file_analisi+self.sim_par[0]+"_SM_"+str(self.sim_par[3])+"YM_"+str(self.sim_par[1])+"Y_"+self.name+".nc",\
                self.file_analisi+self.sim_par[0]+"_SM_"+str(self.sim_par[3])+"YM_ZM_"+str(self.sim_par[1])+"Y_"+self.name+".nc"]


    def print_value(self):
        if self.lat==32:
            a=6
            b=25

        else:
            a=12
            b=51

        data=self.cost*np.reshape(Dataset(self.name_files[0]).variables[self.name][:],[self.sim_par[1]])
        self.mean=round(np.mean(data[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]]),5)
        self.err_std=round(np.std(data[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]])/np.sqrt(len(data[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]])),5)
        self.dev_std=round(np.std(data[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]]),5)
        data=self.cost*Dataset(self.name_files[5],"r").variables[self.name][0]
        vect_land2=np.zeros(np.shape(data))
        vect_ocean2=np.zeros(np.shape(data))
        Antarctica2=np.zeros((a,self.long))
        globe=np.zeros((self.lat,self.long))
        count=np.zeros(4)
        err=np.zeros(4)
        soglia=0.5
        for i in range(0,len(data)):
            for j in range(0,len(data[i])):
                if i>b:
                    if self.lsm[i][j]>=soglia:
                        Antarctica2[i-b-1][j]=data[i][j]*np.cos(np.pi*self.sim_par[4][i]/180)
                        count[0]+=1*np.cos(np.pi*self.sim_par[4][i]/180)
                        err[0]+=(self.dev_std*np.cos(np.pi*self.sim_par[4][i]/180))**2
                if self.lsm[i][j]>=soglia:
                    vect_land2[i][j]=data[i][j]*np.cos(np.pi*self.sim_par[4][i]/180)
                    count[1]+=1*np.cos(np.pi*self.sim_par[4][i]/180)
                    #land_part+=np.cos(np.pi*self.sim_par[4][i]/180)
                    err[1]+=(self.dev_std*np.cos(np.pi*self.sim_par[4][i]/180))**2
                if self.lsm[i][j]<soglia:
                    vect_ocean2[i][j]=data[i][j]*np.cos(np.pi*self.sim_par[4][i]/180)
                    count[2]+=1*np.cos(np.pi*self.sim_par[4][i]/180)
                    #ocean_part+=np.cos(np.pi*self.sim_par[4][i]/180)
                    err[2]+=(self.dev_std*np.cos(np.pi*self.sim_par[4][i]/180))**2

                globe[i][j]=data[i][j]*np.cos(np.pi*self.sim_par[4][i]/180)
                count[3]+=np.cos(np.pi*self.sim_par[4][i]/180)

        self.globe=round(np.sum(globe)/count[3],5)
        self.land=round(np.sum(vect_land2)/count[1],5)
        self.ocean=round(np.sum(vect_ocean2)/count[2],5)
        self.antarctica=round(np.sum(Antarctica2)/count[0],5)
        #self.land_tot=round(np.sum(vect_land2),5)
        #self.land_tot_err=np.sqrt(err[1])
        #self.ocean_tot=round(np.sum(vect_ocean2),5)
        #self.ocean_tot_err=np.sqrt(err[2])
        #self.antarctica_tot=round(np.sum(Antarctica2),5)
        #self.antarctica_tot_err=np.sqrt(err[0])
        self.land_area=round(count[1],5)
        self.ocean_area=round(count[2],5)
        self.antarctica_area=round(count[0],5)

        print("Mean "+str(self.sim_par[2])+"-"+str(self.sim_par[2]+self.sim_par[3])+": "+str(self.mean)+" dev.std: "+str(self.err_std)+" "+self.units)
        print("Global Mean: {:5.3f} {}".format(self.globe,self.units))
        print("Mean over Land with {} as threshold: {:5.3f} {} ".format(soglia,self.land,self.units))
        print("Mean over Ocean with {} as threshold: {:5.3f} {}".format(soglia,self.ocean,self.units))
        print("Mean over Antarctica with {} as threshold: {:5.3f} {}".format(soglia,self.antarctica,self.units))
        print("Land part {}, Ocean Part {}".format(self.land_area,self.ocean_area))

    def global_annual_mean(self):
        data=self.cost*np.reshape(Dataset(self.name_files[0]).variables[self.name][:],[self.sim_par[1]])
        graph(self.time,data,"Time [year]",self.ylabel,self.text+" Global Annual Mean ("+self.sim_par[0]+")",
                self.save,False,self.sim_par[0],self.file_output)
        return data

    def zonal_mean(self):
        data=self.cost*np.reshape(Dataset(self.name_files[1]).variables[self.name][:],[self.lat])
        graph(self.sim_par[4],data,"Latitude [°]",self.ylabel,self.text+" Zonal Mean ("+self.sim_par[0]+")",\
              self.save,True,self.sim_par[0],self.file_output)
        return data

    def zonal_annual_mean(self):
        lats=[self.sim_par[4][i] for i in range(2,len(self.sim_par[4]),3)]
        data=[[float(i)*self.cost for i in cdo.output(input="-sellonlatbox,-180,180,"+str(j-1)+","+str(j+1)+" "+self.name_files[2])]for j in lats]
        graph_n(self.time,data,"Time [year]",self.ylabel,[str(int(i))+"°" for i in lats],self.text+" Zonal Annual Mean ("+self.sim_par[0]+")",\
                self.save,"upper left",self.name,self.file_output)
        return data

    def annual_cycle(self):
        data0=np.reshape([cdo.output(input="-timselmean,"+str(self.sim_par[3])+","+str(self.sim_par[2])+\
        " -selmonth,"+str(i)+" "+self.name_files[3]) for i in range(1,13)],[12])

        data=[self.cost*float(i) for i in data0]

        graph(self.sim_par[5],data,"Time [month]",self.ylabel,self.text+" Annual Cycle ("+self.sim_par[0]+")",self.save,False,self.sim_par[0],self.file_output)

        return data

    def annual_cycle_hemisphere(self):

        if self.temp==True:
            data=[cdo.output(input="-gridboxmean,"+str(self.long)+","+str(intn(self.lat/2))+" -timselmean,"+str(self.sim_par[3])+","+str(self.sim_par[2])+\
            " -addc,-273.15 -selmonth,"+str(i)+" "+self.name_files[4])[0].split() for i in range(1,13)]
        else:
            data=[cdo.output(input="-gridboxmean,"+str(self.long)+","+str(self.lat/2)+" -timselmean,"+str(self.sim_par[3])+","+str(self.sim_par[2])\
            +" -selmonth,"+str(i)+" "+self.name_files[4])[0].split()for i in range(1,13)]

        north_hem=[self.cost*float(data[i][0]) for i in range(0,len(data))]
        south_hem=[self.cost*float(data[i][1]) for i in range(0,len(data))]
        graph2(self.sim_par[5],north_hem,south_hem,"Time [month]",self.ylabel,"Northen hemisphere","Southern hemisphere"
                ,self.text+" Annual Cycle Hemisphere ("+self.sim_par[0]+")",self.save,"best",self.sim_par[0],self.file_output)

    def global_vision(self):
        data=self.cost*Dataset(self.name_files[5],"r").variables[self.name][0]

        graph_globe(data,self.sim_par[6],self.sim_par[4],self.save,"Global "+self.text+" ("+self.sim_par[0]+")",self.ylabel,\
                    self.vmn,self.vmx,self.step,self.sim_par[0],self.file_output,self.contourf,self.fm,cmp=self.color)
        return data

    def global_and_zonal(self):

        if self.season=="Annual Mean":
            data_global_ann=Dataset(self.name_files[5],"r").variables[self.name][0]
            data=self.cost*np.reshape(Dataset(self.name_files[0]).variables[self.name][:],[self.sim_par[1]])
            self.mean=round(np.mean(data[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]]),5)
            data_zonal_ann=Dataset(self.name_files[1],"r").variables[self.name][0]
            if self.contourf:
                graph_globe_zonal(data_global_ann,data_zonal_ann,self.sim_par[4],self.sim_par[6],self.step,\
                                    self.ylabel,self.text+" ["+self.units+"]","ANN "+self.sim_par[0],self.cost,\
                                    self.mean,self.units,self.color,self.fm,self.file_output,self.contourf,self.vmn,self.vmx)
            else:
                graph_globe_zonal(data_global_ann,data_zonal_ann,self.sim_par[4],self.sim_par[6],self.step,\
                                    self.ylabel,self.text+" ["+self.units+"]","ANN "+self.sim_par[0],self.cost,\
                                    self.mean,self.units,self.color,self.fm,self.file_output)

        elif self.season=="DJF Mean":

            mean_djf=self.cost*float(cdo.output(input="-fldmean "+self.name_files[6])[0])
            data_global_djf=Dataset(self.name_files[6],"r").variables[self.name][0]
            data_zonal_djf=Dataset(self.name_files[7],"r").variables[self.name][0]

            if self.contourf:
                graph_globe_zonal(data_global_djf,data_zonal_djf,self.sim_par[4],self.sim_par[6],self.step,\
                                    self.ylabel,self.text+" ["+self.units+"]","DJF "+self.sim_par[0],self.cost,\
                                    mean_djf,self.units,self.color,self.fm,self.file_output,self.contourf,self.vmn,self.vmx)
            else:
                graph_globe_zonal(data_global_djf,data_zonal_djf,self.sim_par[4],self.sim_par[6],self.step,\
                                    self.ylabel,self.text+" ["+self.units+"]","DJF "+self.sim_par[0],self.cost,\
                                    mean_djf,self.units,self.color,self.fm,self.file_output)

        elif self.season=="JJA Mean":

            mean_jja=self.cost*float(cdo.output(input="-fldmean "+self.name_files[6])[2])
            data_global_jja=Dataset(self.name_files[6],"r").variables[self.name][2]
            data_zonal_jja=Dataset(self.name_files[7],"r").variables[self.name][2]

            if self.contourf:
                graph_globe_zonal(data_global_jja,data_zonal_jja,self.sim_par[4],self.sim_par[6],self.step,\
                                    self.ylabel,self.text+" ["+self.units+"]","JJA "+self.sim_par[0],self.cost,
                                    mean_jja ,self.units,self.color,self.fm,self.file_output,self.contourf,self.vmn,self.vmx)
            else:
                graph_globe_zonal(data_global_jja,data_zonal_jja,self.sim_par[4],self.sim_par[6],self.step,\
                                    self.ylabel,self.text+" ["+self.units+"]","JJA "+self.sim_par[0],self.cost,\
                                    mean_jja,self.units,self.color,self.fm,self.file_output)


    def polar(self):
        if self.season=="Annual Mean":
            data_ann=Dataset(self.name_files[5],"r").variables[self.name][0]

            if self.contourf:
                pole_graph("ANN "+self.sim_par[0],data_ann,self.text+" ["+self.units+"]",\
                            self.step,self.color,self.sim_par[4],self.sim_par[6],self.file_output,cost=self.cost,contourf=self.contourf,\
                            mn=self.vmn,mx=self.vmx)
            else:
                pole_graph("ANN "+self.sim_par[0],data_ann,self.text+" ["+self.units+"]",\
                            self.step,self.color,self.sim_par[4],self.sim_par[6],self.file_output,cost=self.cost,fm=self.fm)

        elif self.season=="DJF Mean":
            data_djf=Dataset(self.name_files[6],"r").variables[self.name][0]
            if self.contourf:
                pole_graph("DJF "+self.sim_par[0],data_djf,self.text+" ["+self.units+"]",\
                            self.step,self.color,self.sim_par[4],self.sim_par[6],self.file_output,cost=self.cost,contourf=self.contourf,\
                            mn=self.vmn,mx=self.vmx)
            else:
                pole_graph("DJF "+self.sim_par[0],data_djf,self.text+" ["+self.units+"]",\
                            self.step,self.color,self.sim_par[4],self.sim_par[6],self.file_output,cost=self.cost,fm=self.fm)

        elif self.season=="JJA Mean":
            data_jja=Dataset(self.name_files[6],"r").variables[self.name][2]
            if self.contourf:
                pole_graph("JJA "+self.sim_par[0],data_jja,self.text+" ["+self.units+"]",\
                            self.step,self.color,self.sim_par[4],self.sim_par[6],self.file_output,cost=self.cost,contourf=self.contourf,\
                            mn=self.vmn,mx=self.vmx)
            else:
                pole_graph("JJA "+self.sim_par[0],data_jja,self.text+" ["+self.units+"]",\
                            self.step,self.color,self.sim_par[4],self.sim_par[6],self.file_output,cost=self.cost,fm=self.fm)

















class composed_variable(variable):
    '''

    The single_variable object let analyze the main feature of the variable


    Parameter
    ---------

        names : str
            variable names in ECMWF

        color : colormap
            define the color of the plots

        ssn : str
            season selection (DJF, JJA)

        text_var : str
            name of the variable

        sim_par : list
            list of parameter that define the simulation
            [name of simulation, time of simulation,start time for data mean,
            stop time for data mean,latitudes,month,longitude,delta latitudes,
            lats_inv,path of the simulation]

        ylabel : str
            name of the ylabel

        unit : str
            variable unit

        step : int
            level in the contour/f plot

        **kwargs
            Parameters from the variable object


    Attributes
    ----------

        names : str
            variable names in ECMWF format

        color : colomap
            define the color of the plots

        season : str
            season selection (DJF, JJA)

        text : str
            name of the variable

        sim_par : list
            list of parameter that define the simulation
            [name of simulation,time of simulation,start time for data mean,
            stop time for data mean,latitudes,month,longitude,delta latitudes,
            lats_inv,path of the simulation]

        ylabel : str
            name of the ylabel

        units : str
            variable unit

        step : int
            level in the contour/f plot

        contourf : bool
            choose between contour and contourf plot

        vmn : int/float
            set the minimum value for the contour/f plot

        vmx : int/float
            set the maximum value for the contour/f plot

        save : bool
            choose to saving the image in output/analisi/grafici

        cost : int/float
            value that multiplies the data

        fm : str
            format for the number in the contour plot

        time : list
            list of the duration time of the simulation

        lsm : matrix
            Land Sea Mask data

        file_analisi : str
            analisi path

        file_output : str
            output path

        name_files : list
            defines the name files to take from the CDO analysis

        mean : float
            global mean of the last step year permormed using CDO

        err_std : float
            standard error over the last step year

        dev_std: float
            standard deviation over the last step year

        globe : float
            global mean of the last step year permormed using python

        land : float
            Mean over Land

        ocean : float
            Mean over Ocean

        antarctica : float
            mean over Antarctica

        land_area : float
            total area of land expressed in area grid units

        ocean_area :float
            total area of ocean expressed in area grid units

        antarctica_area : float
            total area of Antarctica expressed in area grid units

    '''
    def __init__(self,names,color,ssn,text_var,sim_par,ylabel,unit,step,**kwargs):
        super().__init__(text_var,sim_par,ylabel,unit,step,**kwargs)
        self.names=names
        self.color=color
        self.season=ssn
        self.name_files=np.zeros((len(self.names),6))
        self.set_name()
        self.print_value()


    def set_name(self):
        self.name_files=np.transpose([[self.file_analisi+self.sim_par[0]+"_YM_FM_"+str(self.sim_par[1])+"Y_"+i+".nc",
                        self.file_analisi+self.sim_par[0]+"_YM_"+str(self.sim_par[3])+"YM_ZM_"+str(self.sim_par[1])+"Y_"+i+".nc",\
                        self.file_analisi+self.sim_par[0]+"_YM_ZM_"+str(self.sim_par[1])+"Y_"+i+".nc",\
                        self.file_analisi+self.sim_par[0]+"_FM_"+str(self.sim_par[1])+"Y_"+i+".nc",\
                        self.file_analisi+self.sim_par[0]+"_all_"+i+".nc",\
                        self.file_analisi+self.sim_par[0]+"_YM_"+str(self.sim_par[3])+"YM_"+str(self.sim_par[1])+"Y_"+i+".nc",\
                        self.file_analisi+self.sim_par[0]+"_SM_"+str(self.sim_par[3])+"YM_"+str(self.sim_par[1])+"Y_"+i+".nc",\
                        self.file_analisi+self.sim_par[0]+"_SM_"+str(self.sim_par[3])+"YM_ZM_"+str(self.sim_par[1])+"Y_"+i+".nc"] for i in self.names])

    def print_value(self):

        if self.lat==32:
            a=6
            b=25
        else:
            a=12
            b=51

        R=np.zeros(self.sim_par[1])
        for i in range(0,len(self.names)):
            if self.names[i]=="prsn":
                 R-=1000*334000*np.reshape(Dataset(self.name_files[0][i]).variables[self.names[i]][:],[self.sim_par[1]])
            elif self.names[i]=="mrro":
                R-=self.cost*np.reshape(Dataset(self.name_files[0][i]).variables[self.names[i]][:],[self.sim_par[1]])
            else:
                R+=self.cost*np.reshape(Dataset(self.name_files[0][i]).variables[self.names[i]][:],[self.sim_par[1]])
        self.annual_data=R
        self.mean=round(np.mean(self.annual_data[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]]),5)
        self.err_std=round(np.std(self.annual_data[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]])\
                    /np.sqrt(len(self.annual_data[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]])),5)
        self.dev_std=round(np.std(self.annual_data[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]]),5)

        R=np.zeros((self.lat,self.long))
        for j in range(0,len(self.names)):
            if self.names[j]=="prsn":
                R-=1000*334000*Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
            elif self.names[j]=="mrro":
                R-=self.cost*Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
            else:
                R+=self.cost*Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]

        vect_land2=np.zeros(np.shape(R))
        vect_ocean2=np.zeros(np.shape(R))
        Antarctica2=np.zeros((a,self.long))
        globe=np.zeros((self.lat,self.long))
        count=np.zeros(4)
        err=np.zeros(4)

        soglia=0.5
        for i in range(0,len(R)):
            for j in range(0,len(R[i])):
                if i>b:
                    if self.lsm[i][j]>=soglia:
                        Antarctica2[i-b-1][j]=R[i][j]*np.cos(np.pi*self.sim_par[4][i]/180)
                        count[0]+=1*np.cos(np.pi*self.sim_par[4][i]/180)
                        err[0]+=(self.dev_std*np.cos(np.pi*self.sim_par[4][i]/180))**2

                if self.lsm[i][j]>=soglia:
                    vect_land2[i][j]=R[i][j]*np.cos(np.pi*self.sim_par[4][i]/180)
                    count[1]+=1*np.cos(np.pi*self.sim_par[4][i]/180)
                    #land_part+=np.cos(np.pi*self.sim_par[4][i]/180)
                    err[1]+=(self.dev_std*np.cos(np.pi*self.sim_par[4][i]/180))**2

                if self.lsm[i][j]<soglia:
                    vect_ocean2[i][j]=R[i][j]*np.cos(np.pi*self.sim_par[4][i]/180)
                    count[2]+=1*np.cos(np.pi*self.sim_par[4][i]/180)
                    #ocean_part+=np.cos(np.pi*self.sim_par[4][i]/180)
                    err[2]+=(self.dev_std*np.cos(np.pi*self.sim_par[4][i]/180))**2

                globe[i][j]=R[i][j]*np.cos(np.pi*self.sim_par[4][i]/180)
                count[3]+=np.cos(np.pi*self.sim_par[4][i]/180)

        self.globe=round(np.sum(globe)/count[3],5)
        self.land=round(np.sum(vect_land2)/count[1],5)
        self.ocean=round(np.sum(vect_ocean2)/count[2],5)
        self.antarctica=round(np.sum(Antarctica2)/count[0],5)
        #self.land_tot=round(np.sum(vect_land2),5)
        #self.land_tot_err=np.sqrt(err[1])
        #self.ocean_tot=round(np.sum(vect_ocean2),5)
        #self.ocean_tot_err=np.sqrt(err[2])
        #self.antarctica_tot=round(np.sum(Antarctica2),5)
        #self.antarctica_tot_err=np.sqrt(err[0])
        self.land_area=round(count[1],5)
        self.ocean_area=round(count[2],5)
        self.antarctica_area=round(count[0],5)

        print("Mean "+str(self.sim_par[2])+"-"+str(self.sim_par[2]+self.sim_par[3])+\
                    ": "+str(self.mean)+" dev.std: "+str(self.err_std)+" "+self.units)
        print("Global Mean: {:5.3f} {}".format(self.globe,self.units))
        print("Mean over Land with {} as threshold: {:5.3f} {} ".format(soglia,self.land,self.units))
        print("Mean over Ocean with {} as threshold: {:5.3f} {}".format(soglia,self.ocean,self.units))
        print("Mean over Antarctica with {} as threshold: {:5.3f} {}".format(soglia,self.antarctica,self.units))
        print("Land part {}, Ocean Part {}".format(self.land_area,self.ocean_area))



    def global_annual_mean(self):
        R=np.zeros(self.sim_par[1])
        for i in range(0,len(self.names)):
            if self.names[i]=="prsn":
                 R-=1000*334000*np.reshape(Dataset(self.name_files[0][i]).variables[self.names[i]][:],[self.sim_par[1]])
            elif self.names[i]=="mrro":
                R-=self.cost*np.reshape(Dataset(self.name_files[0][i]).variables[self.names[i]][:],[self.sim_par[1]])
            else:
                R+=self.cost*np.reshape(Dataset(self.name_files[0][i]).variables[self.names[i]][:],[self.sim_par[1]])
        graph(self.time,R,"Time [year]",self.ylabel,self.text+" Global Annual Mean ("+self.sim_par[0]+")",self.save,False,self.sim_par[0],self.file_output)
        return R

    def zonal_mean(self):

        R=np.zeros(self.lat)
        for i in range(0,len(self.names)):
            if self.names[i]=="prsn":
                R-=np.reshape(Dataset(self.name_files[1][i]).variables[self.names[i]][:],[self.lat])*1000*334000
            elif self.names[i]=="mrro":
                R-=self.cost*np.reshape(Dataset(self.name_files[1][i]).variables[self.names[i]][:],[self.lat])
            else:
                R+=self.cost*np.reshape(Dataset(self.name_files[1][i]).variables[self.names[i]][:],[self.lat])
        graph(self.sim_par[4],R,"Latitude [°]",self.ylabel,self.text+" Zonal Mean ("+self.sim_par[0]+")",self.save,True,self.sim_par[0],self.file_output)
        return R

    def zonal_annual_mean(self):
        if self.lat==32:
            a=10
        else:
            a=21
        R=np.zeros((a,self.sim_par[1]))
        lats=[self.sim_par[4][i] for i in range(2,len(self.sim_par[4]),3)]
        for i in range(0,len(self.names)):
            if self.names[i]=="prsn":
                 R-=[[float(i)*1000*334000 for i in cdo.output(input="-sellonlatbox,-180,180,"+str(j-1)+","+str(j+1)+" "+self.name_files[2][i])]for j in lats]
            elif self.names[i]=="mrro":
                R-=[[float(i)*self.cost for i in cdo.output(input="-sellonlatbox,-180,180,"+str(j-1)+","+str(j+1)+" "+self.name_files[2][i])]for j in lats]
            else:
                R+=[[float(i)*self.cost for i in cdo.output(input="-sellonlatbox,-180,180,"+str(j-1)+","+str(j+1)+" "+self.name_files[2][i])]for j in lats]
        graph_n(self.time,R,"Time [year]",self.ylabel,[str(int(i))+"°" for i in lats],self.text+" Zonal Annual Mean ("+self.sim_par[0]+")",\
        self.save,"upper left",self.sim_par[0],self.file_output)
        return R


    def annual_cycle(self):

        R=np.zeros(12)
        for j in range(0,len(self.names)):
            if self.names[j]=="prsn":
                R-=[float(i)*1000*334000 for i in np.reshape([cdo.output(input="-timselmean,"+str(self.sim_par[3])+","+str(self.sim_par[2])+\
                " -selmonth,"+str(i)+" "+self.name_files[3][j]) for i in range(1,13)],[12])]
            elif self.names[j]=="mrro":
                R-=[self.cost*float(i) for i in np.reshape([cdo.output(input="-timselmean,"+str(self.sim_par[3])+","+str(self.sim_par[2])+\
                " -selmonth,"+str(i)+" "+self.name_files[3][j]) for i in range(1,13)],[12])]
            else:
                R+=[self.cost*float(i) for i in np.reshape([cdo.output(input="-timselmean,"+str(self.sim_par[3])+","+str(self.sim_par[2])+\
                " -selmonth,"+str(i)+" "+self.name_files[3][j]) for i in range(1,13)],[12])]

        graph(self.sim_par[5],R,"Time [month]",self.ylabel,self.text+" Annual Cycle ("+self.sim_par[0]+")",self.save,False,self.sim_par[0],self.file_output)
        return R

    def annual_cycle_hemisphere(self):

        R=np.zeros(12)
        R_north=np.zeros(12)
        R_south=np.zeros(12)
        for j in range(0,len(self.names)):
            if self.names[j]=="prsn":
                R=[cdo.output(input="-gridboxmean,"+str(self.long)+","+str(self.lat/2)+" -timselmean,"+str(self.sim_par[3])+","+str(self.sim_par[2])+\
                " -selmonth,"+str(i)+" "+self.name_files[4][j])[0].split() for i in range(1,13)]
                R_north-=[float(R[i][0])*1000*334000 for i in range(0,len(R))]
                R_south-=[float(R[i][1])*1000*334000 for i in range(0,len(R))]
            elif self.names[j]=="mrro":
                R=[cdo.output(input="-gridboxmean,"+str(self.long)+","+str(self.lat/2)+" -timselmean,"+str(self.sim_par[3])+","+str(self.sim_par[2])+\
                " -selmonth,"+str(i)+" "+self.name_files[4][j])[0].split() for i in range(1,13)]
                R_north-=[self.cost*float(R[i][0]) for i in range(0,len(R))]
                R_south-=[self.cost*float(R[i][1]) for i in range(0,len(R))]
            else:
                R=[cdo.output(input="-gridboxmean,"+str(self.long)+","+str(self.lat/2)+" -timselmean,"+str(self.sim_par[3])+","+str(self.sim_par[2])+\
                " -selmonth,"+str(i)+" "+self.name_files[4][j])[0].split() for i in range(1,13)]
                R_north+=[self.cost*float(R[i][0]) for i in range(0,len(R))]
                R_south+=[self.cost*float(R[i][1]) for i in range(0,len(R))]

        graph2(self.sim_par[5],R_north,R_south,"Time [month]",self.ylabel,"Northen hemisphere","Southern hemisphere",
                self.text+" Annual Cycle ("+self.sim_par[0]+"),self.save,"best",self.sim_par[0],self.file_output)


    def global_vision(self):
        R=np.zeros((self.lat,self.long))
        for j in range(0,len(self.names)):
            if self.names[j]=="prsn":
                R-=1000*334000*Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
            elif self.names[j]=="mrro":
                R-=self.cost*Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
            else:
                R+=self.cost*Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
        graph_globe(R,self.sim_par[6],self.sim_par[4],self.save,"Global "+self.text+"("+self.sim_par[0]+")",
                    self.ylabel,int(np.min(R-1)),int(np.max(R+1)),self.step,self.sim_par[0],self.file_output,self.contourf,self.fm,cmp=self.color)


    def transport(self):

        R_g=np.zeros(self.sim_par[1])
        for i in range(0,len(self.names)):
            if self.names[i]=="prsn":
                 R_g-=1000*334000*np.reshape(Dataset(self.name_files[0][i]).variables[self.names[i]][:],[self.sim_par[1]])
            elif self.names[i]=="mrro":
                R_g-=self.cost*np.reshape(Dataset(self.name_files[0][i]).variables[self.names[i]][:],[self.sim_par[1]])
            else:
                R_g+=self.cost*np.reshape(Dataset(self.name_files[0][i]).variables[self.names[i]][:],[self.sim_par[1]])
        R_z=np.zeros(self.lat)
        for i in range(0,len(self.names)):
            if self.names[i]=="prsn":
                R_z-=np.reshape(Dataset(self.name_files[1][i]).variables[self.names[i]][:],[self.lat])*1000*334000
            elif self.names[i]=="mrro":
                R_z-=self.cost*np.reshape(Dataset(self.name_files[1][i]).variables[self.names[i]][:],[self.lat])
            else:
                R_z+=self.cost*np.reshape(Dataset(self.name_files[1][i]).variables[self.names[i]][:],[self.lat])
        #print(R_g,R_z)
        mn=np.mean(R_g[self.sim_par[2]:self.sim_par[1]])
        #print(mn)
        transport=np.zeros(len(self.sim_par[8]))
        for k in range(1,len(transport)-1):
            transport[k]=transport[k-1]+2*6371000**2*np.pi*np.cos(np.pi*self.sim_par[8][k]/180)*np.pi*self.sim_par[7][k-1]/180*(R_z[k-1]-mn)
            #print(self.transport)
        graph(self.sim_par[8],transport,"Latitude [°]","[W]",""+self.sim_par[0]+" Surface Meridional Transport",True,True,self.sim_par[0],self.file_output)
        return transport

    def global_and_zonal(self):
        if self.season=="Annual Mean":
            R=np.zeros(self.sim_par[1])
            data_global_ann=np.zeros((self.lat,self.long))
            data_zonal_ann=np.zeros(self.lat)
            for j in range(0,len(self.names)):
                if self.names[j]=="prsn":
                    data_global_ann-=1000*334000*Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
                    data_zonal_ann-=1000*334000*np.reshape(Dataset(self.name_files[1][j],"r").variables[self.names[j]][0],[self.lat])
                    R-=1000*334000*np.reshape(Dataset(self.name_files[0][j]).variables[self.names[j]][:],[self.sim_par[1]])
                elif self.names[j]=="mrro":
                    data_global_ann-=Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
                    data_zonal_ann-=np.reshape(Dataset(self.name_files[1][j],"r").variables[self.names[j]][0],[self.lat])
                    R-=self.cost*np.reshape(Dataset(self.name_files[0][j]).variables[self.names[j]][:],[self.sim_par[1]])
                else:
                    data_global_ann+=Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
                    data_zonal_ann+=np.reshape(Dataset(self.name_files[1][j],"r").variables[self.names[j]][0],[self.lat])
                    R+=self.cost*np.reshape(Dataset(self.name_files[0][j]).variables[self.names[j]][:],[self.sim_par[1]])

            self.mean=round(np.mean(R[self.sim_par[2]:self.sim_par[2]+self.sim_par[3]]),5)
            if self.contourf:

                graph_globe_zonal(data_global_ann,data_zonal_ann,self.sim_par[4],self.sim_par[6],self.step,self.ylabel,\
                                    self.text+" ["+self.units+"]","ANN "+self.sim_par[0],self.cost,self.mean,self.units,\
                                    self.color,self.fm,self.file_output,self.contourf,self.vmn,self.vmx)

            else:
                graph_globe_zonal(data_global_ann,data_zonal_ann,self.sim_par[4],self.sim_par[6],self.step,self.ylabel,\
                                    self.text+" ["+self.units+"]","ANN "+self.sim_par[0],self.cost,self.mean,self.units,\
                                    self.color,self.fm,self.file_output)

        elif self.season=="DJF Mean":

            data_global_djf=np.zeros((self.lat,self.long))
            data_zonal_djf=np.zeros(self.lat)
            mean_djf=0.
            for j in range(0,len(self.names)):
                if self.names[j]=="prsn":
                    mean_djf-=1000*334000*float(cdo.output(input="-fldmean "+self.name_files[6][j])[0])
                    data_global_djf-=1000*334000*Dataset(self.name_files[6][j],"r").variables[self.names[j]][0]
                    data_zonal_djf-=1000*334000*np.reshape(Dataset(self.name_files[7][j],"r").variables[self.names[j]][0],[self.lat])

                elif self.names[j]=="mrro":
                    mean_djf-=float(cdo.output(input="-fldmean "+self.name_files[6][j])[0])
                    data_global_djf-=Dataset(self.name_files[6][j],"r").variables[self.names[j]][0]
                    data_zonal_djf-=np.reshape(Dataset(self.name_files[7][j],"r").variables[self.names[j]][0],[self.lat])

                else:
                    mean_djf+=float(cdo.output(input="-fldmean "+self.name_files[6][j])[0])
                    data_global_djf+=Dataset(self.name_files[6][j],"r").variables[self.names[j]][0]
                    data_zonal_djf+=np.reshape(Dataset(self.name_files[7][j],"r").variables[self.names[j]][0],[self.lat])


            if self.contourf:

                graph_globe_zonal(data_global_djf,data_zonal_djf,self.sim_par[4],self.sim_par[6],self.step,self.ylabel,\
                                    self.text+" ["+self.units+"]","DJF "+self.sim_par[0],self.cost,mean_djf,self.units,\
                                    self.color,self.fm,self.file_output,self.contourf,self.vmn,self.vmx)

            else:

                graph_globe_zonal(data_global_djf,data_zonal_djf,self.sim_par[4],self.sim_par[6],self.step,self.ylabel,\
                                    self.text+" ["+self.units+"]","DJF "+self.sim_par[0],self.cost,mean_djf,self.units,\
                                    self.color,self.fm,self.file_output)

        elif self.season=="JJA Mean":
            data_global_jja=np.zeros((self.lat,self.long))
            data_zonal_jja=np.zeros(self.lat)
            mean_jja=0.
            for j in range(0,len(self.names)):
                if self.names[j]=="prsn":

                    mean_jja-=1000*334000*float(cdo.output(input="-fldmean "+self.name_files[6][j])[2])
                    data_global_jja-=1000*334000*Dataset(self.name_files[6][j],"r").variables[self.names[j]][2]
                    data_zonal_jja-=1000*334000*np.reshape(Dataset(self.name_files[7][j],"r").variables[self.names[j]][2],[self.lat])
                elif self.names[j]=="mrro":

                    mean_jja-=float(cdo.output(input="-fldmean "+self.name_files[6][j])[2])
                    data_global_jja-=Dataset(self.name_files[6][j],"r").variables[self.names[j]][2]
                    data_zonal_jja-=np.reshape(Dataset(self.name_files[7][j],"r").variables[self.names[j]][2],[self.lat])

                else:

                    mean_jja+=float(cdo.output(input="-fldmean "+self.name_files[6][j])[2])
                    data_global_jja+=Dataset(self.name_files[6][j],"r").variables[self.names[j]][2]
                    data_zonal_jja+=np.reshape(Dataset(self.name_files[7][j],"r").variables[self.names[j]][2],[self.lat])

            if self.contourf:

                graph_globe_zonal(data_global_jja,data_zonal_jja,self.sim_par[4],self.sim_par[6],self.step,self.ylabel,\
                                    self.text+" ["+self.units+"]","JJA "+self.sim_par[0],self.cost,mean_jja ,self.units,\
                                    self.color,self.fm,self.file_output,self.contourf,self.vmn,self.vmx)
            else:

                graph_globe_zonal(data_global_jja,data_zonal_jja,self.sim_par[4],self.sim_par[6],self.step,self.ylabel,\
                                    self.text+" ["+self.units+"]","JJA "+self.sim_par[0],self.cost,mean_jja,self.units,\
                                    self.color,self.fm,self.file_output)

    def polar(self):
        if self.season=="Annual Mean":
            data_ann=np.zeros((self.lat,self.long))
            for j in range(0,len(self.names)):
                if self.names[j]=="prsn":
                    data_ann-=1000*334000*Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
                elif self.names[j]=="mrro":
                    data_ann-=Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]
                else:
                    data_ann+=Dataset(self.name_files[5][j],"r").variables[self.names[j]][0]

            if self.contourf:
                pole_graph("ANN "+self.sim_par[0],data_ann,self.text+" ["+self.units+"]",15,self.color,self.sim_par[4],
                            self.sim_par[6],self.file_output,cost=self.cost,contourf=self.contourf,mn=self.vmn,mx=self.vmx)
            else:
                pole_graph("ANN "+self.sim_par[0],data_ann,self.text+" ["+self.units+"]",15,self.color,self.sim_par[4],
                            self.sim_par[6],self.file_output,cost=self.cost,fm=self.fm)

        elif self.season=="DJF Mean":
            data_djf=np.zeros((self.lat,self.long))
            for j in range(0,len(self.names)):
                if self.names[j]=="prsn":
                    data_djf-=1000*334000*Dataset(self.name_files[6][j],"r").variables[self.names[j]][0]
                elif self.names[j]=="mrro":
                    data_djf-=Dataset(self.name_files[6][j],"r").variables[self.names[j]][0]
                else:
                    data_djf+=Dataset(self.name_files[6][j],"r").variables[self.names[j]][0]

            if self.contourf:
                pole_graph("DJF "+self.sim_par[0],data_djf,self.text+" ["+self.units+"]",15,self.color,self.sim_par[4],
                            self.sim_par[6],self.file_output,cost=self.cost,contourf=self.contourf,mn=self.vmn,mx=self.vmx)
            else:
                pole_graph("DJF "+self.sim_par[0],data_djf,self.text+" ["+self.units+"]",15,self.color,self.sim_par[4],
                            self.sim_par[6],self.file_output,cost=self.cost,fm=self.fm)

        elif self.season=="JJA Mean":
            data_jja=np.zeros((self.lat,self.long))

            for j in range(0,len(self.names)):
                if self.names[j]=="prsn":
                    data_jja-=1000*334000*Dataset(self.name_files[6][j],"r").variables[self.names[j]][2]
                elif self.names[j]=="mrro":
                    data_jja-=Dataset(self.name_files[6][j],"r").variables[self.names[j]][2]
                else:
                    data_jja+=Dataset(self.name_files[6][j],"r").variables[self.names[j]][2]

            if self.contourf:
                pole_graph("JJA "+self.sim_par[0],data_jja,self.text+" ["+self.units+"]",15,self.color,self.sim_par[4],
                            self.sim_par[6],self.file_output,cost=self.cost,contourf=self.contourf,mn=self.vmn,mx=self.vmx)
            else:
                pole_graph("JJA "+self.sim_par[0],data_jja,self.text+" ["+self.units+"]",15,self.color,self.sim_par[4],
                            self.sim_par[6],self.file_output,cost=self.cost,fm=self.fm)













class lev_variable(variable):
    '''

    The single_variable object let analyze the main feature of the variable


    Parameter
    ---------

        name : str
            variable name in ECMWF

        level: int
            selected pressure level

        press : list
            level of pressure

        text_var : str
            name of the variable

        sim_par : list
            list of parameter that define the simulation
            [name of simulation, time of simulation,start time for data mean,
            stop time for data mean,latitudes,month,longitude,delta latitudes,
            lats_inv,path of the simulation]

        ylabel : str
            name of the ylabel

        unit : str
            variable unit

        step : int
            level in the contour/f plot

        **kwargs
            Parameters from the variable object


    Attributes
    ----------

        name : str
            variable name in ECMWF format

        level: int
            selected pressure level

        press : list
            level of pressure

        num_lev : int
            number of level

        text : str
            name of the variable

        sim_par : list
            list of parameter that define the simulation
            [name of simulation,time of simulation,start time for data mean,
            stop time for data mean,latitudes,month,longitude,delta latitudes,
            lats_inv,path of the simulation]

        ylabel : str
            name of the ylabel

        units : str
            variable unit

        step : int
            level in the contour/f plot

        contourf : bool
            choose between contour and contourf plot

        vmn : int/float
            set the minimum value for the contour/f plot

        vmx : int/float
            set the maximum value for the contour/f plot

        save : bool
            choose to saving the image in output/analisi/grafici

        cost : int/float
            value that multiplies the data

        fm : str
            format for the number in the contour plot

        time : list
            list of the duration time of the simulation

        lsm : matrix
            Land Sea Mask data

        file_analisi : str
            analisi path

        file_output : str
            output path

        name_files : list
            defines the name files to take from the CDO analysis

        mean : float
            global mean of the last step year permormed using CDO for every level



    '''
    def __init__(self,name,level,press,text_var,sim_par,ylabel,unit,step,**kwargs):
        super().__init__(text_var,sim_par,ylabel,unit,step,**kwargs)
        self.name=name
        self.num_lev=len(press)
        self.level=level
        self.press=press
        self.set_name()
        self.print_value()

    def set_name(self):

        self.name_files=[self.file_analisi+self.sim_par[0]+"_YM_FM_"+str(self.sim_par[1])+"Y_"+self.name+".nc",\
                        self.file_analisi+self.sim_par[0]+"_YM_"+str(self.sim_par[3])+"YM_ZM_"+str(self.sim_par[1])+"Y_"+self.name+".nc",\
                        self.file_analisi+self.sim_par[0]+"_FM_"+str(self.sim_par[1])+"Y_"+self.name+".nc",\
                        self.file_analisi+self.sim_par[0]+"_YM_"+str(self.sim_par[3])+"YM_"+str(self.sim_par[1])+"Y_"+self.name+".nc"]

    def print_value(self):
        data=[[self.cost*float(i) for i in cdo.output(input="-sellevidx,"+str(j)+" "+self.name_files[0])] for j in range(1,self.num_lev+1)]
        self.mean=[np.mean(k) for k in data]
        for k in range(0,len(data)):
            print("Mean level {} hPa: {:5.3f} {}".format(self.press[k],self.mean[k],self.units))

    def global_annual_mean_level(self):

        data=[[self.cost*float(i) for i in cdo.output(input="-sellevidx,"+str(j)+" "+self.name_files[0])] for j in range(1,self.num_lev+1)]
        graph_n(self.time,data,"Time [year]",self.ylabel,[str(i)+" hPa" for i in self.press],self.text+" ("+self.sim_par[0]+")",False,"upper left",self.sim_par[0])
        return data

    def zonal_mean_level(self):
        if self.lat==32:
            a=6
        else:
            a=11
        data=[[self.cost*float(j) for j in ' '.join([i for i in \
        np.reshape(cdo.output(input="-sellevidx,"+str(k)+" "+self.name_files[1]),[a])]).split()]for k in range(1,self.num_lev+1)]
        graph_n(self.sim_par[4],data,"Latitude [°]",self.ylabel,[str(i)+" hPa" for i in self.press],
                self.text+" Zonal Mean "+"("+self.sim_par[0]+")",False,"upper left",self.sim_par[0])
        return data

    def annual_cycle_level(self):
        data=[[self.cost*float(i) for i in np.reshape([cdo.output(input="-sellevidx,"+str(k)+\
                " -selmonth,"+str(i)+" -ymonmean -selyear,"+str(self.sim_par[3])+"/"\
                +str(self.sim_par[1])+" "+self.name_files[2]) for i in range(1,13)],[12])] for k in range(1,self.num_lev+1)]
        graph_n(self.sim_par[5],data,"Time [month]",self.ylabel,[str(i)+" hPa" for i in self.press],
                self.text+" Annual Cycle "+"("+self.sim_par[0]+")",False,"upper left",self.sim_par[0])
        return data

    def global_vision_level(self):
        if self.lat==32:
            a=342
        else:
            a=1366
        data=np.reshape([self.cost*float(i) for i in ' '.join([j for j in np.reshape(cdo.output(input="-sellevidx,"+str(self.level+1)\
                        +" "+self.name_files[3]),[a])]).split()],[self.lat,self.long])
        if self.contourf:
            graph_globe(data,self.sim_par[6],self.sim_par[4],False,self.text+" "+str(self.press[self.level])+" hPa",self.ylabel,self.vmn,\
                        self.vmx,self.step,self.sim_par[0],self.file_output,self.contourf,self.fm)
        else:
            graph_globe(data,self.sim_par[6],self.sim_par[4],False,self.text+" "+str(self.press[self.level])+" hPa",self.ylabel,np.min(data),\
                        np.max(data),self.step,self.sim_par[0],self.file_output,self.contourf,self.fm)

    def graph_level(self):

        fig,ax=plt.subplots(figsize=(8,6))
        x,y=np.meshgrid(self.sim_par[4],self.press)

        #vmin=int(np.min(Dataset(self.name_files[1],"r").variables[self.name][:])-1)
        #vmax=int(np.max(Dataset(self.name_files[1],"r").variables[self.name][:])+1)
        if self.contourf:
            print(self.contourf)
            cs=ax.contourf(x,y,np.reshape(self.cost*Dataset(self.name_files[1],"r").variables[self.name][:],\
                            (13,self.lat)),levels=np.linspace(self.vmn,self.vmx,self.step),cmap=plt.cm.jet)
            cbar = plt.colorbar(cs,orientation='vertical', shrink=0.9,ticks=np.linspace(self.vmn,self.vmx,15))
            cbar.set_label(self.ylabel,rotation=-90,labelpad=25)
        else:
            print(self.contourf)
            mn=np.min(Dataset(self.name_files[1],"r").variables[self.name][:]*self.cost)
            mx=np.max(Dataset(self.name_files[1],"r").variables[self.name][:]*self.cost)
            cs=ax.contour(x,y,np.reshape(self.cost*Dataset(self.name_files[1],"r").variables[self.name][:],\
                        (13,self.lat)),levels=t.MaxNLocator(nbins=self.step).tick_values(mn,mx) ,linewidths=1.2)
            plt.clabel(cs,fmt=self.fm,colors="k",inline_spacing=5)
        ax.xaxis.set_major_locator(plt.MultipleLocator(10))
        ax.yaxis.set_ticks([1000,850,700,500,400,300,200,100,30])
        ax.set_ylim(1000,30,self.sim_par[0])
        ax.set_xlabel("Latitude [°]")
        ax.set_ylabel(" Pressure [hPa]")
        ax.set_xlim(-86,86)
        ax.set_xticks((80,60,40,20,0,-20,-40,-60,-80))
        ax.set_xticklabels(["80N","60N","40N","20N","0","20S","40S","60S","80S"])
        #ax.clabel(cs, inline=True, fontsize=12)
        #plt.yscale('log')
        ax.grid()

        #plt.gca().invert_yaxis()
        plt.title(self.text+" ("+self.sim_par[0]+")"+"\n")
        plt.show()
        #if self.save==True:
        #    plt.savefig("grafici/"+self.text+" "+self.sim_par[0])



















def read_file(path,name_file):
    with open(path+name_file,'r') as f:
        heading=f.readline()
        data=[[float(num) for num in line.split()] for line in f]
    return heading,data

def plot_nc(file,variable):
    data=Dataset("../NSM2_PLA.0001.nc","r")
    year=file.split(".")[-2]
    for i in data.variables[variable][:]:
        plt.matshow(i)
        plt.colorbar()
        plt.title(variable+" "+year+"\n")
        plt.show()


def print_value(file_name,start,end,cost=1):
    var=file_name.split("_")[-1]
    year=int(file_name.split("_")[-2].replace("Y",""))
    data=np.reshape(Dataset(file_name+".nc").variables[var][:],[year])
    print("Mean "+str(start)+"-"+str(end)+": "+str(np.mean(cost*data[start:end]))+" dev.std: "+str(np.std(cost*data[start:end])/np.sqrt(len(data[start:end]))))

def print_value2(data,starts,ends):
    print("Mean "+str(starts)+"-"+str(ends)+": "+str(np.mean(data[starts:ends]))+" dev.std: "+str(np.std(data[starts:ends])/np.sqrt(len(data[starts:ends]))))




def read_graph_file(name_file,path,month,title,mesi,column,bar_title,vmin,vmax,cbar_type):
    if "32" in name_file:
        lat=32
        lon=64
    else:
        lat=64
        lon=128
    if month==True:
        with open(path+name_file,'r') as f:
            str_data=f.readline()
            f.seek(0)
            data=[[float(num) for num in line.split()] for line in f]
        for i in range(0,int(len(data)*column/2048)):
            data_res=np.reshape(data[i*int(2048/column)+1+i:(i+1)*int(2048/column)+1+i],[lat,lon])
            Title=title+" "+mesi[i]

        return data,str_data
    else:

        with open(path+name_file,'r') as f:
            str_data=f.readline()
            data=[[float(num) for num in line.split()] for line in f]
        data_res=np.reshape(data,[lat,lon])

        return data_res,str_data


def graph(xdata,ydata,xlabel,ylabel,title,save,zonal,name_run,path):
    fig,ax=plt.subplots(figsize=(7,5))
    ax.plot(xdata,ydata)
    ax.set_title(title+"\n",fontsize=14)
    ax.set_xlabel(xlabel,fontsize=13)
    ax.set_ylabel(ylabel,fontsize=13)

    if zonal==True:
        ax.xaxis.set_major_locator(plt.MultipleLocator(10))
        ax.grid(linestyle='--')
        ax.set_xlim(86,-86,name_run)
    else:
        ax.grid(axis='y',linestyle='--')
    if save==True:
        plt.savefig(path+title,bbox_inches='tight')
    plt.show()


def graph2(xdata,ydata1,ydata2,xlabel,ylabel,legend1,legend2,title,save,loc_legend,name_run,path):
    fig,ax=plt.subplots(figsize=(7,5))
    ax.plot(xdata,ydata1,label=legend1)
    ax.plot(xdata,ydata2,label=legend2)
    legend=ax.legend(loc=loc_legend, shadow=True)
    ax.set_title(title+"\n",fontsize=16)
    ax.set_xlabel(xlabel,fontsize=13)
    ax.set_ylabel(ylabel,fontsize=13)

    ax.grid(axis='y',linestyle='--')
    if save==True:
        plt.savefig(path+title,bbox_inches='tight')
    plt.show()

def graph_n(xdata,ydata,xlabel,ylabel,legend,title,save,loc_legend,name_run,path):
    fig,ax=plt.subplots(figsize=(8,5))
    for i in range(0,len(ydata)):
        ax.plot(xdata,ydata[i],label=legend[i])
    legend=ax.legend(bbox_to_anchor=(1.03, 1.03),loc=loc_legend, shadow=True)
    ax.set_title(title+"\n",fontsize=16)
    ax.set_xlabel(xlabel,fontsize=13)
    ax.set_ylabel(ylabel,fontsize=13)
    #ax.yaxis.set_label_coords(-0.1,1.02)
    ax.grid(axis='y',linestyle='--')
    if save==True:
        plt.savefig(path+title,bbox_inches='tight')
    plt.show()

def graph_globe(data,lons,lats,save,title,cbar_title,vmn,vmx,step_bar,name_run,path,contourf,fm,cmp=plt.cm.jet,cost=1):
    fig = plt.figure(figsize=(10,6))

    m = Basemap(projection="robin", llcrnrlat=-90, urcrnrlat=90,llcrnrlon=0, urcrnrlon=360, resolution='c', lon_0=0)
    m.drawmapboundary()
    m.drawparallels(np.arange(-90,90,30),labels=[1,0,0,0])
    m.drawmeridians(np.arange(m.lonmin,m.lonmax+30,60),labels=[0,0,0,1])
    var_cyclic, lons_cyclic = add_cyclic_point(data*cost,lons)
    var_cyclic, lons_cyclic = shiftgrid(180.,var_cyclic, lons_cyclic, start=False)
    lon2d, lat2d = np.meshgrid(lons_cyclic, lats)
    x, y = m(lon2d, lat2d)
    if contourf==False:
        m.drawcoastlines(linewidth=0.5,color="grey")
        mn=np.min(data*cost)
        mx=np.max(data*cost)
        cs=m.contour(x,y,var_cyclic,levels=t.MaxNLocator(nbins=step_bar).tick_values(mn,mx) ,linewidths=1.2)
        plt.clabel(cs,fmt=fm,colors="k",inline_spacing=5)
    else:
        m.drawcoastlines()
        cs = m.contourf(x, y,var_cyclic, cmap=cmp,levels=t.MaxNLocator(nbins=step_bar).tick_values(vmn,vmx),extend="both")
        cbar = plt.colorbar(cs,orientation='vertical',ticks=t.MaxNLocator(nbins=step_bar).tick_values(vmn,vmx))
        cbar.set_label(cbar_title,rotation=-90,labelpad=25)


    plt.title(title+"\n")
    if save==True:
        fig.savefig(path+title,bbox_inches='tight')
    plt.show()

def graph_globe_zonal(data_globe,data_zonal,lats,lons,step,ylabel,title_globe,title_fig,cost,mean,unit,color,fm,path,contourf=False,vmn=None,vmx=None,save=True):
    """data_globe,data_zonal,lats,lons,step,ylabel,title_globe,title_fig,cost,mean,unit,color,fm,path,contourf=False,vmn=None,vmx=None,save=True"""

    var_cyclic, lons_cyclic = add_cyclic_point(cost*data_globe,lons)
    var_cyclic, lons_cyclic = shiftgrid(180.,var_cyclic, lons_cyclic, start=False)
    x,y = np.meshgrid(lons_cyclic, lats)
    fig,ax=plt.subplots(1,1,figsize=(9,5))
    fig.suptitle(title_fig)#+"\n\n",y=1.10,fontsize=24)
    ax_divider = make_axes_locatable(ax)
    #fig.tight_layout()
    ax.set_title(title_globe+"\n")
    m=Basemap(projection="robin",lon_0=0,ax=ax)
    x1,y1=m(x,y)

    m.drawparallels(np.arange(-80.,81.,20.),labels=[1,0,0,0])
    m.drawmeridians(np.arange(-180.,181.,60.),labels=[0,0,0,1])
    if contourf:
        m.drawcoastlines()
        cs = m.contourf(x1, y1,var_cyclic, cmap=color,levels=t.MaxNLocator(nbins=step).tick_values(vmn,vmx),extend="both")

        # Add an axes to the right of the main axes.
        cax0 = ax_divider.append_axes("bottom", size="7%", pad="10%")
        cbar = fig.colorbar(cs,cax=cax0,orientation='horizontal',ticks=t.MaxNLocator(nbins=step).tick_values(vmn,vmx))
        #cbar.set_label(ylabel,rotation=-90,fontsize=13,labelpad=25)
    else:
        m.drawcoastlines(linewidth=0.5,color="grey")
        mn=np.min(data_globe*cost)
        mx=np.max(data_globe*cost)
        cs=m.contour(x1,y1,var_cyclic,levels=t.MaxNLocator(nbins=step).tick_values(mn,mx) ,linewidths=1.2)
        plt.clabel(cs,fmt=fm,colors="k",inline_spacing=5)

    ax1 = ax_divider.append_axes("right", size="45%", pad="10%")
    #ax[1]=plt.subplot(1,2,2,anchor=(0,0.5),sharey=ax,aspect="equal")
    ax1.set_title("Mean: "+str(round(mean,2))+" "+unit+" \n")
    ax1.plot(cost*data_zonal,lats)
    ax1.grid(axis="both")
    ax1.set_xlabel(ylabel)
    ax1.set_yticklabels([])
    #ax1.set_yticklabels(["","80°S","60°S","40°S","20°S","0°","20°N","40°N","60°N","80°N"])
    ax1.set_ylim(-90,90)
    ax1.yaxis.set_major_locator(plt.MultipleLocator(20))
    if vmn!=None:
        ax1.set_xlim(vmn,vmx)
    #ax1.xaxis.set_major_locator(plt.MultipleLocator(4))
    #x1.autoscale(axis='x', tight=True)
    #ax1.set_box_aspect(2)


    if save==True:
        plt.savefig(path+title_fig+" Globe_Zonal "+title_globe,bbox_inches='tight')
    plt.show()
def pole_graph(name_simulation,data,ylabel,step,color,lats,lons,path,contourf=False,mn=None,mx=None,fm="%0.9f",cost=1,save=True):

    if contourf:
        fig,ax=plt.subplots(1,2,figsize=(12,8))
        fig.suptitle(name_simulation,y=1.005,fontsize=20)
        ax[0].set_title("SH\n\n",fontsize=15)
        m1= Basemap(ax=ax[0],projection='aeqd',lon_0 = 0,lat_0 = -90,width = 13000000,height = 13000000)
        #m1.fillcontinents(color='coral',alpha=0.2)
        #m1.drawlsmask()
        m1.drawcoastlines(linewidth=1.5)
        m1.drawparallels(np.arange(-80.,81.,10.))
        m1.drawmeridians(np.arange(-180.,181.,20.),labels=[1,1,1,1])
        var_cyclic1, lons_cyclic1 = add_cyclic_point(cost*data,lons)
        var_cyclic1, lons_cyclic1 = shiftgrid(180.,var_cyclic1, lons_cyclic1, start=False)
        lon2d1, lat2d1 = np.meshgrid(lons_cyclic1, lats)
        x1, y1 = m1(lon2d1, lat2d1)
        c1= m1.contourf(x1, y1,var_cyclic1, cmap=color,levels=t.MaxNLocator(nbins=step).tick_values(mn,mx),extend="both")

        ax[1].set_title("NH\n\n",fontsize=15)
        m2= Basemap(ax=ax[1],projection='aeqd',lon_0 = 0,lat_0 = 90,width = 13000000,height = 13000000)
        #m2.fillcontinents(color='coral',alpha=0.2)
        m2.drawcoastlines(linewidth=1.5)
        m2.drawparallels(np.arange(-80.,81.,20.))
        m2.drawmeridians(np.arange(-180.,181.,20.),labels=[1,1,1,1])

        var_cyclic2, lons_cyclic2 = addcyclic(cost*data,lons)
        var_cyclic2, lons_cyclic2 = shiftgrid(180.,var_cyclic2, lons_cyclic2, start=False)
        lon2d2, lat2d2 = np.meshgrid(lons_cyclic2, lats)
        x2, y2 = m2(lon2d2, lat2d2)
        c2= m2.contourf(x2, y2,var_cyclic2, cmap=color,levels=t.MaxNLocator(nbins=step).tick_values(mn,mx),extend="both")


        cbar=fig.colorbar(c2,ax=ax,location='bottom',ticks=t.MaxNLocator(nbins=step).tick_values(mn,mx),pad=0.07,shrink=0.5)
        cbar.set_label(ylabel,labelpad=20,fontsize=15)
    else:
        mn=np.min(cost*data)
        mx=np.max(cost*data)
        fig,ax=plt.subplots(1,2,figsize=(12,7))
        fig.suptitle(name_simulation,y=0.96,fontsize=20)
        ax[0].set_title("South Pole "+ylabel+"\n\n",fontsize=15)
        m1= Basemap(ax=ax[0],projection='aeqd',lon_0 = 0,lat_0 = -90,width = 13000000,height = 13000000)
        #m1.fillcontinents(color='coral',alpha=0.2)
        #m1.etopo()
        m1.drawcoastlines(linewidth=0.5,color="grey")
        m1.drawparallels(np.arange(-80.,81.,10.))
        m1.drawmeridians(np.arange(-180.,181.,20.),labels=[1,1,1,1])

        var_cyclic1, lons_cyclic1 = add_cyclic_point(cost*data,lons)
        var_cyclic1, lons_cyclic1 = shiftgrid(180.,var_cyclic1, lons_cyclic1, start=False)
        lon2d1, lat2d1= np.meshgrid(lons_cyclic1, lats)
        x1, y1 = m1(lon2d1, lat2d1)
        c1=m1.contour(x1, y1,var_cyclic1,levels=t.MaxNLocator(nbins=step).tick_values(mn,mx),linewidths=2)
        clb1=plt.clabel(c1,fmt=fm,colors="k",inline_spacing=5,fontsize=12,use_clabeltext=True)


        ax[1].set_title("North Pole "+ylabel+"\n\n",fontsize=15)
        m2= Basemap(ax=ax[1],projection='aeqd',lon_0 = 0,lat_0 = 90,width = 13000000,height = 13000000)
        #m2.fillcontinents(color='coral',alpha=0.2)
        m2.drawcoastlines(linewidth=0.7,color="grey")
        m2.drawparallels(np.arange(-80.,81.,20.))
        m2.drawmeridians(np.arange(-180.,181.,20.),labels=[1,1,1,1])

        var_cyclic2, lons_cyclic2 = add_cyclic_point(cost*data,lons)
        var_cyclic2, lons_cyclic2 = shiftgrid(180.,var_cyclic2, lons_cyclic2, start=False)
        lon2d2, lat2d2= np.meshgrid(lons_cyclic2, lats)
        x2, y2 = m2(lon2d2, lat2d2)
        c2=m2.contour(x2, y2,var_cyclic2,levels=t.MaxNLocator(nbins=step).tick_values(mn,mx),linewidths=2)
        clb2=plt.clabel(c2,fmt=fm,colors="k",inline_spacing=5,fontsize=12,use_clabeltext=True)



    if save==True:
        plt.savefig(path+name_simulation+" Polar "+ylabel,bbox_inches='tight')
    plt.show()



def zonal(colorc,cost,name_run,save,step,title,ydata,path,fm='%2.f',contourf=False,vmn=None,vmx=None,location="upper right"):

    fig,ax=plt.subplots(figsize=(8,6))
    x,y=np.meshgrid(lats,z_press)
    if contourf==False:
        vmn=int(np.min(cost*ydata))
        vmx=int(np.max(cost*ydata))
        cs1=ax.contour(x,y,np.reshape(cost*ydata,(13,len(lats))),linewidths=1.2,levels=t.MaxNLocator(nbins=step).tick_values(vmn,vmx),linestyles="solid",cmap=colorc,alpha=1)
        el,_=cs1.legend_elements()

        ax.legend([el[0]],[title],loc=location,shadow=True,fontsize="large")
        ax.clabel(cs1,fontsize=14,fmt=fm,colors="k")
    else:
        cs1=ax.contourf(x,y,np.reshape(cost*ydata,(13,len(lats))),levels=t.MaxNLocator(nbins=step).tick_values(vmn,vmx),cmap=colorc,alpha=1,extend="both")
        cbar=plt.colorbar(cs1,orientation='vertical', ticks=t.MaxNLocator(nbins=step).tick_values(vmn,vmx))
        cbar.set_label(title,fontsize=18,rotation=-90,labelpad=25)
    ax.xaxis.set_major_locator(plt.MultipleLocator(10))
    ax.yaxis.set_ticks([1000,850,700,500,400,300,200,100,30])
    ax.set_ylim(1000,30)
    ax.set_xlabel("Latitude [°]")
    ax.set_ylabel("Pressure [hPa]")
    ax.set_xlim(-86,86)
    ax.set_xticks((80,60,40,20,0,-20,-40,-60,-80))
    ax.set_xticklabels(["80N","60N","40N","20N","0","20S","40S","60S","80S"])
    ax.grid()
    plt.title(name_run+"\n")

    if save==True:
        plt.savefig(path+name_run+" zonal "+title,bbox_inches='tight')
    plt.show()


# In[ ]:
