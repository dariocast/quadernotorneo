class GiocatoreModel {
  final int id;
  final String nome;
  final String gruppo;
  final int gol;

  GiocatoreModel({this.id, this.nome, this.gruppo, this.gol});

  factory GiocatoreModel.fromJson(Map<String, dynamic> json) {
    return GiocatoreModel(
      id: json['_id'] as int,
      nome: json['nome'] as String,
      gruppo: json['gruppo'] as String,
      gol: json['gol'] as int,
    );
  }

  Map<String, dynamic> toJson() =>
      {'_id': id, 'nome': nome, 'gruppo': gruppo, 'gol': gol};
}
