#!/usr/bin/env python
# coding: utf-8

# # Standard Simulation #

from module_single_file import *


import tkinter as tk
from tkinter import *
from tkinter import ttk
from tkinter import filedialog
#import os
#os.system('python module_study_file_2.py')
#get_ipython().run_line_magic('run', './module_study_file_2.py')

var_dic={
    "as" :["Albedo", "Reflectivity [%]", "%",100],
    "clh" :["High Level Cloud", "Cover [%]", "%",100],
    "clm" :["Medium Level Cloud", "Cover [%]", "%",100],
    "cll" :["Low Level Cloud", "Cover [%]", "%",100],
    "clt" :["Total Cloud Cover", "Cover [%]", "%",100],
    "evap" :["Evaporation","Evaporation [mm/day]","mm/day",86400000],
    "glac" :["Glacier Cover","Cover [%]", "%",100],
    "hfls" :["Surface Latent Heat Flux","Flux [W/m^2]","W/m^2"],
    "hfss" :["Surface Sensible Heat Flux", "Flux [W/m^2]","W/m^2"],
    "hus"   : ["Specific Humidity", "[g/Kg]", "g/Kg",1000], #lev
    "icec": ["Seai Ice Cover","Cover [%]", "%",100],
    "mrro" :["Surface Runoff", "[mm/day]", "mm/day",86400000],
    "mrso"  :["Soil Wetness", "[m]", "m",1],
    "pl"    : ["Log Surface Pressure", "Pressure [Pa]", "Pa",1],
    "prt"  :["Total Precipitation", "Precipitation [mm/day]", "mm/day"], #2
    "rls" :["Surface Thermal Radiation", "[W/m^2]","W/m^2",1],
    "rlut" :["Top Thermal Radiation", "[W/m^2]","W/m^2",1],
    "rss" :["Surface Solar Radiation", "[W/m^2]","W/m^2",1],
    "rst" :["Top Solar Radation", "[W/m^2]","W/m^2",1],
    "rsut":["Top Solar Radiation Upward","[W/m^2]","W/m^2",1],
    "sg"  : ["Surface Geopotential Orography", "Geopotential [m^2/s^2]", "m^2/s^2",1],
    "sit":["Sea Ice Thickness", "[m]","m",1],
    "snd" : ["Snow Depth", "Depth [m]", "m",1],
    "ssru":["Surface Solar Radiation Upward","[W/m^2]","W/m^2",1],
    "sst"  : ["Sea Surface Temperature","T [°C]", "°C",1],
    "stru":["Surface Thermal Radiation Upward","[W/m^2]","W/m^2",1],
    "ta"    : ["Temperature", "T [°C]", "°C",1], #lev
    "tas" : ["2m Surface Temperature", "T [°C]", "°C",1],
    "ts"  : ["Surface Temperature","T [°C]", "°C",1],
    "tso":["Soil Temperature","T [°C]", "°C",1],
    "tsod":["Deep Soil Temperature","T [°C]", "°C",1],
    "RTOA" : ["TOA Energy Balance", "[W/m^2]","W/m^2",1], #2
    "RSUP" :["SUP Energy Balance", "[W/m^2]","W/m^2",1], #2
    "P-E" : ["precipitation-Evaporaration","[mm/day]","mm/day",86400000]
    }
vr=["as","clh","clm","cll","clt","evap","glac","hfls","hfss","hus","icec","mrro","mrso","pl","prt","rls","rlut",\
"rss","rst","rsut","sg","sit","snd","ssru","sst","stru","ta","tas","ts","tso","tsod","RTOA","RSUP","P-E"]

# In[3]:


grpdic={
    "global annual" : "a",
    "zonal" : "b",
    "zonal annual" :"c",
    "annual cycle": "d",
    "annual cycle hemisphere" : "e",
    "global vision" : "f",
    "global and zonal" :"g",
    "polar" : "h",
    "transport": "i",
    "graph level":"l"
}

grp_1=["global annual", "zonal", "zonal annual", "annual cycle","annual cycle hemisphere", "global vision", "global and zonal", "polar"]
grp_2=["global annual", "zonal","zonal annual", "annual cycle","annual cycle hemisphere", "global vision", "global and zonal", "polar","transport"]
grp_3=["global annual", "zonal", "annual cycle", "global vision","graph level"]
lev=[""]


press=[1000,850,700,500,400,300,250,200,150,100,70,50,30]
str_press=["1000","850","700","500","400","300","250","200","150","100","70","50","30"]
mesi=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
r_eq=6371000


#stating the graphical interface
gui = Tk()
gui.geometry("450x200")
gui.title("PlaSim-analysis")

#function

