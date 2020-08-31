class GruppoModel {
  final String nome;

  GruppoModel({this.nome});

  factory GruppoModel.fromJson(Map<String, dynamic> json) {
    return GruppoModel(
      nome: json['nome'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'nome': nome};
}
