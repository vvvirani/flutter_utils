import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ScreenUtil {
  static const Size defaultSize = Size(360, 690);
  static final ScreenUtil _instance = ScreenUtil._();

  late Size _uiSize;

  late Orientation _orientation;

  late double _screenWidth;
  late double _screenHeight;
  late bool _minTextAdapt;
  BuildContext? _context;
  late bool _splitScreenMode;

  ScreenUtil._();

  factory ScreenUtil() {
    return _instance;
  }

  static Future<void> ensureScreenSize([
    FlutterWindow? window,
    Duration duration = const Duration(milliseconds: 10),
  ]) async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    window ??= binding.window;

    if (window.viewConfiguration.geometry.isEmpty) {
      return Future.delayed(duration, () async {
        binding.deferFirstFrame();
        await ensureScreenSize(window, duration);
        return binding.allowFirstFrame();
      });
    }
  }

  Set<Element>? _elementsToRebuild;

  static void registerToBuild(
    BuildContext context, [
    bool withDescendants = false,
  ]) {
    (_instance._elementsToRebuild ??= {}).add(context as Element);

    if (withDescendants) {
      context.visitChildren((element) {
        registerToBuild(element, true);
      });
    }
  }

  static Future<void> init(
    BuildContext context, {
    Size designSize = defaultSize,
    bool splitScreenMode = false,
    bool minTextAdapt = false,
    bool scaleByHeight = false,
  }) async {
    Element? navigatorContext = Navigator.maybeOf(context)?.context as Element?;
    InheritedElement? mediaQueryContext =
        navigatorContext?.getElementForInheritedWidgetOfExactType<MediaQuery>();

    Completer<void> initCompleter = Completer<void>();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      mediaQueryContext?.visitChildElements((el) => _instance._context = el);
      if (_instance._context != null) initCompleter.complete();
    });

    MediaQueryData? deviceData =
        MediaQuery.maybeOf(context).nonEmptySizeOrNull();

    Size deviceSize = deviceData?.size ?? designSize;
    Orientation orientation = deviceData?.orientation ??
        (deviceSize.width > deviceSize.height
            ? Orientation.landscape
            : Orientation.portrait);

    _instance
      .._context = scaleByHeight ? null : context
      .._uiSize = designSize
      .._splitScreenMode = splitScreenMode
      .._minTextAdapt = minTextAdapt
      .._orientation = orientation
      .._screenWidth = scaleByHeight
          ? (deviceSize.height * designSize.width) / designSize.height
          : deviceSize.width
      .._screenHeight = deviceSize.height;

    _instance._elementsToRebuild?.forEach((el) => el.markNeedsBuild());

    return initCompleter.future;
  }

  Orientation get orientation => _orientation;

  double get textScaleFactor =>
      _context != null ? MediaQuery.of(_context!).textScaleFactor : 1;

  double? get pixelRatio =>
      _context != null ? MediaQuery.of(_context!).devicePixelRatio : 1;

  double get screenWidth {
    return _context != null
        ? MediaQuery.of(_context!).size.width
        : _screenWidth;
  }

  double get screenHeight {
    return _context != null
        ? MediaQuery.of(_context!).size.height
        : _screenHeight;
  }

  double get statusBarHeight {
    return _context == null ? 0 : MediaQuery.of(_context!).padding.top;
  }

  double get bottomBarHeight {
    return _context == null ? 0 : MediaQuery.of(_context!).padding.bottom;
  }

  double get scaleWidth => screenWidth / _uiSize.width;

  double get scaleHeight {
    return (_splitScreenMode ? max(screenHeight, 700) : screenHeight) /
        _uiSize.height;
  }

  double get scaleText {
    return _minTextAdapt ? min(scaleWidth, scaleHeight) : scaleWidth;
  }

  double setWidth(num width) => width * scaleWidth;

  double setHeight(num height) => height * scaleHeight;

  double radius(num r) => r * min(scaleWidth, scaleHeight);

  double setSp(num fontSize) => fontSize * scaleText;

  Widget setVerticalSpacing(num height) => SizedBox(height: setHeight(height));

  Widget setVerticalSpacingFromWidth(num height) {
    return SizedBox(height: setWidth(height));
  }

  Widget setHorizontalSpacing(num width) => SizedBox(width: setWidth(width));

  Widget setHorizontalSpacingRadius(num width) {
    return SizedBox(width: radius(width));
  }

  Widget setVerticalSpacingRadius(num height) {
    return SizedBox(height: radius(height));
  }
}

extension on MediaQueryData? {
  MediaQueryData? nonEmptySizeOrNull() {
    if (this?.size.isEmpty ?? true) {
      return null;
    } else {
      return this;
    }
  }
}
