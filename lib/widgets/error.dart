//for shwing Error messages
import 'package:final_offer/widgets/buttons.dart';
import 'package:flutter/material.dart';

showMsg(String msg, Icon icon, BuildContext context) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            msg,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        icon
      ],
    ),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// Future showErrorDialogue(BuildContext context, String title, String content, final onPress) {
//   return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//             title: Text(title),
//             content: Text(content),
//             actions: [
//               MaterialButton(
//                 onPressed: onPress,
//                 color: Colors.blue,
//                 child: const Text(
//                   'Close',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               )
//             ],
//           ));
// }

class ErrorDialog extends StatefulWidget {
  final String title;
  final String message;
  final String type;
  final Function function;
  final String buttontxt;
  const ErrorDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.type,
      required this.function,
      required this.buttontxt});

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              width: 350,
              height: 300,
              child: SizedBox(
                child: Stack(children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: widget.type == 'E' ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        color: Colors.blue,
                        height: 2,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: FixedPrimary(ontap: widget.function, buttonText: widget.buttontxt),
                          )
                        ],
                      ))
                ]),
              ),
            ),
          ),
        )),
        onWillPop: () async => false);
  }
}
