import 'package:hive/hive.dart';

part 'quick_split_model.g.dart';

/// Quick Split Model
/// 
/// Represents a restaurant bill split with equal division among participants.
/// Stores bill amount, tax, tip, and per-person calculations.
@HiveType(typeId: 2)
class QuickSplitModel {
  /// Unique identifier for the split
  @HiveField(0)
  final String splitId;

  /// Timestamp when split was created
  @HiveField(1)
  final DateTime timestamp;

  /// Base bill amount before tax and tip
  @HiveField(2)
  final double billAmount;

  /// Number of people sharing the bill (2-50)
  @HiveField(3)
  final int numberOfPeople;

  /// Calculated or entered tax amount
  @HiveField(4)
  final double? taxAmount;

  /// Whether tax is percentage (true) or fixed amount (false)
  @HiveField(5)
  final bool isTaxPercentage;

  /// Tax percentage value (if isTaxPercentage = true)
  @HiveField(6)
  final double? taxPercentage;

  /// Calculated or entered tip amount
  @HiveField(7)
  final double? tipAmount;

  /// Whether tip is percentage (true) or fixed amount (false)
  @HiveField(8)
  final bool isTipPercentage;

  /// Tip percentage value (if isTipPercentage = true)
  @HiveField(9)
  final double? tipPercentage;

  /// Total amount including bill + tax + tip
  @HiveField(10)
  final double grandTotal;

  /// Amount each person needs to pay
  @HiveField(11)
  final double perPersonAmount;

  /// Currency code (INR, USD, EUR, etc.)
  @HiveField(12)
  final String currency;

  /// Optional restaurant name
  @HiveField(13)
  final String? restaurantName;

  /// List of person indices who have paid (["0", "2", "3"])
  @HiveField(14)
  final List<String> paidBy;

  QuickSplitModel({
    required this.splitId,
    required this.timestamp,
    required this.billAmount,
    required this.numberOfPeople,
    this.taxAmount,
    this.isTaxPercentage = true,
    this.taxPercentage,
    this.tipAmount,
    this.isTipPercentage = true,
    this.tipPercentage,
    required this.grandTotal,
    required this.perPersonAmount,
    required this.currency,
    this.restaurantName,
    this.paidBy = const [],
  });

  /// Create a copy with updated fields
  QuickSplitModel copyWith({
    String? splitId,
    DateTime? timestamp,
    double? billAmount,
    int? numberOfPeople,
    double? taxAmount,
    bool? isTaxPercentage,
    double? taxPercentage,
    double? tipAmount,
    bool? isTipPercentage,
    double? tipPercentage,
    double? grandTotal,
    double? perPersonAmount,
    String? currency,
    String? restaurantName,
    List<String>? paidBy,
  }) {
    return QuickSplitModel(
      splitId: splitId ?? this.splitId,
      timestamp: timestamp ?? this.timestamp,
      billAmount: billAmount ?? this.billAmount,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      taxAmount: taxAmount ?? this.taxAmount,
      isTaxPercentage: isTaxPercentage ?? this.isTaxPercentage,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      tipAmount: tipAmount ?? this.tipAmount,
      isTipPercentage: isTipPercentage ?? this.isTipPercentage,
      tipPercentage: tipPercentage ?? this.tipPercentage,
      grandTotal: grandTotal ?? this.grandTotal,
      perPersonAmount: perPersonAmount ?? this.perPersonAmount,
      currency: currency ?? this.currency,
      restaurantName: restaurantName ?? this.restaurantName,
      paidBy: paidBy ?? this.paidBy,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'splitId': splitId,
      'timestamp': timestamp.toIso8601String(),
      'billAmount': billAmount,
      'numberOfPeople': numberOfPeople,
      'taxAmount': taxAmount,
      'isTaxPercentage': isTaxPercentage,
      'taxPercentage': taxPercentage,
      'tipAmount': tipAmount,
      'isTipPercentage': isTipPercentage,
      'tipPercentage': tipPercentage,
      'grandTotal': grandTotal,
      'perPersonAmount': perPersonAmount,
      'currency': currency,
      'restaurantName': restaurantName,
      'paidBy': paidBy,
    };
  }

  /// Create from JSON
  factory QuickSplitModel.fromJson(Map<String, dynamic> json) {
    return QuickSplitModel(
      splitId: json['splitId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      billAmount: (json['billAmount'] as num).toDouble(),
      numberOfPeople: json['numberOfPeople'] as int,
      taxAmount: json['taxAmount'] != null ? (json['taxAmount'] as num).toDouble() : null,
      isTaxPercentage: json['isTaxPercentage'] as bool? ?? true,
      taxPercentage: json['taxPercentage'] != null ? (json['taxPercentage'] as num).toDouble() : null,
      tipAmount: json['tipAmount'] != null ? (json['tipAmount'] as num).toDouble() : null,
      isTipPercentage: json['isTipPercentage'] as bool? ?? true,
      tipPercentage: json['tipPercentage'] != null ? (json['tipPercentage'] as num).toDouble() : null,
      grandTotal: (json['grandTotal'] as num).toDouble(),
      perPersonAmount: (json['perPersonAmount'] as num).toDouble(),
      currency: json['currency'] as String,
      restaurantName: json['restaurantName'] as String?,
      paidBy: (json['paidBy'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// Get number of people who have paid
  int get paidCount => paidBy.length;

  /// Get number of people who haven't paid
  int get unpaidCount => numberOfPeople - paidCount;

  /// Check if everyone has paid
  bool get isFullyPaid => paidCount == numberOfPeople;

  /// Get total amount paid so far
  double get totalPaidAmount => perPersonAmount * paidCount;

  /// Get remaining amount to be collected
  double get remainingAmount => perPersonAmount * unpaidCount;

  @override
  String toString() {
    return 'QuickSplitModel(id: $splitId, bill: $billAmount, people: $numberOfPeople, perPerson: $perPersonAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuickSplitModel && other.splitId == splitId;
  }

  @override
  int get hashCode => splitId.hashCode;
}
