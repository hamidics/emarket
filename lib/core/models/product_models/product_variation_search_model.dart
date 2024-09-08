/*
  
 */

class ProductVariationSearchModel {
  static const String OrderDesc = 'desc';
  static const String OrderAsc = 'asc';
  static const String OrderByDate = 'date';
  static const String OrderById = 'id';
  static const String OrderByInclude = 'include';
  static const String OrderByTitle = 'title';
  static const String OrderBySlug = 'slug';
  static const String StatusAny = 'any';
  static const String StatusDraft = 'draft';
  static const String StatusPending = 'pending';
  static const String StatusPrivate = 'private';
  static const String StatusPublish = 'publish';
  static const String StockStatusInStock = 'instock';
  static const String StockStatusOutOfStock = 'outofstock';
  static const String StockStatusOnBackOrder = 'onbackorder';

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
  List<int> parent;
  List<int> parentExclude;
  String slug;
  String status = 'publish';
  String sku;
  bool onSale;
  String minPrice;
  String maxPrice;
  String stockStatus;

  ProductVariationSearchModel();

  ProductVariationSearchModel.set({
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
    this.parent,
    this.parentExclude,
    this.slug,
    this.status,
    this.sku,
    this.onSale,
    this.minPrice,
    this.maxPrice,
    this.stockStatus,
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
        'parent': parent,
        'parent_exclude': parentExclude,
        'slug': slug,
        'status': status,
        'sku': sku,
        'on_sale': onSale,
        'min_price': minPrice,
        'max_price': maxPrice,
        'stock_status': stockStatus,
      };
}
