import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wallhaven/pages/global_theme.dart';

import '../store/store.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GlobalTheme.backImg(ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: GetBuilder<StoreController>(
              builder: (controller) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      initialValue: controller.userName,
                      onChanged: (v) => controller.updateUserName(v),
                      decoration: const InputDecoration(
                          label: Text('用户名'), prefixIcon: Icon(Icons.person)),
                    ),
                    const Padding(padding: EdgeInsets.all(20.0)),
                    TextFormField(
                      initialValue: controller.apiKey,
                      onChanged: (v) => controller.updateApiKey(v),
                      // obscureText: true,
                      decoration: const InputDecoration(
                          label: Text('API密钥'), prefixIcon: Icon(Icons.key)),
                    ),
                    const Padding(padding: EdgeInsets.all(40.0)),
                    RawMaterialButton(
                      onPressed: () {
                        StorageManger.prefs.then((prefs) {
                          prefs.setString('apiKey', controller.apiKey);
                          prefs.setString('userName', controller.userName);
                        });
                      },
                      child: const Text("保存"),
                    )
                  ],
                );
              },
            ))));
  }
}
