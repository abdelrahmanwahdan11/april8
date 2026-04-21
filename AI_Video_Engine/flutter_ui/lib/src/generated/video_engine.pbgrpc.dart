//
//  Generated code. Do not modify.
//  source: video_engine.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'video_engine.pb.dart' as $0;

export 'video_engine.pb.dart';

@$pb.GrpcServiceName('video_core.EngineController')
class EngineControllerClient extends $grpc.Client {
  static final _$executePlan = $grpc.ClientMethod<$0.CorrectionPlan, $0.ExecutionProgress>(
      '/video_core.EngineController/ExecutePlan',
      ($0.CorrectionPlan value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ExecutionProgress.fromBuffer(value));

  EngineControllerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.ExecutionProgress> executePlan($0.CorrectionPlan request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$executePlan, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('video_core.EngineController')
abstract class EngineControllerServiceBase extends $grpc.Service {
  $core.String get $name => 'video_core.EngineController';

  EngineControllerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CorrectionPlan, $0.ExecutionProgress>(
        'ExecutePlan',
        executePlan_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.CorrectionPlan.fromBuffer(value),
        ($0.ExecutionProgress value) => value.writeToBuffer()));
  }

  $async.Stream<$0.ExecutionProgress> executePlan_Pre($grpc.ServiceCall call, $async.Future<$0.CorrectionPlan> request) async* {
    yield* executePlan(call, await request);
  }

  $async.Stream<$0.ExecutionProgress> executePlan($grpc.ServiceCall call, $0.CorrectionPlan request);
}
