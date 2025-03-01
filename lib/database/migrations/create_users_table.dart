import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      id();
      char('name', length: 100);
      char('password', length: 200);
      char('email', length: 191, unique: true);
      char('avatar', length: 100, nullable: true);
      char('phone', length: 150, nullable: true);
      longText('description', nullable: true);
      char('birth_day', length: 200, nullable: true);
      mediumInt('gender', nullable: true);
      dateTime('created_at', defaultValue: DateTime.now().toString());
      dateTime('updated_at', defaultValue: DateTime.now().toString());
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
