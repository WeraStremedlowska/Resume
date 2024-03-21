// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

import '../main.dart';

Widget $buildResumePreview(BuildContext context) => const ResumePreviewJS();

/// {@template resume_preview_js}
/// ResumePreviewJS widget.
/// {@endtemplate}
class ResumePreviewJS extends StatefulWidget {
  /// {@macro resume_preview_js}
  const ResumePreviewJS({
    super.key, // ignore: unused_element
  });

  @override
  State<ResumePreviewJS> createState() => _ResumePreviewJSState();
}

class _ResumePreviewJSState extends State<ResumePreviewJS> {
  late final TextEditingController _controller;
  html.ShadowRoot? _shadowRoot;

  @override
  void initState() {
    super.initState();

    ui.platformViewRegistry.registerViewFactory(
      'embedded-cv-view',
          (int viewId) => html.DivElement()
        ..style.display = 'block'
        ..style.width = '100%' // 100% of parent (Scaffold)
        ..style.height = '100%' // 100% of parent (Scaffold)
        ..style.overflowY = 'hidden'
        ..style.overflowX = 'hidden'
        ..style.border = 'none'
        ..classes.addAll(['embedded-cv-view']),
      isVisible: true,
    );

    _controller = WebViewScreen.of(context)..addListener(_onNameChanged);

    html.window.console.log('ResumePreviewJS view factory registered');
  }

  void _appendShadowContent() {
    final view = html.document.querySelector('.embedded-cv-view');
    if (view == null) {
      html.window.console.error('Embedded CV view not found');
      return;
    }

    final sanitizer = html.NodeTreeSanitizer(
      html.NodeValidatorBuilder.common()
        ..allowInlineStyles()
        ..allowElement('style', attributes: ['type'])
        ..allowElement('script', attributes: ['src']),
    );

    final content = html.DivElement()
      ..classes.addAll(['a4-wrapper', 'cv-shadow-container'])
      ..append(html.DivElement()
        ..classes.add('a4-content')
        ..appendHtml(_$cvInlineContent, treeSanitizer: sanitizer));
    final style = html.StyleElement()..text = _$cvInlineStyle;
    final script = html.ScriptElement()..text = _$cvInlineScript;

    _shadowRoot = (view.shadowRoot ?? view.attachShadow({'mode': 'open'}))
      ..append(style)
      ..append(content)
      ..append(script);

    _shadowRoot?.addEventListener('wheel', _onScrollEvent);

    _onNameChanged();
    html.window.console.log('Shadow content appended');
  }

  void _onNameChanged() {
    final name = _controller.text;
    final nameTemplate =
    _shadowRoot?.querySelector('.header > h1.cv-template-name');
    if (nameTemplate == null) {
      html.window.console.error('Name template not found');
      return;
    }
    nameTemplate.text = name.trim();
    html.window.console.log('Name changed: $name');
  }

  void _onScrollEvent(html.Event event) {
    if (event is! html.WheelEvent) return;
    final wrapper = _shadowRoot?.querySelector('.a4-wrapper');
    if (wrapper == null) return;
    event.preventDefault();
    wrapper.scrollTop += event.deltaY.toInt();
  }

