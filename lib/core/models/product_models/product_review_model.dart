/*
  
 */

class ProductReviewModel {
  int id;
  DateTime dateCreated;
  int productId;
  String status;
  String reviewer;
  String reviewerEmail;
  String review;
  int rating;
  bool verified;
  Map<String, String> reviewerAvatarUrls;

  ProductReviewModel();

  ProductReviewModel.set({
    this.id,
    this.dateCreated,
    this.productId,
    this.status,
    this.reviewer,
    this.reviewerEmail,
    this.review,
    this.rating,
    this.verified,
    this.reviewerAvatarUrls,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) =>
      ProductReviewModel.set(
        id: json['id'],
        dateCreated: DateTime.parse(json['date_created']),
        productId: json['product_id'],
        status: json['status'],
        reviewer: json['reviewer'],
        reviewerEmail: json['reviewer_email'],
        review: json['review'],
        rating: json['rating'],
        verified: json['verified'],
        reviewerAvatarUrls: Map.from(json['reviewer_avatar_urls'])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date_created': dateCreated.toIso8601String(),
        'product_id': productId,
        'status': status,
        'reviewer': reviewer,
        'reviewer_email': reviewerEmail,
        'review': review,
        'rating': rating,
        'verified': verified,
        'reviewer_avatar_urls': Map.from(reviewerAvatarUrls)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
