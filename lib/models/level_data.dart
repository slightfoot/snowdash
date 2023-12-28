class LevelData {
  const LevelData({
    required this.layers,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      layers: (json['layers'] as List) //
          .map((el) => LevelLayer(el))
          .toList(),
    );
  }

  final List<LevelLayer> layers;
}

class LevelLayer {
  LevelLayer(this._json);

  Map<String, dynamic> _json;

  int get id => _json['id'];

  List<int> get data => (_json['data'] as List).cast();

  int get width => _json['width'];

  int get height => _json['height'];
}
