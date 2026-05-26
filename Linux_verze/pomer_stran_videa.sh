#!/usr/bin/bash

# linuxova "Popelka", prebira vsechny videa v adresari a u tech co jsou
# natoceny kamerou na mobilu (tzn.na vysku) prida cerny svisly okraj
# je potreba instalovana utilita "mediainfo" a kalkulacka "bc"

# for file in *.*; do pomer_stran_videa.sh $file; done

if [ -z "$1" ]; then
h=${0##*/}
echo $h" video.mp4"
exit 0
fi

in=$1
echo $in

vyska=$(mediainfo $in | grep "Height" | awk -F' ' '{print $3}')
sirka=$(mediainfo $in | grep "Width" | awk -F' ' '{print $3}')
#echo $vyska
#echo $sirka

# paklize je vyska videa treba  1280 bodu tak to vypise jako 1 280, takze se pak musi spojit dva kousy zase dohromady :(
# uplne zbytecna prace
d_vyska=${#vyska}
#echo $d_vyska

if [ $d_vyska -eq 1 ]; then
vyska_2=$(mediainfo $1 | grep "Height" | awk -F' ' '{print $4}')
#echo $vyska_2
vyska=$vyska$vyska_2
fi

d_sirka=${#sirka}
#echo $d_sirka
if [ $d_sirka -eq 1 ]; then
sirka_2=$(mediainfo $1 | grep "Width" | awk -F' ' '{print $4}')
#echo $sirka_2
sirka=$sirka$sirka_2
fi

echo "sirka videa = "$sirka
echo "vyska videa = "$vyska

pomer_stran=$(echo "$vyska / $sirka" | bc -l)
#pomer_stran=$(echo "$sirka / $vyska" | bc -l)
echo "pomer stran videa = "$pomer_stran

# vysledek 1.000000 je pro ctvercove video napr. 1000x1000 pixelu
# cim je video vic na vysku tak je pomer vice vetsi nezli 1.0
# pro video z Facebooku ktere je vyrazne na vysku (1280x720) bude pomer 1.7777777777 apod.


# vyhodnoceni vysledku ( tady opet poradila AI )
if awk "BEGIN {exit !($pomer_stran == 1.0)}"; then
    echo "video je ctvercove = 1.0"

elif awk "BEGIN {exit !($pomer_stran >= 1.0 && $pomer_stran <= 2.0)}"; then
    echo "video je na vysku >=1.0 az <=2.0"
    echo "k tomuto videu budou po stanach svisle cerne okraje"

    file=${in:0:${#in}-4}
    #echo $file
    file+="_okraje."
    #pripona=${in:${#in)-3}:${#in}}
    pripona=${in:${#in}-3:${#in}} # u video souboru je vzdy pripona na 3 znaky, jinou neznam
    #echo $pripona
    file+=$pripona
    #echo $file
    #ffmpeg -i $in -vf "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2" -c:a copy $file -y
    ffmpeg -loglevel 5 -i $in -vf "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2" -c:a copy $file -n
    echo "hotovo"
    
elif awk "BEGIN {exit !($pomer_stran >= 0.0 && $pomer_stran <= 1.0)}"; then
    echo "video je na sirku >=0.0 az <=1.0"
    
else
    echo "Hodnota nespadá do žádného rozsahu"
fi
