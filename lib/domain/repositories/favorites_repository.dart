import '../entities/favorite_item.dart';

abstract class FavoritesRepository {
  Future<bool> toggle(FavoriteItem item);
  Future<bool> isFavorite(int id);
  Future<List<FavoriteItem>> getAll();
  Stream<List<FavoriteItem>> watchAll();
}
