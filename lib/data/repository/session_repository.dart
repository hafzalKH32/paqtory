import '../../core/api_clients.dart';
import '../models/session_model.dart';

class SessionRepository {
  final ApiClient api;
  SessionRepository({ApiClient? apiClient}) : api = apiClient ?? ApiClient();

  Future<List<SessionModel>> fetchSessions() async {
    // Mock data
    await Future.delayed(Duration(milliseconds: 300));
    return [
      SessionModel(id: 's1', creator: 'Alice', title: 'Alice Live Shop'),
      SessionModel(id: 's2', creator: 'Bob', title: 'Bob\'s Deals'),
      SessionModel(id: 's3', creator: 'Sarah', title: 'Fashion by Sarah'),
    ];
  }
}
