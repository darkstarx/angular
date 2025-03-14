import 'package:source_span/source_span.dart';

import '../ast.dart';
import '../token/tokens.dart';
import '../visitor.dart';

/// Represents the closing DOM element that was parsed.
///
/// Clients should not extend, implement, or mix-in this class.
abstract mixin class CloseElementAst implements TemplateAst {
  /// Creates a synthetic close element AST.
  factory CloseElementAst(
    String name,
  ) = _SyntheticCloseElementAst;

  /// Creates a synthetic close element AST from an existing AST node.
  factory CloseElementAst.from(
    TemplateAst origin,
    String name,
  ) = _SyntheticCloseElementAst.from;

  /// Creates a new close element AST from a parsed source.
  factory CloseElementAst.parsed(
    SourceFile sourceFile,
    NgToken closeTagStart,
    NgToken nameToken,
    NgToken closeTagEnd, {
    ElementAst? openComplement,
  }) = ParsedCloseElementAst;

  @override
  bool operator ==(Object? other) {
    return other is CloseElementAst && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  R accept<R, C>(TemplateAstVisitor<R, C?> visitor, [C? context]) =>
      visitor.visitCloseElement(this, context);

  /// Whether this is a `</template>` tag and should be directly rendered.
  bool get isEmbeddedTemplate => name == 'template';

  /// Name (tag) of the close element.
  String get name;

  @override
  String toString() {
    return '$CloseElementAst </$name>';
  }
}

/// Represents a real, non-synthetic DOM close element that was parsed.
///
/// Clients should not extend, implement, or mix-in this class.
class ParsedCloseElementAst extends TemplateAst with CloseElementAst {
  /// [NgToken] that represents the identifier tag in `</tag>`.
  final NgToken identifierToken;

  ParsedCloseElementAst(
    SourceFile sourceFile,
    NgToken closeElementStart,
    this.identifierToken,
    NgToken closeElementEnd, {
    ElementAst? openComplement,
  }) : super.parsed(closeElementStart, closeElementEnd, sourceFile);

  @override
  String get name => identifierToken.lexeme;
}

class _SyntheticCloseElementAst extends SyntheticTemplateAst
    with CloseElementAst {
  _SyntheticCloseElementAst(
    this.name,
  );

  _SyntheticCloseElementAst.from(
    TemplateAst super.origin,
    this.name,
  ) : super.from();

  @override
  final String name;
}
