abstract class Mission {
  int get id;

  String get name;

  String get type;

  Map<String, dynamic> toJson();
}

class MissionImpl implements Mission {
  @override
  final int id;
  @override
  final String name;
  @override
  final String type;

  MissionImpl({required this.id, required this.name, required this.type});

  // Parse from JSON
  factory MissionImpl.fromJson(Map<String, dynamic> json) {
    return MissionImpl(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  // Convert to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}
