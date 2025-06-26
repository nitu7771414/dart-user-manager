import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

List<Map<String, dynamic>> users = [];

Future<void> fetchUsers() async {
  try {
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/users");
    final response = await http.get(
      uri,
      headers: {'User-Agent': 'Mozilla/5.0', 'Accept': 'application/json'},
    );
    List dec = jsonDecode(response.body);
    users = List<Map<String, dynamic>>.from(dec);
    print(dec);
  } catch (e) {
    print("unsuccessful!");
  }
}

void showMenu() {
  print("==== User Manager Menu ====");
  print("1. show all users");
  print("2. show details of users by id");
  print("3. filter users by city");
  print("4. exit");
  stdout.write("enter choice : ");
}

void showUsernames() {
  for (var user in users) {
    print("user : ${user['username']}");
  }
}

void userById() {
  Map<String, dynamic>? user;
  stdout.write("enter id: ");
  String? input = stdin.readLineSync();
  int? id = int.tryParse(input ?? '');

  for (var u in users) {
    if (u['id'] == id) {
      user = u;
      break;
    }
  }
  if (user == null) {
    print("error");
  } else {
    print('''User Details:
    Name :    ${user['name']}
    Username: ${user['username']}
    Email   : ${user['email']}
    City    : ${user['address']['city']}
    Company : ${user['company']['name']}
    ''');
  }
}

void filterUsersByCity() {
  stdout.write('\n city name: ');
  String? city = stdin.readLineSync();
  final filtered = users.where(
    (user) =>
        user['address']['city'].toString().toLowerCase() == city?.toLowerCase(),
  );
  print('\n users in $city:');
  for (var user in filtered) {
    print(' ${user['name']} (${user['username']})');
  }
}

void main() async {
  await fetchUsers();
  while (true) {
    showMenu();
    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        showUsernames();
        break;
      case '2':
        userById();
        break;
      case '3':
        filterUsersByCity();
        break;
      case '4':
        print("goodbye!");
        break;
      default:
        print("invalid choice");
    }
  }
}
