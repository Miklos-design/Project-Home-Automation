import 'package:http/http.dart' as http;

Future<void> checkApiConnection() async {
  final url = Uri.parse('http://192.168.0.68:8123/api/states');
  final headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3ZDVjMmQ5MjJlZjg0YzhiYmE5NmM2Mzk5NTNkNjk2NyIsImlhdCI6MTcyMjg1OTY4MCwiZXhwIjoyMDM4MjE5NjgwfQ.JMW0uIi2Zwzn0CWRheznp91MQDKHcFTDr9-f68f3qQE',
    'Content-Type': 'application/json',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    print('API connection successful: ${response.body}');
  } else {
    print('Failed to connect to API: ${response.statusCode}, ${response.body}');
  }
}

void main() {
  checkApiConnection();
}
