// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui';

class GradientElevatedButton extends ButtonStyleButton {
  /// Create an ElevatedButton.
  const GradientElevatedButton({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    required super.child,
  });

  /// Create an elevated button from a pair of widgets that serve as the button's
  /// [icon] and [label].
  ///
  /// The icon and label are arranged in a row and padded by 12 logical pixels
  /// at the start, and 16 at the end, with an 8 pixel gap in between.
  factory GradientElevatedButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    GradientButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    required Widget icon,
    required Widget label,
  }) = _ElevatedButtonWithIcon;

  /// A static convenience method that constructs an elevated button
  /// [GradientButtonStyle] given simple values.
  ///
  /// The [foregroundColor] and [disabledForegroundColor] colors are used
  /// to create a [WidgetStateProperty] [GradientButtonStyle.foregroundColor], and
  /// a derived [GradientButtonStyle.overlayColor].
  ///
  /// The [backgroundColor] and [disabledBackgroundColor] colors are
  /// used to create a [WidgetStateProperty] [GradientButtonStyle.backgroundColor].
  ///
  /// The button's elevations are defined relative to the [elevation]
  /// parameter. The disabled elevation is the same as the parameter
  /// value, [elevation] + 2 is used when the button is hovered
  /// or focused, and elevation + 6 is used when the button is pressed.
  ///
  /// Similarly, the [enabledMouseCursor] and [disabledMouseCursor]
  /// parameters are used to construct [GradientButtonStyle].mouseCursor.
  ///
  /// All of the other parameters are either used directly or used to
  /// create a [WidgetStateProperty] with a single value for all
  /// states.
  ///
  /// All parameters default to null, by default this method returns
  /// a [GradientButtonStyle] that doesn't override anything.
  ///
  /// For example, to override the default text and icon colors for a
  /// [GradientElevatedButton], as well as its overlay color, with all of the
  /// standard opacity adjustments for the pressed, focused, and
  /// hovered states, one could write:
  ///
  /// ```dart
  /// ElevatedButton(
  ///   style: ElevatedButton.styleFrom(foregroundColor: Colors.green),
  ///   onPressed: () {
  ///     // ...
  ///   },
  ///   child: const Text('Jump'),
  /// ),
  /// ```
  ///
  /// And to change the fill color:
  ///
  /// ```dart
  /// ElevatedButton(
  ///   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
  ///   onPressed: () {
  ///     // ...
  ///   },
  ///   child: const Text('Meow'),
  /// ),
  /// ```
  ///
  static GradientButtonStyle styleFrom({
    Gradient? gradient,
    Color? foregroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    double? elevation,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    BorderSide? side,
    OutlinedBorder? shape,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
    @Deprecated('Use backgroundColor instead. '
        'This feature was deprecated after v3.1.0.')
    Color? primary,
    @Deprecated('Use foregroundColor instead. '
        'This feature was deprecated after v3.1.0.')
    Color? onPrimary,
    @Deprecated(
        'Use disabledForegroundColor and disabledBackgroundColor instead. '
        'This feature was deprecated after v3.1.0.')
    Color? onSurface,
  }) {
    final Color? foreground = foregroundColor ?? onPrimary;
    final Color? disabledForeground =
        disabledForegroundColor ?? onSurface?.withOpacity(0.38);
    final WidgetStateProperty<Color?>? foregroundColorProp =
        (foreground == null && disabledForeground == null)
            ? null
            : _ElevatedButtonDefaultColor(foreground, disabledForeground);
    final WidgetStateProperty<Color?>? overlayColor =
        (foreground == null) ? null : _ElevatedButtonDefaultOverlay(foreground);
    final WidgetStateProperty<double>? elevationValue =
        (elevation == null) ? null : _ElevatedButtonDefaultElevation(elevation);
    final WidgetStateProperty<MouseCursor?>? mouseCursor =
        (enabledMouseCursor == null && disabledMouseCursor == null)
            ? null
            : _ElevatedButtonDefaultMouseCursor(
                enabledMouseCursor, disabledMouseCursor);

    return GradientButtonStyle(
      gradient: gradient,
      textStyle: WidgetStatePropertyAll<TextStyle?>(textStyle),
      foregroundColor: foregroundColorProp,
      overlayColor: overlayColor,
      shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
      surfaceTintColor: ButtonStyleButton.allOrNull<Color>(surfaceTintColor),
      elevation: elevationValue,
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize),
      fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
      maximumSize: ButtonStyleButton.allOrNull<Size>(maximumSize),
      side: ButtonStyleButton.allOrNull<BorderSide>(side),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      mouseCursor: mouseCursor,
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
      splashFactory: splashFactory,
    );
  }

  /// Defines the button's default appearance.
  ///
  /// The button [child]'s [Text] and [Icon] widgets are rendered with
  /// the [GradientButtonStyle]'s foreground color. The button's [InkWell] adds
  /// the style's overlay color when the button is focused, hovered
  /// or pressed. The button's background color becomes its [Material]
  /// color.
  ///
  /// All of the ButtonStyle's defaults appear below. In this list
  /// "Theme.foo" is shorthand for `Theme.of(context).foo`. Color
  /// scheme values like "onSurface(0.38)" are shorthand for
  /// `onSurface.withOpacity(0.38)`. [WidgetStateProperty] valued
  /// properties that are not followed by a sublist have the same
  /// value for all states, otherwise the values are as specified for
  /// each state, and "others" means all other states.
  ///
  /// The `textScaleFactor` is the value of
  /// `MediaQuery.of(context).textScaleFactor` and the names of the
  /// EdgeInsets constructors and `EdgeInsetsGeometry.lerp` have been
  /// abbreviated for readability.
  ///
  /// The color of the [ButtonStyle.textStyle] is not used, the
  /// [ButtonStyle.foregroundColor] color is used instead.
  ///
  /// ## Material 2 defaults
  ///
  /// * `textStyle` - Theme.textTheme.button
  /// * `backgroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.12)
  ///   * others - Theme.colorScheme.primary
  /// * `foregroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.38)
  ///   * others - Theme.colorScheme.onPrimary
  /// * `overlayColor`
  ///   * hovered - Theme.colorScheme.onPrimary(0.08)
  ///   * focused or pressed - Theme.colorScheme.onPrimary(0.24)
  /// * `shadowColor` - Theme.shadowColor
  /// * `elevation`
  ///   * disabled - 0
  ///   * default - 2
  ///   * hovered or focused - 4
  ///   * pressed - 8
  /// * `padding`
  ///   * `textScaleFactor <= 1` - horizontal(16)
  ///   * `1 < textScaleFactor <= 2` - lerp(horizontal(16), horizontal(8))
  ///   * `2 < textScaleFactor <= 3` - lerp(horizontal(8), horizontal(4))
  ///   * `3 < textScaleFactor` - horizontal(4)
  /// * `minimumSize` - Size(64, 36)
  /// * `fixedSize` - null
  /// * `maximumSize` - Size.infinite
  /// * `side` - null
  /// * `shape` - RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
  /// * `mouseCursor`
  ///   * disabled - SystemMouseCursors.basic
  ///   * others - SystemMouseCursors.click
  /// * `visualDensity` - theme.visualDensity
  /// * `tapTargetSize` - theme.materialTapTargetSize
  /// * `animationDuration` - kThemeChangeDuration
  /// * `enableFeedback` - true
  /// * `alignment` - Alignment.center
  /// * `splashFactory` - InkRipple.splashFactory
  ///
  /// The default padding values for the [ElevatedButton.icon] factory are slightly different:
  ///
  /// * `padding`
  ///   * `textScaleFactor <= 1` - start(12) end(16)
  ///   * `1 < textScaleFactor <= 2` - lerp(start(12) end(16), horizontal(8))
  ///   * `2 < textScaleFactor <= 3` - lerp(horizontal(8), horizontal(4))
  ///   * `3 < textScaleFactor` - horizontal(4)
  ///
  /// The default value for `side`, which defines the appearance of the button's
  /// outline, is null. That means that the outline is defined by the button
  /// shape's [OutlinedBorder.side]. Typically the default value of an
  /// [OutlinedBorder]'s side is [BorderSide.none], so an outline is not drawn.
  ///
  /// ## Material 3 defaults
  ///
  /// If [ThemeData.useMaterial3] is set to true the following defaults will
  /// be used:
  ///
  /// * `textStyle` - Theme.textTheme.labelLarge
  /// * `backgroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.12)
  ///   * others - Theme.colorScheme.surface
  /// * `foregroundColor`
  ///   * disabled - Theme.colorScheme.onSurface(0.38)
  ///   * others - Theme.colorScheme.primary
  /// * `overlayColor`
  ///   * hovered - Theme.colorScheme.primary(0.08)
  ///   * focused or pressed - Theme.colorScheme.primary(0.12)
  /// * `shadowColor` - Theme.colorScheme.shadow
  /// * `surfaceTintColor` - Theme.colorScheme.surfaceTint
  /// * `elevation`
  ///   * disabled - 0
  ///   * default - 1
  ///   * hovered - 3
  ///   * focused or pressed - 1
  /// * `padding`
  ///   * `textScaleFactor <= 1` - horizontal(16)
  ///   * `1 < textScaleFactor <= 2` - lerp(horizontal(16), horizontal(8))
  ///   * `2 < textScaleFactor <= 3` - lerp(horizontal(8), horizontal(4))
  ///   * `3 < textScaleFactor` - horizontal(4)
  /// * `minimumSize` - Size(64, 40)
  /// * `fixedSize` - null
  /// * `maximumSize` - Size.infinite
  /// * `side` - null
  /// * `shape` - StadiumBorder()
  /// * `mouseCursor`
  ///   * disabled - SystemMouseCursors.basic
  ///   * others - SystemMouseCursors.click
  /// * `visualDensity` - Theme.visualDensity
  /// * `tapTargetSize` - Theme.materialTapTargetSize
  /// * `animationDuration` - kThemeChangeDuration
  /// * `enableFeedback` - true
  /// * `alignment` - Alignment.center
  /// * `splashFactory` - Theme.splashFactory
  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Theme.of(context).useMaterial3
        ? _ElevatedButtonDefaultsM3(context)
        : styleFrom(
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
            disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
            shadowColor: theme.shadowColor,
            elevation: 2,
            textStyle: theme.textTheme.labelLarge,
            padding: _scaledPadding(context),
            minimumSize: const Size(64, 36),
            maximumSize: Size.infinite,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            enabledMouseCursor: SystemMouseCursors.click,
            disabledMouseCursor: SystemMouseCursors.basic,
            visualDensity: theme.visualDensity,
            tapTargetSize: theme.materialTapTargetSize,
            animationDuration: kThemeChangeDuration,
            enableFeedback: true,
            alignment: Alignment.center,
            splashFactory: InkRipple.splashFactory,
          );
  }

  /// Returns the [ElevatedButtonThemeData.style] of the closest
  /// [ElevatedButtonTheme] ancestor.
  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    return ElevatedButtonTheme.of(context).style;
  }
}

