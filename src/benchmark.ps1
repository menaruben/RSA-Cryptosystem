$juliaTime = Measure-Command { julia $PSScriptRoot\rsa_encryption.jl }
$pythonTime = Measure-Command { python $PSScriptRoot\rsa_encryption.py }
$cTime = Measure-Command { "$PSScriptRoot\a.exe" }

$results = [PSCustomObject]@{
    Language = "Julia", "Python", "C"
    Time_in_Seconds = $juliaTime.TotalSeconds, $pythonTime.TotalSeconds, $cTime.TotalSeconds
}

$results | Format-Table -AutoSize
