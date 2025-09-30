class OptimizeImageConfig {
  final bool enable;
  final OptimizeImagePlugin plugin;

  OptimizeImageConfig({
    this.enable = false,
    this.plugin = OptimizeImagePlugin.optimole,
  });

  factory OptimizeImageConfig.fromJson(Map<String, dynamic> json) {
    return OptimizeImageConfig(
      enable: json['enable'] ?? false,
      plugin: OptimizeImagePlugin.fromString(json['plugin'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable': enable,
      'plugin': plugin.keyName,
    };
  }
}

enum OptimizeImagePlugin {
  /// ref: https://wordpress.org/plugins/optimole-wp/
  optimole('optimole'),

  /// ref: https://support.inspireui.com/help-center/articles/3/8/19/app-performance
  regenerateImage('re-generate-image'),
  ;

  final String keyName;

  const OptimizeImagePlugin(this.keyName);

  bool get isOptimolePlugin => this == OptimizeImagePlugin.optimole;
  bool get isRegenerateImagePlugin =>
      this == OptimizeImagePlugin.regenerateImage;

  factory OptimizeImagePlugin.fromString(String? value) {
    return OptimizeImagePlugin.values.firstWhere(
      (element) => element.keyName == value,
      orElse: () => OptimizeImagePlugin.regenerateImage,
    );
  }
}
