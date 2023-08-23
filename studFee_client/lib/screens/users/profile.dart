import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studfees/components/readonly_textfield.dart';
import 'package:studfees/provider/user_provider.dart';
import 'package:studfees/services/auth_service.dart';
import 'package:studfees/util/config.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile-screen';

  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthServiceProvider authServiceProvider = AuthServiceProvider();
  File? coverImage;
  File? profileImage;
  String? profileImageUrl;

  uploadCoverImage() async {
    final imagePicker = ImagePicker();

    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        coverImage = File(pickedImage.path);
      } else {
        return;
      }
    });
    authServiceProvider.uploadCoverImage(
        context: context, coverImage: coverImage as File);
    // try {
    //   CloudinaryResponse response = await Config.cloudinary.uploadFile(
    //     CloudinaryFile.fromFile(coverImage!.path,
    //         resourceType: CloudinaryResourceType.Image,
    //         folder: 'StudFees/CoverImages'),
    //   );
    //   profileImageUrl = response.secureUrl;
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  uploadProfileImage() async {
    final imagePicker = ImagePicker();

    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        authServiceProvider.uploadProfileImage(
            context: context, profileImage: profileImage as File);
      } else {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().hour;

    String? greetings;

    if (now < 12) {
      greetings = 'Good Morining 🌻';
    } else if (now < 17) {
      greetings = 'Good Afternoon 🌞';
    } else {
      greetings = 'Good Evening 🌙';
    }
    final user = Provider.of<UserProvider>(context).user;

    final TextEditingController department =
        TextEditingController(text: user.department);
    final TextEditingController email = TextEditingController(text: user.email);
    final TextEditingController ugLevel =
        TextEditingController(text: user.ugLevel);
    final TextEditingController yearOfAdmins =
        TextEditingController(text: user.yearOfAdmin);
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      title: Text(
                        greetings.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        user.fullname.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Config.primaryColor,
                    radius: 20,
                    child: (user.profileImage != null)
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            backgroundImage: NetworkImage(user.profileImage!))
                        : const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            backgroundImage:
                                AssetImage('assets/images/profile.png'),
                          ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                uploadProfileImage();
              },
              child: CircleAvatar(
                  backgroundColor: Config.primaryColor,
                  radius: 70,
                  child: (user.profileImage != null)
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 65,
                          backgroundImage: NetworkImage(user.profileImage!))
                      : const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 65,
                          backgroundImage:
                              AssetImage('assets/images/profile.png'),
                        )),
            ),
            // SizedBox(
            //   height: 270,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         child: GestureDetector(
            //           onTap: () => uploadCoverImage(),
            //           child: Column(
            //             children: [
            //               SizedBox(
            //                 width: MediaQuery.of(context).size.width,
            //                 height: 200,
            //                 child: (user.coverImage != null)
            //                     ? Image.network(
            //                         user.coverImage!,
            //                         fit: BoxFit.cover,
            //                       )
            //                     : Container(
            //                         decoration: const BoxDecoration(
            //                           color: Colors.black,
            //                           image: DecorationImage(
            //                             opacity: 200,
            //                             // image: Image.asset(),
            //                             image: AssetImage(
            //                               'assets/images/cover.jpg',
            //                             ),
            //                             fit: BoxFit.cover,
            //                           ),
            //                         ),
            //                         child: const Center(
            //                           child: Text(
            //                             'Click to Upload Cover Picture',
            //                             style: TextStyle(
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Positioned(
            //         top: 125.0,
            //         left: 50.0,
            //         right: 50.0,
            //         child: GestureDetector(
            //           onTap: () {
            //             uploadProfileImage();
            //           },
            //           child: CircleAvatar(
            //               backgroundColor: Config.primaryColor,
            //               radius: 70,
            //               child: (user.profileImage != null)
            //                   ? CircleAvatar(
            //                       backgroundColor: Colors.white,
            //                       radius: 65,
            //                       backgroundImage:
            //                           NetworkImage(user.profileImage!))
            //                   : const CircleAvatar(
            //                       backgroundColor: Colors.white,
            //                       radius: 65,
            //                       backgroundImage:
            //                           AssetImage('assets/images/profile.png'),
            //                     )),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0.0),
                  title: Text(
                    user.fullname.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    'Admission No: ${user.admissionNumber}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            DefaultTabController(
              length: 2,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          // color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const TabBar(
                          tabs: [
                            Text(
                              'Profile Details',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Change Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                ReadOnlyTextField(controller: department),
                                const SizedBox(height: 20),
                                ReadOnlyTextField(controller: email),
                                const SizedBox(height: 20),
                                ReadOnlyTextField(controller: ugLevel),
                                const SizedBox(height: 20),
                                ReadOnlyTextField(controller: yearOfAdmins),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
