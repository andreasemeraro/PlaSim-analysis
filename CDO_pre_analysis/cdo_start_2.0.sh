#!/usr/bin/env bash

name_dir=../NSM2_100_70_30_ML_SI_T21
name_sim="NSM2"
year=100
step=30
start=70
day_start=101
day_stop=130
#VARIABLE LEGEND
#sg --> Surf. Geopotential Orography
#pl --> Log Surface Pressure
#ta --> Temperature
#hus --> Specific Humudity
#d --> Divergence
#zeta --> Vorticity
#mld --> Mixed Layer Depth
#ts --> Surface Temperature
#mrso --> Soil Wetness
#snd -->Snow Depth
#prl --> Large Scale Precipitation
#prc --> Convective Precipitation
#prsn --> Snow fall
#hfss --> Surface Sensible Heat Flux
#hfls --> Surface Latent Heat Flux
#clw --> Liquid Water Content
#u3 --> m**3/s**3
#mrro --> Surface Runoff
#cl --> Cloud Cover
#clt --> Total Cloud Cover
#tas --> Temperature at 2m
#tsa --> Surface Temperature Accumulated
#tsod --> Deep Soil Temperature
#lsm --> Land Sea Mask
#z0 --> Surface roughness
#as --> Albedo
#rss --> Surface Solar Radiation
#rls --> Sruface Thermal Radiation
#rst --> Top Solar Radiation
#rlut --> Top Thermal Radiation
#tauu --> U-stress
#tauv --> V-stress
#evap --> Evaporation
#tso --> Soil Temperature
#tasmax -->Maximum daily 2m Temperature
#tasmin --> MInimum daily Temperature
#rsut --> Top Solar Radiation Upward
#ssru --> Surface Solar Radiation Upward
#stru Surfce Thermal Radiation Upward
#tso2 -->Soil Temperature Level 2
#tso3 --> Soil Tmperature Level 3
#tso4 --> Soil Temperature Level 4
#sic --> Sea Ice Cover
#sit --> Sea Ice Thickness
#vegf --> Forest Cover
#snm --> Snow Melt
#sndc --> Snow Depth Change
#dwmax --> Field Capacity
#prw --> Vert Integrated Specific Humudity
#glac -- Glacier Cover

#u
#v
#mastrfu --> Mass Stream Function
#zh --> SeaSurface Geopotential Heigth
#velopot --> Velocity Potential
#stream --> Stream function
#eddyhflux
#eddyqflux
#eddymflux
#bstps
#bstta
#bstzeta
#bstzh
#clh
#clm
#cll
#ps
declare -a var_PLA=( "as" "clt " "clh" "cll" "clm" "evap" "hfls" "hfss" "hus" "mastrfu" "mld" "mrro" "mrso" "prc" "prl" "prsn" "ps" "rls" "rss" "rst" "rlut" "sit" "snd" "ta" "tas" "tauu" "tso" "u" "v" "velopot" "zh" "zeta" )

# "as" "clt " "clh" "cll" "clm" "evap" "hfls" "hfss" "hus" "koppen" "mastrfu" "mld" "mrro" "mrso" "prc" "prl" "prsn" "ps" "rls" "rss" "rst" "rlut" "sit" "snd" "ta" "tas" "tauu" "tso" "u" "v" "velopot" "zh" "zeta" "bstps" "bstta" "bstzeta" "bstzh" "eddyhflux" "eddymflux" "eddyqflux"
. ./cdo_PLA_2.0.sh $name_sim $name_dir $year $step $start $day_start $day_stop "var_PLA[@]"


#VARIABLE LEGEND
#heata --> Heat Flux from Atmosphere
#ofluxa --> Heat Flux from the Ocean
#tsfluxa --> FLux to warm/cool ice/Snow
#smelta --> FLux from snow Melt
#imelta --> FLux used for ice melt
#cfluxa --> FLux to the Ocean
#fluxca --> Cond. heat Flux
#qmelta --> Res FLux to Ice
#xflxicea --> Flux Correction
#icec --> Sea Ice Cover
#iced --> Ice Thickness
#scflxa --> FLux from Snow
#cfluxra --> FLux from limiting ice to xmaxd
#cfluxna --> FLux due to negative ice
#ts --> Surface Temperature
#zsnow --> Snow Depth
#sst --> Sea Surface Temperature
#ls --> Land Sea Mask
#clicec2 --> Climatological Ice Cover
#cliced2 --> Climatological Ice Thickness
#icecc --> Ice cover computed prognostically
#cpmea --> Fresh Water fro LSG
#croffa --> Runoff for LSG
#stoia --> Snow COnverted to ice
declare -a var_ICE=( "icec" "iced" )
. ./cdo_ICE_2.0.sh $name_sim $name_dir $year $step $start "var_ICE[@]"

#VARIABLE LEGEND
#heata --> Heat Flux from Atmoshere
#ifluxa --> Heat Flux into Ice
#fssta --> Flux Correction
#dssta --> Vertical DIffusion
#qhda --> Horizontal DIffusion
#fldoa --> Flux from deep ocean
#icec --> Sea Ice Cover
#sst --> Sea Surface Temperature
#ls --> Land Sea Mask
#clsst --> Climatological SST
declare -a var_OCE=( "sst" )
. ./cdo_OCE_2.0.sh $name_sim $name_dir $year $step $start "var_OCE[@]"



#VARIABLE LEGEND
#lon->longitude
#lat->latitude
#lon_2 ?
#lat_2 ?
#wet->land sea-mask for scalar points
#t->Potential Temperature
#s->Salinity
#w->Vertical Velocity Component
#zeta->Surface Elevation
#sice-> Ice Thickness
#psi->Horizontal Barotropic Stream Function
#depp->Depth in Scalar-Points
#fluwat-> Net Fresh Water FLux (P-E)
#flukwat-> Fresh Water due to Newtonian Coupling
#flukhea->Heat Flux due to Newtonian Coupling
#convadd->Potential Energy DIssipation due to convection
#tbound-> boundary value of t
#fluxhea->heat fluxhea
#fldsst->sst differences lsg-plasim
#fldice->ice-difference lsg.plasim
#fldpme->pme-differences lsg-plasim
#fldtaux->taux-differences lsg-plasim
#fldtauy->tauy-differences lsg-plasim
#convad->convective adjustement events
#wetvec->land-sea mask for vector points
#utot->zonal velocity component
#vtot->meridional velocity component
#ub-> zonal component of barotropic velocity
#vb->meridional component of barotropic velocity
#deov->depth in vector points
#taux->zonal component of wind stress
#tauy->meridional components of wind stress

#declare -a var_LSG=( "icec" "iced" "clicec2" "cliced2" )
#. ./cdo_LSG.sh $name_sim $name_dir $year $step $start "var_ICE[@]"
