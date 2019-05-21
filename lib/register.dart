import 'package:flutter/material.dart';
import 'database.dart';


class Register extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }

}

class RegisterPageState extends State<Register>{
  final _formkey = GlobalKey<FormState>();

  RegisterProvider user = RegisterProvider();
  final userid = TextEditingController();
  final name = TextEditingController();
  final age = TextEditingController();
  final password = TextEditingController();
  final repassword = TextEditingController();
  final quote = TextEditingController();

  bool isUserIn = false;

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  int countSpace(String s){
    int result = 0;
    for(int i = 0;i<s.length;i++){
      if(s[i] == ' '){
        result += 1;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "User Id",
                hintText: "User Id must be between 6 to 12",
                icon: Icon(Icons.account_box, size: 40, color: Colors.grey),
              ),
              controller: userid,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                else if (value.length < 6 || value.length > 12){
                  return "Please fill UserId Correctly";
                }
                else if (this.isUserIn){
                  return "This Username is taken";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "ex. 'John Snow'",
                icon: Icon(Icons.account_circle, size: 40, color: Colors.grey),
              ),
              controller: name,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                if(countSpace(value) != 1){
                  return "Please fill Name Correctly";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Age",
                hintText: "Please fill Age Between 10 to 80",
                icon: Icon(Icons.event_note, size: 40, color: Colors.grey),
              ),
              controller: age,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill Age";
                }
                else if (!isNumeric(value) || int.parse(value) < 10 || int.parse(value) > 80) {
                  return "Please fill Age correctly";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Password must be longer than 6",
                icon: Icon(Icons.lock, size: 40, color: Colors.grey),
              ),
              controller: password,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty || value.length <= 6) {
                  return "Please fill Password Correctly";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Confirm Password",
                icon: Icon(Icons.lock, size: 40, color: Colors.grey),
              ),
              controller: repassword,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty || value != password.text) {
                  return "Please fill Password as above";
                }
              }
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              child: Text("REGISTER NEW ACCOUNT"),
              onPressed: () async {
                await user.open("user.db");
                List<User> allUser = await user.getAllUser();
                User userData = User();
                userData.username = userid.text;
                userData.name = name.text;
                userData.age = age.text;
                userData.password = password.text;


                void showAllUser() {
                  for(var i=0; i < allUser.length;i++){
                    print(allUser[i]);
                    }
                  }
                showAllUser();


                //function to check if user in
                void isNewUserIn(User user) {
                  for(var i=0; i < allUser.length;i++){
                    if (user.username == allUser[i].username){
                      this.isUserIn = true;
                      break;
                    }
                  }
                }

                //call function
                isNewUserIn(userData);
                print(this.isUserIn);

                //validate form
                if (_formkey.currentState.validate()){
                                  //if user not exist
                  if(!this.isUserIn) {
                    userid.text = "";
                    name.text = "";
                    age.text = "";
                    password.text = "";
                    repassword.text = "";
                    await user.insertUser(userData);
                    Navigator.pop(context);
                    print('insert complete');
                  }
                }

                this.isUserIn = false;

                showAllUser();
              }
              
            ),
          ],
        ),
      ),
    );
  }
}