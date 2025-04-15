# Agentic AI Architecture – Meeting Transcript Summarizer & Planner

This project implements a functionally complete **Agentic AI system** that reads meeting transcripts, summarizes them, and generates structured action plans. It uses a summarizer agent (BART) and planner agent (FLAN-T5) coordinated through a backend orchestrator and a Streamlit-based frontend.

---

## ✅ Project Structure

```plaintext
agentic_arch/
├── agents/                 # Summarizer and Planner agents
│   ├── summarizer_agent.py
│   └── planner_agent.py
├── orchestrator.py         # Backend CLI orchestrator
├── frontend/
│   └── app.py              # Streamlit UI
├── test_inputs/            # Sample meeting transcripts
├── outputs/                # Output summaries and plans
├── run_tests.py            # Benchmark test runner
├── collect_metrics_vm.sh   # VM-level performance evaluation
├── requirements.txt        # Python dependencies
└── Dockerfile              # Docker container setup
```

---

## 🚀 Setup Instructions

### 1. Create Virtual Environment
```bash
py -3.10 -m venv venv
venv\Scripts\activate  # On Windows
```

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Add Sample Test File
Add `.txt` transcript(s) to `test_inputs/`, e.g., `meeting1.txt`.

---

## 🔍 Run the App

### Option A: Run via CLI (Orchestrator)
```bash
python orchestrator.py
```

### Option B: Run Streamlit Frontend
```bash
streamlit run frontend/app.py
```
Then open [http://localhost:8501](http://localhost:8501) and upload a meeting `.txt` file.

---

## 📆 Docker Instructions

### 1. Build Docker Image
```bash
docker build -t agentic-ai-app .
```

### 2. Run the Container
```bash
docker run -p 8501:8501 agentic-ai-app
```

---

## ⚖️ Benchmarking & Metrics Collection

### 1. Place test files in `test_inputs/`

### 2. Run Metrics Script (Linux VM)
```bash
bash collect_metrics_vm.sh
```

### 3. Output
- `benchmark_output.txt` → Raw test output
- `docker_stats.txt` → Resource usage
- `performance_summary.log` → Final results (boot time, latency, throughput)

---

## 📅 Authors
- Rishabh Johri, MTech AI, IIT Jodhpur

---

## 📃 License
This project is licensed under the MIT License.
