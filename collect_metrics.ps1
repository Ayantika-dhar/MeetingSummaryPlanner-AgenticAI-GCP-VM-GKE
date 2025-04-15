Write-Host "---- METRICS COLLECTION (GKE | PowerShell) ----"

# Step 1: Track frontend boot time
$start = Get-Date

Write-Host "Waiting for frontend to become available..."

do {
    Start-Sleep -Seconds 1
    $response = try { Invoke-WebRequest -Uri "http://104.197.155.232:30004" -UseBasicParsing -TimeoutSec 2 } catch { $null }
} while (-not $response)

$end = Get-Date
$bootTime = [math]::Round(($end - $start).TotalSeconds, 2)
Write-Host "Boot Time: $bootTime seconds"

# Step 2: Run benchmark
Write-Host "`nRunning Benchmark Tests (Upload-Service NodePort)..."
$env:UPLOAD_URL = "http://104.197.155.232:30004/upload/"

python run_tests.py > benchmark_output.txt
Get-Content benchmark_output.txt

# Step 3: Extract metrics
$latency = Select-String -Path "benchmark_output.txt" -Pattern "Average Latency" | ForEach-Object { ($_ -split ": ")[1] }
$throughput = Select-String -Path "benchmark_output.txt" -Pattern "Throughput" | ForEach-Object { ($_ -split ": ")[1] }

# Step 4: Save benchmark summary
@"
----- GKE (Containerized) METRICS -----

BOOT TIME (sec): $bootTime
AVERAGE LATENCY (ms): $latency
THROUGHPUT (req/sec): $throughput

Tested at: $(Get-Date)
NodePort: 30001
Frontend: http://104.197.155.232:30004
"@ | Out-File -Encoding UTF8 performance_summary.log

# Step 5: Format and display pod stats like Docker format
Write-Host "`nCapturing Docker-style Pod Stats (Kubernetes)..."
$kubectlStats = kubectl top pods -n msa-generator --no-headers

$header = "NAME".PadRight(60) + "CPU %".PadRight(10) + "MEM USAGE / LIMIT"
Write-Host $header
Add-Content performance_summary.log "`nCapturing Kubernetes Pod Stats..."
Add-Content performance_summary.log $header

foreach ($line in $kubectlStats) {
    $parts = $line -split '\s+'
    $name = $parts[0].PadRight(60)

    # Convert CPU m to %
    $cpuRaw = $parts[1] -replace "m", ""
    if ($cpuRaw -match '^\d+$') {
        $cpuPercent = "{0:N2}%" -f ([double]$cpuRaw / 1000 * 100)
    } else {
        $cpuPercent = "N/A"
    }
    $cpu = $cpuPercent.PadRight(10)

    # Memory
    $mem = $parts[2]
    $memFormatted = "$mem / N/A"

    $formattedLine = "$name$cpu$memFormatted"
    Write-Host $formattedLine
    Add-Content performance_summary.log $formattedLine
}

# Step 6: Print key metrics to console
Write-Host "`nFinal Metrics:"
Write-Host "Average Latency: $latency"
Write-Host "Throughput: $throughput req/sec"
Write-Host "Boot Time: $bootTime seconds"
Write-Host "`nAll metrics saved to performance_summary.log"


