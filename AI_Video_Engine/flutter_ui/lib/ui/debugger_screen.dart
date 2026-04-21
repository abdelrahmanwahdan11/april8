// File: flutter_ui/lib/ui/debugger_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/video_state_manager.dart';
import 'timeline_painter.dart';
import '../src/generated/video_engine.pb.dart';

class DebuggerScreen extends ConsumerWidget {
  const DebuggerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoStateProvider);

    // Matte Black & Gold Theme
    final bgColor = const Color(0xFF121212);
    final goldColor = const Color(0xFFFFD700);
    final cardColor = const Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('AI Video Engine Debugger', style: TextStyle(color: Color(0xFFFFD700))),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Top: Video Player Placeholder
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.black,
              child: const Center(
                child: Text(
                  'Video Player Placeholder',
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                ),
              ),
            ),
          ),

          // Middle: Dynamic Card
          Expanded(
            flex: 1,
            child: Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'AI Issue Detected: Shake at 00:15',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldColor,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: videoState is VideoProcessing
                          ? null
                          : () {
                              // Dummy plan for testing
                              final plan = CorrectionPlan()
                                ..inputVideoPath = 'input.mp4'
                                ..outputVideoPath = 'output.mp4';

                              final cmd = Command()
                                ..type = CommandType.STABILIZE
                                ..startTimeMs = 15000
                                ..endTimeMs = 20000;
                              cmd.parameters['shakiness'] = 'high';
                              plan.commands.add(cmd);

                              ref.read(videoStateProvider.notifier).executePlan(plan);
                            },
                      child: const Text('Apply Fix'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom: Timeline and Progress
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // State text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _getStateText(videoState),
                    style: TextStyle(color: goldColor),
                  ),
                ),

                // Timeline
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      // Handle scrubbing here
                    },
                    child: CustomPaint(
                      size: const Size(double.infinity, 60),
                      painter: TimelinePainter(
                        progressPercentage: videoState is VideoProcessing ? videoState.progress / 100.0 : 0.0,
                        aiMarkers: [
                          {'startTime': 0.2, 'endTime': 0.3, 'type': 'shake'},
                          {'startTime': 0.6, 'endTime': 0.8, 'type': 'low_light'},
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Progress Indicator
                if (videoState is VideoProcessing)
                  LinearProgressIndicator(
                    value: videoState.progress / 100.0,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                  )
                else
                  LinearProgressIndicator(
                    value: 0.0,
                    backgroundColor: Colors.grey[800],
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStateText(VideoState state) {
    if (state is VideoInitial) return 'Ready';
    if (state is VideoAnalyzing) return 'Analyzing...';
    if (state is VideoProcessing) return '${state.task} (${state.progress}%)';
    if (state is VideoSuccess) return 'Success!';
    if (state is VideoError) return 'Error: ${state.errorDetails}';
    return '';
  }
}
