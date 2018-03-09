#Reads in CSV, selects column containing Kerberos ticket option information; converts the options (0x40810010) and provides a new column with the #Descriptions of the options utilized ie. Forwardable, Renewable, Canonicalize, Renewable-ok.
#To utilize, change the $_.TICKETOPTIONS to whatever your CSV Kerberos ticket option column is named; Change the import-csv/export-csv options to #desired locations.
#Use at own risk; Tyler Williams - tjwill86@gmail.com; 20180308
#Edited 20180309 - moved $kerbtable out of the function to increase performance

$kerbtable = @{0='Reserved';1='Forwardable';2='Forwarded';3='Proxiable';4='Proxy';5='Allow-postdate';6='Postdated';7='Invalid';8='Renewable';9='Initial';10='Pre-authent';11='Opt-hardware-auth';12='Transited-policy-checked';13='Ok-as-delegate';14='Request-anonymous';15='Name-canonicalize';16='Unused';17='Unused';18='Unused';19='Unused';20='Unused';21='Unused';22='Unused';23='Unused';24='Unused';25='Unused';26='Disable-transited-check';27='Renewable-ok';28='Enc-tkt-in-skey';29='Unused';30='Renew';31='Validate'}
function dataParser($item){
$item = [convert]::Tostring($item,2)
$element = @()
$count = 0..$item.length
if ($item -le 32 ){$item = $item.Insert(0,0)}
$count | %{if($item[$_] -eq '1'){$element += $kerbtable.Item($_)}}
return "$element"
}
date;
$csv = import-csv '\\full\path\to.csv'
$csv = ($csv | Select-Object *,@{Name="Expanded_TicketOptions";Expression='.'}); $csv| %{$_.Expanded_TicketOptions = dataParser($_.TICKETOPTIONS)}; $csv | Export-Csv \\full\path\to\output.csv -NoTypeInformation
date;
