import time
import os
import requests

# Streamlit uses this endpoint to handle file uploads
STREAMLIT_UPLOAD_URL = "http://localhost:8501/_stcore/upload_file"

test_dir = "test_inputs"
test_files = [f for f in os.listdir(test_dir) if f.endswith(".txt")]
latencies = []

print(f"📤 Sending {len(test_files)} test files to Streamlit frontend...\n")

for file in test_files:
    file_path = os.path.join(test_dir, file)
    with open(file_path, "rb") as f:
        files = {"file": (file, f, "text/plain")}
        start = time.time()
        response = requests.post(STREAMLIT_UPLOAD_URL, files=files)
        end = time.time()

        latency_ms = (end - start) * 1000
        latencies.append(latency_ms)

        print(f"{file}: {response.status_code} | Latency: {latency_ms:.2f} ms")

# Metrics
avg_latency = sum(latencies) / len(latencies)
throughput = len(latencies) / (sum(latencies) / 1000)

print("\n📊 Benchmark Results:")
print(f"Average Latency: {avg_latency:.2f} ms")
print(f"Throughput: {throughput:.2f} req/sec")
