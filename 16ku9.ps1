cls
Write-Host -ForegroundColor Yellow "vsechny videa v adtresari prevdeu na format pro TV Setup Box - 16:9 "

#$pole_include = @("*.txt", "*.doc")
#$pole_include = @("*.fli","*.FLC") # toto nejni case senzitive ! ,"*. "

$pole_include = @("*.fli","*.FLC","*.mp4","*.avi","*.mpg") # toto nejni case senzitive ! ,"*. " FLC jako flc atd.
#$pole_include = @("*.fci") test

$files_celkem = @()
$files_celkem += @(Get-ChildItem -Name)

$files = @()
$files += @(Get-ChildItem -Include $pole_include -Name) | Sort-Object

# kontrola existence video souboru
if ( $celkem_videi -eq 0 ){
Write-Warning "nanalezeny zadne video soubory" 
sleep 5
exit
}

# nastaveni hodnoty verbose u vystupu ffmpeg
$pole_lvl = @("quiet", "panic", "fatal", "error", "warning", "info", "verbose", "debug", "trace")
#                0        1        2        3        4          5        6         7        8
#$lvl = $pole_lvl[5] # (default=5)
$lvl = $pole_lvl[2] # (default=5)


# kontrOla jestli uz neexistuje prevod z minula
$files_2 = @()
for ( $aa = 0; $aa -le $files.Length -1; $aa++) {
$filename = $files[$aa]

if ( -not ($filename.Contains("_16ku9"))) {
$files_2 += $filename
# prepise do noveho pole, vsechny nalezene soubory v aktualnim adresari u ktery jeste neprobehla konverze 16:9
}
}

$celkem_videi = $files_2.Length
$celkem_souboru = $files_celkem.Length
echo "celkem videi v adresari $celkem_videi"
echo "celkem vsech souboru v adresari $celkem_souboru"
sleep 5

for ( $bb = 0; $bb -le $files_2.Length -1; $bb++) {

$soubor = $files_2[$bb]
Write-Host -ForegroundColor Cyan $soubor
sleep 2

$soubor_nazev = $soubor.Substring(0,$soubor.Length -4)
$soubor_pripona = $soubor.Substring($soubor.Length -4, 4)
$output = $soubor_nazev
$output += "_16ku9"
$output += $soubor_pripona

# ffmpeg -i %in%.mp4 -vf "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2" -c:a copy %nazev% --- JAKO VZOR
# & ffmpeg -loglevel $lvl -i $soubor -vf "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2" -c:a "copy" $output -y
& ffmpeg -loglevel $lvl -i $soubor -vf "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2" -c:a "copy" $output -n
}

Write-Host -ForegroundColor Yellow "vse hotovo"
sleep 20

