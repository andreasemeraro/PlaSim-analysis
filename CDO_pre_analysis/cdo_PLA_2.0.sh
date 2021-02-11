#!/bin/bash
name_sim=${1?Error: no name_sim given}
path=${2?Error: no path given}
years=${3?Error: no year given}
step=${4?Error: no step given}
start=${5?Error: no start given}
day_start=${6?Error: no day_start given}
day_stop=${7?Error: no day_stop given}
vars=("${!8}")
nome_file=$name_sim"_"
nome_file_1=$name_sim"_PLA."


#"tso" "hus" "mrso" "clt " "mrro" "prw" "prc" "tas" "as" "hfls" "hfss" "sit" "prsn" "rls" "rlut" "rss" "rst" "ta" "clt" "snd" "evap" "prl" "prc" "clw"
file_input_1=""
file_input_2=""
#path=longsim_100_ML_SI_WGA1_T21
nome_cartella=analisi

cd $path/output
mkdir -p $nome_cartella/grafici

count=1
for riga in `ls -1|grep "$nome_file_1" `

do
  if [ $count -le $years  ]; then
    if [[ "$riga" == *"$count"* ]]; then
	      file_input_1+=$riga" "
	  fi
  fi
  if [ $count -ge $day_start ] && [ $count -le $day_stop ]; then
    if [[ "$riga" == *"$count"* ]]; then
	      file_input_2+=$riga" "
	  fi
  fi
  let "count += 1"
done
if [[ "`ls analisi/ -1|grep "lsm.nc" `" ==  *"lsm.nc"* ]]; then
    echo "lsm.nc create precedently"
else
    cdo -select,name="lsm" $file_input_1 $nome_cartella/lsm.nc
fi

