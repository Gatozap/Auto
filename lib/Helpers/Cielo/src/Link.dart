class Link {
  String method;
  String rel;
  String href;

  Link({
    this.method,
    this.rel,
    this.href,
  });

  Map<String, dynamic> toJson() {
    return {
      "Method": this.method == null ? null : this.method,
      "Rel": this.rel == null ? null : this.rel,
      "Href": this.href == null ? null : this.href,
    };
  }

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      method: json["Method"] == null ? null : json["Method"],
      rel: json["Rel"] == null ? null : json["Rel"],
      href: json["Href"] == null ? null : json["Href"],
    );
  }
}
