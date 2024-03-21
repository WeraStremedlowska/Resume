import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resume/resume_preview.dart';

void main() => runZonedGuarded<Future<void>>(
      () async {
    runApp(const App());
  },
      (error, stackTrace) =>
  // ignore: avoid_print
  print('Top level exception: $error\n$stackTrace'),
);

/// {@template app}
/// App widget.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Resume Builder',
    theme: ThemeData.dark(),
    home: const WebViewScreen(),
  );
}

/// {@template webview_app}
/// WebViewScreen widget.
/// {@endtemplate}
class WebViewScreen extends StatefulWidget {
  /// {@macro webview_app}
  const WebViewScreen({
    super.key, // ignore: unused_element
  });

  /// Returns the [TextEditingController] from the closest [WebViewScreen] ancestor.
  static TextEditingController of(BuildContext context, {bool listen = true}) =>
      context.findAncestorStateOfType<_WebViewScreenState>()!.controller;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

/// State for widget WebViewScreen.
class _WebViewScreenState extends State<WebViewScreen> {
  bool _show = true;
  double _size = 75;
  bool get _isSizeMax => _size >= 100;
  bool get _isSizeMin => _size <= 25;
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller =
  TextEditingController(text: 'Wera Stremedlowska');

  void _updateSize(double value) => setState(() => _size = value);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Resume Builder',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      backgroundColor: Colors.blueGrey,
      centerTitle: true,
    ),
    floatingActionButton: Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => setState(() => _show = !_show),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              ),
              child: _show
                  ? const Icon(Icons.visibility_off, key: ValueKey(true))
                  : const Icon(Icons.visibility, key: ValueKey(false)),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _isSizeMax ? 0.25 : 1,
            child: FloatingActionButton(
              onPressed: _isSizeMax
                  ? null
                  : () => _updateSize((_size + 25).clamp(25, 100)),
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _isSizeMin ? 0.25 : 1,
            child: FloatingActionButton(
              onPressed: _isSizeMin
                  ? null
                  : () => _updateSize((_size - 25).clamp(25, 100)),
              child: const Icon(Icons.remove),
            ),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 64,
              width: 420,
              child: TextFormField(
                decoration: InputDecoration(
                  isCollapsed: false,
                  isDense: false,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.blueGrey.shade200,
                    ),
                  ),
                  hoverColor: Colors.blueGrey.shade100,
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  helperText: null,
                  suffixIcon: const Icon(Icons.search),
                  counter: const SizedBox.shrink(),
                  errorText: null,
                  helperMaxLines: 0,
                  errorMaxLines: 0,
                ),
                controller: controller,
                focusNode: focusNode,
                maxLines: 1,
                expands: false,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: Theme(
              data: ThemeData.light(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: _show
                      ? LayoutBuilder(
                    builder: (context, constraints) => SizedBox(
                      width: constraints.maxWidth * _size / 100,
                      height: constraints.maxHeight * _size / 100,
                      child: const Center(
                        child: AspectRatio(
                          aspectRatio: 1 / 1.414,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ResumePreview(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 64,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  'Size: ${_size.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
