import 'dart:async';

/// Per-widget undo/redo stack for property values.
class PropertyHistory {
  static const int _maxSize = 50;

  final List<Map<String, dynamic>> _undoStack = [];
  final List<Map<String, dynamic>> _redoStack = [];

  /// Timer for debouncing slider pushes.
  Timer? _debounceTimer;
  String? _lastPropertyName;

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  /// Push a state snapshot before a change.
  /// Debounces rapid changes to the same property (e.g. slider drags).
  void push(Map<String, dynamic> previousState, {String? changedProperty}) {
    if (changedProperty != null && changedProperty == _lastPropertyName) {
      // Same property changing rapidly — debounce: replace pending push
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _lastPropertyName = null;
      });
      // Don't push duplicate; the first push for this drag is already there
      return;
    }

    // Different property or first change — push immediately
    _lastPropertyName = changedProperty;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _lastPropertyName = null;
    });

    _undoStack.add(Map<String, dynamic>.from(previousState));
    if (_undoStack.length > _maxSize) {
      _undoStack.removeAt(0);
    }
    _redoStack.clear();
  }

  /// Undo: returns the previous state, or null if nothing to undo.
  Map<String, dynamic>? undo(Map<String, dynamic> currentState) {
    if (_undoStack.isEmpty) return null;
    _redoStack.add(Map<String, dynamic>.from(currentState));
    return _undoStack.removeLast();
  }

  /// Redo: returns the next state, or null if nothing to redo.
  Map<String, dynamic>? redo(Map<String, dynamic> currentState) {
    if (_redoStack.isEmpty) return null;
    _undoStack.add(Map<String, dynamic>.from(currentState));
    return _redoStack.removeLast();
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
