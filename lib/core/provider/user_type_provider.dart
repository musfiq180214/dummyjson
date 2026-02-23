import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserType { guest, loggedIn }

final userTypeProvider = StateProvider<UserType>((ref) => UserType.guest);