EdgeInsetsGeometry _scaledPadding(BuildContext context) {
  return ButtonStyleButton.scaledPadding(
    const EdgeInsets.symmetric(horizontal: 16),
    const EdgeInsets.symmetric(horizontal: 8),
    const EdgeInsets.symmetric(horizontal: 4),
    1,
  );
}

@immutable
class _ElevatedButtonDefaultColor extends WidgetStateProperty<Color?>
    with Diagnosticable {
  _ElevatedButtonDefaultColor(this.color, this.disabled);

  final Color? color;
  final Color? disabled;

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabled;
    }
    return color;
  }
}

@immutable
class _ElevatedButtonDefaultOverlay extends WidgetStateProperty<Color?>
    with Diagnosticable {
  _ElevatedButtonDefaultOverlay(this.overlay);

  final Color overlay;

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return overlay.withOpacity(0.08);
    }
    if (states.contains(WidgetState.focused) ||
        states.contains(WidgetState.pressed)) {
      return overlay.withOpacity(0.24);
    }
    return null;
  }
}

@immutable
class _ElevatedButtonDefaultElevation extends WidgetStateProperty<double>
    with Diagnosticable {
  _ElevatedButtonDefaultElevation(this.elevation);

  final double elevation;

  @override
  double resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return 0;
    }
    if (states.contains(WidgetState.hovered)) {
      return elevation + 2;
    }
    if (states.contains(WidgetState.focused)) {
      return elevation + 2;
    }
    if (states.contains(WidgetState.pressed)) {
      return elevation + 6;
    }
    return elevation;
  }
}

