/*
  
 */

class ProductReviewSearchModel {
  static const String OrderDesc = 'desc';
  static const String OrderAsc = 'asc';
  static const String OrderByDate = 'date';
  static const String OrderById = 'id';
  static const String OrderByInclude = 'include';
  static const String OrderByProduct = 'product';
  static const String OrderBySlug = 'slug';
  static const String StatusAll = 'all';
  static const String StatusHold = 'hold';
  static const String StatusApproved = 'approved';
  static const String StatusSpam = 'spam';
  static const String StatusTrash = 'trash';

  int page;
  int perPage = 12;
  String search;
  String after;
  String before;
  List<int> exclude;
  List<int> include;
  int offset;
  String order = 'desc';
  String orderBy = 'date';
  List<int> reviewer;
  List<int> reviewerExclude;
  List<String> reviewerEmail;
  List<int> product;
  String status = 'approved';

  ProductReviewSearchModel();

  ProductReviewSearchModel.set({
    this.page,
    this.perPage,
    this.search,
    this.after,
    this.before,
    this.exclude,
    this.include,
    this.offset,
    this.order,
    this.orderBy,
    this.reviewer,
    this.reviewerExclude,
    this.reviewerEmail,
    this.product,
    this.status,
  });

  Map<String, dynamic> toJson() => {
        'page': page,
        'per_page': perPage,
        'search': search,
        'after': after,
        'before': before,
        'exclude': exclude,
        'include': include,
        'offset': offset,
        'order': order,
        'order_by': orderBy,
        'reviewer': reviewer,
        'reviewer_email': reviewerEmail,
        'product': product,
        'status': status,
      };
}
