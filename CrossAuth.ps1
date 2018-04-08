#Used to identify SVC accounts authenticating to Domain X when the IP tied to that computer has been identified in Domain Y
#Review before you use it. Created by Tyler Williams, email tjwill86@gmail.com 20180408

#IP normalization function
function gimmeIP([string]$line) { 
    if ( $line -match 'ffff'-and $line.Length -eq '16' ) {
        $([IPAddress][UInt64]$('0x'+$line.split(':',4)[-1].replace(':','').replace('}',''))).IPAddressToString
    } else { $line }
}

#Input file variable
#$file = .\input_file.csv
echo 'start'; date
$hash = @{}
$account = @{}
$csv = $(import-csv $file | Select-Object USERNAME_TARGET, IP_WINDOWSEVENT, HOSTNAME_TARGET)

#Creating dict with K=IP,(V=UserName,V=Domain)
$csv | ForEach-Object {
if($_.USERNAME_TARGET.Contains("$")){
$hash.Add((gimmeIP($_.IP_WINDOWSEVENT)),(@{
        'User' = ($_.USERNAME_TARGET)
        'Domain' = (((($_.HOSTNAME_TARGET).Split('.'))[0]).toupper())
    }))}}

#Creating dict with K=IP,(V=UserName,V=Domain)
$csv | ForEach-Object {
if($_.USERNAME_TARGET.Contains("svc")){
$account.Add((gimmeIP($_.IP_WINDOWSEVENT)),(@{
        'User' = ($_.USERNAME_TARGET)
        'Domain' = (((($_.HOSTNAME_TARGET).Split('.'))[0]).toupper())
    }))}}
#Initialize groupings arrat
$groupings = @()
#Creates customObject to contain the data from the $hash and $account variables
$data = foreach($x in $hash.Keys){
    if($account[$x].User){
        $object = New-Object –TypeName PSObject
        $object | Add-Member –MemberType NoteProperty –Name source_ip –Value $x
        $object | Add-Member –MemberType NoteProperty –Name account_un –Value $account[$x].User
        $object | Add-Member –MemberType NoteProperty –Name account_domain –Value $account[$x].Domain
        $object | Add-Member –MemberType NoteProperty –Name service_un –Value $hash[$x].User
        $object | Add-Member –MemberType NoteProperty –Name service_domain –Value $hash[$x].Domain
        $groupings += $object                } 
}
#Finds mismatched Domains
foreach($x in $groupings){if($x.account_domain -ne $x.service_domain){echo $x}}

#$data | Export-Csv .\'Update'$file.csv -NoTypeInformation
echo 'end'; date
