class OfferDetails {
  double price;
  String tag;
  String date;
  List<String> servicesIncluded;

  OfferDetails(this.tag, this.price, this.date, this.servicesIncluded);

  OfferDetails.demo() : tag = "JDA", price=10.0, date ="", servicesIncluded = [];
}
