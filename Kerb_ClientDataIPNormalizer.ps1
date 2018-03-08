#Used to modify column value of csv to change Kerberos client data information from being a "ffff:dead:beef" to "222.173.190.239"
#To use change the $_.IP_WINDOWSEVENT to the column name of the client data information and the import-csv/export-csv paths
#
function gimmeIP([string]$line) { 
    if ( $line -match 'ffff' ) {
        $([IPAddress][UInt64]$('0x'+$line.split(':',4)[-1].replace(':','').replace('}',''))).IPAddressToString
    } else { $line }
}
echo 'start'; date
$csv = import-csv '\\full\path\to.csv' 
$csv | % { $_.IP_WINDOWSEVENT = gimmeIP($_.IP_WINDOWSEVENT) }
$csv | export-csv -notypeinformation '\\full\path\to\outfile.csv'
echo 'end'; date
