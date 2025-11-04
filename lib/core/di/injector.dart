import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/user_local_data_source.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/add_user.dart';
import '../../domain/usecases/get_users.dart';
import '../../presentation/cubit/user_cubit.dart';
import '../api/dio_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

void init() {
  // Blocs/Cubits
  sl.registerFactory(() => UserCubit(getUsers: sl(), addUser: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => AddUser(sl()));

  // Repositories
  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(remoteDataSource: sl(),localDataSource: sl(), // Add local data source
          networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(), // Register local data source
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(dio: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl())); // Register network info
  sl.registerLazySingleton(() => DioClient.createDio());
  sl.registerLazySingleton(() => Connectivity()); // Register connectivity
}