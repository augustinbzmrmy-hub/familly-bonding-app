$ErrorActionPreference = "Stop"
try {
    $json = '{"fullName":"Test","email":"test111@test.com","password":"pass","role":"FAMILY_MEMBER"}'
    $r1 = Invoke-WebRequest -Uri 'http://localhost:8080/familly-bonding-api/api/auth/register' -Method Post -Body $json -ContentType 'application/json'
    $r1.Content | Out-File -FilePath "d:\FAMILLY APP\out.txt"
} catch {
     $_.Exception.Message | Out-File -FilePath "d:\FAMILLY APP\out.txt"
}
