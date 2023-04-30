$juliaTime = Measure-Command { julia $PSScriptRoot\rsa_encryption.jl }
$pythonTime = Measure-Command { python $PSScriptRoot\rsa_encryption.py }

Write-Host "Julia was $($pythonTime.TotalMilliseconds / $juliaTime.TotalMilliseconds)x faster than Python!"
# Julia was 24.2264099245683x faster than Python!