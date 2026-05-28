#!/usr/bin/bash

# hodnota=0.3
# hodnota=1.25
# hodnota=2.0

hodnota=$1

if [ "$(echo "$hodnota >= 0.0 && $hodnota < 0.5" | bc -l)" -eq 1 ]; then
echo "hodnota je v intervalu od >=0.0 && <0.5"

elif [ "$(echo "$hodnota >= 0.5 && $hodnota <= 1.7" | bc -l)" -eq 1 ]; then
echo "hodnota je v intervalu od >=0.5 && <=1.7"

elif [ "$(echo "$hodnota > 1.7 && $hodnota <= 2.0" | bc -l)" -eq 1 ]; then
echo "hodnota je v intervalu od >=1.7 && <=2.0"

else
echo "$hodnota je mimo interval"
fi
