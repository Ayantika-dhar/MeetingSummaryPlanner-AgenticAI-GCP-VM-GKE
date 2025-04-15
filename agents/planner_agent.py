from transformers import pipeline

class PlannerAgent:
    def __init__(self):
        self.planner = pipeline("text2text-generation", model="google/flan-t5-base")

    def run(self, summary):
        prompt = (
            "Given the following meeting summary, generate action items or key decisions as bullet points:\n\n"
            f"{summary}\n\n"
            "Action Plan:"
        )
        response = self.planner(prompt, max_length=256, do_sample=False)
        return response[0]["generated_text"]
