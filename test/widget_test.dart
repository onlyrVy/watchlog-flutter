import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchlog/main.dart';

void main() {
  testWidgets('App launches and shows splash or login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: WatchLogApp()));

    // Splash shows briefly while auth state resolves — just confirm
    // the app builds without throwing.
    await tester.pump();

    expect(find.byType(WatchLogApp), findsOneWidget);
  });
}
