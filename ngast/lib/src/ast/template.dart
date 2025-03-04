import 'package:collection/collection.dart';
import 'package:source_span/source_span.dart';

import '../ast.dart';
import '../token/tokens.dart';
import '../visitor.dart';

const _listEquals = ListEquality();

/// Represents an embedded template (i.e. is not directly rendered in DOM).
///
/// It shares many properties with an [ElementAst], but is not one. It may be
/// considered invalid to a `<template>` without any [properties] or
/// [references].
///
/// Clients should not extend, implement, or mix-in this class.
abstract mixin class EmbeddedTemplateAst implements StandaloneTemplateAst {
  factory EmbeddedTemplateAst({
    List<AnnotationAst> annotations,
    List<AttributeAst> attributes,
    List<StandaloneTemplateAst> childNodes,
    List<EventAst> events,
    List<PropertyAst> properties,
    List<ReferenceAst> references,
    List<LetBindingAst> letBindings,
  }) = _SyntheticEmbeddedTemplateAst;

  factory EmbeddedTemplateAst.from(
    TemplateAst origin, {
    List<AnnotationAst> annotations,
    List<AttributeAst> attributes,
    List<StandaloneTemplateAst> childNodes,
    List<EventAst> events,
    List<PropertyAst> properties,
    List<ReferenceAst> references,
    List<LetBindingAst> letBindings,
  }) = _SyntheticEmbeddedTemplateAst.from;

  factory EmbeddedTemplateAst.parsed(
    SourceFile sourceFile,
    NgToken beginToken,
    NgToken endToken, {
    CloseElementAst? closeComplement,
    List<AnnotationAst> annotations,
    List<AttributeAst> attributes,
    List<StandaloneTemplateAst> childNodes,
    List<EventAst> events,
    List<PropertyAst> properties,
    List<ReferenceAst> references,
    List<LetBindingAst> letBindings,
  }) = _ParsedEmbeddedTemplateAst;

  @override
  R? accept<R, C>(TemplateAstVisitor<R, C?> visitor, [C? context]) {
    return visitor.visitEmbeddedTemplate(this, context);
  }

  /// Annotations.
  List<AnnotationAst> get annotations;

  /// Attributes.
  ///
  /// Within a `<template>` tag, it may be assumed that this is a directive.
  List<AttributeAst> get attributes;

  /// Events.
  ///
  /// Within a `<template>` tag, it may be assumed that this is a directive.
  List<EventAst> get events;

  /// Property assignments.
  ///
  /// For an embedded template, it may be assumed that all of this will be one
  /// or more structural directives (i.e. like `ngForOf`), as the template
  /// itself does not have properties.
  List<PropertyAst> get properties;

  /// References to the template.
  ///
  /// Unlike a reference to a DOM element, this will be a `TemplateRef`.
  List<ReferenceAst> get references;

  /// `let-` binding defined within a template.
  List<LetBindingAst> get letBindings;

  /// </template> that is paired to this <template>.
  CloseElementAst? get closeComplement;
  set closeComplement(CloseElementAst? closeComplement);

  @override
  bool operator ==(Object? other) {
    return other is EmbeddedTemplateAst &&
        closeComplement == other.closeComplement &&
        _listEquals.equals(annotations, other.annotations) &&
        _listEquals.equals(attributes, other.attributes) &&
        _listEquals.equals(events, other.events) &&
        _listEquals.equals(properties, other.properties) &&
        _listEquals.equals(childNodes, other.childNodes) &&
        _listEquals.equals(references, other.references) &&
        _listEquals.equals(letBindings, other.letBindings);
  }

  @override
  int get hashCode {
    return Object.hashAll([
      closeComplement,
      _listEquals.hash(annotations),
      _listEquals.hash(attributes),
      _listEquals.hash(events),
      _listEquals.hash(childNodes),
      _listEquals.hash(properties),
      _listEquals.hash(references),
      _listEquals.hash(letBindings),
    ]);
  }

  @override
  String toString() {
    final buffer = StringBuffer('$EmbeddedTemplateAst{ ');
    if (annotations.isNotEmpty) {
      buffer
        ..write('annotations=')
        ..writeAll(attributes, ', ')
        ..write(' ');
    }
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
    if (letBindings.isNotEmpty) {
      buffer
        ..write('letBindings=')
        ..writeAll(letBindings, ', ')
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

class _ParsedEmbeddedTemplateAst extends TemplateAst with EmbeddedTemplateAst {
  _ParsedEmbeddedTemplateAst(
    SourceFile sourceFile,
    NgToken beginToken,
    NgToken endToken, {
    this.closeComplement,
    this.annotations = const [],
    this.attributes = const [],
    this.childNodes = const [],
    this.events = const [],
    this.properties = const [],
    this.references = const [],
    this.letBindings = const [],
  }) : super.parsed(beginToken, endToken, sourceFile);

  @override
  final List<AnnotationAst> annotations;

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
  final List<LetBindingAst> letBindings;

  @override
  CloseElementAst? closeComplement;
}

class _SyntheticEmbeddedTemplateAst extends SyntheticTemplateAst
    with EmbeddedTemplateAst {
  _SyntheticEmbeddedTemplateAst({
    this.annotations = const [],
    this.attributes = const [],
    this.childNodes = const [],
    this.events = const [],
    this.properties = const [],
    this.references = const [],
    this.letBindings = const [],
  }) : closeComplement = CloseElementAst('template');

  _SyntheticEmbeddedTemplateAst.from(
    TemplateAst super.origin, {
    this.annotations = const [],
    this.attributes = const [],
    this.childNodes = const [],
    this.events = const [],
    this.properties = const [],
    this.references = const [],
    this.letBindings = const [],
  })  : closeComplement = CloseElementAst('template'),
        super.from();

  @override
  final List<AnnotationAst> annotations;

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
  final List<LetBindingAst> letBindings;

  @override
  CloseElementAst? closeComplement;
}
