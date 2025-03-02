import 'package:vania/vania.dart';
import 'package:vania_furniture_api/app/http/controllers/auth_controller.dart';
import 'package:vania_furniture_api/app/http/controllers/home_controller.dart';
import 'package:vania_furniture_api/app/http/controllers/profile_controller.dart';
import 'package:vania_furniture_api/app/http/middleware/authenticate.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix('api');

    Router.post("/register", authController.register);
    Router.post("/login", authController.login);
    Router.put("/update_pass", authController.updatePassword);

    Router.group(() {
      // Products
      Router.get("/get_products/{id}", homeController.productList);
      Router.get("/detail_product/{id}", homeController.detail);
      Router.get("/search_product", homeController.search);

      // Wish list
      Router.post("/add_wishlist", profileController.addWishlist);
      Router.get("/my_wishlist", profileController.myWishlist);
    }, middleware: [AuthenticateMiddleware()]);
  }
}