@immutable
class _ElevatedButtonDefaultMouseCursor
    extends WidgetStateProperty<MouseCursor?> with Diagnosticable {
  _ElevatedButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor? enabledCursor;
  final MouseCursor? disabledCursor;

  @override
  MouseCursor? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabledCursor;
    }
    return enabledCursor;
  }
}

class _ElevatedButtonWithIcon extends GradientElevatedButton {
  _ElevatedButtonWithIcon({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    super.statesController,
    required Widget icon,
    required Widget label,
  }) : super(
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: _ElevatedButtonWithIconChild(icon: icon, label: label),
        );

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsetsDirectional.fromSTEB(12, 0, 16, 0),
      const EdgeInsets.symmetric(horizontal: 8),
      const EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
      1,
    );
    return super.defaultStyleOf(context).copyWith(
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(scaledPadding),
        );
  }
}

class _ElevatedButtonWithIconChild extends StatelessWidget {
  const _ElevatedButtonWithIconChild({required this.label, required this.icon});

  final Widget label;
  final Widget icon;

  get math => null;

  @override
  Widget build(BuildContext context) {
    const double scale = 1;
    final double gap =
        scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[icon, SizedBox(width: gap), Flexible(child: label)],
    );
  }
}

// BEGIN GENERATED TOKEN PROPERTIES - ElevatedButton

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

