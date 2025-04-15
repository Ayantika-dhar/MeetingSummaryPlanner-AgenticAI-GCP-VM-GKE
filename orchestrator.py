from agents.summarizer_agent import SummarizerAgent
from agents.planner_agent import PlannerAgent

def main():
    with open("test_inputs/article.txt", "r", encoding="utf-8") as f:
        article = f.read()
    summary = SummarizerAgent().run(article)
    plan = PlannerAgent().run(summary)
    with open("outputs/summary.txt", "w", encoding="utf-8") as f:
        f.write(summary)
    with open("outputs/plan.txt", "w", encoding="utf-8") as f:
        f.write(plan)

if __name__ == "__main__":
    main()
