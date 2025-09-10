import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myfirstapp/authen/login.dart';
import 'package:myfirstapp/config/config.dart';
import 'package:myfirstapp/model/res/get_trip_res.dart';
import 'package:myfirstapp/pages/detail_trip.dart';
import 'package:myfirstapp/pages/profile.dart';
import 'package:http/http.dart' as http;

class TripsPages extends StatefulWidget {
  int cid = 0;
  TripsPages({super.key, required this.cid});

  @override
  State<TripsPages> createState() => _TripsPagesState();
}

class _TripsPagesState extends State<TripsPages> {
  String url = "";
  late List<TripGetResponses> tripGetResponses;
  late List<TripGetResponses> trip_zone;

  late Future<void> loadData;
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายการทริป"),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == "logout") {
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else if (value == "profile") {
                log(value);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(cid: widget.cid),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FilledButton(
                    onPressed: () {
                      loadDataAsync();
                    },
                    child: Text("ทั้งหมด"),
                  ),
                ),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () {
                        fil_zone("เอเชีย");
                      },
                      child: Text("เอเซีย"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FilledButton(
                    onPressed: () {
                      fil_zone("ยุโรป");
                    },
                    child: Text("ยุโรบ"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FilledButton(
                    onPressed: () {
                      fil_zone("เอเชียตะวันออกเฉียงใต้");
                    },
                    child: Text("อาเซียน"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FilledButton(
                    onPressed: () {
                      fil_zone("ประเทศไทย");
                    },
                    child: Text("ไทย"),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: ListView(
                  children: trip_zone
                      .map(
                        (trips) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(trips.name),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Image.network(trips.coverimage),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("ประเทศ ${trips.country}"),
                                          Text(
                                            "ระยะเวลา ${trips.duration} วัน",
                                          ),
                                          Text("ราคา ${trips.price} บาท"),

                                          FilledButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailTripPage(
                                                        idx: trips.idx,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Text("รายละเอียดเพิ่มเติม"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    setState(() {
      tripGetResponses = tripGetResponsesFromJson(res.body);
      trip_zone = tripGetResponsesFromJson(res.body);
    });
    log(tripGetResponses.length.toString());
  }

  Future<void> fil_zone(String zone) async {
    trip_zone.clear();
    for (var tirps in tripGetResponses) {
      if (tirps.destinationZone == zone) {
        trip_zone.add(tirps);
      }
    }
    setState(() {});
  }
}
