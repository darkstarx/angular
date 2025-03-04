import 'package:source_span/source_span.dart';

import '../ast.dart';
import '../token/tokens.dart';
import '../visitor.dart';

/// Represents a block of static text (i.e. not bound to a directive).
///
/// Clients should not extend, implement, or mix-in this class.
abstract mixin class TextAst implements StandaloneTemplateAst {
  /// Create a new synthetic [TextAst] with a string [value].
  factory TextAst(String value) = _SyntheticTextAst;

  /// Create a new synthetic [TextAst] that originated from node [origin].
  factory TextAst.from(
    TemplateAst origin,
    String value,
  ) = _SyntheticTextAst.from;

  /// Create a new [TextAst] parsed from tokens from [sourceFile].
  factory TextAst.parsed(
    SourceFile sourceFile,
    NgToken textToken,
  ) = _ParsedTextAst;

  @override
  bool operator ==(Object? other) {
    return other is TextAst && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  R accept<R, C>(TemplateAstVisitor<R, C?> visitor, [C? context]) {
    return visitor.visitText(this, context);
  }

  /// Static text value.
  String get value;

  @override
  String toString() => '$TextAst {$value}';
}

class _ParsedTextAst extends TemplateAst with TextAst {
  _ParsedTextAst(
    SourceFile sourceFile,
    NgToken textToken,
  ) : super.parsed(textToken, textToken, sourceFile);

  @override
  String get value => beginToken!.lexeme;
}

class _SyntheticTextAst extends SyntheticTemplateAst with TextAst {
  @override
  final String value;

  _SyntheticTextAst(this.value);

  _SyntheticTextAst.from(TemplateAst super.origin, this.value) : super.from();
}
