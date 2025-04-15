#!/bin/bash

echo "---- METRICS COLLECTION (AGENTIC AI - STREAMLIT) ----"

# 1. Track boot time (from script start to Streamlit ready)
START=$(date +%s)

echo "Waiting for Streamlit frontend to be available..."
until curl -s --max-time 2 http://localhost:8501 > /dev/null; do
    sleep 1
done

END=$(date +%s)
BOOT_TIME=$((END - START))
echo "✅ Boot Time: $BOOT_TIME seconds"

# 2. Docker Resource Usage Snapshot
echo "📦 Capturing Docker Stats..."
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" > docker_stats.txt
cat docker_stats.txt

# 3. Benchmark Agentic AI with test files
echo "🧪 Running Benchmark Tests..."
python3 run_tests.py > benchmark_output.txt
cat benchmark_output.txt

# 4. Extract metrics from output
LATENCY=$(grep "Average Latency" benchmark_output.txt | awk '{print $3}')
THROUGHPUT=$(grep "Throughput" benchmark_output.txt | awk '{print $2}')

# 5. Save to performance summary log
cat <<EOF > performance_summary.log
--- AGENTIC AI PERFORMANCE METRICS (Streamlit) ---

BOOT TIME (sec): $BOOT_TIME
AVERAGE LATENCY (ms): $LATENCY
THROUGHPUT (req/sec): $THROUGHPUT

--- DOCKER RESOURCE USAGE ---
$(cat docker_stats.txt)
EOF

echo "✅ All metrics saved to performance_summary.log"
