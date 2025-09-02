import 'package:gazobeton/data/repository/cart_repository.dart';
import 'package:gazobeton/data/repository/product_repository.dart';
import 'package:gazobeton/features/cart/bloc/cart_bloc.dart';
import 'package:gazobeton/features/detail/bloc/product_bloc.dart';
import '../../features/orders/blocs/orders_bloc.dart';
import '../exports.dart';

List<SingleChildWidget> providers = [
  Provider(
    create: (context) => ApiClient(),
  ),
  Provider(
    create: (context) => AuthRepository(
      client: context.read(),
    ),
  ),
  RepositoryProvider<HomeRepository>(
    create: (context) => HomeRepository(
      client: context.read<ApiClient>(),
    ),
  ),
  RepositoryProvider<ProductRepository>(
    create: (context) => ProductRepository(
      client: context.read<ApiClient>(),
    ),
  ),
  BlocProvider(
    create: (context) => ProductBloc(
      repository: context.read<ProductRepository>(),
    ),
  ),
  BlocProvider(
    create: (context) => HomeBloc(
      repo: context.read(),
    ),
  ),
  Provider(
    create: (context) => OrdersRepository(client: context.read()),
  ),
  BlocProvider(
    create: (context) => OrdersBloc(repo: context.read()),
  ),
  Provider(
    create: (context) => CheckoutRepository(client: context.read()),
  ),
  BlocProvider(
    create: (context) => CheckoutBloc(
      repo: context.read(),
    ),
  ),
  Provider(
    create: (context) => CartRepository(client: context.read()),
  ),
  BlocProvider(
    create: (context) => CartBloc(repo: context.read()),
  ),
];