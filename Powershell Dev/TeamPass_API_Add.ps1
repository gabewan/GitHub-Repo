function ConvertTo-Base64String($text){
$bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
$encoded = [convert]::ToBase64String($bytes)
$encoded
}

$folder = "MTI1Nw=" # Enter folder ID, must be received from *nix based device.
$APIKey = "rhamgh8hbLrkyDu5u4aNqyFZ3AKSuF5KMKMHpZZ"

foreach ($Entry in (Import-Csv 'C:\users\grlewis\desktop\Glucommander Kiosk.csv')) {
  $Url = "https://teampass.nghs.com/api/index.php/add/item/" + (ConvertTo-Base64String -text $Entry.label) + ";" + (ConvertTo-Base64String -text $Entry.password) + ";" + (ConvertTo-Base64String -text $Entry.description) + ";" + $folder + ";" + (ConvertTo-Base64String -text $Entry.login) + ";;" + (ConvertTo-Base64String -text $Entry.url) + ";;" + (ConvertTo-Base64String -text "1") + "?apikey=" + $APIKey
  Invoke-WebRequest $Url
}


