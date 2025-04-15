
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy code
COPY . /app

# Install Python deps only (no apt)
RUN pip install --no-cache-dir streamlit transformers torch

# Expose Streamlit default port
EXPOSE 8501

# Start the Streamlit app
CMD ["streamlit", "run", "frontend/app.py", "--server.port=8501", "--server.address=0.0.0.0", "--server.enableCORS=false"]
