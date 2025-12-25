/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/dalieu_logo.png
  AssetGenImage get dalieuLogo =>
      const AssetGenImage('assets/images/dalieu_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [dalieuLogo];
}

class $AssetsOverlaysGen {
  const $AssetsOverlaysGen();

  /// File path: assets/overlays/895ba2df-0f7b-497b-9568-cabdb547652b.jpeg
  AssetGenImage get a895ba2df0f7b497b9568Cabdb547652b => const AssetGenImage(
      'assets/overlays/895ba2df-0f7b-497b-9568-cabdb547652b.jpeg');

  /// File path: assets/overlays/body_front.jpeg
  AssetGenImage get bodyFront =>
      const AssetGenImage('assets/overlays/body_front.jpeg');

  /// File path: assets/overlays/face_front.jpeg
  AssetGenImage get faceFront =>
      const AssetGenImage('assets/overlays/face_front.jpeg');

  /// File path: assets/overlays/face_left.jpeg
  AssetGenImage get faceLeft =>
      const AssetGenImage('assets/overlays/face_left.jpeg');

  /// File path: assets/overlays/foot_bottom.jpeg
  AssetGenImage get footBottom =>
      const AssetGenImage('assets/overlays/foot_bottom.jpeg');

  /// File path: assets/overlays/foot_top.jpeg
  AssetGenImage get footTop =>
      const AssetGenImage('assets/overlays/foot_top.jpeg');

  /// File path: assets/overlays/forearm_inner.jpeg
  AssetGenImage get forearmInner =>
      const AssetGenImage('assets/overlays/forearm_inner.jpeg');

  /// File path: assets/overlays/genital.jpeg
  AssetGenImage get genital =>
      const AssetGenImage('assets/overlays/genital.jpeg');

  /// File path: assets/overlays/hand_back.jpeg
  AssetGenImage get handBack =>
      const AssetGenImage('assets/overlays/hand_back.jpeg');

  /// File path: assets/overlays/upperarm_inner.jpeg
  AssetGenImage get upperarmInner =>
      const AssetGenImage('assets/overlays/upperarm_inner.jpeg');

  /// List of all assets
  List<AssetGenImage> get values => [
        a895ba2df0f7b497b9568Cabdb547652b,
        bodyFront,
        faceFront,
        faceLeft,
        footBottom,
        footTop,
        forearmInner,
        genital,
        handBack,
        upperarmInner
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsOverlaysGen overlays = $AssetsOverlaysGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
