import 'package:covid_app/widgets/myMessages.dart';
import 'package:covid_app/widgets/myRequests.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/services/database.dart';
import 'package:covid_app/widgets/editName.dart';
import 'package:covid_app/widgets/profilePageButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth _auth;
  User _user;

  UserData userData;

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    //var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    double headerHeight1 = 0.24 * screenHeight; //revert to 200
    double headerHeight2 = 0.12 * screenHeight; //revert to 100
    double avatarSize = 0.13 * screenHeight; //revert to 110

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff2f3f5),
        body: StreamBuilder<UserData>(
            stream: DatabaseService(uid: _user.uid).getProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                userData = snapshot.data;
              }

              return Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Material(
                        elevation: 3.0,
                        child: Column(
                          children: [
                            Container(
                              height: headerHeight1,
                              decoration: BoxDecoration(
                                //color: Theme.of(context).primaryColor,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context)
                                          .primaryColor
                                          .withOpacity(1.0),
                                      BlendMode.softLight),
                                  image: AssetImage('assets/images/headbg.png'),
                                ),
                              ),
                              child: Container(),
                            ),
                            Container(
                              color: Colors.white,
                              height: headerHeight2,
                              child: Padding(
                                padding: EdgeInsets.only(top: avatarSize / 2),
                                child: Center(
                                    child: Text(
                                  (userData != null) ? userData.name : '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 0.3,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[850],
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: headerHeight1 - avatarSize / 2,
                        child: Initicon(
                          text: (userData != null) ? userData.name : '',
                          elevation: 5.0,
                          size: avatarSize,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: screenHeight - headerHeight1 - headerHeight2 - 60,
                    child: (userData != null)
                        ? ListView(
                            padding: EdgeInsets.only(bottom: 50),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ProfilePageButton(
                                        title: 'My Requests',
                                        subTitle:
                                            'Check your pending and completed requests',
                                        icon: Icons.question_answer_outlined,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          MyRequests(
                                                              uid: userData
                                                                  .uid)));
                                        }),
                                    SizedBox(height: 3),
                                    ProfilePageButton(
                                        title: 'My Messages',
                                        subTitle: 'Check all your messages',
                                        icon: Icons.message_outlined,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          MyMessages()));
                                        }),
                                    SizedBox(height: 3),
                                    ProfilePageButton(
                                        title: 'Edit Name',
                                        subTitle: 'Edit your profile name',
                                        icon: Icons.edit_outlined,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          EditName(
                                                              initialName:
                                                                  userData.name,
                                                              uid: userData
                                                                  .uid)));
                                        }),
                                    // ProfilePageButton(title: 'Delete Account', subTitle: 'Delete your account permanently', icon: Icons.delete_outline_outlined, onTap: () {deleteAccount(context);}),
                                    SizedBox(height: 3),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: InkWell(
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    String token = await FirebaseMessaging
                                        .instance
                                        .getToken();
                                    await DatabaseService(
                                            uid: _auth.currentUser.uid)
                                        .removeFCMToken(token);
                                    await _auth.signOut();
                                    context.loaderOverlay.hide();
                                    Navigator.pushReplacementNamed(
                                        context, '/signup');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Signed out successfully!')));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Colors.red,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Icon(
                                          Icons.logout,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'LOG OUT',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: PlaceholderLines(
                              count: 3,
                              animate: true,
                            ),
                          ),
                  ),
                ],
              );
            }));
  }
}
