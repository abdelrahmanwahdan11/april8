# File: python_ai_agent/llm_parser.py
import json
import video_engine_pb2

SYSTEM_PROMPT = """
You are an AI specialized in video editing commands.
Convert natural language requests into strictly formatted JSON matching the Protocol Buffer CorrectionPlan structure.
Ensure output is ONLY JSON.
"""

def parse_natural_language_to_plan(input_text, input_video, output_video):
    # Dummy parsing function for testing based on natural language input
    plan = video_engine_pb2.CorrectionPlan()
    plan.input_video_path = input_video
    plan.output_video_path = output_video

    # In a real scenario, we'd query an LLM with SYSTEM_PROMPT.
    # Here we simulate some returned JSON based on simple keyword matching.
    if "cut" in input_text.lower():
        cmd = plan.commands.add()
        cmd.type = video_engine_pb2.CommandType.CUT_SEGMENT
        cmd.start_time_ms = 0
        cmd.end_time_ms = 5000

    if "stabilize" in input_text.lower():
        cmd = plan.commands.add()
        cmd.type = video_engine_pb2.CommandType.STABILIZE
        cmd.start_time_ms = 0
        cmd.end_time_ms = 5000
        cmd.parameters["shakiness"] = "high"

    return plan
