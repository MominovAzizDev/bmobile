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
];
