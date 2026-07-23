$SUPABASE_URL = "https://msgqdkhjdpidwbhwnhgr.supabase.co"
$ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1zZ3Fka2hqZHBpZHdiaHduaGdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxNTkxMDcsImV4cCI6MjA5NDczNTEwN30.LGYFlUNfavCKqOYef3fEojUe0Njdhw9a73y3hNBCeAE"
$API_URL = "https://microservicio-mineria.vercel.app/api/v1/cacei/segmentation"

$email = "test_tutor_20260711161002@cacei-test.com"
$password = "TestPass123!"

$loginHeaders = @{
    "apikey"       = $ANON_KEY
    "Content-Type" = "application/json"
}

$loginBody = @{
    email    = $email
    password = $password
} | ConvertTo-Json

try {
    $lr = Invoke-RestMethod `
        -Uri "$SUPABASE_URL/auth/v1/token?grant_type=password" `
        -Headers $loginHeaders `
        -Method Post `
        -Body $loginBody `
        -ContentType "application/json"

    $token = $lr.access_token
    $userId = $lr.user.id
    Write-Host "Login OK. UserId: $userId"

    $userHeaders = @{
        "apikey"        = $ANON_KEY
        "Authorization" = "Bearer $token"
    }

    # 1. getTutorGroupIds
    Write-Host "`n1. getTutorGroupIds:"
    try {
        $groups = Invoke-RestMethod -Uri "$SUPABASE_URL/rest/v1/grupos?select=id&tutor_id=eq.$userId" -Headers $userHeaders -Method Get
        Write-Host "Grupos: $(($groups | ConvertTo-Json -Compress))"
    } catch {
        Write-Host "Error getTutorGroupIds: $($_.Exception.Message)"
    }

    # 2. getTutorStudentScopeCount
    Write-Host "`n2. getTutorStudentScopeCount:"
    try {
        $scope = Invoke-RestMethod -Uri "$SUPABASE_URL/rest/v1/tutor_student_scope?select=id&tutor_id=eq.$userId&active=eq.true" -Headers $userHeaders -Method Get
        Write-Host "Scope: $(($scope | ConvertTo-Json -Compress))"
    } catch {
        Write-Host "Error getTutorStudentScopeCount: $($_.Exception.Message)"
    }

    # 3. /students API
    Write-Host "`n3. API /students:"
    $apiHeaders = @{
        "Content-Type" = "application/json"
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
        "X-CASEI-ROLE" = "tutor"
        "X-CASEI-USER-ID" = $userId
        "X-CASEI-PURPOSE" = "casei_mobile_dashboard"
    }
    try {
        $students = Invoke-RestMethod -Uri "$API_URL/students?limit=500&offset=0&role=tutor" -Headers $apiHeaders -Method Get
        Write-Host "Students API call successful."
    } catch {
        $errStatus = $_.Exception.Response.StatusCode.value__
        try {
            $sr = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
            $errBody = $sr.ReadToEnd()
            Write-Host "Error API /students: $errStatus - $errBody"
        } catch {
            Write-Host "Error API /students: $errStatus - $($_.Exception.Message)"
        }
    }
}
catch {
    Write-Host "Login failed: $($_.Exception.Message)"
}
