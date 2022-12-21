class DataHelper {
  static const generations = [
    Generation(1, "I"),
    Generation(2, "II"),
    Generation(3, "III"),
    Generation(4, "IV"),
    Generation(5, "V"),
    Generation(6, "VI"),
    Generation(7, "VII"),
    Generation(8, "VIII"),
  ];
}

class Generation {
  final int number;
  final String text;
  const Generation(this.number,this.text);
}