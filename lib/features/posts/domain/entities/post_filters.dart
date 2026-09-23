import 'package:equatable/equatable.dart';

class PostFilters extends Equatable {
  final String? transactionType;
  final String? location;

  const PostFilters({
    this.transactionType,
    this.location,
  });

  PostFilters copyWith({
    String? transactionType,
    String? location,
    bool clearTransactionType = false,
    bool clearLocation = false,
  }) {
    return PostFilters(
      transactionType: clearTransactionType ? null : transactionType ?? this.transactionType,
      location: clearLocation ? null : location ?? this.location,
    );
  }

  bool get isEmpty => transactionType == null && location == null;
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [transactionType, location];
}