// Token database version: v0_143

class _ElevatedButtonDefaultsM3 extends ButtonStyle {
  _ElevatedButtonDefaultsM3(this.context)
      : super(
          animationDuration: kThemeChangeDuration,
          enableFeedback: true,
          alignment: Alignment.center,
        );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
      WidgetStatePropertyAll<TextStyle?>(
          Theme.of(context).textTheme.labelLarge);

  @override
  WidgetStateProperty<Color?>? get backgroundColor =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return _colors.onSurface.withOpacity(0.12);
        }
        return _colors.surface;
      });

  @override
  WidgetStateProperty<Color?>? get foregroundColor =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return _colors.onSurface.withOpacity(0.38);
        }
        return _colors.primary;
      });

  @override
  WidgetStateProperty<Color?>? get overlayColor =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary.withOpacity(0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary.withOpacity(0.12);
        }
        if (states.contains(WidgetState.pressed)) {
          return _colors.primary.withOpacity(0.12);
        }
        return null;
      });

  @override
  WidgetStateProperty<Color>? get shadowColor =>
      WidgetStatePropertyAll<Color>(_colors.shadow);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor =>
      WidgetStatePropertyAll<Color>(_colors.surfaceTint);

  @override
  WidgetStateProperty<double>? get elevation =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return 0.0;
        }
        if (states.contains(WidgetState.hovered)) {
          return 3.0;
        }
        if (states.contains(WidgetState.focused)) {
          return 1.0;
        }
        if (states.contains(WidgetState.pressed)) {
          return 1.0;
        }
        return 1.0;
      });

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
      WidgetStatePropertyAll<EdgeInsetsGeometry>(_scaledPadding(context));

  @override
  WidgetStateProperty<Size>? get minimumSize =>
      const WidgetStatePropertyAll<Size>(Size(64.0, 40.0));

  // No default fixedSize

  @override
  WidgetStateProperty<Size>? get maximumSize =>
      const WidgetStatePropertyAll<Size>(Size.infinite);

  // No default side

  @override
  WidgetStateProperty<OutlinedBorder>? get shape =>
      const WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder());

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.basic;
        }
        return SystemMouseCursors.click;
      });

  @override
  VisualDensity? get visualDensity => Theme.of(context).visualDensity;

  @override
  MaterialTapTargetSize? get tapTargetSize =>
      Theme.of(context).materialTapTargetSize;

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;
}

