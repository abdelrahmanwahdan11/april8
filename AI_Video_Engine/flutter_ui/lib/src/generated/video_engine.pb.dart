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

import 'video_engine.pbenum.dart';

export 'video_engine.pbenum.dart';

class Command extends $pb.GeneratedMessage {
  factory Command({
    CommandType? type,
    $core.int? startTimeMs,
    $core.int? endTimeMs,
    $core.Map<$core.String, $core.String>? parameters,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (startTimeMs != null) {
      $result.startTimeMs = startTimeMs;
    }
    if (endTimeMs != null) {
      $result.endTimeMs = endTimeMs;
    }
    if (parameters != null) {
      $result.parameters.addAll(parameters);
    }
    return $result;
  }
  Command._() : super();
  factory Command.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Command.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Command', package: const $pb.PackageName(_omitMessageNames ? '' : 'video_core'), createEmptyInstance: create)
    ..e<CommandType>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: CommandType.UNKNOWN, valueOf: CommandType.valueOf, enumValues: CommandType.values)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'startTimeMs', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'endTimeMs', $pb.PbFieldType.O3)
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'parameters', entryClassName: 'Command.ParametersEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('video_core'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Command clone() => Command()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Command copyWith(void Function(Command) updates) => super.copyWith((message) => updates(message as Command)) as Command;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Command create() => Command._();
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => $pb.PbList<Command>();
  @$core.pragma('dart2js:noInline')
  static Command getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Command>(create);
  static Command? _defaultInstance;

  @$pb.TagNumber(1)
  CommandType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(CommandType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get startTimeMs => $_getIZ(1);
  @$pb.TagNumber(2)
  set startTimeMs($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStartTimeMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTimeMs() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get endTimeMs => $_getIZ(2);
  @$pb.TagNumber(3)
  set endTimeMs($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEndTimeMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndTimeMs() => clearField(3);

  @$pb.TagNumber(4)
  $core.Map<$core.String, $core.String> get parameters => $_getMap(3);
}

class CorrectionPlan extends $pb.GeneratedMessage {
  factory CorrectionPlan({
    $core.String? inputVideoPath,
    $core.String? outputVideoPath,
    $core.Iterable<Command>? commands,
  }) {
    final $result = create();
    if (inputVideoPath != null) {
      $result.inputVideoPath = inputVideoPath;
    }
    if (outputVideoPath != null) {
      $result.outputVideoPath = outputVideoPath;
    }
    if (commands != null) {
      $result.commands.addAll(commands);
    }
    return $result;
  }
  CorrectionPlan._() : super();
  factory CorrectionPlan.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CorrectionPlan.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CorrectionPlan', package: const $pb.PackageName(_omitMessageNames ? '' : 'video_core'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'inputVideoPath')
    ..aOS(2, _omitFieldNames ? '' : 'outputVideoPath')
    ..pc<Command>(3, _omitFieldNames ? '' : 'commands', $pb.PbFieldType.PM, subBuilder: Command.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CorrectionPlan clone() => CorrectionPlan()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CorrectionPlan copyWith(void Function(CorrectionPlan) updates) => super.copyWith((message) => updates(message as CorrectionPlan)) as CorrectionPlan;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorrectionPlan create() => CorrectionPlan._();
  CorrectionPlan createEmptyInstance() => create();
  static $pb.PbList<CorrectionPlan> createRepeated() => $pb.PbList<CorrectionPlan>();
  @$core.pragma('dart2js:noInline')
  static CorrectionPlan getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CorrectionPlan>(create);
  static CorrectionPlan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get inputVideoPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set inputVideoPath($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInputVideoPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearInputVideoPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get outputVideoPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set outputVideoPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOutputVideoPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutputVideoPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<Command> get commands => $_getList(2);
}

class ExecutionProgress extends $pb.GeneratedMessage {
  factory ExecutionProgress({
    $core.int? progressPercentage,
    $core.String? currentTask,
    $core.bool? isFinished,
    $core.bool? hasError,
    $core.String? errorDetails,
  }) {
    final $result = create();
    if (progressPercentage != null) {
      $result.progressPercentage = progressPercentage;
    }
    if (currentTask != null) {
      $result.currentTask = currentTask;
    }
    if (isFinished != null) {
      $result.isFinished = isFinished;
    }
    if (hasError != null) {
      $result.hasError = hasError;
    }
    if (errorDetails != null) {
      $result.errorDetails = errorDetails;
    }
    return $result;
  }
  ExecutionProgress._() : super();
  factory ExecutionProgress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExecutionProgress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExecutionProgress', package: const $pb.PackageName(_omitMessageNames ? '' : 'video_core'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'progressPercentage', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'currentTask')
    ..aOB(3, _omitFieldNames ? '' : 'isFinished')
    ..aOB(4, _omitFieldNames ? '' : 'hasError')
    ..aOS(5, _omitFieldNames ? '' : 'errorDetails')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExecutionProgress clone() => ExecutionProgress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExecutionProgress copyWith(void Function(ExecutionProgress) updates) => super.copyWith((message) => updates(message as ExecutionProgress)) as ExecutionProgress;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecutionProgress create() => ExecutionProgress._();
  ExecutionProgress createEmptyInstance() => create();
  static $pb.PbList<ExecutionProgress> createRepeated() => $pb.PbList<ExecutionProgress>();
  @$core.pragma('dart2js:noInline')
  static ExecutionProgress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExecutionProgress>(create);
  static ExecutionProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get progressPercentage => $_getIZ(0);
  @$pb.TagNumber(1)
  set progressPercentage($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProgressPercentage() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgressPercentage() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get currentTask => $_getSZ(1);
  @$pb.TagNumber(2)
  set currentTask($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurrentTask() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentTask() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isFinished => $_getBF(2);
  @$pb.TagNumber(3)
  set isFinished($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsFinished() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsFinished() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasError => $_getBF(3);
  @$pb.TagNumber(4)
  set hasError($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasError() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get errorDetails => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorDetails($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasErrorDetails() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorDetails() => clearField(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
