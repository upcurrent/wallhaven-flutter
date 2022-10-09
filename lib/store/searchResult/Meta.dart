class Meta {
  Meta({
     // required this.currentPage,
     // required this.lastPage,
     // required this.perPage,
     required this.total,
     required this.query,
     required this.seed,});

 factory Meta.fromJson(dynamic json) {
    return Meta(
      //   currentPage : json['current_page'],
      // lastPage : json['last_page'],
      // perPage : json['per_page'],
      total : json['total'],
      seed : json['seed'],
      query: json['query']);
  }
  // final int currentPage;
  // final int lastPage;
  // final int perPage;
  final int total;
  final dynamic query;
  final dynamic seed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // map['current_page'] = currentPage;
    // map['last_page'] = lastPage;
    // map['per_page'] = perPage;
    map['total'] = total;
    map['query'] = query;
    map['seed'] = seed;
    return map;
  }

}
