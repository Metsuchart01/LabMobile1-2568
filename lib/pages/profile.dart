import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfirstapp/config/config.dart';
import 'package:myfirstapp/model/res/get_custumer_res.dart';

class ProfilePage extends StatefulWidget {
  final int cid;
  ProfilePage({super.key, required this.cid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String url = "";
  GetCustumerRes? getCustumerRes;
  late Future<void> loadData;

  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  void dispose() {
    nameCtl.dispose();
    phoneCtl.dispose();
    emailCtl.dispose();
    imageCtl.dispose();
    passwordCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'ยืนยันการยกเลิกสมาชิก?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('ปิด'),
                          ),
                          FilledButton(
                            onPressed: delete,
                            child: const Text('ยืนยัน'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (getCustumerRes == null) {
            return const Center(child: Text('ไม่พบข้อมูลลูกค้า'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.network(getCustumerRes!.image, width: 150),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtl,
                    decoration: const InputDecoration(
                      labelText: 'ชื่อ-นามสกุล',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneCtl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'หมายเลขโทรศัพท์',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailCtl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'อีเมล',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: imageCtl,
                    decoration: const InputDecoration(
                      labelText: 'URL รูปภาพ',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {}); // อัปเดตรูปภาพทันที
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordCtl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'รหัสผ่าน',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: FilledButton(
                      onPressed: update,
                      child: const Text("บันทึกข้อมูล"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void delete() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var res = await http.delete(Uri.parse('$url/customers/${widget.cid}'));
    log(res.statusCode.toString());

    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('ลบข้อมูลสำเร็จ'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('ปิด'),
            ),
          ],
        ),
      ).then((s) {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: const Text('ลบข้อมูลไม่สำเร็จ'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    try {
      var res = await http.get(Uri.parse('$url/customers/${widget.cid}'));
      if (res.statusCode == 200) {
        setState(() {
          getCustumerRes = getCustumerResFromJson(res.body);
          nameCtl.text = getCustumerRes!.fullname;
          phoneCtl.text = getCustumerRes!.phone;
          emailCtl.text = getCustumerRes!.email;
          imageCtl.text = getCustumerRes!.image;
        });
      } else {
        log('ไม่สามารถโหลดข้อมูล: ${res.statusCode}');
      }
    } catch (e) {
      log('เกิดข้อผิดพลาด: $e');
    }
  }

  Future<void> update() async {
    var jsonData = {
      "fullname": nameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text,
      "password": passwordCtl.text, // ต้องรองรับใน API
    };

    try {
      var res = await http.put(
        Uri.parse('$url/customers/${widget.cid}'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(jsonData),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("ผลการทำงาน"),
            content: Text(data['message'] ?? "อัปเดตสำเร็จ"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ตกลง"),
              ),
            ],
          ),
        );
      } else {
        log('Update failed: ${res.statusCode}');
      }
    } catch (e) {
      log('เกิดข้อผิดพลาด: $e');
    }
  }
}
