import 'package:gazobeton/core/exports.dart';
import 'package:gazobeton/data/repository/product_repository.dart';
import 'package:gazobeton/features/detail/bloc/product_event.dart';
import 'package:gazobeton/features/detail/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<LoadProductByIdEvent>(_onLoadProductById);
    on<LoadProductsByCategoryEvent>(_onLoadProductsByCategory); // YANGI event
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.fetchProduct();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Mahsulotlarni yuklashda xatolik: ${e.toString()}'));
    }
  }

  Future<void> _onLoadProductById(
    LoadProductByIdEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.fetchProduct();
      final product = products.firstWhere(
        (p) => p.productCategoryId == event.productId,
        orElse: () => products.first,
      );
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductError('Mahsulot yuklashda xatolik: ${e.toString()}'));
    }
  }

  // YANGI: Kategoriya bo'yicha mahsulotlarni yuklash
  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.fetchProductsByCategory(event.categoryId);
      if (products.isNotEmpty) {
        emit(ProductLoaded(products));
      } else {
        emit(ProductError('Bu kategoriyada mahsulotlar topilmadi'));
      }
    } catch (e) {
      emit(ProductError('Kategoriya mahsulotlarini yuklashda xatolik: ${e.toString()}'));
    }
  }
}