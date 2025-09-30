class YITHBadgeSize {
  const YITHBadgeSize({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  factory YITHBadgeSize.fromJson(Map<String?, dynamic> json) => YITHBadgeSize(
        width: double.tryParse(json['dimensions']['width']) ?? 0.0,
        height: double.tryParse(json['dimensions']['height']) ?? 0.0,
      );
}
