#This will convert the ipv6ish numbers that come from the IP_WINDOWSEVENT column and change them into ipv4. NOTE THAT THE LAST LINE OF THE OUTPUT 
#WILL BE A DUPLICATE SO JUST DELETE THE LAST LINE BEFORE SAVING THE OUTPUT COLUMN INTO THE UPDATED SPREADSHEET
$csv = Import-Csv "\\full\path\to.csv" 
$count = 0..$csv.Count
$count | %{
$hex=$csv[$_].IP_WINDOWSEVENT.split(':')
$ipv6 = $hex -split '(..)' | ? {$_}
$oct1 = $ipv6[2]
$oct2 = $ipv6[3]
$oct3 = $ipv6[4]
$oct4 = $ipv6[5]
if($ipv6[1].Contains('ff')){
$a = [uint32]"0x$oct1"
$b = [uint32]"0x$oct2"
$c = [uint32]"0x$oct3"
$d = [uint32]"0x$oct4"
$ipv4 = [string]$a+'.'+[string]$b+'.'+[string]$c+'.'+[string]$d
echo $ipv4 >> \\full\path\to\Output.csv
}
else{echo $csv[$_].IP_WINDOWSEVENT} >> \\full\path\to\Output.csv }
}