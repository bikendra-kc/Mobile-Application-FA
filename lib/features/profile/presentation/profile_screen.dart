import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library_managent/features/profile/presentation/change_password.dart';
import 'package:flutter_library_managent/features/profile/presentation/edit_profile_screen.dart';
import 'package:flutter_library_managent/features/profile/presentation/my_orders_screen.dart';
import 'package:flutter_library_managent/features/profile/data/model/profileResponse.dart';
import 'package:flutter_library_managent/features/profile/data/repository/profileRepositroy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shake/shake.dart';
import '../../../core/failure/failure.dart';
import '../../../core/shared_prefs/user_shared_prefs.dart';
import 'add_protect.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileRepository = ref.read(profileRemoteRepositoryProvider);

    void logout(BuildContext context, WidgetRef ref) {
      ref.read(userSharedPrefsProvider).deleteUserToken();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }

    void showLogoutAlert(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  logout(context, ref);
                },
              ),
            ],
          );
        },
      );
    }

    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        showLogoutAlert(context);
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      detector.startListening();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 118, 17, 7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: FutureBuilder<Either<AppException, ProfileResponse>>(
            future: profileRepository.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    animating: true,
                    color: Colors.red,
                    radius: 20,
                  ),
                );
              } else if (snapshot.hasData) {
                final result = snapshot.data!;
                return result.fold(
                  (error) => Text('Error: ${error.error}'),
                  (profile) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(
                            'https://img.freepik.com/free-icon/user_318-159711.jpg'),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profile.user!.email.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.verified,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // add firtname and last name
                      Text(
                        'Full Name: ' + profile.user!.name.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      // add role

                      buildBorderButton(
                        icon: Icons.edit,
                        iconColor: Colors.blue, // Add icon color
                        title: 'Edit Profile',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProfileUpdatePage(
                                profile: profile,
                              ),
                            ),
                          );
                        },
                      ),
                      buildBorderButton(
                        icon: Icons.shopping_cart,
                        iconColor: Colors.green, // Add icon color
                        title: 'My Orderes',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const OrderDetailsScreen()),
                          );
                        },
                      ),
                      buildBorderButton(
                        icon: Icons.lock,
                        iconColor: Colors.orange, // Add icon color
                        title: 'Change my Password',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChangePasswordPage(),
                            ),
                          );
                        },
                      ),
                      buildBorderButton(
                        icon: Icons.lock,
                        iconColor: Colors.orange, // Add icon color
                        title: 'Add product',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddProductPage(),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: buildBorderButton(
                          icon: Icons.logout,
                          iconColor: Colors.red, // Add icon color
                          title: 'Sign Out',
                          onTap: () {
                            showLogoutAlert(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('No data available');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildBorderButton({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 91, 8, 193),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor), // Apply icon color
            SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