/// The base [StatefulWidget] class for buttons whose style is defined by a [ButtonStyle] object.
///
/// Concrete subclasses must override [defaultStyleOf] and [themeStyleOf].
///
/// See also:
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [FilledButton], a filled button that doesn't elevate when pressed.
///  * [FilledButton.tonal], a filled button variant that uses a secondary fill color.
///  * [OutlinedButton], a button with an outlined border and no fill color.
///  * [TextButton], a button with no outline or fill color.
///  * <https://m3.material.io/components/buttons/overview>, an overview of each of
///    the Material Design button types and how they should be used in designs.
abstract class ButtonStyleButton extends StatefulWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const ButtonStyleButton({
    super.key,
    required this.onPressed,
    required this.onLongPress,
    required this.onHover,
    required this.onFocusChange,
    required this.style,
    required this.focusNode,
    required this.autofocus,
    required this.clipBehavior,
    this.statesController,
    required this.child,
  });

  /// Called when the button is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onLongPress;

  /// Called when a pointer enters or exits the button response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  final ValueChanged<bool>? onHover;

  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  final ValueChanged<bool>? onFocusChange;

  /// Customizes this button's appearance.
  ///
  /// Non-null properties of this style override the corresponding
  /// properties in [themeStyleOf] and [defaultStyleOf]. [WidgetStateProperty]s
  /// that resolve to non-null values will similarly override the corresponding
  /// [WidgetStateProperty]s in [themeStyleOf] and [defaultStyleOf].
  ///
  /// Null by default.
  final GradientButtonStyle? style;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip clipBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.inkwell.statesController}
  final WidgetStatesController? statesController;

  /// Typically the button's label.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// Returns a non-null [ButtonStyle] that's based primarily on the [Theme]'s
  /// [ThemeData.textTheme] and [ThemeData.colorScheme].
  ///
  /// The returned style can be overridden by the [style] parameter and
  /// by the style returned by [themeStyleOf]. For example the default
  /// style of the [TextButton] subclass can be overridden with its
  /// [TextButton.style] constructor parameter, or with a
  /// [TextButtonTheme].
  ///
  /// Concrete button subclasses should return a ButtonStyle that
  /// has no null properties, and where all of the [WidgetStateProperty]
  /// properties resolve to non-null values.
  ///
  /// See also:
  ///
  ///  * [themeStyleOf], Returns the ButtonStyle of this button's component theme.
  @protected
  ButtonStyle defaultStyleOf(BuildContext context);

  /// Returns the ButtonStyle that belongs to the button's component theme.
  ///
  /// The returned style can be overridden by the [style] parameter.
  ///
  /// Concrete button subclasses should return the ButtonStyle for the
  /// nearest subclass-specific inherited theme, and if no such theme
  /// exists, then the same value from the overall [Theme].
  ///
  /// See also:
  ///
  ///  * [defaultStyleOf], Returns the default [ButtonStyle] for this button.
  @protected
  ButtonStyle? themeStyleOf(BuildContext context);

  /// Whether the button is enabled or disabled.
  ///
  /// Buttons are disabled by default. To enable a button, set its [onPressed]
  /// or [onLongPress] properties to a non-null value.
  bool get enabled => onPressed != null || onLongPress != null;

  @override
  State<ButtonStyleButton> createState() => _ButtonStyleState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
    properties.add(
        DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
  }

  /// Returns null if [value] is null, otherwise `WidgetStatePropertyAll<T>(value)`.
  ///
  /// A convenience method for subclasses.
  static WidgetStateProperty<T>? allOrNull<T>(T? value) =>
      value == null ? null : WidgetStatePropertyAll<T>(value);

  /// Returns an interpolated value based on the [textScaleFactor] parameter:
  ///
  ///  * 0 - 1 [geometry1x]
  ///  * 1 - 2 lerp([geometry1x], [geometry2x], [textScaleFactor] - 1)
  ///  * 2 - 3 lerp([geometry2x], [geometry3x], [textScaleFactor] - 2)
  ///  * otherwise [geometry3x]
  ///
  /// A convenience method for subclasses.
  static EdgeInsetsGeometry scaledPadding(
    EdgeInsetsGeometry geometry1x,
    EdgeInsetsGeometry geometry2x,
    EdgeInsetsGeometry geometry3x,
    double textScaleFactor,
  ) {
    if (textScaleFactor <= 1) {
      return geometry1x;
    } else if (textScaleFactor >= 3) {
      return geometry3x;
    } else if (textScaleFactor <= 2) {
      return EdgeInsetsGeometry.lerp(
          geometry1x, geometry2x, textScaleFactor - 1)!;
    }
    return EdgeInsetsGeometry.lerp(
        geometry2x, geometry3x, textScaleFactor - 2)!;
  }
}

