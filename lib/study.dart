import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamwork/color/color.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  String? userUID;

  @override
  void initState() {
    super.initState();
    fetchUserUID();
  }

  void fetchUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUID = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primary,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text('수강 목록',style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          // if (!snapshot.hasData) {
          //   return const Center(child: CircularProgressIndicator()); // Loading indicator
          // }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Container();
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var userDocument = documents[index];
              var documentUID = userDocument.id;

              // Check if the document UID matches the current user's UID
              if (userUID != null && documentUID == userUID) {
                var lectureList = userDocument['lectureList'] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Text('${userDocument['name']}의 스터디룸',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    for (var lecture in lectureList)
                      Column(
                        children: [
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: () {},
                            child: SizedBox(
                              height: 70,
                              width: 320,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient : LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Color(0xfffff1eb),Color(0xfface0f9)]
                                    ),
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      lecture,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                  ],
                );
              } else {
                // Return an empty container if the document UID does not match the current user's UID
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}




