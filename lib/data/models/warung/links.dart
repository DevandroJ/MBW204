class Links {
    String self;

    Links({
        this.self,
    });

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json["self"] == null ? null : json["self"],
    );

    Map<String, dynamic> toJson() => {
        "self": self == null ? null : self,
    };
}