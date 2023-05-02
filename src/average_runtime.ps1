function Get-AverageRuntime {
    <#
    Measures the average runtime of a script block
    #>
    param(
        [Parameter(Mandatory)] [scriptblock] $Scriptblock,
        [Parameter()] [int] $Count = 5
    )
    $total_milliseconds = 0
    $tests_done = 0
    while ($tests_done -lt $Count) {
        $runtime = (Measure-Command $Scriptblock).TotalMilliseconds
        $total_milliseconds += $runtime
        $tests_done += 1
    }
    $average_runtime = $total_milliseconds / $Count
    return $average_runtime
}

$cTime = Get-AverageRuntime -Scriptblock { "$PSScriptRoot\C\a.exe" }
$goTime = Get-AverageRuntime -Scriptblock { "$PSScriptRoot\Go\rsa_encryption.exe" }
$rustTime = Get-AverageRuntime -Scriptblock { "$PSScriptRoot\Rust\target\release\rsa_encryption.exe" }
$juliaTime = Get-AverageRuntime -Scriptblock { julia $PSScriptRoot\Julia\rsa_encryption.jl }
$pythonTime = Get-AverageRuntime -Scriptblock { python $PSScriptRoot\Python\rsa_encryption.py }

$results = @(
    [PSCustomObject]@{
        Language = "Julia"
        Milliseconds = $juliaTime
    },
    [PSCustomObject]@{
        Language = "Python"
        Milliseconds = $pythonTime
    },
    [PSCustomObject]@{
        Language = "C"
        Milliseconds = $cTime
    },
    [PSCustomObject]@{
        Language = "Go"
        Milliseconds = $goTime
    },
    [PSCustomObject]@{
        Language = "Rust"
        Milliseconds = $rustTime
    }
)

$results | Select-Object Language, @{Name="Milliseconds"; Expression={"{0:F4}" -f $_.Milliseconds}} | Format-Table
