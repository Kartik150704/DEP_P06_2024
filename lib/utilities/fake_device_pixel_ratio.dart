import 'package:flutter/widgets.dart';

class FakeDevicePixelRatio extends StatelessWidget {
  final num fakeDevicePixelRatio;
  final Widget child;

  const FakeDevicePixelRatio({
    super.key,
    required this.fakeDevicePixelRatio,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ratio =
        fakeDevicePixelRatio / WidgetsBinding.instance.window.devicePixelRatio;
    print(MediaQuery.of(context).devicePixelRatio);

    return FractionallySizedBox(
      widthFactor: 1 / ratio,
      heightFactor: 1 / ratio,
      child: Transform.scale(
        scale: ratio,
        child: child,
      ),
    );
  }
}
