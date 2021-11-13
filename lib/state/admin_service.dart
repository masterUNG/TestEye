import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:joelfindtechnician/models/typetechnic_array.dart';
import 'package:joelfindtechnician/models/user_model.dart';
import 'package:joelfindtechnician/widgets/show_progress.dart';

class AdminService extends StatefulWidget {
  const AdminService({Key? key}) : super(key: key);

  @override
  _AdminServiceState createState() => _AdminServiceState();
}

class _AdminServiceState extends State<AdminService> {
  List<UserModelFirebase> userModels = [];
  List<UserModelFirebase> searchUserModels = [];
  List<String> docsIds = [];
  final debouncer = Debouncer(millisecond: 500);
  List<TypeTechnicArrayModel> typeTechnicArrayModels = [];

  @override
  void initState() {
    super.initState();
    readAllUser();
  }

  Future<Null> readAllUser() async {
    if (userModels.length != 0) {
      userModels.clear();
      docsIds.clear();
      searchUserModels.clear();
      typeTechnicArrayModels.clear();
    }

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .orderBy('accept')
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          UserModelFirebase userModelFirebase =
              UserModelFirebase.fromMap(item.data());

          TypeTechnicArrayModel typeTechnicArrayModel =
              TypeTechnicArrayModel.fromMap(item.data());
          setState(() {
            userModels.add(userModelFirebase);
            searchUserModels = userModels;
            docsIds.add(item.id);
            typeTechnicArrayModels.add(typeTechnicArrayModel);
          });
        }
      });
    });
  }

  Future<Null> confirmAcceptDialog(
      String docs, UserModelFirebase userModelFirebase, TypeTechnicArrayModel typeTechnicArrayModel) async{
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: Text(userModelFirebase.name),
          subtitle: Text(userModelFirebase.email),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('TypeTechnic =>  ${typeTechnicArrayModel.typeTechnics.toString()}'),
            Text('JobScope =>  ${userModelFirebase.jobScope}'),
            Text('PhoneNumber =>  ${userModelFirebase.phoneNumber}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              editAccept(docs, userModelFirebase);
            },
            child: Text('Accept'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Service'),
      ),
      body: userModels.length == 0
          ? ShowProgress()
          : GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildSearch(),
                    buildListView(),
                  ],
                ),
              ),
            ),
    );
  }

  Container buildSearch() {
    return Container(
      margin: EdgeInsets.all(16),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            searchUserModels = userModels
                .where((element) =>
                    (element.name.toLowerCase().contains(value.toLowerCase())))
                .toList();
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: searchUserModels.length,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(searchUserModels[index].name),
                  Checkbox(
                    value: searchUserModels[index].accept,
                    onChanged: (value) {
                      print('You tap ==>> idDoc ==> ${docsIds[index]}');
                      confirmAcceptDialog(
                          docsIds[index], searchUserModels[index], typeTechnicArrayModels[index]);
                    },
                  ),
                ],
              ),
              Text(searchUserModels[index].email),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> editAccept(
      String docs, UserModelFirebase userModelFirebase) async {
    await Firebase.initializeApp().then((value) async {
      Map<String, dynamic> data = {};
      data['accept'] = !userModelFirebase.accept;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(docs)
          .update(data)
          .then((value) => readAllUser());
    });
  }
}

class Debouncer {
  final int millisecond;
  Timer? timer;
  VoidCallback? callback;

  Debouncer({required this.millisecond});

  run(VoidCallback voidCallback) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: millisecond), voidCallback);
  }
}
