import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myfirstapp/config/config.dart';
import 'package:myfirstapp/model/res/get_tripdetail_res.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class DetailTripPage extends StatefulWidget {
  int idx = 0;
  DetailTripPage({super.key, required this.idx});

  @override
  State<DetailTripPage> createState() => _DetailTripPageState();
}

class _DetailTripPageState extends State<DetailTripPage> {
  String url = "";
  late TripgetResponse tripgetResponse;
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
      appBar: AppBar(title: Text("รายละเอียด")),

      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        tripgetResponse.name,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("ประเทศ ${tripgetResponse.country}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ), // Adjust as needed
                          child: Image.network(tripgetResponse.coverimage),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ราคา ${tripgetResponse.price}"),
                          Text("โซน ${tripgetResponse.destinationZone}"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(tripgetResponse.detail),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        FilledButton(onPressed: () {}, child: Text("จองเลย!!")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips/${widget.idx}')); //เส้น api
    log(res.body);
    setState(() {
      tripgetResponse = tripgetResponseFromJson(res.body);
      log(tripgetResponse.toString());
    });
  }
}
