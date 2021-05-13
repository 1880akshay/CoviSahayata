import 'package:covid_app/widgets/myRequests.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/services/database.dart';
import 'package:covid_app/widgets/editName.dart';
import 'package:covid_app/widgets/profilePageButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  double avatarSize = 110;
  FirebaseAuth _auth;
  User _user;

  UserData userData;

  @override
  void initState()  {
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    super.initState();
  }

  Future<void> _showConfirmationDialog(BuildContext mainContext) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete your account permanently? This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('YES'),
              onPressed: () async {
                Navigator.of(context).pop();
                mainContext.loaderOverlay.show();
                try {
                  await DatabaseService(uid: _user.uid).deleteAccount();
                  await _auth.signOut();
                  Navigator.pushReplacementNamed(mainContext, '/signup');
                  mainContext.loaderOverlay.hide();
                  ScaffoldMessenger.of(mainContext).showSnackBar(SnackBar(content: Text('Account deleted successfully!')));
                } catch(e) {
                  mainContext.loaderOverlay.hide();
                  ScaffoldMessenger.of(mainContext).showSnackBar(SnackBar(content: Text('Something went wrong! Please try again')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void deleteAccount(BuildContext mainContext) async {
    await _showConfirmationDialog(mainContext);
  }

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    //var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff2f3f5),
      body: StreamBuilder<UserData>(
        stream: DatabaseService(uid: _user.uid).getProfile,
        builder: (context, snapshot) {

          if(snapshot.hasData) {
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
                          height: 200,
                          decoration: BoxDecoration(
                            //color: Theme.of(context).primaryColor,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(Theme.of(context).primaryColor.withOpacity(1.0), BlendMode.softLight),
                              image: AssetImage('assets/images/headbg.png'),
                            ),
                          ),
                          child: Container(),
                        ),
                        Container(
                          color: Colors.white,
                          height: 100,
                          child: Padding(
                            padding: EdgeInsets.only(top: avatarSize / 2),
                            child: Center(
                                child: Text(
                                  (userData != null) ? userData.name : '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[850],
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 200 - avatarSize / 2,
                    child: Initicon(
                      text: (userData != null) ? userData.name : '',
                      elevation: 5.0,
                      size: avatarSize,
                    ),
                  ),
                ],
              ),
              Container(
                height: screenHeight - 360,
                child: (userData != null) ? ListView(
                  padding: EdgeInsets.only(bottom: 50),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProfilePageButton(title: 'My Requests', subTitle: 'Check your pending and completed requests', icon: Icons.question_answer_outlined, onTap: () {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyRequests(uid: userData.uid)));}),
                          SizedBox(height: 3),
                          ProfilePageButton(title: 'Edit Name', subTitle: 'Edit your profile name', icon: Icons.edit_outlined, onTap: () {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditName(initialName: userData.name, uid: userData.uid)));}),
                          SizedBox(height: 3),
                          ProfilePageButton(title: 'Delete Account', subTitle: 'Delete your account permanently', icon: Icons.delete_outline_outlined, onTap: () {deleteAccount(context);}),
                          SizedBox(height: 3),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: InkWell(
                        onTap: () async {
                          context.loaderOverlay.show();
                          await _auth.signOut();
                          context.loaderOverlay.hide();
                          Navigator.pushReplacementNamed(context, '/signup');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signed out successfully!')));
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
                ) :
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: PlaceholderLines(
                    count: 3,
                    animate: true,
                  ),
                ),
              ),
            ],
          );
        }
      )
    );
  }
}

