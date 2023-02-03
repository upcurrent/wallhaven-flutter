import 'package:flutter/material.dart';
import 'package:wallhaven/pages/global_theme.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalTheme.backImg(SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
            body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
              ),
              height: 200,
              width: double.infinity,
              child: const Text('avatar'),
            ),
            Container(
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    // hAction.test();
                  },
                  child: const Text("user name"),
                )),
            // SizedBox(
            //     height: 100,
            //     child: GestureDetector(
            //       onTap: () {
            //         showDialog<void>(
            //           context: context,
            //           barrierDismissible: false,
            //           builder: (BuildContext context) {
            //             return AlertDialog(
            //               title: const Text('提示'),
            //               content: SingleChildScrollView(
            //                 child: ListBody(
            //                   children: const <Widget>[
            //                     Text('是否退出登录?'),
            //                   ],
            //                 ),
            //               ),
            //               actions: <Widget>[
            //                 RawMaterialButton(
            //                   onPressed: () => {Navigator.of(context).pop()},
            //                   child: const Text("取消"),
            //                 ),
            //                 RawMaterialButton(
            //                   onPressed: () {
            //                     Navigator.of(context).pop();
            //                   },
            //                   child: const Text("确定"),
            //                 )
            //               ],
            //             );
            //           },
            //         );
            //       },
            //       child: const Text('退出登录'),
            //     )),
          ],
        )
    )));
  }
}
