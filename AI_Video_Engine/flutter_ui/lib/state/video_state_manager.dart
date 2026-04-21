// File: flutter_ui/lib/state/video_state_manager.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';
import '../src/generated/video_engine.pbgrpc.dart';

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
  final String errorDetails;
  VideoError(this.errorDetails);
}

class VideoStateNotifier extends StateNotifier<VideoState> {
  VideoStateNotifier() : super(VideoInitial());

  Future<void> executePlan(CorrectionPlan plan) async {
    state = VideoAnalyzing();

    final channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    final stub = EngineControllerClient(channel);

    try {
      final responseStream = stub.executePlan(plan);

      await for (var progress in responseStream) {
        if (progress.hasError) {
          state = VideoError(progress.errorDetails);
          break;
        } else if (progress.isFinished) {
          state = VideoSuccess();
          break;
        } else {
          state = VideoProcessing(progress.progressPercentage, progress.currentTask);
        }
      }
    } catch (e) {
      state = VideoError(e.toString());
    } finally {
      await channel.shutdown();
    }
  }
}

final videoStateProvider = StateNotifierProvider<VideoStateNotifier, VideoState>((ref) {
  return VideoStateNotifier();
});
