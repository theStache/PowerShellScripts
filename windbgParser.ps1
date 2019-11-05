#input: 9509ec60          TcpIp!RtnFreeFrame (<no parameter info>) 
#output: ; bp 9509ec60 ".echo IN FUNCTION TcpIp!RtnFreeFrame; dc [esp] L1; da poi [esp+4]; da poi [esp+8]; dc [esp+c] L1; g;"

$filename = 'path\to\file.txt'
foreach ($line in [System.IO.File]::ReadLines($filename)) {
    $line = $line.split()
    [string]::Format('; bp {0} ".echo IN FUNCTION {1}; dc [esp] L1; da poi [esp+4]; da poi [esp+8]; dc [esp+c] L1; g;"',$line[0],$line[10]) | Out-File -FilePath 'path\to\Output.txt' -Append
}
