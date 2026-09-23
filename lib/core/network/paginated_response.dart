class PaginatedResponse<T> {
  final List<T> content;
  final int pageNo;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool last;

  PaginatedResponse({
    required this.content,
    required this.pageNo,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      content: (json['content'] as List?)?.map(fromJsonT).toList() ?? [],
      pageNo: json['pageNo'] as int? ?? 0,
      pageSize: json['pageSize'] as int? ?? 0,
      totalElements: json['totalElements'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      last: json['last'] as bool? ?? true,
    );
  }
}
