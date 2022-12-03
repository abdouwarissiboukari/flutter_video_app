import 'package:flutter/material.dart';

class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size) onChildSize;

  const SizeProviderWidget({
    super.key,
    required this.onChildSize,
    required this.child,
  });
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    _onResize();
    super.initState();
  }

  void _onResize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.size is Size) {
        widget.onChildSize(context.size!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ///add size listener for every build uncomment the fallowing
    ///_onResize();
    return widget.child;
  }
}

class Margin extends StatefulWidget {
  const Margin({
    super.key,
    required this.child,
    this.horizontal = 0,
    this.vertical = 0,
    this.left = 0,
    this.top = 0,
  });

  final Widget child;
  final double horizontal;
  final double vertical;
  final double top;
  final double left;

  @override
  State<Margin> createState() => _MarginState();
}

class _MarginState extends State<Margin> {
  Size childSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    final horizontalMargin = widget.horizontal * 2 * -1;
    final verticalMargin = widget.vertical * 2 * -1;

    final newWidth = childSize.width + horizontalMargin;
    final newHeight = childSize.height + verticalMargin;

    if (childSize != Size.zero) {
      return LimitedBox(
        maxWidth: newWidth,
        maxHeight: newHeight,
        child: OverflowBox(
          maxWidth: newWidth,
          maxHeight: newHeight,
          child: Transform.translate(
            offset: Offset(widget.left, widget.top),
            child: SizedBox(
              width: newWidth,
              height: newHeight,
              child: widget.child,
            ),
          ),
        ),
      );
    }

    return SizeProviderWidget(
      child: widget.child,
      onChildSize: (size) {
        setState(() => childSize = size);
      },
    );
  }
}
