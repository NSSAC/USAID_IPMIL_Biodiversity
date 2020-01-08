#!/bin/bash
# inline sed modifications: -i.bak
DESC=$(
cat << EOF
Standardizing the field reports obtained from Nepal.
HowTo: Call this file without arguments to know your options.
This version might become outdated with the next set of data.
xlsx2csv can be installed as follows
  pip install xlsx2csv
https://github.com/dilshod/xlsx2csv
EOF
)

dataFile='$ROOT_REPO/data/field_report_2019-06-11.xlsx'

function processSheet(){ # IGNORE
sheetName=$1
csvfile=$2.csv
xlsx2csv -d "|" -n $sheetName $dataFile $csvfile
standardize $csvfile
}

function standardize(){ # IGNORE
# standardize header
#sed -i.bak '
sed -e '
1s/|Species|/|species|/
1s/|Site|/|site|/
1s/|Latitude|/|latitude|/
1s/|Longitude|/|longitude|/
1s/|X_coordi|/|longitude|/
1s/|Y_coordi|/|latitude|/
1s/|Elevation|/|elevation|/
1s/|Aspect|/|aspect|/
1s/|Slope|/|slope|/
1s/|Associate sps|/|associated_species|/
1s/|Associated species|/|associated_species|/
1s/|Associated sps|/|associated_species|/
1s/|Landuse|/|landuse|/
1s/|Land use|/|landuse|/
1s/|Magnitude|/|magnitude|/
1s/|Management/|management/
1s/|Location|/|location|/
1s/|Presence_absence|/|presence|/
' $1 > .temp_standardize

# add presence column
awk -F"|" -v OFS="|" ' 
NR==1{for(i=1;i<=NF;i++) if ($i=="magnitude") mag=i;  
$(NF+1)="presence"; print; next}
{if ($mag=="Absent" || $mag=="") $(NF+1)=0; else $(NF+1)=1; print} ' .temp_standardize > $1
}

function convert_to_csv(){
processSheet Lentena lantana
processSheet Chromoleana chromoleana
processSheet Mikeniea mikeniea
processSheet Eichorniea eichornia
processSheet Ageratina ageratina
processSheet Parthenium parthenium
processSheet Ipomea ipomea
}


if [[ $# == 0 ]]; then
   echo "$DESC"
   echo "Here are the options:"
   grep "^function" $BASH_SOURCE | sed -e 's/function/  /' -e 's/[(){]//g' -e '/IGNORE/d'
else 
   eval $1 $2
fi

