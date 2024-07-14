import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/core/Providers/is_loading_provider.dart';
import 'package:seller_app/core/Providers/user_provider.dart';
import 'package:seller_app/core/constants.dart';
import 'package:seller_app/features/auth/controller/auth_controller.dart';
import 'package:seller_app/features/liked_items/screens/liiked_item_screen.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // function to build user details widget & handle errors using future provider
              _buildAccountDetails(ref, context),
              // fetch from firestore
              (isLoading)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

void logout(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        elevation: 2,
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authControllerProvider).logoutUser(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              // do noting
              Navigator.of(context).pop(context);
            },
            child: const Text(
              'No',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    },
  );
}

Widget _buildAccountDetails(WidgetRef ref, BuildContext context) {
  final accountDetailsState = ref.watch(userProvider);

// build widgets accourding to the state of account details returned by provider
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
    child: Column(
      children: [
        const SizedBox(height: 20),
        // showing user photo
        accountDetailsState.photoUrl != null
            ? Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(accountDetailsState.photoUrl!),
                ),
              )
            : Center(
                child: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey,
                  radius: 50,
                  backgroundImage: accountDetailsState.gender == 'Male'
                      ? const AssetImage(Constants.maleProfilePic)
                      : const AssetImage(Constants.femaleProfilePic),
                ),
              ),

        // user username
        Text(
          accountDetailsState.fullName ?? 'No name',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        // email
        Text(
          accountDetailsState.email,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w100,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(
          height: 20,
        ),
        const Divider(),
        const SizedBox(
          height: 30,
        ),

        // liked items listtile
        ListTile(
          title: const Text('Liked items'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LikedItems(),
              ),
            );
          },
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(),
            ),
            child: Icon(
              Icons.favorite,
              color: Colors.pink[400],
            ),
          ),
          trailing: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(),
            ),
            child: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            ),
          ),
        ),

        const SizedBox(height: 2),

        // logout tile
        ListTile(
          title: const Text(
            'Logut',
          ),
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
                border: Border.all()),
            child: const Icon(
              Icons.logout_sharp,
              color: Colors.grey,
            ),
          ),
          onTap: () {
            logout(context, ref);
          },
        ),
      ],
    ),
  );
}
