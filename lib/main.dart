import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unifi_exams/presentation/cubit/user_cubit.dart';
import '../../core/di/injector.dart' as di;

import 'core/routing/app_router.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<UserCubit>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Exam',
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: AppRouter.router,
      ),
    );
  }
}