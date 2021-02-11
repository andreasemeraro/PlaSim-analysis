#!/bin/bash
name_sim=${1?Error: no name_sim given}
path=${2?Error: no path given}
years=${3?Error: no year given}
step=${4?Error: no step given}
start=${5?Error: no start given}
vars=("${!6}")
nome_file=$name_sim"_"
nome_file_1=$name_sim"_ICE."
file_input_1=""
file_input_2=""
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
  let "count += 1"
done
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

    if [ "$var" = "sst" ]; then

	echo -e "$(tput setaf 1)Seleziono la variabile $var da tutti i file PLA e li salvo sul file: $(tput setab 7)$file_output_1 $(tput sgr0)\n"
        cdo  -select,name=$var $file_input_1 $nome_cartella/$file_output_1
	cdo -ifnotthen  $nome_cartella/lsm.nc $nome_cartella/$file_output_1 $nome_cartella/$var".nc"
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

    elif [ "$var" = "ofluxa" ] || [ "$var" = "cfluxa" ] || [ "$var" = "icec" ] || [ "$var" = "iced" ] || [ "$var" = "cpmea" ] ||  [ "$var" = "croffa" ] || [ "$var" = "cpmea" ]; then
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
