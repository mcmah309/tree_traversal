import 'dart:collection';

/// Tree Traversals where [T] is aware of it's children. This allows for various traversals that involve moving down the tree.
/// Down: [levelOrderIterable], [postOrderIterable], [preOrderIterable].
class TreeTraversal<T> {
  final Iterable<T> Function(T node) _getChildrenFn;

  const TreeTraversal({required Iterable<T> Function(T node) getChildren}) : _getChildrenFn = getChildren;

  //************************************************************************//
  //  Depth First
  //************************************************************************//

  /// {@template preOrderIterable}
  /// In pre-order traversal, the current node is visited first, then the left subtree is recursively traversed, and finally the right subtree is recursively traversed.
  /// ```
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
  /// ```
  /// Pre-order traversal: A, B, D, E, C, F, G
  /// {@endtemplate}
  Iterable<T> preOrderIterable(T node) sync* {
    yield node;
    for (final child in _getChildrenFn(node)) {
      yield* preOrderIterable(child);
    }
  }

  /// {@template postOrderIterable}
  /// In post-order traversal, the left subtree is recursively traversed, then the right subtree is recursively traversed, and finally the current node is visited.
  /// ```
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
  /// ```
  /// Post-order traversal: D, E, B, F, G, C, A
  /// {@endtemplate}
  Iterable<T> postOrderIterable(T node) sync* {
    for (final child in _getChildrenFn(node)) {
      yield* postOrderIterable(child);
    }
    yield node;
  }

  //************************************************************************//
  // 1.2 Breath First Traversal
  //************************************************************************//

  /// {@template levelOrderIterable}
  /// In level-order traversal, nodes are visited level by level, from left to right.
  /// ```
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
  /// ```
  /// Level-order traversal: A, B, C, D, E, F, G
  /// {@endtemplate}
  Iterable<T> levelOrderIterable(T node) sync* {
    final queue = Queue<T>();
    queue.add(node);

    while (queue.isNotEmpty) {
      final node = queue.removeFirst();
      yield node;
      queue.addAll(_getChildrenFn(node));
    }
  }
}

/// Tree Traversals where [T] is aware of it's child and parent. This allows for various traversals that involve moving up and down the tree.
/// Down: [levelOrderIterable], [postOrderIterable], [preOrderIterable].
/// Up and Down: [reverseOrderIterable], [postOrderContinuationIterable], [preOrderContinuationIterable].
class ParentedTreeTraversal<T extends Object> extends TreeTraversal<T> {
  final T? Function(T node) _getParentFn;

  /// Takes the node and index, and returns the child of the node at that index.
  final T Function(T node, int index) _getChildAtIndexFn;

  /// Takes a node and a child of that node, and returns the index of the child in the node.
  final int Function(T node, T child) _getChildsIndexFn;

  const ParentedTreeTraversal(
      {required Iterable<T> Function(T) getChildren,
      required T? Function(T node) getParent,
      required T Function(T node, int index) getChildAtIndex,
      required int Function(T node, T child) getChildsIndex})
      : _getParentFn = getParent,
        _getChildAtIndexFn = getChildAtIndex,
        _getChildsIndexFn = getChildsIndex,
        super(getChildren: getChildren);

  /// {@template reverseOrderIterable}
  /// In Reverse traversal, the current node is first visited, then the current nodes previous siblings, then its parent, then its parents previous siblings and so on.
  /// ```
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
  /// ```
  /// Reverse traversal starting at G: G, F, C, B, A
  /// {@endtemplate}
  Iterable<T> reverseOrderIterable(T node) sync* {
    while (true) {
      T? parent = _getParentFn(node);
      if (parent != null) {
        int indexInParent = _getChildsIndexFn(parent, node);
        for (int i = indexInParent; i >= 0; i--) {
          yield _getChildAtIndexFn(parent, i);
        }
        node = parent;
      } else {
        yield node;
        break;
      }
    }
  }

  //************************************************************************//

  /// {@template postOrderContinuationIterable}
  /// Performs a post-order traversal as continuing from the current node. That is, if post-order traversal was
  /// already taking place in the current tree and the provided node was just encountered
  /// ```
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
  /// ```
  /// Post Order Continuation traversal starting at C: F, G, C, A
  /// {@endtemplate}
  Iterable<T> postOrderContinuationIterable(T node) sync* {
    yield* _postOrderContinuationHelper(node, 0);
  }

  Iterable<T> _postOrderContinuationHelper(T node, int skip) sync* {
    yield* _postOrderWithSkipChildren(node, skip);

    final T? parent = _getParentFn(node);
    // has no parent, end generation
    if (parent == null) {
      return;
    } else {
      int parentShouldSkip = _getChildsIndexFn(parent, node) + 1;
      yield* _postOrderContinuationHelper(parent, parentShouldSkip);
    }
  }

  Iterable<T> _postOrderWithSkipChildren(T node, int skip) sync* {
    for (T childNode in _getChildrenFn(node).skip(skip)) {
      yield* _postOrderWithSkipChildren(childNode, 0);
    }
    yield node;
  }

  //************************************************************************//

  /// {@template postOrderContinuationIterable}
  /// Performs a pre-order traversal as continuing from the current node. That is, if pre-order traversal was
  /// already taking place in the current tree and the provided node was just encountered.
  /// ```
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
  /// ```
  /// Pre Order Continuation traversal starting at E: E, C, F, G
  /// {@endtemplate}
  Iterable<T> preOrderContinuationIterable(T node) sync* {
    yield node;
    yield* _preOrderContinuationHelper(node, 0);
  }

  Iterable<T> _preOrderContinuationHelper(T node, int skip) sync* {
    yield* _preOrderWithSkipChildren(node, skip);

    final T? parent = _getParentFn(node);
    // has no parent, end generation
    if (parent == null) {
      return;
    } else {
      int parentShouldSkip = _getChildsIndexFn(parent, node) + 1;
      yield* _preOrderContinuationHelper(parent, parentShouldSkip);
    }
  }

  Iterable<T> _preOrderWithSkipChildren(T node, int skip) sync* {
    for (T childNode in _getChildrenFn(node).skip(skip)) {
      yield childNode;
      yield* _preOrderWithSkipChildren(childNode, 0);
    }
  }
}
