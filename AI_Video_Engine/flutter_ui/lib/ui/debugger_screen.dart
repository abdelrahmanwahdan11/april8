import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/video_state_manager.dart';
import 'timeline_painter.dart';

class DebuggerScreen extends ConsumerWidget {
  const DebuggerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoStateProvider);
    final isProcessing = videoState is VideoProcessing;

    // Dummy AI Markers
    final List<Map<String, dynamic>> aiMarkers = [
      {'startTime': 5000, 'endTime': 8000, 'type': 'shake'},
      {'startTime': 12000, 'endTime': 15000, 'type': 'low_light'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Video Engine Debugger', style: TextStyle(color: Color(0xFFFFD700))),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Column(
        children: [
          // Top: Video Player Placeholder
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: const Color(0xFFFFD700), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_outline, color: Colors.white54, size: 64),
              ),
            ),
          ),

          // Middle: Dynamic Card
          Expanded(
            flex: 1,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Detected Issues', style: TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Shake detected at 00:05\nLow light detected at 00:12', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: isProcessing ? null : () {
                        ref.read(videoStateProvider.notifier).applyFixes("input.mp4", "output.mp4");
                      },
                      child: const Text('Apply Fix'),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Bottom: Timeline & Progress
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      // Handle scrubbing
                    },
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: TimelinePainter(
                          progressMs: 10000,
                          totalDurationMs: 30000,
                          aiMarkers: aiMarkers,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (videoState is VideoProcessing) ...[
                    LinearProgressIndicator(
                      value: videoState.progress / 100,
                      color: const Color(0xFFFFD700),
                      backgroundColor: const Color(0xFF1E1E1E),
                    ),
                    const SizedBox(height: 8),
                    Text(videoState.task, style: const TextStyle(color: Colors.white70)),
                  ],
                  if (videoState is VideoSuccess)
                    const Text('Processing Complete!', style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