/// The base [State] class for buttons whose style is defined by a [ButtonStyle] object.
///
/// See also:
///
///  * [ButtonStyleButton], the [StatefulWidget] subclass for which this class is the [State].
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [FilledButton], a filled ButtonStyleButton that doesn't elevate when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
///  * [TextButton], a simple button without a shadow.
class _ButtonStyleState extends State<ButtonStyleButton>
    with TickerProviderStateMixin {
  AnimationController? controller;
  double? elevation;
  Color? backgroundColor;
  WidgetStatesController? internalStatesController;

  void handleStatesControllerChange() {
    // Force a rebuild to resolve WidgetStateProperty properties
    setState(() {});
  }

  WidgetStatesController get statesController =>
      widget.statesController ?? internalStatesController!;

  void initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = WidgetStatesController();
    }
    statesController.update(WidgetState.disabled, !widget.enabled);
    statesController.addListener(handleStatesControllerChange);
  }

  @override
  void initState() {
    super.initState();
    initStatesController();
  }

  @override
  void didUpdateWidget(ButtonStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statesController != oldWidget.statesController) {
      oldWidget.statesController?.removeListener(handleStatesControllerChange);
      if (widget.statesController != null) {
        internalStatesController?.dispose();
        internalStatesController = null;
      }
      initStatesController();
    }
    if (widget.enabled != oldWidget.enabled) {
      statesController.update(WidgetState.disabled, !widget.enabled);
      if (!widget.enabled) {
        // The button may have been disabled while a press gesture is currently underway.
        statesController.update(WidgetState.pressed, false);
      }
    }
  }

  @override
  void dispose() {
    statesController.removeListener(handleStatesControllerChange);
    internalStatesController?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GradientButtonStyle? widgetStyle = widget.style;
    final GradientButtonStyle? primaryTheme =
        GradientButtonThemeData.of(context);
    final GradientButtonStyle themeStyle = GradientButtonStyle.copyWith(
        style: widget.themeStyleOf(context),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ));
    final GradientButtonStyle defaultStyle = GradientButtonStyle.copyWith(
        style: widget.defaultStyleOf(context),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ));

    T? effectiveValue<T>(T? Function(GradientButtonStyle? style) getProperty) {
      final T? widgetValue = getProperty(widgetStyle);
      final T? primaryThemeValue = getProperty(primaryTheme);
      final T? themeValue = getProperty(themeStyle);

      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? primaryThemeValue ?? themeValue ?? defaultValue;
    }

    T? resolve<T>(
        WidgetStateProperty<T>? Function(GradientButtonStyle? style)
            getProperty) {
      return effectiveValue(
        (GradientButtonStyle? style) {
          return getProperty(style)?.resolve(statesController.value);
        },
      );
    }

    Gradient? resolvedGradient = resolve<Gradient?>(
        (GradientButtonStyle? style) =>
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              return style?.gradient;
            }));
    final double? resolvedElevation =
        resolve<double?>((ButtonStyle? style) => style?.elevation);
    final TextStyle? resolvedTextStyle =
        resolve<TextStyle?>((ButtonStyle? style) => style?.textStyle);

    Color? resolvedBackgroundColor =
        resolve<Color?>((ButtonStyle? style) => style?.backgroundColor);
    final Color? resolvedForegroundColor =
        resolve<Color?>((ButtonStyle? style) => style?.foregroundColor);
    final Color? resolvedShadowColor =
        resolve<Color?>((ButtonStyle? style) => style?.shadowColor);
    final Color? resolvedSurfaceTintColor =
        resolve<Color?>((ButtonStyle? style) => style?.surfaceTintColor);
    final EdgeInsetsGeometry? resolvedPadding =
        resolve<EdgeInsetsGeometry?>((ButtonStyle? style) => style?.padding);
    final Size? resolvedMinimumSize =
        resolve<Size?>((ButtonStyle? style) => style?.minimumSize);
    final Size? resolvedFixedSize =
        resolve<Size?>((ButtonStyle? style) => style?.fixedSize);
    final Size? resolvedMaximumSize =
        resolve<Size?>((ButtonStyle? style) => style?.maximumSize);
    final Color? resolvedIconColor =
        resolve<Color?>((ButtonStyle? style) => style?.iconColor);
    final double? resolvedIconSize =
        resolve<double?>((ButtonStyle? style) => style?.iconSize);
    final BorderSide? resolvedSide =
        resolve<BorderSide?>((ButtonStyle? style) => style?.side);
    final OutlinedBorder? resolvedShape =
        resolve<OutlinedBorder?>((ButtonStyle? style) => style?.shape);

    final WidgetStateMouseCursor mouseCursor = _MouseCursor(
      (Set<WidgetState> states) => effectiveValue(
          (ButtonStyle? style) => style?.mouseCursor?.resolve(states)),
    );

    final WidgetStateProperty<Color?> overlayColor =
        WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) => effectiveValue(
          (ButtonStyle? style) => style?.overlayColor?.resolve(states)),
    );

    final VisualDensity? resolvedVisualDensity =
        effectiveValue((ButtonStyle? style) => style?.visualDensity);
    final MaterialTapTargetSize? resolvedTapTargetSize =
        effectiveValue((ButtonStyle? style) => style?.tapTargetSize);
    final Duration? resolvedAnimationDuration =
        effectiveValue((ButtonStyle? style) => style?.animationDuration);
    final bool? resolvedEnableFeedback =
        effectiveValue((ButtonStyle? style) => style?.enableFeedback);
    final AlignmentGeometry? resolvedAlignment =
        effectiveValue((ButtonStyle? style) => style?.alignment);
    final Offset densityAdjustment = resolvedVisualDensity!.baseSizeAdjustment;
    final InteractiveInkFeatureFactory? resolvedSplashFactory =
        effectiveValue((ButtonStyle? style) => style?.splashFactory);

    BoxConstraints effectiveConstraints =
        resolvedVisualDensity.effectiveConstraints(
      BoxConstraints(
        minWidth: resolvedMinimumSize!.width,
        minHeight: resolvedMinimumSize.height,
        maxWidth: resolvedMaximumSize!.width,
        maxHeight: resolvedMaximumSize.height,
      ),
    );
    if (resolvedFixedSize != null) {
      final Size size = effectiveConstraints.constrain(resolvedFixedSize);
      if (size.width.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(
          minWidth: size.width,
          maxWidth: size.width,
        );
      }
      if (size.height.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(
          minHeight: size.height,
          maxHeight: size.height,
        );
      }
    }

    // Per the Material Design team: don't allow the VisualDensity
    // adjustment to reduce the width of the left/right padding. If we
    // did, VisualDensity.compact, the default for desktop/web, would
    // reduce the horizontal padding to zero.
    final double dy = densityAdjustment.dy;
    final double dx = math.max(0, densityAdjustment.dx);
    final EdgeInsetsGeometry padding = resolvedPadding!
        .add(EdgeInsets.fromLTRB(dx, dy, dx, dy))
        .clamp(EdgeInsets.zero,
            EdgeInsetsGeometry.infinity); // ignore_clamp_double_lint

    // If an opaque button's background is becoming translucent while its
    // elevation is changing, change the elevation first. Material implicitly
    // animates its elevation but not its color. SKIA renders non-zero
    // elevations as a shadow colored fill behind the Material's background.
    if (resolvedAnimationDuration! > Duration.zero &&
        elevation != null &&
        backgroundColor != null &&
        elevation != resolvedElevation &&
        backgroundColor!.value != resolvedBackgroundColor!.value &&
        backgroundColor!.opacity == 1 &&
        resolvedBackgroundColor.opacity < 1 &&
        resolvedElevation == 0) {
      if (controller?.duration != resolvedAnimationDuration) {
        controller?.dispose();
        controller = AnimationController(
          duration: resolvedAnimationDuration,
          vsync: this,
        )..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {}); // Rebuild with the final background color.
            }
          });
      }
      resolvedBackgroundColor =
          backgroundColor; // Defer changing the background color.
      controller!.value = 0;
      controller!.forward();
    }
    elevation = resolvedElevation;
    backgroundColor = resolvedBackgroundColor;
    BorderSide side = BorderSide(
      color: resolvedSide?.color == const Color(0xff000000)
          ? Colors.transparent
          : resolvedSide?.color ?? Colors.transparent,
      style: resolvedSide?.style ?? BorderStyle.solid,
      strokeAlign: resolvedSide?.strokeAlign ?? -1.0,
      width: resolvedSide?.width ?? 1.0,
    );
    final Widget result = Container(
      decoration: ShapeDecoration(
        gradient: resolvedGradient,
        shape: resolvedShape!.copyWith(side: side),
      ),
      constraints: effectiveConstraints,
      child: Material(
        elevation: resolvedElevation!,
        textStyle: resolvedTextStyle?.copyWith(color: resolvedForegroundColor),
        shape: resolvedShape.copyWith(side: side),
        color: Colors.transparent,
        shadowColor: resolvedShadowColor,
        surfaceTintColor: resolvedSurfaceTintColor,
        type: MaterialType.transparency,
        animationDuration: resolvedAnimationDuration,
        clipBehavior: widget.clipBehavior,
        child: InkWell(
          onTap: widget.onPressed,
          onLongPress: widget.onLongPress,
          onHover: widget.onHover,
          mouseCursor: mouseCursor,
          focusNode: widget.focusNode,
          canRequestFocus: widget.enabled,
          onFocusChange: widget.onFocusChange,
          autofocus: widget.autofocus,
          splashFactory: resolvedSplashFactory,
          overlayColor: overlayColor,
          highlightColor: Colors.transparent,
          customBorder: resolvedShape.copyWith(side: side),
          statesController: statesController,
          child: Builder(builder: (context) {
            return IconTheme.merge(
              data: IconThemeData(
                  color: resolvedIconColor ?? resolvedForegroundColor,
                  size: resolvedIconSize),
              child: Padding(
                padding: padding,
                child: Align(
                  alignment: resolvedAlignment!,
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: widget.child,
                ),
              ),
            );
          }),
        ),
      ),
    );

    final Size minSize;
    switch (resolvedTapTargetSize!) {
      case MaterialTapTargetSize.padded:
        minSize = Size(
          kMinInteractiveDimension + densityAdjustment.dx,
          kMinInteractiveDimension + densityAdjustment.dy,
        );
        assert(minSize.width >= 0.0);
        assert(minSize.height >= 0.0);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        minSize = Size.zero;
        break;
    }

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: _InputPadding(
        minSize: minSize,
        child: result,
      ),
    );
  }
}

