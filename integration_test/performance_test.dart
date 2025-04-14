import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:new_try/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  testWidgets("performance test", (WidgetTester tester) async {
    // Reset the app state before starting the test
    binding.reset();

    // Start performance tracing
    await binding.traceAction(() async {
      app.main(); // Ensure app.main() calls runApp(MyApp())
      await tester.pumpAndSettle(); // Wait for animations/frame build
    }, reportKey: 'startup_performance');
  });
}