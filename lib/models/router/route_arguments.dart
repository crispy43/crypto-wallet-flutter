import 'dart:convert';

import 'package:flutter/foundation.dart';

/// # RouteArguments
/// 화면 전환시 애니메이션 타입, payload(파라미터)를 전달
/// 상태 값 캐싱이 필요 없는 경우 isMaintainState를 false로
/// 전체 화면 다이얼로그(모달)로 화면을 띄울 경우 isFullscreenDialog를 true로
class RouteArguments {
  final String? animationType;
  final bool isMaintainState;
  final bool isFullscreenDialog;
  final Map<String, dynamic>? payload;
  RouteArguments({
    this.animationType,
    this.isMaintainState = true,
    this.isFullscreenDialog = false,
    this.payload,
  });

  RouteArguments copyWith({
    String? animationType,
    bool? isMaintainState,
    bool? isFullscreenDialog,
    Map<String, dynamic>? payload,
  }) {
    return RouteArguments(
      animationType: animationType ?? this.animationType,
      isMaintainState: isMaintainState ?? this.isMaintainState,
      isFullscreenDialog: isFullscreenDialog ?? this.isFullscreenDialog,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'animationType': animationType,
      'isMaintainState': isMaintainState,
      'isFullscreenDialog': isFullscreenDialog,
      'payload': payload,
    };
  }

  factory RouteArguments.fromMap(Map<String, dynamic> map) {
    return RouteArguments(
      animationType: map['animationType'],
      isMaintainState: map['isMaintainState'] ?? true,
      isFullscreenDialog: map['isFullscreenDialog'] ?? false,
      payload: Map<String, dynamic>.from(map['payload']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteArguments.fromJson(String source) =>
      RouteArguments.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RouteArguments(animationType: '
        '$animationType, isMaintainState: $isMaintainState, '
        'isFullscreenDialogWord: $isFullscreenDialog, payloadWord: '
        '$payload)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteArguments &&
        other.animationType == animationType &&
        other.isMaintainState == isMaintainState &&
        other.isFullscreenDialog == isFullscreenDialog &&
        mapEquals(other.payload, payload);
  }

  @override
  int get hashCode {
    return animationType.hashCode ^
        isMaintainState.hashCode ^
        isFullscreenDialog.hashCode ^
        payload.hashCode;
  }
}
