import 'package:flutter/material.dart';

import 'platform/resume_preview_js.dart'
// ignore: uri_does_not_exist
if (dart.library.io) 'platform/resume_preview_vm.dart';

/// {@template resume_preview}
/// ResumePreview widget.
/// {@endtemplate}
class ResumePreview extends StatelessWidget {
  /// {@macro resume_preview}
  const ResumePreview({
    super.key, // ignore: unused_element
  });

  @override
  Widget build(BuildContext context) => $buildResumePreview(context);
}