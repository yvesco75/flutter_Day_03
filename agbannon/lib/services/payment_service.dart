// lib/services/payment_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/payment.dart';
import 'auth_service.dart';

class PaymentService {
  final AuthService _authService = AuthService();

  Future<List<Payment>> getPayments({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? method,
    String? orderId,
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

      if (method != null && method.isNotEmpty) {
        queryParams['method'] = method;
      }

      if (orderId != null && orderId.isNotEmpty) {
        queryParams['order_id'] = orderId;
      }

      if (startDate != null && startDate.isNotEmpty) {
        queryParams['start_date'] = startDate;
      }

      if (endDate != null && endDate.isNotEmpty) {
        queryParams['end_date'] = endDate;
      }

      final Uri uri = Uri.parse(
        AppConstants.paymentsEndpoint,
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
        final List<dynamic> paymentsJson = data['payments'];

        return paymentsJson.map((json) => Payment.fromJson(json)).toList();
      } else {
        throw Exception(AppConstants.serverError);
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération des paiements: ${e.toString()}',
      );
    }
  }

  Future<Payment> getPaymentById(String id) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.get(
        Uri.parse('${AppConstants.paymentsEndpoint}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Payment.fromJson(data);
      } else {
        throw Exception('Paiement non trouvé');
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la récupération du paiement: ${e.toString()}',
      );
    }
  }

  Future<Payment> confirmPayment(String id) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.post(
        Uri.parse('${AppConstants.paymentsEndpoint}/$id/confirm'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Payment.fromJson(data);
      } else {
        throw Exception('Erreur lors de la confirmation du paiement');
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la confirmation du paiement: ${e.toString()}',
      );
    }
  }

  Future<Payment> createPayment(
    String orderId,
    double amount,
    String method,
  ) async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await http.post(
        Uri.parse(AppConstants.paymentsEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'order_id': orderId,
          'amount': amount,
          'method': method,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Payment.fromJson(data);
      } else {
        throw Exception('Erreur lors de la création du paiement');
      }
    } catch (e) {
      throw Exception(
        'Erreur lors de la création du paiement: ${e.toString()}',
      );
    }
  }

  Future<Map<String, dynamic>> getPaymentStats({
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
        '${AppConstants.paymentsEndpoint}/stats',
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
}
