import 'package:vania/vania.dart';

import '../app/http/controllers/auth_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.post("/register", authController.register);
    Router.post("/login", authController.login);
    Router.put("/update-password", authController.updatePassword);
  }
}
