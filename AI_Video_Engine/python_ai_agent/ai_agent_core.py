# File: python_ai_agent/ai_agent_core.py
import grpc
import sys
import video_engine_pb2
import video_engine_pb2_grpc
from audio_linter import detect_silence_segments
from visual_linter import detect_visual_issues
from llm_parser import parse_natural_language_to_plan

def run_agent(input_video, output_video, user_prompt=None):
    plan = video_engine_pb2.CorrectionPlan()
    plan.input_video_path = input_video
    plan.output_video_path = output_video

    # 1. Automated Linters
    print("Running audio linter...")
    audio_commands = detect_silence_segments(input_video)
    plan.commands.extend(audio_commands)

    print("Running visual linter...")
    visual_commands = detect_visual_issues(input_video)
    plan.commands.extend(visual_commands)

    # 2. Natural Language
    if user_prompt:
        print("Parsing natural language prompt...")
        llm_plan = parse_natural_language_to_plan(user_prompt, input_video, output_video)
        plan.commands.extend(llm_plan.commands)

    print(f"Generated {len(plan.commands)} commands.")

    # 3. Send to C++ Muscle
    print("Connecting to gRPC server at localhost:50051...")
    try:
        with grpc.insecure_channel('localhost:50051') as channel:
            stub = video_engine_pb2_grpc.EngineControllerStub(channel)

            print("Sending plan for execution...")
            for progress in stub.ExecutePlan(plan):
                if progress.has_error:
                    print(f"\nError from C++ Engine: {progress.error_details}")
                    break

                # Print progress bar
                sys.stdout.write(f"\r[{progress.progress_percentage}%] {progress.current_task}")
                sys.stdout.flush()

                if progress.is_finished:
                    print("\nRendering complete!")
                    break
    except grpc.RpcError as e:
        print(f"\ngRPC connection failed: {e}")

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: python ai_agent_core.py <input_video> <output_video> [user_prompt]")
        sys.exit(1)

    in_vid = sys.argv[1]
    out_vid = sys.argv[2]
    prompt = sys.argv[3] if len(sys.argv) > 3 else None

    run_agent(in_vid, out_vid, prompt)
