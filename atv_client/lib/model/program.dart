class Program {
  final int id;
  final String externalId;
  final String channelExternalId;
  bool isDeleted;

  Program({
    this.id,
    this.externalId,
    this.channelExternalId,
    this.isDeleted = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Program &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          externalId == other.externalId &&
          channelExternalId == other.channelExternalId &&
          isDeleted == other.isDeleted;

  @override
  int get hashCode =>
      id.hashCode ^
      externalId.hashCode ^
      channelExternalId.hashCode ^
      isDeleted.hashCode;

  @override
  String toString() {
    return 'Program{id: $id, externalId: $externalId, channelExternalId: $channelExternalId, isDeleted: $isDeleted}';
  }
}
