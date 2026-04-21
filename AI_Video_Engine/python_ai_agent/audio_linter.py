from pydub import AudioSegment
from pydub.silence import detect_silence
import video_engine_pb2

def lint_audio(video_path):
    print(f"Linting audio for {video_path}")
    commands = []

    try:
        # Pydub can extract audio directly from a video file if ffmpeg is installed
        audio = AudioSegment.from_file(video_path)

        # Detect silence
        # min_silence_len=1500ms, silence_thresh=-40dB
        silences = detect_silence(audio, min_silence_len=1500, silence_thresh=-40)

        for start, end in silences:
            cmd = video_engine_pb2.Command()
            cmd.type = video_engine_pb2.CUT_SEGMENT
            cmd.start_time_ms = start
            cmd.end_time_ms = end
            commands.append(cmd)

    except Exception as e:
        print(f"Error processing audio: {e}")

    return commands