def varclick(event):
    var_label=Label(gui,text=var_dic[var_combo.get()][0]).grid(row=1,column=2)
    if var_combo.get()=="prt" or var_combo.get()=="RTOA" or var_combo.get()=="RSUP" or var_combo.get()=="P-E":
        grpcombo.configure(value=grp_2)
    elif var_combo.get()=="hus" or var_combo.get()=="ta":
        grpcombo.configure(value=grp_3)
    else:
        grpcombo.configure(value=grp_1)


def graphclick(event):
    if grpdic[grpcombo.get()]=="f" :
        radYes.configure(state="normal")
        radNo.configure(state="normal")
        if var_combo.get()=="hus" or var_combo.get()=="ta":
            cmblevel.configure(state="normal")
    elif grpdic[grpcombo.get()]=="g" or grpdic[grpcombo.get()]=="h":
        radYes.configure(state="normal")
        radNo.configure(state="normal")
        cmbmonth.configure(state="normal")
    elif grpdic[grpcombo.get()]=="l":
        radYes.configure(state="normal")
        radNo.configure(state="normal")

    else:
        radYes.configure(state="disabled")
        radNo.configure(state="disabled")
        cmbmonth.configure(state="disabled")
        min_value.configure(state='disable')
        max_value.configure(state='disable')
        cmblevel.configure(state="disable")
        cntf.set("No")
    grplabel=Label(gui,text=grpcombo.get()).grid(row=2,column=2)

def getFolderPath():
    folder_selected = filedialog.askdirectory()
    folderPath.set(folder_selected)

def doStuff():
    folder = folderPath.get()
    print("Doing stuff with folder", folder)

def minmax(val):
    if val:
        min_value.configure(state='normal')
        max_value.configure(state='normal')
    else:
        min_value.configure(state='disable')
        max_value.configure(state='disable')


def gr(folderPath,var):
    """function activated by the Plot button"""
    minimum=IntVar()
    maximum=IntVar()
    minimum=min_value.get()
    maximum=max_value.get()

    name_simulation=folderPath.get().split("/")[-1].split("_")[0]
    #title_sim=folderPath.get().split("/")[-1].split("_")[0]
    #title_sim2=folderPath.get().split("/")[-1].split("_")[0]
    tm=int(folderPath.get().split("/")[-1].split("_")[1])
    strt=int(folderPath.get().split("/")[-1].split("_")[2])
    stp=int(folderPath.get().split("/")[-1].split("_")[3])

    lev=press.index(int(cmblevel.get()))
    #prendo le variabili lat e long da un qualsiasi file netcdf
    file_nc=Dataset(folderPath.get().split("/")[-1]+"/output/"+name_simulation+"_PLA.0001.nc")

    lats=file_nc.variables["lat"]
    time=[i for i in range(1,tm+1)]
    lons=file_nc.variables["lon"]
    #hybm=file_nc.variables["hybm"][:]
    #press=[int(i*101100) for i in hybm]

    lats_inv=lats
    lats_inv=np.insert(lats_inv,0,90)
    lats_inv=np.append(lats_inv,-90)
    delta_lat=np.zeros(len(lats_inv)-1)
    for i in range(1,len(lats_inv)):

        delta_lat[i-1]=lats_inv[i]-lats_inv[i-1]
    simulation=[name_simulation,tm,strt,stp,lats,mesi,lons,delta_lat,lats_inv,folderPath.get()]
    #print(step_slider.get())


    if cntf.get()==True:
        mn_tkk=int(min_value.get())
        mx_tkk=int(max_value.get())
        if var=="prt" or var=="RTOA" or var=="RSUP" or var=="P-E":
            if var=="prt":
                v=["prl","prc"]
            elif var=="RTOA":
                v=["rst","rlut"]
            elif var=="RSUP":
                v=["rss","rls","hfss","hfls","prsn"]
            elif var=="P-E":
                v=["prl","prc","evap"]
            t=composed_variable(v,plt.cm.jet,cmbmonth.get(),var_dic[var][0],simulation,var_dic[var][1],var_dic[var][2],int(step_slider.get()),\
                                contourf=cntf.get(),vmn=mn_tkk,vmx=mx_tkk,cost=var_dic[var][-1])

        elif var=="hus" or var=="ta":
            t=lev_variable(var,lev,press,var_dic[var][0],simulation,
                            var_dic[var][1],var_dic[var][2],int(step_slider.get()),cost=var_dic[var][-1],contourf=cntf.get(),vmn=mn_tkk,vmx=mx_tkk)

        else:
            t=single_variable(var,plt.cm.jet,cmbmonth.get(),var_dic[var][0],simulation,var_dic[var][1],var_dic[var][2],int(step_slider.get()),\
                                contourf=cntf.get(),vmn=mn_tkk,vmx=mx_tkk,cost=var_dic[var][-1])

    else:
        if var=="prt" or var=="RTOA" or var=="RSUP" or var=="P-E":
            if var=="prt":
                v=["prl","prc"]
            elif var=="RTOA":
                v=["rst","rlut"]
            elif var=="RSUP":
                v=["rss","rls","hfss","hfls","prsn"]
            elif var=="P-E":
                v=["prl","prc","evap"]
            t=composed_variable(v,plt.cm.jet,cmbmonth.get(),var_dic[var][0],simulation,var_dic[var][1],var_dic[var][2],
                        int(step_slider.get()),cost=var_dic[var][-1])
        elif var=="hus" or var=="ta":
            t=lev_variable(var,lev,press,var_dic[var][0],simulation,
                            var_dic[var][1],var_dic[var][2],int(step_slider.get()),cost=var_dic[var][-1])
        else:
            t=single_variable(var,plt.cm.jet,cmbmonth.get(),var_dic[var][0],simulation,
                            var_dic[var][1],var_dic[var][2],int(step_slider.get()),cost=var_dic[var][-1])


    if var=="hus" or var=="ta":
        if "a" in grpdic[grpcombo.get()]:
            t.global_annual_mean_level()
        if "b" in grpdic[grpcombo.get()]:
            t.zonal_mean_level()
        if "d" in grpdic[grpcombo.get()]:
            t.annual_cycle_level()
        if "f" in grpdic[grpcombo.get()]:
            t.global_vision_level()
        if "l" in grpdic[grpcombo.get()]:
            t.graph_level()
    else:
        if "a" in grpdic[grpcombo.get()]:
                t.global_annual_mean()
        elif "b" in grpdic[grpcombo.get()]:
                t.zonal_mean()
        elif "c" in grpdic[grpcombo.get()]:
                t.zonal_annual_mean()
        elif "d" in grpdic[grpcombo.get()]:
                t.annual_cycle()
        elif "e" in grpdic[grpcombo.get()]:
                t.annual_cycle_hemisphere()
        elif "f" in grpdic[grpcombo.get()]:
                t.global_vision()
        elif "g" in grpdic[grpcombo.get()]:
                t.global_and_zonal()
        elif "h" in grpdic[grpcombo.get()]:
                t.polar()
        elif "i" in grpdic[grpcombo.get()]:
                t.transport()

