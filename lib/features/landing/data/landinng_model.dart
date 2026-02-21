class UpdateType {
  final bool forceUpdate;
  final int currentBuild;
  final int updatedBuild;

  UpdateType({
    required this.forceUpdate,
    required this.currentBuild,
    required this.updatedBuild,
  });

  factory UpdateType.fromJson(Map<String, dynamic> json) {
    return UpdateType(
      forceUpdate: json['force_update'] ?? false,
      currentBuild: json['current_build'] ?? 0,
      updatedBuild: json['updated_build'] ?? 0,
    );
  }

  bool get isMajorUpdate => forceUpdate;
}
