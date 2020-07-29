enum ItemType {
  http,
  https,
}

class ProxyListItem {
  final String host;
  final int port;
  final ItemType type;
  final String country;


  ProxyListItem({this.host, this.port, this.type, this.country});

  factory ProxyListItem.fromJson(Map<String, dynamic> json) {
    return ProxyListItem(
      host: json['host'] as String,
      port: json['port'] as int,
      type: (json['type'] as String) == 'http' ? ItemType.http : ItemType.https,
      country: json['country'] as String,
    );
  }
}