class _MouseCursor extends WidgetStateMouseCursor {
  const _MouseCursor(this.resolveCallback);

  final WidgetPropertyResolver<MouseCursor?> resolveCallback;

  @override
  MouseCursor resolve(Set<WidgetState> states) => resolveCallback(states)!;

  @override
  String get debugDescription => 'ButtonStyleButton_MouseCursor';
}

/// A widget to pad the area around a [ButtonStyleButton]'s inner [Material].
///
/// Redirect taps that occur in the padded area around the child to the center
/// of the child. This increases the size of the button and the button's
/// "tap target", but not its material or its ink splashes.
class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({
    super.child,
    required this.minSize,
  });

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, [RenderBox? child]) : super(child);

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  Size _computeSize(
      {required BoxConstraints constraints,
      required ChildLayouter layoutChild}) {
    if (child != null) {
      final Size childSize = layoutChild(child!, constraints);
      final double height = math.max(childSize.width, minSize.width);
      final double width = math.max(childSize.height, minSize.height);
      return constraints.constrain(Size(height, width));
    }
    return Size.zero;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  @override
  void performLayout() {
    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    if (child != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset =
          Alignment.center.alongOffset(size - child!.size as Offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }
    final Offset center = child!.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (BoxHitTestResult result, Offset position) {
        assert(position == center);
        return child!.hitTest(result, position: center);
      },
    );
  }
}

