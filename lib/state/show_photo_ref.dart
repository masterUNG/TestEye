import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:joelfindtechnician/models/reference_model.dart';
import 'package:joelfindtechnician/utility/my_constant.dart';
import 'package:joelfindtechnician/widgets/show_image.dart';
import 'package:joelfindtechnician/widgets/show_text.dart';
import 'package:photo_view/photo_view.dart';

class ShowPhotoRefer extends StatefulWidget {
  final ReferenceModel referenceModel;
  final String docIdRef;
  final String docUser;
  const ShowPhotoRefer(
      {Key? key,
      required this.referenceModel,
      required this.docIdRef,
      required this.docUser})
      : super(key: key);

  @override
  _ShowPhotoReferState createState() => _ShowPhotoReferState();
}

class _ShowPhotoReferState extends State<ShowPhotoRefer> {
  ReferenceModel? referenceModel;
  TextEditingController descripController = TextEditingController();
  String? docIdRef, docUser, descripStr;

  @override
  void initState() {
    super.initState();
    referenceModel = widget.referenceModel;
    docIdRef = widget.docIdRef;
    docUser = widget.docUser;
    descripController.text = referenceModel!.descrip;
    descripStr = referenceModel!.descrip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constaints) {
          return Column(children: [
            menuedit(),
            Container(
              height: constaints.maxHeight - 108,
              child: PhotoView(
                imageProvider: NetworkImage(
                  referenceModel!.image,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              width: constaints.maxWidth,
              height: 60,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      changDateToString(referenceModel!.datejob),
                      style: MyConstant().h2StyleWhite(),
                    ),
                    Text(descripStr!, style: MyConstant().h2StyleWhite()),
                  ],
                ),
              ),
            ),
          ]);
        }),
      ),
    );
  }

  Container menuedit() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: ListTile(
                    leading: ShowImage(),
                    title: ShowText(
                      title: 'Edit Description or delete ?',
                    ),
                  ),
                  content: TextFormField(
                    controller: descripController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        print('edit at doId ==>> $docIdRef');

                        Map<String, dynamic> map = {};
                        map['descrip'] = descripController.text;

                        await Firebase.initializeApp().then((value) async {
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(docUser)
                              .collection('referjob')
                              .doc(docIdRef)
                              .update(map)
                              .then((value) {
                            setState(() {
                              descripStr = descripController.text;
                            });
                          });
                        });

                        Navigator.pop(context);
                      },
                      child: Text('Edit'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: ListTile(
                                    leading: ShowImage(),
                                    title: ShowText(
                                      title: 'Delete Photo ?',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await Firebase.initializeApp()
                                            .then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(docUser)
                                              .collection('referjob')
                                              .doc(docIdRef)
                                              .delete()
                                              .then((value) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        });
                                      },
                                      child: Text('Delete'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ));
                      },
                      child: Text('Delete'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String changDateToString(Timestamp datejob) {
    String result;

    DateTime dateTime = datejob.toDate();
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    result = dateFormat.format(dateTime);
    return result;
  }
}
