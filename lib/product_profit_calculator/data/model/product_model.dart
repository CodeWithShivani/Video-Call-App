class Product {

  String name;

  double mrp;

  String mfg;

  String exp;

  int quantity;

  Product({

    required this.name,

    required this.mrp,

    required this.mfg,

    required this.exp,

    this.quantity = 1,
  });
}