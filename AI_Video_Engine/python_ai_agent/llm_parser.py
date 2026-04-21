import json
import video_engine_pb2

SYSTEM_PROMPT = """
You are an AI Video Editor Assistant. Your job is to convert natural language requests into a strictly formatted JSON array of commands.
Each command must have the following structure:
{
  "type": "CUT_SEGMENT" | "STABILIZE" | "COLOR_CORRECT" | "AUDIO_DENOISE",
  "start_time_ms": integer (optional, default 0),
  "end_time_ms": integer (optional, default 0),
  "parameters": { string: string } (optional)
}
Output ONLY valid JSON.
"""

def parse_natural_language(text):
    """
    Dummy parsing function for testing.
    In a real system, this would call an LLM API with the SYSTEM_PROMPT.
    """
    print(f"Parsing natural language: '{text}'")

    # Dummy logic to simulate LLM parsing
    commands = []

    if "stabilize" in text.lower():
        cmd = video_engine_pb2.Command()
        cmd.type = video_engine_pb2.STABILIZE
        cmd.parameters["shakiness"] = "medium"
        commands.append(cmd)

    if "brighten" in text.lower():
        cmd = video_engine_pb2.Command()
        cmd.type = video_engine_pb2.COLOR_CORRECT
        cmd.parameters["exposure"] = "+1.0"
        commands.append(cmd)

    return commands
