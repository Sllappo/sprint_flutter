class Candidat {
  final String nom;
  final Map<String, int> scores = {};
  final Set<String> testsEffectues = {};

  Candidat(this.nom);

  bool peutPasserTest(String discipline) => !testsEffectues.contains(discipline);

  void ajouterScore(String discipline, int score) {
    scores[discipline] = score;
    testsEffectues.add(discipline);
  }
}

class Question {
  final String enonce;
  final List<String> options;
  final int bonneReponse;
  final int tempsLimite;

  Question(this.enonce, this.options, this.bonneReponse, this.tempsLimite);
}
