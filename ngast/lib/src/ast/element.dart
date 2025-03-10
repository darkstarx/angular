import 'package:collection/collection.dart';
import 'package:source_span/source_span.dart';

import '../ast.dart';
import '../token/tokens.dart';
import '../visitor.dart';

const _listEquals = ListEquality();

/// Represents a DOM element that was parsed, that could be upgraded.
///
/// Clients should not extend, implement, or mix-in this class.
abstract mixin class ElementAst implements StandaloneTemplateAst {
  /// Create a synthetic element AST.
  factory ElementAst(
    String name,
    CloseElementAst? closeComplement, {
    List<AttributeAst> attributes,
    List<StandaloneTemplateAst> childNodes,
    List<EventAst> events,
    List<PropertyAst> properties,
    List<ReferenceAst> references,
    List<BananaAst> bananas,
    List<StarAst> stars,
    List<AnnotationAst> annotations,
  }) = _SyntheticElementAst;

  /// Create a synthetic element AST from an existing AST node.
  factory ElementAst.from(
    TemplateAst origin,
    String name,
    CloseElementAst? closeComplement, {
    List<AttributeAst> attributes,
    List<StandaloneTemplateAst> childNodes,
    List<EventAst> events,
    List<PropertyAst> properties,
    List<ReferenceAst> references,
    List<BananaAst> bananas,
    List<StarAst> stars,
    List<AnnotationAst> annotations,
  }) = _SyntheticElementAst.from;

  /// Create a new element AST from parsed source.
  factory ElementAst.parsed(
    SourceFile sourceFile,
    NgToken openElementStart,
    NgToken nameToken,
    NgToken openElementEnd, {
    CloseElementAst? closeComplement,
    List<AttributeAst> attributes,
    List<StandaloneTemplateAst> childNodes,
    List<EventAst> events,
    List<PropertyAst> properties,
    List<ReferenceAst> references,
    List<BananaAst> bananas,
    List<StarAst> stars,
    List<AnnotationAst> annotations,
  }) = ParsedElementAst;

  @override
  bool operator ==(Object? other) {
    return other is ElementAst &&
        name == other.name &&
        closeComplement == other.closeComplement &&
        _listEquals.equals(attributes, other.attributes) &&
        _listEquals.equals(childNodes, other.childNodes) &&
        _listEquals.equals(events, other.events) &&
        _listEquals.equals(properties, other.properties) &&
        _listEquals.equals(references, other.references) &&
        _listEquals.equals(bananas, other.bananas) &&
        _listEquals.equals(stars, other.stars) &&
        _listEquals.equals(annotations, other.annotations);
  }

  @override
  int get hashCode {
    return Object.hashAll([
      name,
      closeComplement,
      _listEquals.hash(attributes),
      _listEquals.hash(childNodes),
      _listEquals.hash(events),
      _listEquals.hash(properties),
      _listEquals.hash(references),
      _listEquals.hash(bananas),
      _listEquals.hash(stars),
      _listEquals.hash(annotations),
    ]);
  }

  @override
  R? accept<R, C>(TemplateAstVisitor<R, C?> visitor, [C? context]) {
    return visitor.visitElement(this, context);
  }

  /// Determines whether the element tag name is void element.
  bool get isVoidElement;

  /// CloseElement complement
  ///
  /// If [closeComplement] == null, then [isVoidElement] is true.
  CloseElementAst? get closeComplement;
  set closeComplement(CloseElementAst? closeElementAst);

  /// Name (tag) of the element.
  String get name;

  /// Attributes.
  List<AttributeAst> get attributes;

  /// Event listeners.
  List<EventAst> get events;

  /// Property assignments.
  List<PropertyAst> get properties;

  /// Reference assignments.
  List<ReferenceAst> get references;

  /// Bananas assignments.
  List<BananaAst> get bananas;

  /// Star assignments.
  List<StarAst> get stars;

  /// Annotation assignments.
  List<AnnotationAst> get annotations;

  @override
  String toString() {
    final buffer = StringBuffer('$ElementAst <$name> { ');
    if (attributes.isNotEmpty) {
      buffer
        ..write('attributes=')
        ..writeAll(attributes, ', ')
        ..write(' ');
    }
    if (events.isNotEmpty) {
      buffer
        ..write('events=')
        ..writeAll(events, ', ')
        ..write(' ');
    }
    if (properties.isNotEmpty) {
      buffer
        ..write('properties=')
        ..writeAll(properties, ', ')
        ..write(' ');
    }
    if (references.isNotEmpty) {
      buffer
        ..write('references=')
        ..writeAll(references, ', ')
        ..write(' ');
    }
    if (bananas.isNotEmpty) {
      buffer
        ..write('bananas=')
        ..writeAll(bananas, ', ')
        ..write(' ');
    }
    if (stars.isNotEmpty) {
      buffer
        ..write('stars=')
        ..writeAll(stars, ', ')
        ..write(' ');
    }
    if (annotations.isNotEmpty) {
      buffer
        ..write('annotations=')
        ..writeAll(annotations, ', ')
        ..write(' ');
    }
    if (childNodes.isNotEmpty) {
      buffer
        ..write('childNodes=')
        ..writeAll(childNodes, ', ')
        ..write(' ');
    }
    if (closeComplement != null) {
      buffer
        ..write('closeComplement=')
        ..write(closeComplement)
        ..write(' ');
    }
    return (buffer..write('}')).toString();
  }
}

