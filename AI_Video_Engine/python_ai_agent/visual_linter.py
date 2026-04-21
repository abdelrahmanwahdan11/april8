# File: python_ai_agent/visual_linter.py
import cv2
import numpy as np
import video_engine_pb2

def detect_visual_issues(video_path):
    commands = []
    cap = cv2.VideoCapture(video_path)

    if not cap.isOpened():
        print(f"Visual linter error: Could not open {video_path}")
        return commands

    fps = cap.get(cv2.CAP_PROP_FPS)
    if fps == 0:
        fps = 30 # fallback

    frame_interval = int(fps) # sample 1 frame per second

    frame_count = 0
    total_sampled_frames = 0
    low_exposure_frames = 0
    shaky_frames = 0

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        if frame_count % frame_interval == 0:
            total_sampled_frames += 1
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

            # Exposure calculation
            exposure = np.mean(gray)
            if exposure < 60:
                low_exposure_frames += 1

            # Shakiness calculation
            variance = cv2.Laplacian(gray, cv2.CV_64F).var()
            if variance < 100:
                shaky_frames += 1

        frame_count += 1

    cap.release()

    if total_sampled_frames > 0:
        if low_exposure_frames / total_sampled_frames > 0.3:
            cmd = video_engine_pb2.Command()
            cmd.type = video_engine_pb2.CommandType.COLOR_CORRECT
            cmd.start_time_ms = 0
            cmd.end_time_ms = int(frame_count / fps * 1000)
            cmd.parameters["exposure"] = "+1.5"
            commands.append(cmd)

        if shaky_frames / total_sampled_frames > 0.2:
            cmd = video_engine_pb2.Command()
            cmd.type = video_engine_pb2.CommandType.STABILIZE
            cmd.start_time_ms = 0
            cmd.end_time_ms = int(frame_count / fps * 1000)
            cmd.parameters["shakiness"] = "high"
            commands.append(cmd)

    return commands
