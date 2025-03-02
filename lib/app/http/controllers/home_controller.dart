import 'dart:io';

import 'package:vania/vania.dart';
import 'package:vania_furniture_api/app/models/products.dart';

class HomeController extends Controller {
  Future<Response> productList(int categoryId) async {
    if (categoryId == -1) {
      final productList = await Products().query().get();
      return Response.json({"data": productList});
    }

    final specificProduct =
        await Products().query().where('category_id', '=', categoryId).get();

    return Response.json({"data": specificProduct});
  }

  Future<Response> detail(int id) async {
    final productDetail = await Products().query().where('id', '=', id).first();

    if (productDetail == null) {
      return Response.json({"error": "Product not found"}, HttpStatus.notFound);
    }

    return Response.json({"data": productDetail});
  }

  Future<Response> search(Request request) async {
    final search = request.query('search');

    if (search == null || search.isEmpty) {
      return Response.json({"data": []});
    } else if (search == 'init') {
      final products = await Products().query().limit(5).get();
      return Response.json({"data": products});
    }

    final searchResult =
        await Products().query().where('title', 'like', '%$search').get();

    return Response.json({"data": searchResult});
  }
}

final HomeController homeController = HomeController();
