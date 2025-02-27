// lib/services/order_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/order.dart';
import 'auth_service.dart';

class OrderService {
  final AuthService _authService = AuthService();

  Future<List<Order>> getOrders({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? status,
    String? search,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Construction de l'URL avec les paramètres
      final queryParams = {'page': page.toString(), 'limit': limit.toString()};

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (startDate != null && startDate.isNotEmpty) {
        queryParams['start_date'] = startDate;
      }

      if (endDate != null && endDate.isNotEmpty) {
        queryParams['end_date'] = endDate;
      }

      final Uri uri = Uri.parse(
        AppConstants.ordersEndpoint,
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> ordersJson = data['orders'];

        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception(AppConstants.serverError);
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération des commandes: ${e.toString()}',
      );
    }
  }

  Future<Order> getOrderById(String id) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.get(
        Uri.parse('${AppConstants.ordersEndpoint}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Order.fromJson(data);
      } else {
        throw Exception('Commande non trouvée');
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération de la commande: ${e.toString()}',
      );
    }
  }

  Future<Order> updateOrderStatus(String id, String status) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.patch(
        Uri.parse('${AppConstants.ordersEndpoint}/$id/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Order.fromJson(data);
      } else {
        throw Exception(
          'Erreur lors de la mise à jour du statut de la commande',
        );
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la mise à jour du statut: ${e.toString()}',
      );
    }
  }

  Future<Map<String, dynamic>> getOrderStats({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Construction de l'URL avec les paramètres
      final queryParams = <String, String>{};

      if (startDate != null && startDate.isNotEmpty) {
        queryParams['start_date'] = startDate;
      }

      if (endDate != null && endDate.isNotEmpty) {
        queryParams['end_date'] = endDate;
      }

      final Uri uri = Uri.parse(
        '${AppConstants.ordersEndpoint}/stats',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception(AppConstants.serverError);
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération des statistiques: ${e.toString()}',
      );
    }
  }

  Future<bool> cancelOrder(String id, String reason) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.post(
        Uri.parse('${AppConstants.ordersEndpoint}/$id/cancel'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'reason': reason}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception(
        'Erreur lors de l\'annulation de la commande: ${e.toString()}',
      );
    }
  }
}