#variables
folderPath = StringVar()
var = StringVar()
cntf=BooleanVar()

#widgets
a = Label(gui ,text="Select path")
a.grid(row=0,column = 0)

E = Entry(gui,textvariable=folderPath)
E.grid(row=0,column=1)

btnFind = ttk.Button(gui, text="Browse Folder",command=getFolderPath)
btnFind.grid(row=0,column=2)

var_combo=ttk.Combobox(gui,value=vr)
var_combo.current(0)
var_combo.bind("<<ComboboxSelected>>",varclick)
var_combo.grid(row=1,column=1)

grpcombo=ttk.Combobox(gui,value=grp_1)
grpcombo.current(0)
grpcombo.bind("<<ComboboxSelected>>",graphclick)
grpcombo.grid(row=2,column=1)

cmbmonth=ttk.Combobox(gui,value=["Annual Mean","DJF Mean","JJA Mean"])
cmbmonth.current(0)
cmbmonth.configure(state="disabled")
#grpcombo.bind("<<ComboboxSelected>>",graphclick)
cmbmonth.grid(row=7,column=1)

cmblevel=ttk.Combobox(gui,value=str_press)
cmblevel.current(0)
cmblevel.configure(state="disabled")
cmblevel.grid(row=8,column=1)

step_slider=Scale(gui,from_=10,to=30,orient=HORIZONTAL)
step_slider.set(value=15)
step_slider.grid(row=3,column=1)

min_label=Label(gui,text="Minimum Value").grid(row=5,column=1)
min_value=Entry(gui,state='disable')

max_label=Label(gui,text="Maximum Value").grid(row=6,column=1)
max_value=Entry(gui,state='disable')

max_value.grid(row=6,column=2)
min_value.grid(row=5,column=2)

cntf_label=Label(gui,text="Contourf").grid(row=4,column=0)
radYes=Radiobutton(gui,text="Yes",variable=cntf,value=True,state='disabled',command=lambda: minmax(cntf.get()))
radNo=Radiobutton(gui,text="No",variable=cntf,value=False,state='disabled',command=lambda: minmax(cntf.get()))
radYes.grid(row=4,column=1)
radNo.grid(row=4,column=2)

Button1=Button(gui,text="Plot",command=lambda: gr(folderPath,var_combo.get()))
Button1.grid(row=9,column=1)

gui.mainloop()
