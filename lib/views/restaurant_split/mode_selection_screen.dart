import 'package:flutter/material.dart';
import 'widgets/mode_card.dart';
import 'widgets/history_card.dart';
import '../../view_models/restaurant/quick_split_view_model.dart';
import '../../models/restaurant/quick_split_model.dart';

/// Mode Selection Screen
/// Entry point for Restaurant Split feature
/// Displays Quick Split and Item-Level Split options with recent history
class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  final QuickSplitViewModel _viewModel = QuickSplitViewModel();
  List<QuickSplitModel> _recentSplits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentSplits();
  }

  Future<void> _loadRecentSplits() async {
    setState(() => _isLoading = true);
    final splits = await _viewModel.getRecentSplits(limit: 3);
    setState(() {
      _recentSplits = splits;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _navigateToQuickSplit() {
    Navigator.pushNamed(context, '/quick-split-input');
  }

  void _navigateToItemLevelSplit() {
    // TODO: Implement Item-Level Split (Phase 2)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item-Level Split coming soon!'),
        backgroundColor: Color(0xFF00B4D8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _loadHistorySplit(QuickSplitModel split) {
    // Navigate to input screen with pre-loaded data
    Navigator.pushNamed(
      context,
      '/quick-split-input',
      arguments: split,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Restaurant Split',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2D3142)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Choose Splitting Mode',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select how you want to split your restaurant bill',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF2D3142).withOpacity(0.6),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Mode cards
              ModeCard(
                icon: Icons.flash_on_rounded,
                title: 'Quick Split',
                description:
                    'Fast equal splitting for groups. Simple, fair, and instant.',
                color: const Color(0xFF00B4D8),
                badge: 'Fast',
                onTap: _navigateToQuickSplit,
              ),
              const SizedBox(height: 16),
              ModeCard(
                icon: Icons.restaurant_menu_rounded,
                title: 'Item-Level Split',
                description:
                    'Detailed item-by-item splitting. Track who ordered what.',
                color: const Color(0xFFFF6B6B),
                badge: 'Precise',
                onTap: _navigateToItemLevelSplit,
              ),

              // Recent splits section
              if (_recentSplits.isNotEmpty) ...[
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Splits',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    Text(
                      '${_recentSplits.length} items',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2D3142).withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ..._recentSplits.map(
                  (split) => HistoryCard(
                    split: split,
                    onTap: () => _loadHistorySplit(split),
                    color: const Color(0xFF00B4D8),
                  ),
                ),
              ],

              // Loading state
              if (_isLoading) ...[
                const SizedBox(height: 40),
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00B4D8),
                  ),
                ),
              ],

              // Empty state
              if (!_isLoading && _recentSplits.isEmpty) ...[
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 64,
                        color: const Color(0xFF2D3142).withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No recent splits yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF2D3142).withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first split above!',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF2D3142).withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
