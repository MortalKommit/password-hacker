Function Time-it{
param([Parameter(Mandatory=$true,Position = 0)][ValidateNotNullOrEmpty()]$script,
      [Parameter(Position = 1)]$times = 10)
$stopwatch_times = [System.Collections.ArrayList]::new()
$stopwatch =  [system.diagnostics.stopwatch]::new()
$times_count = $times
while($times_count -ne 0){
    $stopwatch.Start() 
    Invoke-Expression -command $script | Out-Null
    $stopwatch_times.Add($stopwatch.Elapsed.TotalSeconds) | Out-Null
    $stopwatch.Stop() 
    $stopwatch.Reset() 
    $times_count -= 1
}
Write-Output "$times runs, $($($stopwatch_times | Measure-Object -Average).Average) seconds per run"
}
