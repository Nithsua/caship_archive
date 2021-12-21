import 'package:caship/providers/themeProvider.dart';
import 'package:caship/providers/userProvider.dart';
import 'package:caship/views/accountsListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

final avatarProvider = FutureProvider<String>((ref) async {
  final res = await get(Uri.parse(
      "https://avatars.dicebear.com/api/bottts/${ref.watch(userProvider.select((value) => value.username))}.svg"));
  return res.body;
});

class ProfileView extends ConsumerWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ref.watch(
                                  userProvider.select((value) => value.name)),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(ref.watch(userProvider
                                .select((value) => value.username))),
                          ],
                        ),
                      ),
                      ref.watch(avatarProvider).when(
                          loading: () => SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(),
                                ],
                              ),
                              width: 100,
                              height: 100),
                          data: (string) => SvgPicture.string(string,
                              width: 100, height: 100),
                          error: (_, stackTrace) {
                            print(stackTrace);
                            return const SizedBox(width: 100, height: 100);
                          }),
                    ],
                  ),
                ),
              ),
              ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: const Icon(
                      CupertinoIcons.archivebox,
                    ),
                    title: const Text("Accounts"),
                    onTap: () => Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => AccountsView())),
                  ),
                  (() {
                    final onPressed = () =>
                        ref.read(themeProvider.notifier).switchThemeMode();
                    if (ref.watch(themeProvider) == ThemeMode.system) {
                      return ListTile(
                        leading: const Icon(CupertinoIcons.desktopcomputer),
                        title: const Text("System Default"),
                        onTap: onPressed,
                      );
                    } else if (ref.watch(themeProvider) == ThemeMode.light) {
                      return ListTile(
                          leading: const Icon(CupertinoIcons.sun_min),
                          title: const Text("Light Mode"),
                          onTap: onPressed);
                    } else {
                      return ListTile(
                          leading: const Icon(CupertinoIcons.moon),
                          title: const Text("Dark Mode"),
                          onTap: onPressed);
                    }
                  }()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