  @override
  void dispose() {
    _controller.removeListener(_onNameChanged);
    _shadowRoot?.removeEventListener('wheel', _onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FittedBox(
    alignment: Alignment.center,
    clipBehavior: Clip.hardEdge,
    fit: BoxFit.contain,
    child: SizedBox(
      width: 794,
      height: 1122,
      child: HtmlElementView(
        viewType: 'embedded-cv-view',
        onPlatformViewCreated: (_) => _appendShadowContent(),
      ),
    ),
  );
}

String get _$cvInlineStyle => r'''
div.a4-wrapper {
  display: flex;
  width: 100%;
  height: 100%;
  border: none; /* 1px solid #ccc; */
  position: relative;
  box-shadow: none; /* 0 4px 6px rgba(0,0,0,0.1); */
  justify-content: center;
  transform-origin: top left;
  transition: transform 0.3s ease;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 0px;
  box-sizing: border-box;
  font-family: Arial, sans-serif;
  font-size: 16px;
  line-height: 1.5;
  color: #333;

  /* scrollbar-width: thin;
  scrollbar-color: #363636 #e7e7e7; */
}

div.a4-wrapper::-webkit-scrollbar {
  width: 12px;
}

div.a4-wrapper::-webkit-scrollbar-track {
  border-radius: 8px;
  background-color: #e7e7e7;
  border: 1px solid #cacaca;
  box-shadow: inset 0 0 6px rgba(0, 0, 0, .3);
}

div.a4-wrapper::-webkit-scrollbar-thumb {
  border-radius: 8px;
  background-color: #363636;
}

div.a4-wrapper::-webkit-scrollbar-thumb:hover {
  background: #555;
}

div.a4-content {
  font-family: Arial, sans-serif;
  width: 794px;
  min-height: 1122px; /*  A4 size */
  box-sizing: border-box;
  padding: 20px;
}

.header { text-align: center; }
.section { margin-top: 20px; }
.section-title { font-size: 24px; color: #333; }
.list { margin-top: 10px; }
.item { margin-bottom: 10px; }
''';

String get _$cvInlineContent => r'''
<div class="header">
    <h1 class="cv-template-name">Stremedlowska Wera</h1>
    <p>🔗 <a href="https://www.linkedin.com/in/wera-stremedlowska/">LinkedIn</a></p>
    <p>📧 <a href="mailto:stremedlowska@gmail.com">stremedlowska@gmail.com</a></p>
    <p>Flutter Developer</p>
</div>

<div class="section">
    <h2 class="section-title">Summary</h2>
    <p>A dedicated Flutter Developer with hands-on experience in a range of technical skills including Dart, Java, and Swift. Proven expertise in software testing with tools such as Selenium and Postman, and adept in agile project management using platforms like JIRA and Trello. Skilled at leveraging version control using Git and GitHub, and comfortable working in a variety of IDEs. Committed to producing high-quality applications and ensuring seamless user experience.</p>
</div>

<div class="section">
    <h2 class="section-title">Technical Skills</h2>
    <ul class="list">
        <li class="item">Languages: Dart, Java, Swift</li>
        <li class="item">Testing: Selenium WebDriver, Postman (REST API), Unittest</li>
        <li class="item">Development: Flutter, VS code, IntelliJ, Android Studio, XCode</li>
        <li class="item">Tools: Git, GitHub, GitHub Actions, Jira, Trello, MS Office, Chrome Dev tools, Click Up, TestRail, Excel, Figma</li>
    </ul>
</div>

<div class="section">
    <h2 class="section-title">Work Experience</h2>
    <ul class="list">
        <li class="item">
            <strong>Flutter Developer</strong>
            Juni 2022–Heute (1 year 4 months)
            ale-ko GmbH - Remote Flutter Development
            <ul>
                <li>Developed and maintained Flutter applications.</li>
                <li>Collaborated with remote teams using tools such as JIRA and GitHub for seamless project execution.</li>
                <li>Implemented agile methodologies to optimize software delivery process.</li>
            </ul>
        </li>
        <li class="item">
            <strong>Software QA Engineer</strong>
            Juni 2020–Juni 2021 (1 year 1 month)
            Technomation EOOD - Remote Software Quality Assurance
            <ul>
                <li>Executed manual tests and utilized Postman for REST API testing.</li>
                <li>Managed defect tracking using JIRA and maintained documentation in GitHub.</li>
            </ul>
        </li>
        <li class="item">
            <strong>Kunden und Logistik Management</strong>
            März 2011–Mai 2019 (8 years 3 months)
            Union Service Rus Ltd - Logistics Management
            <ul>
                <li>Managed scheduling and routing for TL/LTL's shipping of cargo.</li>
                <li>Tracked shipments via supply chain optimization software.</li>
                <li>Negotiated rates with carriers and ensured 99.9% on-time delivery.</li>
            </ul>
        </li>
    </ul>
</div>

<div class="section">
    <h2 class="section-title">Languages</h2>
    <p>English, Russian, German</p>
</div>
''';


String get _$cvInlineScript => r'''
console.log('Embedded CV script loaded');
''';