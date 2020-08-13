class Channel {
  final int id;
  final String externalId;
  final String title;
  final String logoUri;
  final bool isDefault;
  final bool isBrowsable;

  Channel({
    this.id,
    this.externalId,
    this.isDefault = false,
    this.isBrowsable = false,
    this.title,
    this.logoUri,
  });
}
