import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myfirstapp/authen/login.dart';
import 'package:myfirstapp/config/config.dart';
import 'package:myfirstapp/model/req/post_register_req.dart';
import 'package:myfirstapp/model/res/post_register_res.dart';
import 'package:myfirstapp/pages/trip.dart';
import 'package:http/http.dart' as http;

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  String url = "";

  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController configpasswordCtl = TextEditingController();
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
      appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("ชื่อ - นามสกุล")],
              ),
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: fullnameCtl,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("หมายเลขโทรศัพท์")],
              ),
            ),
            TextField(
              keyboardType: TextInputType.phone,
              controller: phoneCtl,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("อีเมล์")],
              ),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailCtl,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("รหัสผ่าน")],
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("ยืนยันรหัสผ่าน")],
              ),
            ),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: configpasswordCtl,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FilledButton(
                onPressed: register,
                child: Text("สมัครสมาชิก"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    "หากมีบัญชีอยู่แล้ว ?",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: Text("เข้าสู่ระบบ"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  register() async {
    if (fullnameCtl.text.isNotEmpty &&
        phoneCtl.text.isNotEmpty &&
        emailCtl.text.isNotEmpty &&
        passwordCtl.text.isNotEmpty &&
        configpasswordCtl.text.isNotEmpty) {
      if (passwordCtl.text == configpasswordCtl.text) {
        CustomerRegisterPostRequest req = CustomerRegisterPostRequest(
          fullname: fullnameCtl.text,
          phone: phoneCtl.text,
          email: emailCtl.text,
          image: "",
          password: passwordCtl.text,
        );
        var res = await http.post(
          Uri.parse('$url/customers'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerRegisterPostRequestToJson(req),
        );
        log(res.body);
        CustomerRegisterPostResponse customerRegisterPostResponse =
            customerRegisterPostResponseFromJson(res.body);
        log(customerRegisterPostResponse.message);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TripsPages(cid: customerRegisterPostResponse.id),
          ),
        );
      } else {
        log("รหัสผ่านไม่ตรงกัน");
      }
    } else {
      log("กรอกไม่ครบ");
    }
  }
}
