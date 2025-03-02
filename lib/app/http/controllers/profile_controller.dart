import 'dart:io';

import 'package:vania/vania.dart';
import 'package:vania_furniture_api/app/models/wishlist.dart';

class ProfileController extends Controller {
  Future<Response> addWishlist(Request request) async {
    final body = request.body;
    final id = body['id'];

    if (id == null) {
      return Response.json(
          {"error": "id is required"}, HttpStatus.notAcceptable);
    }

    final userId = Auth().id();
    final wishlist = await Wishlist()
        .query()
        .where('user_id', '=', userId)
        .where('product_id', '=', id)
        .first();

    if (wishlist != null) {
      await Wishlist()
          .query()
          .where('product_id', '=', id)
          .where('user_id', '=', userId)
          .delete();

      return Response.json(
          {"message": "Wishlist canceled for this product"}, HttpStatus.ok);
    }

    await Wishlist().query().insert({
      "user_id": userId,
      "product_id": id,
      "created_at": DateTime.now(),
      "updated_at": DateTime.now(),
    });

    return Response.json(
        {"message": "Wishlist added for this product"}, HttpStatus.ok);
  }

  Future<Response> myWishlist(Request request) async {
    final userId = Auth().id();
    final wishlist = await Wishlist()
        .query()
        .join('products', 'products.id', '=', 'wishlists.product_id')
        .select(['products.*'])
        .where('wishlists.user_id', '=', userId)
        .get();

    return Response.json({"data": wishlist});
  }
}

final ProfileController profileController = ProfileController();
