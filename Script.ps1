# EDIT THESE VARIABLES TO SPECIFY LICENSE TYPE, ETC.
# Upload your .json file to https://json-csv.com/ to convert it to an excel file

$fileName = "%DESKTOP%\SELicenses.json"
$licensetype = "PE"
$subtype = "STRUCTURAL"
$total = 10000

# DON'T EDIT ANYTHING BELOW THIS LINE EXCEPT FOR SEARCH STRINGS

$ParentDir = Split-Path $fileName
$num = 0
$found = 0
$userAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
Clear-Variable -Name "List"
CLS
del $filename
While($num -lt $total)
{
    $Response = Invoke-WebRequest -UserAgent $userAgent -UseBasicParsing "https://pvl.ehawaii.gov/pvlsearch/api/licenses/$licensetype-$num-0/detailsByLicense.json"

    # YOU CAN USE THE LINE BELOW TO EDIT SEARCH STRINGS OR EXCLUSIONS (-notmatch is used for items you want to find) (-match is used for items you don't want to find)
    # ERASE "-or $Response -notmatch $subtype" if there is no subtype for the license you want.

    If ($Response -Match 'license":null' -or $Response -Match 'TERMINATED' -or $Response -Match 'DECEASED' -or $Response -notmatch $subtype)
        {
        Echo "$found Active Licenses Found   -   Trying License#:$num -> No Active License Found"
        }
    Else
        {
        $found += 1
        Echo "$found Active Licenses Found   -   Trying License#:$num -> Found an Active License!"
        $List += $Response.Content
        }
    $num += 1
}
echo $List > $fileName
CLS
write-host "`n"
echo "You can find your License List at: $fileName    -    Please drag and drop in into the JSON Converter Window."
write-host "`n"
echo "License Finder found $found active $licensetype - $subtype licenses."
write-host "`n"
echo "...Opening https://json-csv.com now!"
(New-Object -Com Shell.Application).Open("https://json-csv.com")
ii $Parentdir
write-host "`n"
write-host "`n"
