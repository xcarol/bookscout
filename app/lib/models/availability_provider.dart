class AvailabilityProvider {
  final String providerName;
  final bool isAvailable;
  final num? price;
  final String? currency;
  final String url;
  final String format;
  final String status;

  AvailabilityProvider({
    required this.providerName,
    required this.isAvailable,
    this.price,
    this.currency,
    required this.url,
    required this.format,
    required this.status,
  });

  factory AvailabilityProvider.fromJson(Map<String, dynamic> json) {
    return AvailabilityProvider(
      providerName: json['providerName'] ?? 'Unknown Provider',
      isAvailable: json['isAvailable'] == true,
      price: json['price'] as num?,
      currency: json['currency'] as String?,
      url: json['url'] ?? '',
      format: json['format'] ?? 'UNKNOWN',
      status: json['status'] ?? 'UNKNOWN',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'providerName': providerName,
      'isAvailable': isAvailable,
      'price': price,
      'currency': currency,
      'url': url,
      'format': format,
      'status': status,
    };
  }
}
