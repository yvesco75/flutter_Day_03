// stats_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/stats.dart'; // Import your stats model

class StatsProvider with ChangeNotifier {
  SalesStats? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  SalesStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStats(DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://votre-api.com/stats?start=$startDate&end=$endDate'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _stats = SalesStats.fromJson(data);
      } else {
        _errorMessage =
            'Failed to load stats: Status code ${response.statusCode}';
        debugPrint(_errorMessage);
        _stats = null; // Ensure stats is null in case of failure
      }
    } catch (error) {
      _errorMessage = 'Error fetching stats: $error';
      debugPrint(_errorMessage);
      _stats = null; // Ensure stats is null in case of failure
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
