import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:joelfindtechnician/models/user_model_old.dart';
import 'package:joelfindtechnician/state/show_general_profile.dart';
import 'package:joelfindtechnician/state/show_profile.dart';
import 'package:joelfindtechnician/utility/my_constant.dart';
import 'package:joelfindtechnician/widgets/show_image.dart';
import 'package:joelfindtechnician/widgets/show_progress.dart';
import 'package:joelfindtechnician/widgets/show_text.dart';

class ListTechnicWhereType extends StatefulWidget {
  final String province;
  final String typeTechnic;
  const ListTechnicWhereType(
      {Key? key, required this.province, required this.typeTechnic})
      : super(key: key);

  @override
  _ListTechnicWhereTypeState createState() => _ListTechnicWhereTypeState();
}

class _ListTechnicWhereTypeState extends State<ListTechnicWhereType> {
  String? province, typeTechnic;
  List<UserModelOld> userModelOlds = [];

  @override
  void initState() {
    super.initState();
    province = widget.province;
    typeTechnic = widget.typeTechnic;

    readData();
  }

  Future<void> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .where('province', isEqualTo: province)
          .get()
          .then((value) {
        for (var item in value.docs) {
          UserModelOld model = UserModelOld.fromMap(item.data());
          if (checkTechnic(model)) {
            setState(() {
              if (model.uid.isNotEmpty) {
                userModelOlds.add(model);
              }
            });
          }
        }
      });
    });
  }

  bool checkTechnic(UserModelOld model) {
    bool result = false;

    for (var item in model.typeTechnics) {
      if (typeTechnic == item) {
        result = true;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(typeTechnic!),
      ),
      body: userModelOlds.isEmpty
          ? ShowProgress()
          : ListView.builder(
              itemCount: userModelOlds.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowGeneralProfile(
                              uidTechnic: userModelOlds[index].uid,
                            ))),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: userModelOlds[index].img.isEmpty
                                  ? ShowImage()
                                  : SizedBox(),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      userModelOlds[index].img),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) =>
                                      AssetImage(
                                    'assets/images/aircon.png',
                                  ),
                                ),
                              ),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              height: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShowText(
                                    title: userModelOlds[index].name,
                                    textStyle: MyConstant().h2Style(),
                                  ),
                                  Container(
                                    width: 250,
                                    child: ShowText(
                                      title:
                                          cutWord(userModelOlds[index].about),
                                      textStyle: MyConstant().h4Style(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                ),
                                ShowText(title: userModelOlds[index].amphure),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                ),
                                ShowText(title: userModelOlds[index].province),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String cutWord(String string) {
    String result = string;
    if (result.length > 50) {
      result = result.substring(1, 50);
      result = '$result ...';
    }
    return result;
  }
}
