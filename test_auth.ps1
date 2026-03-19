$ErrorActionPreference = "Stop"
try {
    $json = '{"fullName":"Test","email":"test10@test.com","password":"pass","role":"FAMILY_MEMBER"}'
    Write-Host "Registering..."
    $r1 = Invoke-WebRequest -Uri 'http://localhost:8080/familly-bonding-api/api/auth/register' -Method Post -Body $json -ContentType 'application/json'
    Write-Host "Register output: $($r1.Content)"

    $jsonLogin = '{"email":"test10@test.com","password":"pass"}'
    Write-Host "Logging in..."
    $r2 = Invoke-WebRequest -Uri 'http://localhost:8080/familly-bonding-api/api/auth/login' -Method Post -Body $jsonLogin -ContentType 'application/json'
    Write-Host "Login output: $($r2.Content)"
} catch {
    Write-Host "Exception: $_"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $errResponse = $reader.ReadToEnd()
        Write-Host "Response Body: $errResponse"
    }
}
