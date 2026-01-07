import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:truenorthflutterfrontend/app/model/userModel/userLogRegModel/user_profile_model.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class UserProfileUI extends StatefulWidget {
  const UserProfileUI({super.key});

  @override
  State<UserProfileUI> createState() => _MyUserProfile();
}

class _MyUserProfile extends State<UserProfileUI> {
  late Future<UserProfileModel?> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = userProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<UserProfileModel?> userProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cachedProfile = prefs.getString("userProfile");
      if (cachedProfile != null && cachedProfile.isNotEmpty) {
        try {
          final parsed = jsonDecode(cachedProfile);
          return UserProfileModel.fromJson(parsed);
        } catch (e) {
          print("Failed to parse cached profile: $e");
        }
      }
      final auth = TokenService();
      final response = await auth.authorizedGet("profile");

      // final uuid = prefs.getInt("uuid");
      // if (uuid == null) {
      //   //print("UUID not found in SharedPreferences.");
      //   return null;
      // }

      // final url = Uri.parse('${Apiconstants.userProfile}$uuid');
      // final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final json = jsonDecode(response.body);
          final userProfile = UserProfileModel.fromJson(json);

          await prefs.setString("userProfile", response.body);

          return userProfile;
        } catch (e) {
          // print("Error parsing JSON response: $e");
          return null;
        }
      } else {
        print("Failed to fetch profile. Status code: ${response.statusCode}");
        return null;
      }
    } on http.ClientException catch (e) {
      print("HTTP error: $e");
      return null;
    } on PlatformException catch (e) {
      print("Platform exception: $e");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConFig.init(context);
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
                height: SizeConFig.screenHeight,
                width: SizeConFig.screenWidth,
                child: Column(children: [
                  SizedBox(height: SizeConFig.screenHeight * 2 / 100),
                  SizedBox(
                      width: SizeConFig.screenWidth * 95 / 100,
                      child: Column(children: [
                        FutureBuilder(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              169, 106, 122, 44),
                                          width: 2),
                                    ),
                                    child: ClipOval(
                                      child: snapshot.data!.imageURL.isNotEmpty
                                          ? Image.network(
                                              snapshot.data!.imageURL,
                                              height:
                                                  SizeConFig.screenHeight * 0.1,
                                              width:
                                                  SizeConFig.screenWidth * 0.2,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  Appimage.splash,
                                                  height:
                                                      SizeConFig.screenHeight *
                                                          0.1,
                                                  width:
                                                      SizeConFig.screenWidth *
                                                          0.2,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              Appimage.splash,
                                              height:
                                                  SizeConFig.screenHeight * 0.1,
                                              width:
                                                  SizeConFig.screenWidth * 0.2,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),

                                  // ClipOval(
                                  //   child: snapshot.data!.imageURL != null &&
                                  //           snapshot.data!.imageURL!.isNotEmpty
                                  //       ? Image.network(
                                  //           snapshot.data!.imageURL!,
                                  //           height:
                                  //               SizeConFig.screenHeight * 0.1,
                                  //           width: SizeConFig.screenWidth * 0.2,
                                  //           fit: BoxFit.cover,
                                  //           loadingBuilder: (context, child,
                                  //               loadingProgress) {
                                  //             if (loadingProgress == null)
                                  //               return child;
                                  //             return const Center(
                                  //                 child:
                                  //                     CircularProgressIndicator());
                                  //           },
                                  //           errorBuilder:
                                  //               (context, error, stackTrace) {
                                  //             return Image.asset(
                                  //               Appimage.splash,
                                  //               height:
                                  //                   SizeConFig.screenHeight *
                                  //                       0.1,
                                  //               width: SizeConFig.screenWidth *
                                  //                   0.2,
                                  //               fit: BoxFit.cover,
                                  //             );
                                  //           },
                                  //         )
                                  //       : Image.asset(
                                  //           Appimage.splash,
                                  //           height:
                                  //               SizeConFig.screenHeight * 0.1,
                                  //           width: SizeConFig.screenWidth * 0.2,
                                  //           fit: BoxFit.cover,
                                  //         ),
                                  // ),
                                  // DecoratedBox(
                                  //     decoration: BoxDecoration(),
                                  //     child: CircleAvatar(
                                  //       backgroundColor: Color(0xfffb934d),
                                  //       radius: 80,
                                  //       child: Icon(
                                  //         Icons.person,
                                  //         size: 100,
                                  //       ),
                                  //     )

                                  //     ),
                                  SizedBox(
                                      height:
                                          SizeConFig.screenHeight * 0.5 / 100),
                                  Column(
                                    children: [
                                      customUIandText(
                                          "Name", snapshot.data!.empName),
                                      customUIandText(
                                          "Empid", snapshot.data!.empId),
                                      customUIandText(
                                          "Email", snapshot.data!.empEmail),
                                      customUIandText("Phone Number",
                                          snapshot.data!.empPhone),
                                      customUIandText("Designation",
                                          snapshot.data!.empDesignation),
                                      customUIandText(
                                          "Role", snapshot.data!.empRole),
                                    ],
                                  ),
                                ],
                              );
                            }
                            if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }

                            return CircularProgressIndicator();
                          },
                        )
                      ]))
                ]))));
  }

  Widget customUIandText(String uiName, String uiData) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$uiName",
            style: TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: SizeConFig.screenHeight * 0.5 / 100),
          Text(
            "$uiData",
            style: TextStyle(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: SizeConFig.screenHeight * 0.5 / 100),
          Container(
            height: 0.5,
            decoration: BoxDecoration(color: Colors.black),
          ),
          SizedBox(height: SizeConFig.screenHeight * 0.5 / 100),
        ],
      ),
    );
  }
}
