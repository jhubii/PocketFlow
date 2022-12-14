class Users {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String image;
  final double balance;
  final double totalIncome;
  final double totalExpense;
  final double cat1;
  final double cat2;
  final double cat3;
  final double cat4;
  final double cat5;

  Users({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.image,
    required this.balance,
    required this.totalExpense,
    required this.totalIncome,
    required this.cat1,
    required this.cat2,
    required this.cat3,
    required this.cat4,
    required this.cat5,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'image': image,
        'balance': balance,
        'totalExpense': totalExpense,
        'totalIncome': totalIncome,
        'cat1': cat1,
        'cat2': cat2,
        'cat3': cat3,
        'cat4': cat4,
        'cat5': cat5,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email'],
        password: json['password'],
        image: json['image'],
        balance: json['balance'],
        totalExpense: json['totalExpense'],
        totalIncome: json['totalIncome'],
        cat1: json['cat1'],
        cat2: json['cat2'],
        cat3: json['cat3'],
        cat4: json['cat4'],
        cat5: json['cat5'],
      );
}
