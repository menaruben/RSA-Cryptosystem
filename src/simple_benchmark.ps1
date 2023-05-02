$cTime = Measure-Command { "$PSScriptRoot\C\a.exe" }
$goTime = Measure-Command { "$PSScriptRoot\Go\rsa_encryption.exe" }
$rustTime = Measure-Command { "$PSScriptRoot\Rust\target\release\rsa_encryption.exe" }
$juliaTime = Measure-Command { julia $PSScriptRoot\Julia\rsa_encryption.jl }
$pythonTime = Measure-Command { python $PSScriptRoot\Python\rsa_encryption.py }

$results = @(
    [PSCustomObject]@{
        Language = "Julia"
        Milliseconds = $juliaTime.TotalMilliseconds
    },
    [PSCustomObject]@{
        Language = "Python"
        Milliseconds = $pythonTime.TotalMilliseconds
    },
    [PSCustomObject]@{
        Language = "C"
        Milliseconds = $cTime.TotalMilliseconds
    },
    [PSCustomObject]@{
        Language = "Go"
        Milliseconds = $goTime.TotalMilliseconds
    },
    [PSCustomObject]@{
        Language = "Rust"
        Milliseconds = $rustTime.TotalMilliseconds
    }
)

$results | Select-Object Language, @{Name="Milliseconds"; Expression={"{0:F4}" -f $_.Milliseconds}} | Format-Table
