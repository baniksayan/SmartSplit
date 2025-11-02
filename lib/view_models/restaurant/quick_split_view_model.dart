import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../models/restaurant/quick_split_model.dart';
import '../../models/activity/activity_model.dart';
import '../../services/calculation/quick_split_service.dart';
import '../../services/database/quick_split_history_service.dart';
import '../../services/database/activity_service.dart';

/// Quick Split View Model
/// 
/// MVVM ViewModel for Quick Split feature.
/// Manages form state, real-time calculations, and data persistence.
class QuickSplitViewModel extends ChangeNotifier {
  final QuickSplitService _calculationService = QuickSplitService();
  final QuickSplitHistoryService _historyService = QuickSplitHistoryService();
  final ActivityService _activityService = ActivityService();

  // Form controllers
  final TextEditingController billAmountController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController tipController = TextEditingController();
  final TextEditingController restaurantNameController = TextEditingController();

  // Form state
  int numberOfPeople = 2;
  bool isTaxPercentage = true;
  bool isTipPercentage = true;

  // Calculation results
  QuickSplitResult? result;
  QuickSplitResult? previewResult;
  QuickSplitModel? savedSplit;

  // Payment tracking
  List<bool> paidStatus = [];

  // Currency from user profile
  String currency = 'INR';

  // Loading and error states
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  // Validation
  String? billAmountError;

  /// Initialize with user currency
  void init(String userCurrency) {
    currency = userCurrency;
    _setupListeners();
  }

  /// Setup listeners for real-time preview
  void _setupListeners() {
    billAmountController.addListener(_calculatePreview);
    taxController.addListener(_calculatePreview);
    tipController.addListener(_calculatePreview);
  }

  /// Calculate preview in real-time
  void _calculatePreview() {
    try {
      final billAmount = double.tryParse(billAmountController.text) ?? 0.0;
      
      if (billAmount <= 0) {
        previewResult = null;
        notifyListeners();
        return;
      }

      final taxValue = double.tryParse(taxController.text) ?? 0.0;
      final tipValue = double.tryParse(tipController.text) ?? 0.0;

      previewResult = _calculationService.calculateQuickSplit(
        billAmount: billAmount,
        numberOfPeople: numberOfPeople,
        isTaxPercentage: isTaxPercentage,
        taxPercentage: isTaxPercentage ? taxValue : null,
        taxAmount: !isTaxPercentage ? taxValue : null,
        isTipPercentage: isTipPercentage,
        tipPercentage: isTipPercentage ? tipValue : null,
        tipAmount: !isTipPercentage ? tipValue : null,
      );

      notifyListeners();
    } catch (e) {
      previewResult = null;
    }
  }

  /// Increment number of people
  void incrementPeople() {
    if (numberOfPeople < 50) {
      numberOfPeople++;
      _calculatePreview();
    }
  }

  /// Decrement number of people
  void decrementPeople() {
    if (numberOfPeople > 2) {
      numberOfPeople--;
      _calculatePreview();
    }
  }

  /// Toggle tax type (percentage ↔ fixed amount)
  void toggleTaxType() {
    isTaxPercentage = !isTaxPercentage;
    taxController.clear();
    _calculatePreview();
  }

  /// Toggle tip type (percentage ↔ fixed amount)
  void toggleTipType() {
    isTipPercentage = !isTipPercentage;
    tipController.clear();
    _calculatePreview();
  }

  /// Set tip percentage (quick selector: 0%, 10%, 15%, 20%)
  void setTipPercentage(double percentage) {
    isTipPercentage = true;
    tipController.text = percentage.toString();
    _calculatePreview();
  }

