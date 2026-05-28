#!/usr/bin/bash

# Testovaná proměnná
hodnota=1.25

# Definice rozsahů (příklady)
if awk "BEGIN {exit !($hodnota >= 0.0 && $hodnota < 0.5)}"; then
    echo "Kategorie A: Hodnota je mezi 0.0 a 0.5"
    # Zde budou příkazy pro první rozsah

elif awk "BEGIN {exit !($hodnota >= 0.5 && $hodnota <= 1.7777)}"; then
    echo "Kategorie B: Hodnota je mezi 0.5 a 1.7777 (včetně)"
    # Zde budou příkazy pro druhý rozsah

elif awk "BEGIN {exit !($hodnota > 1.7777 && $hodnota <= 3.0)}"; then
    echo "Kategorie C: Hodnota je mezi 1.7777 a 3.0"
    # Zde budou příkazy pro třetí rozsah

else
    echo "Kategorie D: Hodnota nespadá do žádného rozsahu (je moc malá nebo moc velká)"
    # Zde bude akce, pokud číslo nikam nesedí
fi

