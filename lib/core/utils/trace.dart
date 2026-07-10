import 'package:flutter/foundation.dart';

import 'package:ecotrack/core/utils/trace.dart';
typedef VoidCallback = void Function();

/// Retourne un `VoidCallback` qui logge l'appel puis exécute `cb`.
/// Usage: `onPressed: traceCallback('connexion_button', () => context.push('/home')),`
VoidCallback traceCallback(String name, VoidCallback? cb) {
  if (cb == null) return () {};
  return () {
    debugPrint('TRACE callback: $name');
    try {
      cb();
    } catch (e, st) {
      debugPrint('TRACE error in $name: $e\n$st');
      rethrow;
    }
  };
}
