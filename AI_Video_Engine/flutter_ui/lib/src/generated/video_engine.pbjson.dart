//
//  Generated code. Do not modify.
//  source: video_engine.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use commandTypeDescriptor instead')
const CommandType$json = {
  '1': 'CommandType',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'CUT_SEGMENT', '2': 1},
    {'1': 'STABILIZE', '2': 2},
    {'1': 'COLOR_CORRECT', '2': 3},
    {'1': 'AUDIO_DENOISE', '2': 4},
  ],
};

/// Descriptor for `CommandType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List commandTypeDescriptor = $convert.base64Decode(
    'CgtDb21tYW5kVHlwZRILCgdVTktOT1dOEAASDwoLQ1VUX1NFR01FTlQQARINCglTVEFCSUxJWk'
    'UQAhIRCg1DT0xPUl9DT1JSRUNUEAMSEQoNQVVESU9fREVOT0lTRRAE');

@$core.Deprecated('Use commandDescriptor instead')
const Command$json = {
  '1': 'Command',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.video_core.CommandType', '10': 'type'},
    {'1': 'start_time_ms', '3': 2, '4': 1, '5': 5, '10': 'startTimeMs'},
    {'1': 'end_time_ms', '3': 3, '4': 1, '5': 5, '10': 'endTimeMs'},
    {'1': 'parameters', '3': 4, '4': 3, '5': 11, '6': '.video_core.Command.ParametersEntry', '10': 'parameters'},
  ],
  '3': [Command_ParametersEntry$json],
};

@$core.Deprecated('Use commandDescriptor instead')
const Command_ParametersEntry$json = {
  '1': 'ParametersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Command`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandDescriptor = $convert.base64Decode(
    'CgdDb21tYW5kEisKBHR5cGUYASABKA4yFy52aWRlb19jb3JlLkNvbW1hbmRUeXBlUgR0eXBlEi'
    'IKDXN0YXJ0X3RpbWVfbXMYAiABKAVSC3N0YXJ0VGltZU1zEh4KC2VuZF90aW1lX21zGAMgASgF'
    'UgllbmRUaW1lTXMSQwoKcGFyYW1ldGVycxgEIAMoCzIjLnZpZGVvX2NvcmUuQ29tbWFuZC5QYX'
    'JhbWV0ZXJzRW50cnlSCnBhcmFtZXRlcnMaPQoPUGFyYW1ldGVyc0VudHJ5EhAKA2tleRgBIAEo'
    'CVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use correctionPlanDescriptor instead')
const CorrectionPlan$json = {
  '1': 'CorrectionPlan',
  '2': [
    {'1': 'input_video_path', '3': 1, '4': 1, '5': 9, '10': 'inputVideoPath'},
    {'1': 'output_video_path', '3': 2, '4': 1, '5': 9, '10': 'outputVideoPath'},
    {'1': 'commands', '3': 3, '4': 3, '5': 11, '6': '.video_core.Command', '10': 'commands'},
  ],
};

/// Descriptor for `CorrectionPlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List correctionPlanDescriptor = $convert.base64Decode(
    'Cg5Db3JyZWN0aW9uUGxhbhIoChBpbnB1dF92aWRlb19wYXRoGAEgASgJUg5pbnB1dFZpZGVvUG'
    'F0aBIqChFvdXRwdXRfdmlkZW9fcGF0aBgCIAEoCVIPb3V0cHV0VmlkZW9QYXRoEi8KCGNvbW1h'
    'bmRzGAMgAygLMhMudmlkZW9fY29yZS5Db21tYW5kUghjb21tYW5kcw==');

@$core.Deprecated('Use executionProgressDescriptor instead')
const ExecutionProgress$json = {
  '1': 'ExecutionProgress',
  '2': [
    {'1': 'progress_percentage', '3': 1, '4': 1, '5': 5, '10': 'progressPercentage'},
    {'1': 'current_task', '3': 2, '4': 1, '5': 9, '10': 'currentTask'},
    {'1': 'is_finished', '3': 3, '4': 1, '5': 8, '10': 'isFinished'},
    {'1': 'has_error', '3': 4, '4': 1, '5': 8, '10': 'hasError'},
    {'1': 'error_details', '3': 5, '4': 1, '5': 9, '10': 'errorDetails'},
  ],
};

/// Descriptor for `ExecutionProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executionProgressDescriptor = $convert.base64Decode(
    'ChFFeGVjdXRpb25Qcm9ncmVzcxIvChNwcm9ncmVzc19wZXJjZW50YWdlGAEgASgFUhJwcm9ncm'
    'Vzc1BlcmNlbnRhZ2USIQoMY3VycmVudF90YXNrGAIgASgJUgtjdXJyZW50VGFzaxIfCgtpc19m'
    'aW5pc2hlZBgDIAEoCFIKaXNGaW5pc2hlZBIbCgloYXNfZXJyb3IYBCABKAhSCGhhc0Vycm9yEi'
    'MKDWVycm9yX2RldGFpbHMYBSABKAlSDGVycm9yRGV0YWlscw==');