  /// Validate form and calculate final result
  bool validateAndCalculate() {
    // Validate bill amount
    billAmountError = _calculationService.validateBillAmount(
      billAmountController.text,
    );

    if (billAmountError != null) {
      notifyListeners();
      return false;
    }

    try {
      final billAmount = double.parse(billAmountController.text);
      final taxValue = double.tryParse(taxController.text) ?? 0.0;
      final tipValue = double.tryParse(tipController.text) ?? 0.0;

      result = _calculationService.calculateQuickSplit(
        billAmount: billAmount,
        numberOfPeople: numberOfPeople,
        isTaxPercentage: isTaxPercentage,
        taxPercentage: isTaxPercentage ? taxValue : null,
        taxAmount: !isTaxPercentage ? taxValue : null,
        isTipPercentage: isTipPercentage,
        tipPercentage: isTipPercentage ? tipValue : null,
        tipAmount: !isTipPercentage ? tipValue : null,
      );

      // Initialize payment tracking
      paidStatus = List.filled(numberOfPeople, false);

      errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Toggle paid status for a person
  void togglePaidStatus(int index) {
    if (index >= 0 && index < paidStatus.length) {
      paidStatus[index] = !paidStatus[index];
      notifyListeners();
    }
  }

  /// Mark all as paid
  void markAllAsPaid() {
    paidStatus = List.filled(numberOfPeople, true);
    notifyListeners();
  }

  /// Mark all as unpaid
  void markAllAsUnpaid() {
    paidStatus = List.filled(numberOfPeople, false);
    notifyListeners();
  }

  /// Save split to history
  Future<bool> saveToHistory() async {
    if (result == null) return false;

    try {
      isSaving = true;
      notifyListeners();

      final split = QuickSplitModel(
        splitId: const Uuid().v4(),
        timestamp: DateTime.now(),
        billAmount: result!.billAmount,
        numberOfPeople: result!.numberOfPeople,
        taxAmount: result!.taxAmount,
        isTaxPercentage: isTaxPercentage,
        taxPercentage: isTaxPercentage ? double.tryParse(taxController.text) : null,
        tipAmount: result!.tipAmount,
        isTipPercentage: isTipPercentage,
        tipPercentage: isTipPercentage ? double.tryParse(tipController.text) : null,
        grandTotal: result!.grandTotal,
        perPersonAmount: result!.perPersonAmount,
        currency: currency,
        restaurantName: restaurantNameController.text.trim().isEmpty
            ? null
            : restaurantNameController.text.trim(),
        paidBy: paidStatus
            .asMap()
            .entries
            .where((e) => e.value)
            .map((e) => e.key.toString())
            .toList(),
      );

      // Save to history
      await _historyService.saveSplit(split);
      savedSplit = split;

      // Add to activity feed
      final activity = ActivityModel(
        activityId: const Uuid().v4(),
        activityType: ActivityType.restaurant,
        timestamp: DateTime.now(),
        title: split.restaurantName ?? 'Quick Split',
        description: 'Split among ${result!.numberOfPeople} people',
        amount: result!.grandTotal,
        participantCount: result!.numberOfPeople,
        amountPerPerson: result!.perPersonAmount,
        currency: currency,
      );
      await _activityService.addActivity(activity);

      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Failed to save: $e';
      isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Get recent splits
  Future<List<QuickSplitModel>> getRecentSplits({int limit = 10}) async {
    try {
      return await _historyService.getRecentSplits(limit: limit);
    } catch (e) {
      debugPrint('Error getting recent splits: $e');
      return [];
    }
  }

  /// Load a split from history (for reuse)
  void loadFromHistory(QuickSplitModel split) {
    billAmountController.text = split.billAmount.toString();
    numberOfPeople = split.numberOfPeople;
    
    if (split.taxAmount != null && split.taxAmount! > 0) {
      isTaxPercentage = split.isTaxPercentage;
      if (split.isTaxPercentage && split.taxPercentage != null) {
        taxController.text = split.taxPercentage.toString();
      } else {
        taxController.text = split.taxAmount.toString();
      }
    }
    
    if (split.tipAmount != null && split.tipAmount! > 0) {
      isTipPercentage = split.isTipPercentage;
      if (split.isTipPercentage && split.tipPercentage != null) {
        tipController.text = split.tipPercentage.toString();
      } else {
        tipController.text = split.tipAmount.toString();
      }
    }
    
    if (split.restaurantName != null) {
      restaurantNameController.text = split.restaurantName!;
    }
    
    _calculatePreview();
  }

  /// Reset form to initial state
  void reset() {
    billAmountController.clear();
    taxController.clear();
    tipController.clear();
    restaurantNameController.clear();
    numberOfPeople = 2;
    isTaxPercentage = true;
    isTipPercentage = true;
    result = null;
    previewResult = null;
    savedSplit = null;
    paidStatus = [];
    errorMessage = null;
    billAmountError = null;
    notifyListeners();
  }

  /// Format currency amount
  String formatCurrency(double amount) {
    final currencySymbols = {
      'INR': '₹',
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'CHF': 'CHF',
      'SEK': 'kr',
      'NZD': 'NZ\$',
    };

    final symbol = currencySymbols[currency] ?? currency;
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Get currency symbol
  String getCurrencySymbol() {
    const symbols = {
      'INR': '₹',
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'CHF': 'CHF',
      'SEK': 'kr',
      'NZD': 'NZ\$',
    };
    return symbols[currency] ?? currency;
  }

  /// Check if preview is available
  bool get hasPreview => previewResult != null;

  /// Check if tax warning should be shown
  bool get showTaxWarning {
    if (!isTaxPercentage) return false;
    final percentage = double.tryParse(taxController.text);
    return _calculationService.isHighTaxPercentage(percentage);
  }

  /// Check if tip warning should be shown
  bool get showTipWarning {
    if (!isTipPercentage) return false;
    final percentage = double.tryParse(tipController.text);
    return _calculationService.isHighTipPercentage(percentage);
  }

  /// Get paid count
  int get paidCount => paidStatus.where((paid) => paid).length;

  /// Get unpaid count
  int get unpaidCount => paidStatus.where((paid) => !paid).length;

  @override
  void dispose() {
    billAmountController.dispose();
    taxController.dispose();
    tipController.dispose();
    restaurantNameController.dispose();
    super.dispose();
  }
}
