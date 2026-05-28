#!/usr/bin/bash

min=0.5000
max=1.7777

hodnota=1.25
#hodnota=2.0

# podminka: hodnota >= min A ZAROVEN hodnota <= max
if [ "$(echo "$hodnota >= $min && $hodnota <= $max" | bc -l)" -eq 1 ]; then
echo "hodnota je v intervalu od $min do $max"
else
echo "$hodnota je mimo interval"
fi