for var in ${vars[@]}
do
    file_output_1=$nome_file"all_"$var".nc"
    file_output_2=$nome_file"FM_"$years"Y_"$var".nc"
    file_output_3=$nome_file"YM_FM_"$years"Y_"$var".nc"
    file_output_4=$nome_file"YM_"$step"YM_"$years"Y_"$var".nc"
    file_output_5=$nome_file"YM_"$step"YM_ZM_"$years"Y_"$var".nc"
    file_output_6=$nome_file"YM_ZM_"$years"Y_"$var".nc"
    file_output_7=$nome_file"SM_"$step"YM_"$years"Y_"$var".nc"
    file_output_8=$nome_file"SM_"$step"YM_ZM_"$years"Y_"$var".nc"



    if [ "$var" = "bstps" ]; then

	    cdo -select,name=ta,sg,pl  $file_input_2 $nome_cartella/$name_sim"_all_"$var".nc"
	    cdo -setname,$var -del29feb -sealevelpressure -sp2gp $nome_cartella/$name_sim"_all_"$var".nc" $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_ANN_BP2-6_"$day_start"_"$day_stop"_"$var".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false -selseason,DJF $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_DJF_BP2-6_"$day_start"_"$day_stop"_"$var".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false -selseason,JJA $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_JJA_BP2-6_"$day_start"_"$day_stop"_"$var".nc"
      #cdo infov $nome_cartella/$name_sim"_ANN_BP2-6_"$day_start"_"$day_stop"_"$var".nc"


    elif [ "$var" = "bstta" ]; then

	    cdo -select,name=ta,sg,pl  $file_input_2 $nome_cartella/$name_sim"_all_"$var".nc"
      cdo -setname,$var -del29feb -selname,ta -ml2plx,85000,50000,30000,25000 -sp2gp $nome_cartella/$name_sim"_all_"$var".nc" $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_ANN_BP2-6_"$day_start"_"$day_stop"_"$var".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false -selseason,DJF $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_DJF_BP2-6_"$day_start"_"$day_stop"_"$var".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false -selseason,JJA $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_JJA_BP2-6_"$day_start"_"$day_stop"_"$var".nc"


    elif [ "$var" = "bstzeta" ]; then

      cdo -select,name=zeta,sg,pl $file_input_2 $nome_cartella/$name_sim"_all_"$var".nc"
      cdo -setname,$var -del29feb -selname,zeta -ml2plx,85000,50000,30000,25000 -sp2gp $nome_cartella/$name_sim"_all_"$var".nc" $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_ANN_BP2-6_"$day_start"_"$day_stop"_"$var".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false -selseason,DJF $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_DJF_BP2-6_"$day_start"_"$day_stop"_"$var".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false -selseason,JJA $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_JJA_BP2-6_"$day_start"_"$day_stop"_"$var".nc"



    elif [ "$var" = "bstzh" ]; then
      echo $file_input_2
      cdo -select,name=ts,sg,pl,ta,hus $file_input_2 $nome_cartella/$name_sim"_all_"$var"_1.nc"
      cdo -sp2gp $nome_cartella/$name_sim"_all_"$var"_1.nc" $nome_cartella/$name_sim"_all_"$var"_2.nc"
	    cdo -selname,zh -geopotheight $nome_cartella/$name_sim"_all_"$var"_2.nc" $nome_cartella/$name_sim"_all_"$var"_3.nc"

	    cdo -merge $nome_cartella/$name_sim"_all_"$var"_3.nc" $nome_cartella/$name_sim"_all_"$var"_2.nc" $nome_cartella/$name_sim"_all_"$var"_4.nc"
      cdo -setname,$var -del29feb -selname,zh -ml2plx,85000,50000,30000,25000 $nome_cartella/$name_sim"_all_"$var"_4.nc" $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_ANN_BP2-6_"$day_start"_"$day_stop"_"$var".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false -selseason,DJF $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_DJF_BP2-6_"$day_start"_"$day_stop"_"$var".nc"
	    cdo -timstd -bandpass,61,183 -detrend,equal=false -selseason,JJA $nome_cartella/$name_sim"_"$var"_"$day_start"_"$day_stop".nc" $nome_cartella/$name_sim"_JJA_BP2-6_"$day_start"_"$day_stop"_"$var".nc"



    elif  [ "$var" = "clh" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
    	cdo -select,name=cl $file_input_1 $nome_cartella/$name_sim"_"$var
	cdo -setname,clh -select,levidx=1,2,3,4 $nome_cartella/$name_sim"_"$var  $nome_cartella/$file_output_1
        echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
        cdo -fldmean -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
        cdo -timmean -selyear,$start/$years -yearmean -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
        cdo -yearmean -zonmean -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$start/$years -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8



    elif  [ "$var" = "clm" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
    	cdo -select,name=cl $file_input_1 $nome_cartella/$name_sim"_"$var
	cdo -setname,clm -select,levidx=5,6 $nome_cartella/$name_sim"_"$var  $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
        cdo -fldmean -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
        cdo -timmean -selyear,$start/$years -yearmean -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
        cdo -yearmean -zonmean -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$start/$years -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8



    elif  [ "$var" = "cll" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
    	cdo -select,name=cl $file_input_1 $nome_cartella/$name_sim"_"$var
	cdo -setname,cll -select,levidx=7,8,9,10 $nome_cartella/$name_sim"_"$var  $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
        cdo -fldmean -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
        cdo -timmean -selyear,$start/$years -yearmean -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
        cdo -yearmean -zonmean -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$start/$years -vertmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8


    elif [ "$var" = "eddyhflux" ]; then

	cdo -select,name=zeta,d,pl,ta,sg $file_input_2 $nome_cartella/$name_sim"_eddyheat.nc"

	cdo -selname,ta,v -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp -selname,ta,v,pl,sg -dv2uv $nome_cartella/$name_sim"_eddyheat.nc" $nome_cartella/$name_sim"_tav.nc"
	cdo -selname,ta -yearmean -monmean $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_TM_ta.nc"
	cdo -selname,v -yearmean -monmean $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_TM_v.nc"
	cdo -sub -selname,ta $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_TM_ta.nc" $nome_cartella/$name_sim"_eddy_ta.nc"
	cdo -sub -selname,v $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_TM_v.nc" $nome_cartella/$name_sim"_eddy_v.nc"
	cdo -setname,$var -mul $nome_cartella/$name_sim"_eddy_ta.nc" $nome_cartella/$name_sim"_eddy_v.nc" $nome_cartella/$name_sim"all_transient_"$var".nc"

	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"YM_"$step"YM_"$years"Y_transient_"$var".nc"$(tput sgr0)\n "
        cdo -timmean -selyear,$day_start/$day_stop -yearmean $nome_cartella/$name_sim"all_transient_"$var".nc" $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

  echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"YM_"$step"YM_ZM_"$years"Y_transient_"$var".nc" $(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_transient_"$var".nc" $nome_cartella/$nome_file"YM_ZM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

  echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"SM_"$step"YM_"$years"Y_transient_"$var".nc"$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$day_start/$day_stop $nome_cartella/$name_sim"all_transient_"$var".nc" $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

  echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"SM_"$step"YM_ZM_"$years"Y_transient_"$var".nc" $(tput sgr0)\n"
	    cdo -zonmean $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_transient_"$var".nc" $nome_cartella/$nome_file"SM_ZM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

	cdo -selname,ta -zonmean -yearmean -monmean $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_TM_ZM_ta.nc"
	cdo -selname,v -zonmean -yearmean -monmean $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_TM_ZM_v.nc"
  cdo -sub $nome_cartella/$name_sim"_TM_ta.nc" -enlarge,$nome_cartella/$name_sim"_TM_ta.nc" $nome_cartella/$name_sim"_TM_ZM_ta.nc" $nome_cartella/$name_sim"_stateddy_ta.nc"
  cdo -sub $nome_cartella/$name_sim"_TM_v.nc" -enlarge,$nome_cartella/$name_sim"_TM_v.nc" $nome_cartella/$name_sim"_TM_ZM_v.nc" $nome_cartella/$name_sim"_stateddy_v.nc"
  cdo -setname,$var -mul $nome_cartella/$name_sim"_stateddy_ta.nc" $nome_cartella/$name_sim"_stateddy_v.nc" $nome_cartella/$name_sim"_TM_ZM_statheat.nc"


    echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"YM_"$step"YM_"$years"Y_stationary_"$var".nc"$(tput sgr0)\n "
          cdo -timmean -selyear,$day_start/$day_stop -yearmean $nome_cartella/$name_sim"_TM_ZM_statheat.nc" $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"

    echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"YM_"$step"YM_ZM_"$years"Y_stationary_"$var".nc" $(tput sgr0)\n"
          cdo -zonmean $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_stationary_"$var".nc" $nome_cartella/$nome_file"YM_ZM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"


  cdo -selname,ta -yseasmean -monmean $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_SM_ta.nc"
  cdo -selname,ta -zonmean -yseasmean -monmean $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_SM_ZM_ta.nc"
  cdo -sub $nome_cartella/$name_sim"_SM_ta.nc" -enlarge,$nome_cartella/$name_sim"_SM_ta.nc" $nome_cartella/$name_sim"_SM_ZM_ta.nc" $nome_cartella/$name_sim"_SM_stateddy_ta.nc"

  cdo -selname,v -selseason,DJF,JJA -monmean $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_SM_v.nc"
  cdo -selname,v -zonmean -selseason,DJF,JJA -monmean $nome_cartella/$name_sim"_tav.nc" $nome_cartella/$name_sim"_SM_ZM_v.nc"
  cdo -sub $nome_cartella/$name_sim"_SM_v.nc" -enlarge,$nome_cartella/$name_sim"_SM_v.nc" $nome_cartella/$name_sim"_SM_ZM_v.nc" $nome_cartella/$name_sim"_SM_stateddy_v.nc"
	cdo -setname,$var -mul $nome_cartella/$name_sim"_SM_stateddy_v.nc" $nome_cartella/$name_sim"_SM_stateddy_ta.nc" $nome_cartella/$name_sim"_SM_ZM_statheat.nc"

  echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"SM_"$step"YM_"$years"Y_stationary_"$var".nc"$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$day_start/$day_stop $nome_cartella/$name_sim"_SM_ZM_statheat.nc" $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"

  echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"SM_"$step"YM_ZM_"$years"Y_stationary_"$var".nc" $(tput sgr0)\n"
	    cdo -zonmean $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_stationary_"$var".nc" $nome_cartella/$nome_file"SM_ZM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"


    elif [ "$var" = "eddymflux" ]; then
	    cdo -select,name=zeta,d,pl,sg  $file_input_2 $nome_cartella/$name_sim"_eddymomentum.nc"

      cdo -selname,u,v -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp -selname,u,v,pl,sg -dv2uv $nome_cartella/$name_sim"_eddymomentum.nc" $nome_cartella/$name_sim"_uv.nc"

      cdo -selname,u -yearmean -monmean $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_TM_u.nc"
    	cdo -selname,v -yearmean -monmean $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_TM_v.nc"
    	cdo -sub -selname,u $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_TM_u.nc" $nome_cartella/$name_sim"_eddy_u.nc"
    	cdo -sub -selname,v $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_TM_v.nc" $nome_cartella/$name_sim"_eddy_v.nc"
    	cdo -setname,$var -mul $nome_cartella/$name_sim"_eddy_u.nc" $nome_cartella/$name_sim"_eddy_v.nc" $nome_cartella/$name_sim"all_transient_"$var".nc"

    	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"YM_"$step"YM_"$years"Y_transient_"$var".nc"$(tput sgr0)\n "
            cdo -timmean -selyear,$day_start/$day_stop -yearmean $nome_cartella/$name_sim"all_transient_"$var".nc" $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

      echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"YM_"$step"YM_ZM_"$years"Y_transient_"$var".nc" $(tput sgr0)\n"
            cdo -zonmean $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_transient_"$var".nc" $nome_cartella/$nome_file"YM_ZM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

      echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"SM_"$step"YM_"$years"Y_transient_"$var".nc"$(tput sgr0)\n "
        	cdo -yseasmean -selyear,$day_start/$day_stop $nome_cartella/$name_sim"all_transient_"$var".nc" $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

      echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"SM_"$step"YM_ZM_"$years"Y_transient_"$var".nc" $(tput sgr0)\n"
    	    cdo -zonmean $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_transient_"$var".nc" $nome_cartella/$nome_file"SM_ZM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

          	cdo -selname,u -zonmean -yearmean -monmean $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_TM_ZM_u.nc"
          	cdo -selname,v -zonmean -yearmean -monmean $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_TM_ZM_v.nc"
            cdo -sub $nome_cartella/$name_sim"_TM_u.nc" -enlarge,$nome_cartella/$name_sim"_TM_u.nc" $nome_cartella/$name_sim"_TM_ZM_u.nc" $nome_cartella/$name_sim"_stateddy_u.nc"
            cdo -sub $nome_cartella/$name_sim"_TM_v.nc" -enlarge,$nome_cartella/$name_sim"_TM_v.nc" $nome_cartella/$name_sim"_TM_ZM_v.nc" $nome_cartella/$name_sim"_stateddy_v.nc"
            cdo -setname,$var -mul $nome_cartella/$name_sim"_stateddy_u.nc" $nome_cartella/$name_sim"_stateddy_v.nc" $nome_cartella/$name_sim"_TM_ZM_statmomentum.nc"


              echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"YM_"$step"YM_"$years"Y_stationary_"$var".nc"$(tput sgr0)\n "
                    cdo -timmean -selyear,$day_start/$day_stop -yearmean $nome_cartella/$name_sim"_TM_ZM_statmomentum.nc" $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"

              echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"YM_"$step"YM_ZM_"$years"Y_stationary_"$var".nc" $(tput sgr0)\n"
                    cdo -zonmean $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_stationary_"$var".nc" $nome_cartella/$nome_file"YM_ZM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"


            cdo -selname,u -yseasmean -monmean $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_SM_u.nc"
            cdo -selname,u -zonmean -yseasmean -monmean $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_SM_ZM_u.nc"
            cdo -sub $nome_cartella/$name_sim"_SM_u.nc" -enlarge,$nome_cartella/$name_sim"_SM_u.nc" $nome_cartella/$name_sim"_SM_ZM_u.nc" $nome_cartella/$name_sim"_SM_stateddy_u.nc"

            cdo -selname,v -selseason,DJF,JJA -monmean $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_SM_v.nc"
            cdo -selname,v -zonmean -selseason,DJF,JJA -monmean $nome_cartella/$name_sim"_uv.nc" $nome_cartella/$name_sim"_SM_ZM_v.nc"
            cdo -sub $nome_cartella/$name_sim"_SM_v.nc" -enlarge,$nome_cartella/$name_sim"_SM_v.nc" $nome_cartella/$name_sim"_SM_ZM_v.nc" $nome_cartella/$name_sim"_SM_stateddy_v.nc"
          	cdo -setname,$var -mul $nome_cartella/$name_sim"_SM_stateddy_v.nc" $nome_cartella/$name_sim"_SM_stateddy_u.nc" $nome_cartella/$name_sim"_SM_ZM_statmomentum.nc"

            echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"SM_"$step"YM_"$years"Y_stationary_"$var".nc"$(tput sgr0)\n "
              	cdo -yseasmean -selyear,$day_start/$day_stop $nome_cartella/$name_sim"_SM_ZM_statmomentum.nc" $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"

            echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"SM_"$step"YM_ZM_"$years"Y_stationary_"$var".nc" $(tput sgr0)\n"
          	    cdo -zonmean $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_stationary_"$var".nc" $nome_cartella/$nome_file"SM_ZM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"


    elif [ "$var" = "eddyqflux" ]; then
	    cdo -select,name=zeta,d,pl,hus,sg  $file_input_2 $nome_cartella/$name_sim"_eddyq.nc"

	#cdo -select,name=zeta,d,pl,hus,sg NSM2_PLA.0101.nc $nome_cartella/$name_sim"_eddyq.nc"
	cdo -selname,hus,v -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp -selname,hus,v,pl,sg -dv2uv $nome_cartella/$name_sim"_eddyq.nc" $nome_cartella/$name_sim"_qv.nc"

  cdo -selname,hus -yearmean -monmean $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_TM_q.nc"
  cdo -selname,v -yearmean -monmean $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_TM_v.nc"
  cdo -sub -selname,hus $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_TM_q.nc" $nome_cartella/$name_sim"_eddy_q.nc"
  cdo -sub -selname,v $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_TM_v.nc" $nome_cartella/$name_sim"_eddy_v.nc"
  cdo -setname,$var -mul $nome_cartella/$name_sim"_eddy_q.nc" $nome_cartella/$name_sim"_eddy_v.nc" $nome_cartella/$name_sim"all_transient_"$var".nc"

  echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"YM_"$step"YM_"$years"Y_transient_"$var".nc"$(tput sgr0)\n "
        cdo -timmean -selyear,$day_start/$day_stop -yearmean $nome_cartella/$name_sim"all_transient_"$var".nc" $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

  echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"YM_"$step"YM_ZM_"$years"Y_transient_"$var".nc" $(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_transient_"$var".nc" $nome_cartella/$nome_file"YM_ZM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

  echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"SM_"$step"YM_"$years"Y_transient_"$var".nc"$(tput sgr0)\n "
      cdo -yseasmean -selyear,$day_start/$day_stop $nome_cartella/$name_sim"all_transient_"$var".nc" $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

  echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"SM_"$step"YM_ZM_"$years"Y_transient_"$var".nc" $(tput sgr0)\n"
      cdo -zonmean $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_transient_"$var".nc" $nome_cartella/$nome_file"SM_ZM_"$day_start"-"$day_stop"YM_transient_"$var".nc"

        cdo -selname,hus -zonmean -yearmean -monmean $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_TM_ZM_q.nc"
        cdo -selname,v -zonmean -yearmean -monmean $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_TM_ZM_v.nc"
        cdo -sub $nome_cartella/$name_sim"_TM_q.nc" -enlarge,$nome_cartella/$name_sim"_TM_q.nc" $nome_cartella/$name_sim"_TM_ZM_q.nc" $nome_cartella/$name_sim"_stateddy_q.nc"
        cdo -sub $nome_cartella/$name_sim"_TM_v.nc" -enlarge,$nome_cartella/$name_sim"_TM_v.nc" $nome_cartella/$name_sim"_TM_ZM_v.nc" $nome_cartella/$name_sim"_stateddy_v.nc"
        cdo -setname,$var -mul $nome_cartella/$name_sim"_stateddy_q.nc" $nome_cartella/$name_sim"_stateddy_v.nc" $nome_cartella/$name_sim"_TM_ZM_statmoisture.nc"


          echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"YM_"$step"YM_"$years"Y_stationary_"$var".nc"$(tput sgr0)\n "
                cdo -timmean -selyear,$day_start/$day_stop -yearmean $nome_cartella/$name_sim"_TM_ZM_statmoisture.nc" $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"

          echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"YM_"$step"YM_ZM_"$years"Y_stationary_"$var".nc" $(tput sgr0)\n"
                cdo -zonmean $nome_cartella/$nome_file"YM_"$day_start"-"$day_stop"YM_stationary_"$var".nc" $nome_cartella/$nome_file"YM_ZM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"


        cdo -selname,hus -yseasmean -monmean $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_SM_q.nc"
        cdo -selname,hus -zonmean -yseasmean -monmean $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_SM_ZM_q.nc"
        cdo -sub $nome_cartella/$name_sim"_SM_q.nc" -enlarge,$nome_cartella/$name_sim"_SM_q.nc" $nome_cartella/$name_sim"_SM_ZM_q.nc" $nome_cartella/$name_sim"_SM_stateddy_q.nc"

        cdo -selname,v -selseason,DJF,JJA -monmean $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_SM_v.nc"
        cdo -selname,v -zonmean -selseason,DJF,JJA -monmean $nome_cartella/$name_sim"_qv.nc" $nome_cartella/$name_sim"_SM_ZM_v.nc"
        cdo -sub $nome_cartella/$name_sim"_SM_v.nc" -enlarge,$nome_cartella/$name_sim"_SM_v.nc" $nome_cartella/$name_sim"_SM_ZM_v.nc" $nome_cartella/$name_sim"_SM_stateddy_v.nc"

        cdo -setname,$var -mul $nome_cartella/$name_sim"_SM_stateddy_v.nc" $nome_cartella/$name_sim"_SM_stateddy_q.nc" $nome_cartella/$name_sim"_SM_ZM_statmoisture.nc"

        echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$nome_file"SM_"$step"YM_"$years"Y_stationary_"$var".nc"$(tput sgr0)\n "
            cdo -yseasmean -selyear,$day_start/$day_stop $nome_cartella/$name_sim"_SM_ZM_statmoisture.nc" $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"

        echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$nome_file"SM_"$step"YM_ZM_"$years"Y_stationary_"$var".nc" $(tput sgr0)\n"
            cdo -zonmean $nome_cartella/$nome_file"SM_"$day_start"-"$day_stop"YM_stationary_"$var".nc" $nome_cartella/$nome_file"SM_ZM_"$day_start"-"$day_stop"YM_stationary_"$var".nc"


    elif [ "$var" = "hus" ] || [ "$var" = "zeta" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
        cdo  -select,name=$var,pl $file_input_1 $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
        cdo -selname,$var -fldmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n $(tput setaf 1)Faccio la media annuale e degli ultimi $step anni del $var e salvo su: $(tput setab 7)$file_output_4$(tput sgr0)\n"
        #cdo -selname,$var -timmean -selyear,$start/$years -yearmean -ml2plx,85000,50000,30000,25000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
				cdo -selname,$var -timmean -selyear,$start/$years -yearmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni del $var e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -selname,$var -timmean -selyear,$start/$years -yearmean -zonmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni del della $var e salvo su: $(tput setab 7)$file_output_7$(tput sgr0)\n"
        cdo -selname,$var -yseasmean -selyear,$start/$years -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni del della $var e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
        cdo -selname,$var -yseasmean -selyear,$start/$years -zonmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_8


    elif [ "$var" = "koppen" ]; then
        cdo -select,name=prl,prc,ts $file_input_2 $nome_cartella/$nome_file"all_"$var"_1.nc"
        cdo -ydaymean -del29feb -selyear,$day_start/$day_stop $nome_cartella/$nome_file"all_"$var"_1.nc" $nome_cartella/$nome_file"all_"$var"_2.nc"
        cdo -expr,'prt=prl+prc;ts=ts-273.15;' $nome_cartella/$nome_file"all_"$var"_2.nc" $nome_cartella/$nome_file"all_"$var"_3.nc"
        cdo -monmean -selname,ts $nome_cartella/$nome_file"all_"$var"_3.nc" $nome_cartella/$nome_file$var"_ts.nc"
        cdo -monsum -selname,prt $nome_cartella/$nome_file"all_"$var"_3.nc" $nome_cartella/$nome_file$var"_prt.nc"

    elif [ "$var" = "mastrfu" ]; then
	cdo -select,name=zeta,d,pl $file_input_1 $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)$Calcolo la Stream Function e faccio la media zonale e stagionale degli ultimi $step e salvo su $(tput setab 7)$file_output_5$(tput sgr0)\n"
	cdo -mastrfu -yseasmean -selyear,$start/$years -zonmean -selname,v -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp -selname,v,pl -dv2uv $nome_cartella/$file_output_1 $nome_cartella/$file_output_8
	echo -e "\n $(tput setaf 1)$Calcolo la Stream Function e faccio la media zonale e stagionale degli ultimi $step e salvo su $(tput setab 7)$file_output_8$(tput sgr0)\n"
        cdo -mastrfu -timmean -selyear,$start/$years -yearmean -zonmean -selname,v -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp -selname,v,pl -dv2uv $nome_cartella/$file_output_1 $nome_cartella/$file_output_5



    elif [ "$var" = "mrro" ] && [ "$var" = "mld" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
        cdo  -select,name=$var $file_input_1 $nome_cartella/$file_output_1
	cdo -ifnotthen  $nome_cartella/lsm.nc $nome_cartella/$file_output_1 $nome_cartella/$var".nc"
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
	cdo -fldmean $nome_cartella/$var".nc" $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
        cdo -timmean -selyear,$start/$years -yearmean $nome_cartella/$var".nc" $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
        cdo -yearmean -zonmean $nome_cartella/$var".nc" $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$start/$years $nome_cartella/$var".nc" $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8



    elif [ "$var" = "mrso" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
        cdo  -select,name=$var $file_input_1 $nome_cartella/$file_output_1
        cdo -ifthen  $nome_cartella/lsm.nc $nome_cartella/$file_output_1 $nome_cartella/$var".nc"
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
        cdo -fldmean $nome_cartella/$var".nc" $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
        cdo -timmean -selyear,$start/$years -yearmean $nome_cartella/$var".nc" $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
        cdo -yearmean -zonmean $nome_cartella/$var".nc" $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$start/$years $nome_cartella/$var".nc" $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8




    elif [ "$var" = "pl" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
    	cdo  -select,name=$var $file_input_1 $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
        cdo -fldmean -exp -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
        cdo -timmean -selyear,$start/$years -yearmean -exp -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
        cdo -yearmean -zonmean -exp -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$start/$years -exp -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8



    elif [ "$var" = "ps" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
    	cdo -select,name=pl,sg,ta $file_input_1 $nome_cartella/$file_$var
	cdo -setname,ps -sealevelpressure -sp2gp $nome_cartella/$file_$var $nome_cartella/$file_output_1
       	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
        cdo -fldmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
        cdo -timmean -selyear,$start/$years -yearmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
        cdo -yearmean -zonmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$start/$years $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8



    elif [ "$var" = "stream" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
        cdo -select,name=zeta,d,pl $file_input_1 $nome_cartella/$file_$var
        cdo -sp2gp -dv2ps $nome_cartella/$file_$var"_1" $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
	cdo -fldmean -selname,stream -ml2plx,85000,50000,30000,25000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n $(tput setaf 1)Faccio la media annuale e degli ultimi $step anni della $var e salvo su: $(tput setab 7)$file_output_4$(tput sgr0)\n"
        cdo -timmean -selyear,$start/$years -yearmean -selname,stream -ml2plx,85000,50000,30000,25000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, e degli ultimi $step anni del del $var e salvo su: $(tput setab 7)$file_output_7$(tput sgr0)\n"
        cdo -yseasmean -selyear,$start/$years -selname,stream -ml2plx,85000,50000,30000,25000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni del del $var e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
        cdo -yseasmean -selyear,$start/$years -zonmean -selname,stream -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_8




    elif [ "$var" = "tas" ] || [ "$var" = "ts" ];  then

        echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
	cdo  -select,name=$var $file_input_1 $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
    	cdo -setattribute,$var@units="degC" -addc,-273.15 -fldmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
	cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
    	cdo -timmean -selyear,$start/$years -setattribute,$var@units="degC" -addc,-273.15 -yearmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
	cdo -yearmean -zonmean -setattribute,$var@units="degC" -addc,-273.15 $nome_cartella/$file_output_1 $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -setattribute,$var@units="degC" -addc,-273.15 -yseasmean -selyear,$start/$years $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8




    elif [ "$var" = "tso" ] || [ "$var" = "tsod" ] || [ "$var" = "tso2" ] || [ "$var" = "tso3" ] || [ "$var" = "tso4" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
        cdo  -select,name=$var $file_input_1 $nome_cartella/$file_output_1
	cdo -ifthen  $nome_cartella/lsm.nc $nome_cartella/$file_output_1 $nome_cartella/$var".nc"
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
        cdo -setattribute,$var@units="degC" -addc,-273.15 -fldmean $nome_cartella/$var".nc" $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
        cdo -timmean -selyear,$start/$years -setattribute,$var@units="degC" -addc,-273.15 -yearmean $nome_cartella/$var".nc" $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
        cdo -yearmean -zonmean -setattribute,$var@units="degC" -addc,-273.15 $nome_cartella/$var".nc" $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -setattribute,$var@units="degC" -addc,-273.15 -yseasmean -selyear,$start/$years $nome_cartella/$var".nc" $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8



    elif [ "$var" = "ta" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
	cdo  -select,name=$var,pl,sg $file_input_1 $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
	cdo -setattribute,$var@units="degC" -addc,-273.15 -selname,$var -fldmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n $(tput setaf 1)Faccio la media annuale e degli ultimi $step anni della $vara e salvo su: $(tput setab 7)$file_output_4$(tput sgr0)\n"
        cdo -setattribute,$var@units="degC" -addc,-273.15 -selname,$var -timmean -selyear,$start/$years -yearmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni della $var e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -setattribute,$var@units="degC" -addc,-273.15 -selname,$var -timmean -selyear,$start/$years -yearmean -zonmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni del della $var e salvo su: $(tput setab 7)$file_output_7$(tput sgr0)\n"
        cdo -setattribute,$var@units="degC" -addc,-273.15 -selname,$var -yseasmean -selyear,$start/$years -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni del della $var e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
        cdo -setattribute,$var@units="degC" -addc,-273.15 -selname,$var -yseasmean -selyear,$start/$years -zonmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp $nome_cartella/$file_output_1 $nome_cartella/$file_output_8



    elif [ "$var" = "u" ] || [ "$var" = "v" ]; then

        cdo -select,name=zeta,d,pl $file_input_1 $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
	cdo -selname,$var -fldmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp -selname,$var,pl -dv2uv $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n $(tput setaf 1)Faccio la media annuale e degli ultimi $step anni della $var e salvo su: $(tput setab 7)$file_output_4$(tput sgr0)\n"
        cdo -selname,$var -timmean -selyear,$start/$years -yearmean -ml2plx,85000,50000,30000,25000 -sp2gp -selname,$var,pl -dv2uv $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni del $var e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -selname,$var -timmean -selyear,$start/$years -yearmean -zonmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp -selname,$var,pl -dv2uv $nome_cartella/$file_output_1 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, e degli ultimi $step anni del del $var e salvo su: $(tput setab 7)$file_output_7$(tput sgr0)\n"
        cdo -yseasmean -selyear,$start/$years -ml2plx,85000,50000,30000,25000 -sp2gp -selname,$var,pl -dv2uv $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni del del $var e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -yseasmean -selyear,$start/$years -zonmean -ml2plx,100000,85000,70000,50000,40000,30000,25000,20000,15000,10000,7000,5000,3000 -sp2gp -selname,$var,pl -dv2uv $nome_cartella/$file_output_1 $nome_cartella/$file_output_8




    elif [ "$var" = "velopot" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
        cdo -select,name=zeta,d,pl $file_input_1 $nome_cartella/$file_$var
        cdo -sp2gp -dv2ps $nome_cartella/$file_$var"_1" $nome_cartella/$file_output_1
       	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
	cdo -fldmean -selname,velopot -ml2plx,85000,50000,30000,25000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n $(tput setaf 1)Faccio la media annuale e degli ultimi $step anni della $var e salvo su: $(tput setab 7)$file_output_4$(tput sgr0)\n"
        cdo -timmean -selyear,$start/$years -yearmean -selname,velopot -ml2plx,85000,50000,30000,25000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, e degli ultimi $step anni del del $var e salvo su: $(tput setab 7)$file_output_7$(tput sgr0)\n"
	cdo -yseasmean -selyear,$start/$years -selname,velopot -ml2plx,85000,50000,30000,25000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_7




    elif  [ "$var" = "zh" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
        cdo -select,name=ta,ts,sg,pl,hus $file_input_1 $nome_cartella/$name_sim"_"$var"_1.nc"
        cdo -geopotheight -sp2gp $nome_cartella/$name_sim"_"$var"_1.nc" $nome_cartella/$name_sim"_"$var"_2.nc"
	cdo merge -sp2gp $nome_cartella/$name_sim"_"$var"_1.nc" $nome_cartella/$name_sim"_"$var"_2.nc" $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
	cdo -fldmean -selname,zh -ml2plx,85000,50000,30000,25000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n $(tput setaf 1)Faccio la media annuale e degli ultimi $step anni della $var e salvo su: $(tput setab 7)$file_output_4$(tput sgr0)\n"
        cdo -timmean -selyear,$start/$years -yearmean -selname,zh -ml2plx,85000,50000,30000,25000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, e degli ultimi $step anni del $var e salvo su: $(tput setab 7)$file_output_7$(tput sgr0)\n"
	cdo -yseasmean -selyear,$start/$years -selname,zh -ml2plx,85000,50000,30000,25000 $nome_cartella/$file_output_1 $nome_cartella/$file_output_7

    else

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
    	cdo  -select,name=$var $file_input_1 $nome_cartella/$file_output_1
	echo -e "\n $(tput setaf 1)Faccio la media del grigliato salvo su: $(tput setab 7)$file_output_2$(tput sgr0)\n"
        cdo -fldmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_2
	echo -e "\n$(tput setaf 1)Faccio media del grigliato e annuale e salvo su: $(tput setab 7)$file_output_3 $(tput sgr0)\n"
        cdo -yearmean $nome_cartella/$file_output_2 $nome_cartella/$file_output_3
	echo -e "\n$(tput setaf 1) Faccio la media annuale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_4$(tput sgr0)\n "
        cdo -timmean -selyear,$start/$years -yearmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_4
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_5$(tput sgr0)\n"
        cdo -zonmean $nome_cartella/$file_output_4 $nome_cartella/$file_output_5
	echo -e "\n $(tput setaf 1)Faccio la media annuale, zonale  salvo su: $(tput setab 7)$file_output_6$(tput sgr0)\n"
        cdo -yearmean -zonmean $nome_cartella/$file_output_1 $nome_cartella/$file_output_6
	echo -e "\n$(tput setaf 1) Faccio la media stagionale e degli ultimi $step anni, nome file: $(tput setab 7)$file_output_7$(tput sgr0)\n "
    	cdo -yseasmean -selyear,$start/$years $nome_cartella/$file_output_1 $nome_cartella/$file_output_7
	echo -e "\n $(tput setaf 1)Faccio la media stagionale, zonale e degli ultimi $step anni e salvo su: $(tput setab 7)$file_output_8$(tput sgr0)\n"
	cdo -zonmean $nome_cartella/$file_output_7 $nome_cartella/$file_output_8


    fi
done

cd ../../CDO_pre_analysis
