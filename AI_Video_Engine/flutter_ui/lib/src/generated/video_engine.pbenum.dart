//
//  Generated code. Do not modify.
//  source: video_engine.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CommandType extends $pb.ProtobufEnum {
  static const CommandType UNKNOWN = CommandType._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const CommandType CUT_SEGMENT = CommandType._(1, _omitEnumNames ? '' : 'CUT_SEGMENT');
  static const CommandType STABILIZE = CommandType._(2, _omitEnumNames ? '' : 'STABILIZE');
  static const CommandType COLOR_CORRECT = CommandType._(3, _omitEnumNames ? '' : 'COLOR_CORRECT');
  static const CommandType AUDIO_DENOISE = CommandType._(4, _omitEnumNames ? '' : 'AUDIO_DENOISE');

  static const $core.List<CommandType> values = <CommandType> [
    UNKNOWN,
    CUT_SEGMENT,
    STABILIZE,
    COLOR_CORRECT,
    AUDIO_DENOISE,
  ];

  static final $core.Map<$core.int, CommandType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CommandType? valueOf($core.int value) => _byValue[value];

  const CommandType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
