class Sos {
  int _id;
  String _name;
  String _icon;
  String _desc;
  String _type;

  Sos({
    int id,
    String name,
    String slug,
    String icon,
    String desc,
    String type
  }) {
    this._id = id;
    this._name = name;
    this._icon = icon;
    this._desc = desc;
    this._type = type;
  }

  int get id => _id;
  String get name => _name;
  String get icon => _icon;
  String get desc => _desc;
  String get type => _type; 

  Sos.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _icon = json['icon'];
    _desc = json["desc"];
    _type = json["type"];
  }
}
