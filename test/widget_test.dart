import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manaservice/main.dart';

void main() {
  testWidgets('App shows splash screen with app name', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ManaServiceApp()));
    expect(find.text('ManaService'), findsOneWidget);

    // Let the splash timer finish so no timer is left pending.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}