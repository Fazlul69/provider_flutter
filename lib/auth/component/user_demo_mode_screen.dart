import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';

class UserDemoModeScreen extends StatefulWidget {
  final Function(String email, String password) onChanged;

  UserDemoModeScreen({required this.onChanged});

  @override
  _UserDemoModeScreenState createState() => _UserDemoModeScreenState();
}

class _UserDemoModeScreenState extends State<UserDemoModeScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data!.packageName == packageName) {
            return Column(
              children: [
                32.height,
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        widget.onChanged.call(DEFAULT_PROVIDER_EMAIL, DEFAULT_PASS);
                      },
                      child: Text("Demo Provider", style: boldTextStyle(color: primaryColor, size: 14)),
                    ).withWidth(context.width() / 2 - 24),
                    OutlinedButton(
                      onPressed: () {
                        widget.onChanged.call(DEFAULT_HANDYMAN_EMAIL, DEFAULT_PASS);
                      },
                      child: Text("Demo Handyman", style: boldTextStyle(color: primaryColor, size: 14)),
                    ).withWidth(context.width() / 2 - 24),
                    TextButton(
                      child: Text("Reset", style: secondaryTextStyle()),
                      onPressed: () {
                        widget.onChanged.call('', '');
                      },
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Offstage();
          }
        }
        return Offstage();
      },
    );
  }
}
