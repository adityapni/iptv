class Ads {
  late int? id;
  late String? url;
  late String? image_path;

  Ads({
    this.id,
    this.url,
    this.image_path,
  });

  Ads.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    url = json["url"] ?? '';
    image_path = json["image_path"] ?? '';
  }

}
