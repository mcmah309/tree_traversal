import 'dart:collection';

/// Depth first and breadth first traversal on a generic type [T]
class TreeTraversal<T> {
  final Iterable<T> Function(T) _getChildrenFn;

  const TreeTraversal(this._getChildrenFn);

  //************************************************************************//
  //  Depth First
  //************************************************************************//

  /// {@template preOrderIterable}
  /// In pre-order traversal, you visit the current node first, then recursively traverse the left subtree, and finally recursively traverse the right subtree.
  /// Pre-order traversal is commonly used to create a copy of the tree or to serialize the tree structure.
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
  /// Pre-order traversal: A, B, D, E, C, F, G
  /// {@endtemplate}
  Iterable<T> preOrderIterable(T node) sync* {
    yield node;
    for (final child in _getChildrenFn(node)) {
      yield* preOrderIterable(child);
    }
  }

  /// {@template postOrderIterable}
  /// In post-order traversal, you recursively traverse the left subtree first, then recursively traverse the right subtree, and finally visit the current node.
  /// Post-order traversal is commonly used to delete the tree or to perform some calculations involving the descendants of a node before visiting the node itself.
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
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
  /// In level-order traversal, you visit the nodes level by level, from left to right.
  /// Level-order traversal is useful for exploring or searching a tree breadth-first, and it can be helpful in constructing the tree from a list of nodes.
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
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

/// Traversals for going up a tree that may have a generic parent [T]
class ParentedTreeTraversal<T extends Object> extends TreeTraversal<T> {
  final T? Function(T) getParentFn;

  /// Takes the node and index, and returns the child of the node at that index.
  final T Function(T, int) getChildAtIndexFn;

  /// Takes the parent and the child, and returns the index of the child in the parent.
  final int Function(T, T) getChildsIndexFn;

  const ParentedTreeTraversal(super.getChildrenFn, this.getParentFn, this.getChildAtIndexFn, this.getChildsIndexFn);

  /// {@template reverseOrderIterable}
  /// Reverse traversal, you visit this node, then your previous siblings, then your parent, then your parents previous siblings and so on.
  ///           A
  ///         /   \
  ///        B     C
  ///       / \   / \
  ///      D   E F   G
  /// Reverse traversal starting at G: G, F, C, B, A
  /// {@endtemplate}
  Iterable<T> reverseOrderIterable(T node) sync* {
    while (true) {
      T? parent = getParentFn(node);
      if (parent != null) {
        int indexInParent = getChildsIndexFn(parent, node);
        for (int i = indexInParent; i >= 0; i--) {
          yield getChildAtIndexFn(parent, i);
        }
        node = parent;
      } else {
        yield node;
        break;
      }
    }
  }
}