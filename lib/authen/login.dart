import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myfirstapp/authen/register.dart';
import 'package:myfirstapp/config/config.dart';
import 'package:myfirstapp/model/req/post_login_req.dart';
import 'package:myfirstapp/model/res/post_login_res.dart';
import 'package:myfirstapp/pages/trip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LloginPageState();
}

class LloginPageState extends State<LoginPage> {
  String url = '';

  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/travel.jpg'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text(
                  "หมายเลขโทรศัพท์",
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: phoneNoCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text(
                  "รหัสผ่าน",
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registerpage(),
                          ),
                        );
                      },
                      child: Text("ลงทะเบียนใหม่"),
                    ),
                    FilledButton(onPressed: login, child: Text("เข้าสู่ระบบ")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() async {
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );
    log(url);
    var res = await http.post(
      Uri.parse('$url/customers/login'),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: customerLoginPostRequestToJson(req),
    );
    CustomerLoginPostResponse customerLoginPostResponse =
        customerLoginPostResponseFromJson(res.body);
    log(customerLoginPostResponse.customer.fullname);
    log(customerLoginPostResponse.customer.email);
    log(customerLoginPostResponse.customer.idx.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TripsPages(cid: customerLoginPostResponse.customer.idx),
      ),
    );
  }
}