/// Represents a real, non-synthetic DOM element that was parsed,
/// that could be upgraded.
///
/// Clients should not extend, implement, or mix-in this class.
class ParsedElementAst extends TemplateAst with ElementAst {
  /// [NgToken] that represents the identifier tag in `<tag ...>`.
  final NgToken identifierToken;

  ParsedElementAst(
    SourceFile sourceFile,
    NgToken openElementStart,
    this.identifierToken,
    NgToken openElementEnd, {
    this.closeComplement,
    this.attributes = const [],
    this.childNodes = const [],
    this.events = const [],
    this.properties = const [],
    this.references = const [],
    this.bananas = const [],
    this.stars = const [],
    this.annotations = const [],
  }) : super.parsed(openElementStart, openElementEnd, sourceFile);

  /// Name (tag) of the element.
  @override
  String get name => identifierToken.lexeme;

  /// CloseElementAst that complements this elementAst.
  @override
  CloseElementAst? closeComplement;

  @override
  bool get isVoidElement => closeComplement == null;

  /// Attributes
  @override
  final List<AttributeAst> attributes;

  /// Children nodes.
  @override
  final List<StandaloneTemplateAst> childNodes;

  /// Event listeners.
  @override
  final List<EventAst> events;

  /// Property assignments.
  @override
  final List<PropertyAst> properties;

  /// Reference assignments.
  @override
  final List<ReferenceAst> references;

  /// Banana assignments.
  @override
  final List<BananaAst> bananas;

  /// Star assignments.
  @override
  final List<StarAst> stars;

  /// Annotation assignments.
  @override
  final List<AnnotationAst> annotations;
}

class _SyntheticElementAst extends SyntheticTemplateAst with ElementAst {
  _SyntheticElementAst(
    this.name,
    this.closeComplement, {
    this.attributes = const [],
    this.childNodes = const [],
    this.events = const [],
    this.properties = const [],
    this.references = const [],
    this.bananas = const [],
    this.stars = const [],
    this.annotations = const [],
  });

  _SyntheticElementAst.from(
    TemplateAst super.origin,
    this.name,
    this.closeComplement, {
    this.attributes = const [],
    this.childNodes = const [],
    this.events = const [],
    this.properties = const [],
    this.references = const [],
    this.bananas = const [],
    this.stars = const [],
    this.annotations = const [],
  }) : super.from();

  @override
  final String name;

  @override
  CloseElementAst? closeComplement;

  @override
  bool get isVoidElement => closeComplement == null;

  @override
  final List<AttributeAst> attributes;

  @override
  final List<StandaloneTemplateAst> childNodes;

  @override
  final List<EventAst> events;

  @override
  final List<PropertyAst> properties;

  @override
  final List<ReferenceAst> references;

  @override
  final List<BananaAst> bananas;

  @override
  final List<StarAst> stars;

  @override
  final List<AnnotationAst> annotations;
}
