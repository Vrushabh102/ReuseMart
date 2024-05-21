class SellItemModel {
  final String title;
  final String description;
  final String photoUrl;
  final String price;
  final bool showPersonalDetails;

  SellItemModel(
      {required this.title,
      required this.description,
      required this.photoUrl,
      required this.price,
      required this.showPersonalDetails});

  Map<String,dynamic> toJson() {
    return {
      'description' : description,
      'photoUrl' : photoUrl,
      'price' : price,
      'showPersonalDetails' : showPersonalDetails,
      'title' : title
    };
  }


}