class GradientButtonStyle extends ButtonStyle {
  final Gradient? gradient;
  const GradientButtonStyle(
      {this.gradient,
      super.alignment,
      super.animationDuration,
      super.elevation,
      super.enableFeedback,
      super.fixedSize,
      super.foregroundColor,
      super.iconColor,
      super.iconSize,
      super.maximumSize,
      super.minimumSize,
      super.mouseCursor,
      super.overlayColor,
      super.padding,
      super.shadowColor,
      super.shape,
      super.side,
      super.splashFactory,
      super.surfaceTintColor,
      super.tapTargetSize,
      super.textStyle,
      super.visualDensity});

  factory GradientButtonStyle.copyWith(
      {Gradient? gradient, ButtonStyle? style}) {
    return GradientButtonStyle(
      gradient: gradient,
      padding: style?.padding,
      overlayColor: style?.overlayColor,
      mouseCursor: style?.mouseCursor,
      minimumSize: style?.minimumSize,
      maximumSize: style?.maximumSize,
      iconSize: style?.iconSize,
      iconColor: style?.iconColor,
      foregroundColor: style?.foregroundColor,
      fixedSize: style?.fixedSize,
      enableFeedback: style?.enableFeedback,
      elevation: style?.elevation,
      animationDuration: style?.animationDuration,
      alignment: style?.alignment,
      shadowColor: style?.shadowColor,
      shape: style?.shape,
      side: style?.side,
      splashFactory: style?.splashFactory,
      surfaceTintColor: style?.surfaceTintColor,
      tapTargetSize: style?.tapTargetSize,
      textStyle: style?.textStyle,
      visualDensity: style?.visualDensity,
    );
  }
}

class GradientButtonThemeData extends InheritedWidget {
  final GradientButtonStyle? data;
  const GradientButtonThemeData({super.key, this.data, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static GradientButtonStyle? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GradientButtonThemeData>()
        ?.data;
  }
}
