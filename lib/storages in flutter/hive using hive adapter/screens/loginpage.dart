import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project_june1/storages%20in%20flutter/hive%20using%20hive%20adapter/database/hive_db.dart';
import '../models/user_model.dart';
import 'home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //Hive.registerAdapter();
  await Hive.openBox<User>('userData');
  runApp(GetMaterialApp(home: Login2(),));
}

class Login2 extends StatelessWidget {
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HiveLogin'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Username'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pass,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            ElevatedButton(onPressed: () async {
              final users = await HiveDb.instance.getUser();
              checkUserExist(context,users);
            }, child: Text('Login')),
            TextButton(onPressed: (){}, child: Text('Not a User? Register Here'))
          ],
        ),
      ),
    );
  }

  Future <void> checkUserExist(BuildContext context,List<User> users) async{
    final lemail = email.text.trim();
    final lpass = pass.text.trim();
    bool userFound = false;
    if(lemail != " " && lpass != ""){
      await Future.forEach(users, (singleUser){
        if(lemail == singleUser.email && lpass == singleUser.password){
          userFound = true;
        }else{
          userFound = false;
        }
      });
      if(userFound == true){
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HiveHome(email: lemail,)));
        Get.offAll(HiveHome(email: lemail,));
      }else{
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Falied, User Not Found")));
        Get.snackbar('FAILED', 'User Not Exist');
      }
    }else{
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Field MustNot be Empty")));
      Get.snackbar('ERROR', 'Fields Must not be empty');
    }
  }
}
