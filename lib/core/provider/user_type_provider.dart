import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userTypeProvider = StateProvider<UserType>((ref) => UserType.guest);
