abstract class SalesBase {
  final String label;

  SalesBase(this.label);
}

class SalesEarning extends SalesBase {
  final int earning;

  SalesEarning(String label, this.earning) : super(label);
}

class SalesCount extends SalesBase {
  final int count;

  SalesCount(String label, this.count) : super(label);
}
