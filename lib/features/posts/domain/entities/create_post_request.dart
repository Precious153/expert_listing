enum TransactionType { sale, rent, general }

class CreatePostRequest {
  final String content;
  final String imageUrl;
  final String location;
  final TransactionType transactionType;

  CreatePostRequest({
    required this.content,
    this.imageUrl = '',
    this.location = '',
    this.transactionType = TransactionType.general,
  });

  Map<String, dynamic> toJson() {
    String tType;
    switch (transactionType) {
      case TransactionType.sale:
        tType = 'FOR_SALE';
        break;
      case TransactionType.rent:
        tType = 'FOR_RENT';
        break;
      case TransactionType.general:
        tType = 'GENERAL';
        break;
    }

    return {
      'content': content,
      'imageUrl': imageUrl,
      'location': location,
      'transactionType': tType,
    };
  }
}
