#cls

# popleka
Set-PSDebug -Strict

Remove-Variable file, nalezeno_1, nalezeno_2, sirka_1, vyska_1, sirka_2, vyska_2 -ErrorAction SilentlyContinue

$delka_args = $args.length
#echo "celkem args $delka_args" # int32
 
if ($delka_args -eq 0) {
Write-Warning "zadny argument"
echo "konec"
sleep 5
Exit
}

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

#echo $args[0]
$file = $args[0]
echo $file
#echo $file.GetType()


$cmd_output = @()
$cmd_output += & $cmd_madiainfo "-f" $file # parametr "-f" = fuel
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

sleep 10

