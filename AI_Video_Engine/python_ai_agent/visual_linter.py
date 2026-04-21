import cv2
import numpy as np
import video_engine_pb2

def lint_visuals(video_path):
    print(f"Linting visuals for {video_path}")
    commands = []

    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        print(f"Failed to open video: {video_path}")
        return commands

    fps = cap.get(cv2.CAP_PROP_FPS)
    if fps <= 0:
        fps = 30.0 # fallback

    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))

    frame_count = 0
    sampled_frames = 0
    low_exposure_count = 0
    shaky_count = 0

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # Sample only 1 frame per second
        if frame_count % int(fps) == 0:
            sampled_frames += 1
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

            # Exposure check
            exposure = np.mean(gray)
            if exposure < 60:
                low_exposure_count += 1

            # Shakiness check
            variance = cv2.Laplacian(gray, cv2.CV_64F).var()
            if variance < 100:
                shaky_count += 1

        frame_count += 1

    cap.release()

    if sampled_frames > 0:
        if low_exposure_count / sampled_frames > 0.3:
            cmd = video_engine_pb2.Command()
            cmd.type = video_engine_pb2.COLOR_CORRECT
            cmd.parameters["exposure"] = "+1.5"
            commands.append(cmd)

        if shaky_count / sampled_frames > 0.2:
            cmd = video_engine_pb2.Command()
            cmd.type = video_engine_pb2.STABILIZE
            cmd.parameters["shakiness"] = "high"
            commands.append(cmd)

    return commands
