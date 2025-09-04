import 'package:gazobeton/data/repository/cart_repository.dart';
import 'package:gazobeton/data/repository/product_repository.dart';
import 'package:gazobeton/features/cart/bloc/cart_bloc.dart';
import 'package:gazobeton/features/detail/bloc/product_bloc.dart';
import '../../features/orders/blocs/orders_bloc.dart';
import '../exports.dart';

List<SingleChildWidget> providers = [
  // 1. Avval barcha Providerlar (Repository va Client)
  Provider(
    create: (context) => ApiClient(),
  ),
  
  Provider(
    create: (context) => AuthRepository(
      client: context.read<ApiClient>(),
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
  
  Provider(
    create: (context) => CartRepository(client: context.read<ApiClient>()),
  ),
  
  Provider(
    create: (context) => OrdersRepository(client: context.read<ApiClient>()),
  ),
  
  Provider(
    create: (context) => CheckoutRepository(client: context.read<ApiClient>()),
  ),

  // 2. Keyin dependency yo'q BlocProvider lar
  BlocProvider(
    create: (context) => ProductBloc(
      repository: context.read<ProductRepository>(),
    ),
  ),
  
  BlocProvider(
    create: (context) => HomeBloc(
      repo: context.read<HomeRepository>(),
    ),
  ),
  
  // 3. CartBloc ni avval yaratish (chunki boshqalar undan foydalanadi)
  BlocProvider(
    create: (context) => CartBloc(repo: context.read<CartRepository>()),
  ),
  
  // 4. CartBloc ga dependency bor BlocProvider lar
  BlocProvider(
    create: (context) => OrdersBloc(
      cartBloc: context.read<CartBloc>(), // Endi CartBloc mavjud!
      repo: context.read<OrdersRepository>(),
    ),
  ),
  
  // 5. Eng oxirida CheckoutBloc (ko'p dependency bor)
  BlocProvider(
    create: (context) => CheckoutBloc(
      ordersBloc: context.read<OrdersBloc>(),
      cartBloc: context.read<CartBloc>(),
      repo: context.read<CheckoutRepository>(),
    ),
  ),
];