/// Quick Split Calculation Service
/// 
/// Handles all calculation logic for quick bill splitting.
/// Calculates tax, tip, grand total, and per-person amounts.
class QuickSplitService {
  /// Calculate quick split with all parameters
  /// 
  /// Returns [QuickSplitResult] with calculated values
  /// Throws [ArgumentError] if validation fails
  QuickSplitResult calculateQuickSplit({
    required double billAmount,
    required int numberOfPeople,
    double? taxAmount,
    bool isTaxPercentage = false,
    double? taxPercentage,
    double? tipAmount,
    bool isTipPercentage = false,
    double? tipPercentage,
  }) {
    // Validation
    if (billAmount <= 0) {
      throw ArgumentError('Bill amount must be greater than 0');
    }
    if (billAmount > 999999) {
      throw ArgumentError('Bill amount cannot exceed ₹999,999');
    }
    if (numberOfPeople < 2) {
      throw ArgumentError('Minimum 2 people required for splitting');
    }
    if (numberOfPeople > 50) {
      throw ArgumentError('Maximum 50 people allowed');
    }

    // Calculate tax
    double calculatedTax = 0.0;
    if (isTaxPercentage && taxPercentage != null && taxPercentage > 0) {
      calculatedTax = (billAmount * taxPercentage) / 100;
    } else if (!isTaxPercentage && taxAmount != null && taxAmount > 0) {
      calculatedTax = taxAmount;
    }

    // Calculate tip
    double calculatedTip = 0.0;
    if (isTipPercentage && tipPercentage != null && tipPercentage > 0) {
      calculatedTip = (billAmount * tipPercentage) / 100;
    } else if (!isTipPercentage && tipAmount != null && tipAmount > 0) {
      calculatedTip = tipAmount;
    }

    // Calculate grand total
    double grandTotal = billAmount + calculatedTax + calculatedTip;

    // Calculate per person amount (rounded to 2 decimal places)
    double perPersonAmount = _roundToTwoDecimals(grandTotal / numberOfPeople);

    return QuickSplitResult(
      billAmount: billAmount,
      taxAmount: calculatedTax,
      tipAmount: calculatedTip,
      grandTotal: grandTotal,
      perPersonAmount: perPersonAmount,
      numberOfPeople: numberOfPeople,
    );
  }

  /// Round to 2 decimal places
  double _roundToTwoDecimals(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  /// Validate bill amount
  String? validateBillAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter bill amount';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Invalid amount';
    }

    if (amount <= 0) {
      return 'Bill amount must be greater than 0';
    }

    if (amount > 999999) {
      return 'Bill amount cannot exceed ₹999,999';
    }

    return null;
  }

  /// Validate number of people
  String? validateNumberOfPeople(int people) {
    if (people < 2) {
      return 'Minimum 2 people required';
    }
    if (people > 50) {
      return 'Maximum 50 people allowed';
    }
    return null;
  }

  /// Check if tax percentage is unusually high (warning, not error)
  bool isHighTaxPercentage(double? percentage) {
    return percentage != null && percentage > 30;
  }

  /// Check if tip percentage is unusually high (warning, not error)
  bool isHighTipPercentage(double? percentage) {
    return percentage != null && percentage > 25;
  }
}

/// Quick Split Calculation Result
/// 
/// Contains all calculated values from a quick split operation
class QuickSplitResult {
  final double billAmount;
  final double taxAmount;
  final double tipAmount;
  final double grandTotal;
  final double perPersonAmount;
  final int numberOfPeople;

  QuickSplitResult({
    required this.billAmount,
    required this.taxAmount,
    required this.tipAmount,
    required this.grandTotal,
    required this.perPersonAmount,
    required this.numberOfPeople,
  });

  /// Get total amount with tax only (no tip)
  double get billWithTax => billAmount + taxAmount;

  /// Get tax percentage (if tax was applied)
  double? get effectiveTaxPercentage {
    if (taxAmount == 0 || billAmount == 0) return null;
    return (taxAmount / billAmount) * 100;
  }

  /// Get tip percentage (if tip was applied)
  double? get effectiveTipPercentage {
    if (tipAmount == 0 || billAmount == 0) return null;
    return (tipAmount / billAmount) * 100;
  }

  /// Check if tax was applied
  bool get hasTax => taxAmount > 0;

  /// Check if tip was applied
  bool get hasTip => tipAmount > 0;

  @override
  String toString() {
    return 'QuickSplitResult(bill: $billAmount, tax: $taxAmount, tip: $tipAmount, '
        'total: $grandTotal, perPerson: $perPersonAmount, people: $numberOfPeople)';
  }
}
