import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/home_screen.dart';
import 'package:final_offer/app_screens/settings_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/cahtroom.dart';
import 'package:final_offer/models/messages.dart';
import 'package:final_offer/models/users.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:final_offer/widgets/receiver.dart';
import 'package:final_offer/widgets/sender.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../widgets/bottom_navigation_bar.dart';

class SupportChat extends StatefulWidget {
  final ChatroomModel model;
  const SupportChat({Key? key, required this.model}) : super(key: key);

  @override
  State<SupportChat> createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  bool isLoading = false;
  bool isLoadingMessage = false;
  bool minIndex = false;
  Users? userData;
  String msgType = 'text';
  XFile? img;
  ScrollController scrollController = ScrollController();
  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      top: false,
      right: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kColorWhite,
          title: Text(
            'Support Chat',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: kUIDark,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const BottomBar()));
            },
            icon: const Icon(
              CupertinoIcons.arrow_left,
              color: kUIDark,
              size: 20,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MySettings(),
                  ),
                );
              },
              icon: Image.asset(
                'assets/icons/menu1.png',
                scale: 3.5,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: isLoading
              ? Center(
                  child: Container(
                    color: Colors.white,
                    child: const Center(
                        child: SizedBox(
                      height: 30,
                      width: 60,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineScalePulseOut,
                      ),
                    )),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.26,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('chatrooms')
                              .doc(widget.model.id)
                              .collection('chat')
                              .orderBy("date", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.active) {
                              if (snapshot.hasData) {
                                QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                                List<Messages> msgs = datasnapshot.docs
                                    .map((d) => Messages.fromMap(d.data() as Map<String, dynamic>))
                                    .toList();

                                return GroupedListView<dynamic, String>(
                                  controller: scrollController,
                                  //shrinkWrap: true,
                                  //primary: false,
                                  reverse: true,
                                  elements: msgs,
                                  groupBy: (element) => element.groupdDate,
                                  groupSeparatorBuilder: (String groupByValue) => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: 150,
                                          height: 30,
                                          margin: const EdgeInsets.only(top: 5.0),
                                          decoration: BoxDecoration(
                                              color: Colors.blue[300],
                                              borderRadius: BorderRadius.circular(30)),
                                          child: Center(
                                            child: Text(
                                              groupByValue,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ))
                                    ],
                                  ),
                                  itemComparator: (item1, item2) =>
                                      item1.date.compareTo(item2.date), // optional
                                  useStickyGroupSeparators: true, // optional
                                  floatingHeader: true, // optional
                                  order: GroupedListOrder.DESC, // optional
                                  itemBuilder: (context, dynamic element) {
                                    return element.sender != FirebaseAuth.instance.currentUser!.uid
                                        ? Row(
                                            children: [
                                              Receiver(
                                                message: element,
                                                imgUrl: '',
                                                model: widget.model,
                                                user: userData!,
                                              )
                                            ],
                                          )
                                        : Sender(
                                            message: element,
                                            model: widget.model,
                                            user: userData!,
                                          );
                                  },
                                );
                              } else {
                                return const Center(
                                  child: Text(
                                    'No previous Chats',
                                  ),
                                );
                              }
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(color: Colors.red),
                              );
                            } else {
                              return const Text('Error in fetching chats...please try again later');
                            }
                          }),
                    ),
                    Container(
                        width: 339.w,
                        //height: 54.h,
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextField(
                                controller: msgController,
                                maxLines: null,
                                minLines: 1,
                                style: TextStyle(
                                    fontSize: 14.sp, fontWeight: FontWeight.w400, color: kUILight2),
                                decoration: InputDecoration(
                                  filled: true,
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.camera_alt),
                                    color: Colors.blue,
                                    onPressed: () {
                                      showImageSource(context);
                                    },
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        sendMessage();
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        color: kPrimary1,
                                        size: 20,
                                      )),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                    borderSide: BorderSide(color: kFormStockColor, width: 1.w),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.r),
                                    borderSide: BorderSide(color: kFormStockColor, width: 1.w),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 21.w),
                                  fillColor: kColorChat,
                                  hintText: 'Send Message',
                                  hintStyle: TextStyle(
                                      fontSize: 14.sp, fontWeight: FontWeight.w400, color: kUILight2),
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
        ),
      ),
    );
  }

  //getting userData
  Future getUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      userData = Users.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      //updating message seen

      QuerySnapshot chatsnap = await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.model.id)
          .collection('chat')
          .where('receiver', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('seen', isEqualTo: false)
          .get();
      if (chatsnap.docs.isNotEmpty) {
        for (var item in chatsnap.docs) {
          await FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(widget.model.id)
              .collection('chat')
              .doc(item.id)
              .update({'seen': true, 'seenTime': Timestamp.fromDate(DateTime.now())});
        }
      }
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ErrorDialog(
                  title: 'Error',
                  message: e.toString(),
                  type: 'E',
                  function: () {
                    Navigator.pop(context);
                  },
                  buttontxt: 'Close')));
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  //send messaage
  Future sendMessage() async {
    try {
      setState(() {
        isLoadingMessage = true;
        img != null ? msgType = 'image' : msgType = 'text';
      });
      if (msgType == 'text') {
        //sending txt message
        if (msgController.text.isNotEmpty) {
          final send = FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(widget.model.id)
              .collection('chat')
              .doc();
          Messages newmessage = Messages(
              date: Timestamp.fromDate(DateTime.now()),
              id: send.id,
              receiver: 'Ptb2W9v3oRZyNeynKEag',
              seen: false,
              sender: userData!.id,
              type: msgType,
              message: msgController.text,
              groupdDate: DateFormat('MMM dd yyyy').format(DateTime.now()));
          await send.set(newmessage.toMap());
          msgController.clear();
        }
      } else {
        if (img != null) {
          final send = FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(widget.model.id)
              .collection('chat')
              .doc();
          Messages newmessage = Messages(
              date: Timestamp.fromDate(DateTime.now()),
              id: send.id,
              receiver: 'Ptb2W9v3oRZyNeynKEag',
              seen: false,
              sender: userData!.id,
              type: msgType,
              message: 'file',
              groupdDate: DateFormat('MMM dd yyyy').format(DateTime.now()));
          await send.set(newmessage.toMap());
          //sending image in message
          //first upload file
          final firebaseStorage = FirebaseStorage.instance;
          var snapshot = await firebaseStorage
              .ref()
              .child('/chat_images/${userData!.id}-${DateTime.now()}')
              .putFile(File(img!.path));
          var imgUrl = await snapshot.ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(widget.model.id)
              .collection('chat')
              .doc(send.id)
              .update({'message': imgUrl});

          //setState(() {
          msgController.clear();
          //});
        }
      }
    } catch (e) {
      showMsg(
          e.toString(),
          const Icon(
            Icons.close,
            color: Colors.red,
          ),
          context);
    } finally {
      setState(() {
        isLoadingMessage = false;
      });
    }
  }

  //image sources
  showImageSource(BuildContext context) async {
    return await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.camera);

                    if (image == null) {
                      return;
                    } else {
                      setState(() {
                        img = image;
                      });
                      sendMessage().whenComplete(() {
                        setState(() {
                          img = null;
                        });
                      });
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () async {
                  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (image == null) {
                    return;
                  } else {
                    setState(() {
                      img = image;
                    });
                    sendMessage().whenComplete(() {
                      setState(() {
                        img = null;
                      });
                    });
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
