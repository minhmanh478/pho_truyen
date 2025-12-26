class FilterSettingsModel {
  final List<FilterGroup> filter;
  final List<SortOption> sort;

  FilterSettingsModel({required this.filter, required this.sort});

  factory FilterSettingsModel.fromJson(Map<String, dynamic> json) {
    return FilterSettingsModel(
      filter: (json['filter'] as List? ?? [])
          .map((e) => FilterGroup.fromJson(e))
          .toList(),
      sort: (json['sort'] as List? ?? [])
          .map((e) => SortOption.fromJson(e))
          .toList(),
    );
  }
}

class FilterGroup {
  final String title;
  final String code;
  final String type;
  final List<FilterOption> data;

  FilterGroup({
    required this.title,
    required this.code,
    required this.type,
    required this.data,
  });

  factory FilterGroup.fromJson(Map<String, dynamic> json) {
    return FilterGroup(
      title: json['title'] ?? '',
      code: json['code'] ?? '',
      type: json['type'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => FilterOption.fromJson(e))
          .toList(),
    );
  }
}

class FilterOption {
  final String title;
  final String? value;

  FilterOption({required this.title, this.value});

  factory FilterOption.fromJson(Map<String, dynamic> json) {
    return FilterOption(title: json['title'] ?? '', value: json['value']);
  }
}

class SortOption {
  final String title;
  final String order;
  final String sort;

  SortOption({required this.title, required this.order, required this.sort});

  factory SortOption.fromJson(Map<String, dynamic> json) {
    return SortOption(
      title: json['title'] ?? '',
      order: json['order'] ?? '',
      sort: json['sort'] ?? '',
    );
  }
}
