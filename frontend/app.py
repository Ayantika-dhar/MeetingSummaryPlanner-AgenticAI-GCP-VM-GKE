import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import streamlit as st
from agents.summarizer_agent import SummarizerAgent
from agents.planner_agent import PlannerAgent

st.title("Meeting Summary and Action Plan Generator")
uploaded_file = st.file_uploader("Upload a news article (.txt)", type="txt")
if uploaded_file is not None:
    article = uploaded_file.read().decode("utf-8")
    summary = SummarizerAgent().run(article)
    plan = PlannerAgent().run(summary)
    st.subheader("Summary")
    st.write(summary)
    st.subheader("Action Plan")
    st.write(plan)
