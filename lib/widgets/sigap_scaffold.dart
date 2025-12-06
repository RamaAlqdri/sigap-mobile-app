import 'package:flutter/material.dart';

class SigapScaffold extends StatelessWidget {
  const SigapScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.applyContentPadding = true,
    this.contentPadding,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool applyContentPadding;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    Widget content = body;
    if (applyContentPadding) {
      content = Padding(
        padding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: content,
      );
    }
    content = SafeArea(child: content);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFECF4E8),
            Color(0xFFFCFEFB),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: content,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
