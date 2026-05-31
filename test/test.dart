void main() {
  final List<List<int>> matriz = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 5, 6, 7],
    [4, 8, 2, 3],
  ];

  final List<int> primary = [];
  final List<int> secondary = [];

  for (int i = 0; i < matriz.length; i++) {
    for (int j = 0; j < matriz[i].length; j++) {
      if (j == i) primary.add(matriz[i][j]);
    }
    secondary.add(matriz[i][matriz[i].length - i - 1]);
  }
}
