import 'dart:io';

import 'package:vania/vania.dart';
import 'package:vania_furniture_api/app/models/user.dart';

class AuthController extends Controller {
  Future<Response> register(Request request) async {
    request.validate({
      'name': 'required|string',
      'email': 'required|email',
      'password': 'required',
    }, {
      'name.required': 'Name is required',
      'name.string': 'Name must be a string',
      'email.required': 'Email is required',
      'email.email': 'Invalid email format',
      'password.required': 'Password is required',
    });

    String name = request.input('name');
    String email = request.input('email');
    String password = request.input('password');

    var user = await User().query().where('email', '=', email).first();

    if (user != null) {
      return Response.json(
          {"error": "User already exist"}, HttpStatus.conflict);
    }

    password = Hash().make(password);

    await User().query().insert({
      "name": name,
      "email": email,
      "password": password,
    });

    return Response.json({"message": "register success"}, HttpStatus.created);
  }

  Future<Response> login(Request request) async {
    request.validate({
      'email': 'required|email',
      'password': 'required',
    }, {
      'email.required': 'Email is required',
      'email.email': 'Invalid email format',
      'password.required': 'Password is required',
    });

    final body = request.body;

    var user = await User().query().where('email', '=', body['email']).first();

    if (user == null) {
      return Response.json({"error": "User not found"}, HttpStatus.notFound);
    }

    if (!Hash().verify(body['password'], user['password'])) {
      return Response.json({"error": "Your email or password is wrong"},
          HttpStatus.unauthorized);
    }

    final auth = Auth().login(user);
    final token = await auth.createToken(expiresIn: Duration(days: 30));

    return Response.json(token, HttpStatus.ok);
  }

  Future<Response> updatePassword(Request request) async {
    request.validate({
      'email': 'required|email',
      'new_password': 'required',
      'repeat_password': 'required',
    }, {
      'email.required': 'Email is required',
      'email.email': 'Invalid email format',
      'new_password.required': 'Password is required',
      'repeat_password.required': 'Password is required',
    });

    String email = request.input('email');
    String newPassword = request.input('new_password');
    String repeatPassword = request.input('repeat_password');

    var user = await User().query().where('email', '=', email).first();

    if (user == null) {
      return Response.json({"error": "User not found"}, HttpStatus.notFound);
    }

    if (newPassword != repeatPassword) {
      return Response.json(
          {"error": "Both password needed be equal"}, HttpStatus.notAcceptable);
    }

    await User()
        .query()
        .where('email', '=', email)
        .update({"password": Hash().make(newPassword)});

    return Response.json(
        {"message": "Password update success"}, HttpStatus.accepted);
  }
}

final AuthController authController = AuthController();
