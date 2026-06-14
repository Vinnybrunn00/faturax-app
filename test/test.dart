

void main() {
  final List<int> vetor = [4, 29, 100, 54, 23, 56];

  int maior = 0;

  maior = vetor[0];

  for (int i = 1; i < vetor.length; i++) {
    if (vetor[i] > maior) {
      maior = vetor[i];
    }
  }
}
