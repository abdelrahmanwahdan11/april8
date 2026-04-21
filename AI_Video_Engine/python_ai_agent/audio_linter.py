# File: python_ai_agent/audio_linter.py
from pydub import AudioSegment
from pydub.silence import detect_silence
import video_engine_pb2

def detect_silence_segments(video_path):
    commands = []
    try:
        audio = AudioSegment.from_file(video_path)
        # detect_silence returns a list of [start_ms, end_ms]
        silences = detect_silence(audio, min_silence_len=1500, silence_thresh=-40)

        for start_ms, end_ms in silences:
            cmd = video_engine_pb2.Command()
            cmd.type = video_engine_pb2.CommandType.CUT_SEGMENT
            cmd.start_time_ms = start_ms
            cmd.end_time_ms = end_ms
            commands.append(cmd)
    except Exception as e:
        print(f"Audio linter error: {e}")
    return commands
