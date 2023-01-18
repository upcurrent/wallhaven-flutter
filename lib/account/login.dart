import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onChanged: (_) => {},
                  decoration: const InputDecoration(
                      label: Text('帐号'), prefixIcon: Icon(Icons.person)),
                ),
                const Padding(padding: EdgeInsets.all(20.0)),
                TextFormField(
                  onChanged: (_) => {},
                  obscureText: true,
                  decoration: const InputDecoration(
                      label: Text('密码'), prefixIcon: Icon(Icons.password)),
                ),
                const Padding(padding: EdgeInsets.all(40.0)),
                RawMaterialButton(
                  onPressed: () => GFToast.showToast(
                    '登录成功！',
                    context,
                  ),
                  child: const Text("登录"),
                )
              ],
            )));
  }
}
