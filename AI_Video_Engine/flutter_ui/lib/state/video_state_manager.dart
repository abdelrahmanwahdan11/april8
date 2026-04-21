import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';
import '../proto_generated/video_engine.pbgrpc.dart';

abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoAnalyzing extends VideoState {}

class VideoProcessing extends VideoState {
  final int progress;
  final String task;
  VideoProcessing(this.progress, this.task);
}

class VideoSuccess extends VideoState {}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}

class VideoStateManager extends StateNotifier<VideoState> {
  VideoStateManager() : super(VideoInitial());

  ClientChannel? _channel;
  EngineControllerClient? _stub;

  void applyFixes(String inputPath, String outputPath) async {
    state = VideoAnalyzing();

    try {
      _channel = ClientChannel(
        'localhost',
        port: 50051,
        options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
      );
      _stub = EngineControllerClient(_channel!);

      var plan = CorrectionPlan()
        ..inputVideoPath = inputPath
        ..outputVideoPath = outputPath;

      var stream = _stub!.executePlan(plan);

      await for (var progress in stream) {
        if (progress.hasError) {
          state = VideoError(progress.errorDetails);
          return;
        }

        state = VideoProcessing(progress.progressPercentage, progress.currentTask);

        if (progress.isFinished) {
          state = VideoSuccess();
          return;
        }
      }
    } catch (e) {
      state = VideoError(e.toString());
    } finally {
      await _channel?.shutdown();
    }
  }
}

final videoStateProvider = StateNotifierProvider<VideoStateManager, VideoState>((ref) {
  return VideoStateManager();
});
