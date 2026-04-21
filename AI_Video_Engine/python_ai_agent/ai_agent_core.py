import sys
import os

# Ensure the proto files can be imported
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'proto'))

import grpc
import video_engine_pb2
import video_engine_pb2_grpc

from audio_linter import lint_audio
from visual_linter import lint_visuals
from llm_parser import parse_natural_language

def run_agent(input_video, output_video, user_prompt=None):
    plan = video_engine_pb2.CorrectionPlan()
    plan.input_video_path = input_video
    plan.output_video_path = output_video

    # 1. Run Automated Linters
    print("Running automated linters...")
    audio_commands = lint_audio(input_video)
    visual_commands = lint_visuals(input_video)

    plan.commands.extend(audio_commands)
    plan.commands.extend(visual_commands)

    # 2. Parse User Intent (if any)
    if user_prompt:
        llm_commands = parse_natural_language(user_prompt)
        plan.commands.extend(llm_commands)

    print(f"Generated plan with {len(plan.commands)} commands.")

    # 3. Connect to C++ Engine
    print("Connecting to C++ Engine...")
    try:
        channel = grpc.insecure_channel('localhost:50051')
        stub = video_engine_pb2_grpc.EngineControllerStub(channel)

        # 4. Stream Execution Progress
        responses = stub.ExecutePlan(plan)
        for response in responses:
            if response.has_error:
                print(f"\n[ERROR] {response.error_details}")
                break

            # Print streaming progress bar
            bar_length = 50
            filled_len = int(bar_length * response.progress_percentage // 100)
            bar = '=' * filled_len + '-' * (bar_length - filled_len)

            sys.stdout.write(f'\r[{bar}] {response.progress_percentage}% - {response.current_task}')
            sys.stdout.flush()

            if response.is_finished:
                print("\n[SUCCESS] Video processing complete!")
                break

    except grpc.RpcError as e:
        print(f"\n[gRPC Error] Could not connect to engine: {e.details()}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python ai_agent_core.py <input_video> <output_video> [user_prompt]")
        sys.exit(1)

    in_vid = sys.argv[1]
    out_vid = sys.argv[2]
    prompt = sys.argv[3] if len(sys.argv) > 3 else None

    run_agent(in_vid, out_vid, prompt)
