// lib/screens/search/search_screen.dart
import 'package:flutter/material.dart';
import 'package:dating_app/config/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.lightBackground;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: onSurfaceColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                // TODO: Implement search
              },
            ),
            const SizedBox(height: 16),
            // Filter chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip('All', true, primaryColor),
                  _buildFilterChip('Women', false, primaryColor),
                  _buildFilterChip('Men', false, primaryColor),
                  _buildFilterChip('Nearby', false, primaryColor),
                  _buildFilterChip('Premium', false, primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Results
            Expanded(
              child: Center(
                child: Text(
                  'Search results will appear here',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // TODO: Filter search
        },
        backgroundColor: Colors.transparent,
        selectedColor: primaryColor.withOpacity(0.1),
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          color: isSelected ? primaryColor : Colors.grey,
        ),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.grey.shade300,
        ),
      ),
    );
  }
}