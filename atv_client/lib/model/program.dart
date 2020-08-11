class Program {
  final String id;
  final String externalId;
  final String channelExternalId;
  final bool isDeleted;

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
}
