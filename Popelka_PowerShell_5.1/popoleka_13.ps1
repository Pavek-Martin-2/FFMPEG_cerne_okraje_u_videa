cls

# Popleka - PS 5.1
Set-PSDebug -Strict

Remove-Variable file, nalezeno_1, nalezeno_2, sirka_1, vyska_1, sirka_2, vyska_2 -ErrorAction SilentlyContinue

$cmd_madiainfo = "mediainfo.exe"
# soubor mediainfo.exe nakopirovat nekam do cesty PATH !

#$cmd_madiainfo = "mediainfo.exexxxxxx" # testovaci radek

if (Get-Command $cmd_madiainfo -ErrorAction SilentlyContinue) {
#& $cmd_madiainfo
$quiet = & $cmd_madiainfo # $quiet je pro poytlaceni vystupu na monitor (jinak bude vypisovat help)
# takze jakysi presmerovani vystupu do promenny
#$quiet.GetType() # pole

}else{
write-host -ForegroundColor Red "prikaz '$cmd_madiainfo' nenalezen"
echo "konec"
sleep 10
exit 1
}

# nastaveni hodnoty verbose u vystupu ffmpeg
$pole_lvl = @("quiet", "panic", "fatal", "error", "warning", "info", "verbose", "debug", "trace")
#                0        1        2        3        4          5        6         7        8

# tady psat
$pole_pripony = @("*.mpg", "*.mov", "*.avi", "*.mp4") # tady pridavat dalsi

$files = @()
$files += @( Get-ChildItem -Include $pole_pripony  -Name )

$d_files = $files.Length
#echo $d_files

# zadne video soubory v aktualnim adresari ?
if ( $d_files -eq 0 ) {
Write-Warning "nenalezeny zadene video soubory"
echo "konec programu"
sleep 5
Exit
}


$max = $d_files
for ( $cc = 0; $cc -le $d_files-1; $cc++ ) {                  
$video_file = $files[$cc]
$d_video_file = $video_file.Length
Write-Host -ForegroundColor Cyan $video_file

$cmd_output = @()
$cmd_output += & $cmd_madiainfo "-f" $video_file # parametr "-f" = fuel
$d_cmd_output = $cmd_output.Length
#echo $d_cmd_output


# hledani polozek ve vystupu mediainfo
$najdi_1 = "Width"

for ( $aa = 0; $aa -le $d_cmd_output -1; $aa++ ){
$radek_1 = [string] $cmd_output[$aa]
#echo $radek_1

$nalezeno_1 = $radek_1.IndexOf($najdi_1)
#echo $nalezeno_1

if ( $nalezeno_1 -ne -1 ){
# paklize nenajde tak je -1
$radek_nalezeno_1 = $aa
break
}
}

$najdi_2 = "Height"

for ( $bb = 0; $bb -le $d_cmd_output -1; $bb++ ){
$radek_2 = [string] $cmd_output[$bb]
#echo $radek

$nalezeno_2 = $radek_2.IndexOf($najdi_2)
#echo $nalezeno_1

if ( $nalezeno_2 -ne -1 ){
$radek_nalezeno_2 = $bb
break
}
}

if (( $nalezeno_1 -eq -1 ) -or ( $nalezeno_2 -eq -1 )) {
Write-Warning "chyba nic nenalezeno"
echo "konec"
sleep 5
exit 1
}

$sirka_1 = $cmd_output[$radek_nalezeno_1]
$vyska_1 = $cmd_output[$radek_nalezeno_2]

#echo $sirka_1
#echo $vyska_1

# vyhledavani v radku samotnem
$dvojtecka_sirka_1 = $sirka_1.IndexOf(":")
#echo $dvojtecka_sirka_1

$d_sirka_1 = $sirka_1.Length
#echo $d_sirka_1

$sirka_2 = $sirka_1.Substring($dvojtecka_sirka_1 + 2, ( $d_sirka_1 - ( $dvojtecka_sirka_1 + 2 )) )
echo "sirka videa - $sirka_2"

# vyhledavani v dalsim samotnem radku
$dvojtecka_vyska_1 = $vyska_1.IndexOf(":")
#echo $dvojtecka_vyska_1

$d_vyska_1 = $vyska_1.Length
#echo $d_vyska_1

$vyska_2 = $vyska_1.Substring($dvojtecka_vyska_1 + 2, ( $d_vyska_1 - ( $dvojtecka_vyska_1 + 2 )) )
echo "vyska videa -  $vyska_2"

# pomer sran y videa
[int32] $sirka_3 = $sirka_2
[int32] $vyska_3 = $vyska_2

$pomer_stran = (( $vyska_3 / $sirka_3 ))
echo "pomer stran videa = $pomer_stran"

# vyhodnoceni vysledku
if ( $pomer_stran -eq 1.0 ){
Write-Host -ForegroundColor Yellow "video je ctvercove == 1.0"

}elseif (( $pomer_stran -ge 1.0 ) -and ( $pomer_stran -le 2.0 )) {
Write-Host -ForegroundColor Yellow "video je na vysku >=1.0 az <=2.0"
Write-Host -ForegroundColor Red "k tomuto videu budou po stanach svisle cerne okraje"

# subtituce nazvu a pripony upravovenaho videa , vzdy bude brana pismonava pripona souboru
$file_name = $video_file.Substring(0,$d_video_file -4 )
#echo $file_name"<<"

$file_pripona = $video_file.Substring($d_video_file -3, 3) # vzy 3 znaky pripona
#echo $file_pripona"<"

$nazev_output = $file_name
$nazev_output += "_okraje."
$nazev_output += $file_pripona
#echo $nazev_output

# samotny uprava videa, okrajema
$lvl = $pole_lvl[2]
# & ffmpeg -loglevel $lvl -i $video_file -vf "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2" -c:a copy $nazev_output -y
& ffmpeg -loglevel $lvl -i $video_file -vf "pad=ih*16/9:ih:(ow-iw)/2:(oh-ih)/2" -c:a copy $nazev_output -n


# 
}elseif (( $pomer_stran -ge 0.0 ) -and ( $pomer_stran -le 1.0 )) {
Write-Host -ForegroundColor Yellow "video je na sirku >=0.0 az <=1.0"
    
}else{
Write-Host -ForegroundColor Yellow "Hodnota nespadá do žádného rozsahu"
}

echo ""
}

echo "hotovo"
sleep 20

