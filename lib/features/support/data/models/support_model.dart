import '../../domain/entities/support_entity.dart';

class SupportModel extends SupportEntity {
  const SupportModel({
    required super.id,
    required super.name,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
