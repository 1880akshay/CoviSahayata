import 'package:covid_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:covid_app/services/locationData.dart';

class AddRequest extends StatefulWidget {

  const AddRequest({Key key}) : super(key: key);

  @override
  _AddRequestState createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {

  FirebaseAuth _auth;
  User _user;

  List<String> userRequirements = [];
  bool userRequirementEdited = false;
  bool submitClicked = false;

  String selectedState;
  String selectedDistrict;
  String secondaryNumber = '';

  String primaryNumber = '';

  final _numberKey = GlobalKey<FormFieldState>();
  final _stateKey = GlobalKey<FormFieldState>();
  final _districtKey = GlobalKey<FormFieldState>();
  final _addRequestFormKey = GlobalKey<FormState>();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _districtController = TextEditingController();

  bool districtEnabled = false;
  List<String> districtData = [];

  List<String> stateData = [
    'Bombay', 'Delhi', 'Kolkata', 'Ranchi', 'Amritsar',
  ];

  List<Map<String, dynamic>> locationData = LocationData().locationData;

  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    DatabaseService(uid: _user.uid).getProfile.listen((value) {
      if(value != null) {
        primaryNumber = value.number;
      }
    });
    super.initState();
  }

  void toggleRequirementSelection(String req) {
    setState(() {
      userRequirementEdited = true;
      if(userRequirements.contains(req)) {
        userRequirements.remove(req);
      }
      else {
        userRequirements.add(req);
      }
    });
  }

  void submitAddRequest() async {
    FocusScope.of(context).unfocus();
    setState(() {
      submitClicked = true;
    });
    if(_addRequestFormKey.currentState.validate() && userRequirements.isNotEmpty) {
      context.loaderOverlay.show();
      try {
        await DatabaseService(uid: _user.uid).addRequest(userRequirements, selectedState, selectedDistrict, '+91'+secondaryNumber, primaryNumber);
        context.loaderOverlay.hide();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request added successfully!'), behavior: SnackBarBehavior.floating,));
      } catch(e) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong! Please try again')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f3f5),
      appBar: AppBar(
        title: Text(
          'Add Request',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _addRequestFormKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text(
              'Requirement',
              style: TextStyle(
                color: Colors.grey[850],
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              children: [
                RequirementChip(label: 'Oxygen', toggle: toggleRequirementSelection),
                RequirementChip(label: 'Ventilator', toggle: toggleRequirementSelection),
                RequirementChip(label: 'ICU', toggle: toggleRequirementSelection),
                RequirementChip(label: 'Beds', toggle: toggleRequirementSelection),
                RequirementChip(label: 'Plasma', toggle: toggleRequirementSelection),
                RequirementChip(label: 'Remdesivir', toggle: toggleRequirementSelection),
                RequirementChip(label: 'Fabiflu', toggle: toggleRequirementSelection),
              ],
            ),
            if(userRequirements.isEmpty && (userRequirementEdited || submitClicked)) Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                'Please select at least one requirement',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 20),
            TypeAheadFormField(
              key: _stateKey,
              textFieldConfiguration: TextFieldConfiguration(
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  _stateKey.currentState.validate();
                  setState(() {
                    selectedState = '';
                    districtEnabled = false;
                    districtData = [];
                    this._districtController.text = '';
                  });
                },
                controller: this._stateController,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[850],
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6),
                  border: OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  labelText: 'State / UT',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.location_on,
                    size: 20,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                  ),
                ),
              ),
              suggestionsCallback: (pattern) {
                return locationData.where((element) {
                  return element['state'].toLowerCase().contains(pattern.toLowerCase());
                });
              },
              itemBuilder: (context, suggestion) {
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300])
                      ),
                    ),
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      suggestion['state'],
                      style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              noItemsFoundBuilder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[300])
                    ),
                  ),
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'No items found',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                );
              },
              loadingBuilder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[300])
                    ),
                  ),
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Center(
                    child: SpinKitCircle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) {
                this._stateController.text = suggestion['state'];
                _stateKey.currentState.validate();
                setState(() {
                  selectedState = suggestion['state'];
                  districtEnabled = true;
                  districtData = locationData.firstWhere((element) => element['state'] == selectedState)['districts'];
                });
              },
              validator: (value) {
                if (value==null || value.isEmpty) {
                  return 'Please select a state';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TypeAheadFormField(
              key: _districtKey,
              textFieldConfiguration: TextFieldConfiguration(
                enabled: districtEnabled,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  _districtKey.currentState.validate();
                  setState(() {
                    selectedDistrict = value;
                  });
                },
                controller: this._districtController,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[850],
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6),
                  border: OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red[700],
                    fontSize: 12,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  labelText: 'District',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    size: 20,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                  ),
                ),
              ),
              suggestionsCallback: (pattern) {
                return districtData.where((element) {
                  return element.toLowerCase().contains(pattern.toLowerCase());
                });
              },
              itemBuilder: (context, suggestion) {
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey[300])
                      ),
                    ),
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                this._districtController.text = suggestion;
                _districtKey.currentState.validate();
                setState(() {
                  selectedDistrict = suggestion;
                });
              },
              validator: (value) {
                if (value==null || value.isEmpty) {
                  return 'Please select a district';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              key: _numberKey,
              validator: (value) {
                String regex = '^[0-9]*\$';
                RegExp regExp = new RegExp(regex);
                if(regExp.hasMatch(value)) return null;
                return 'Invalid Phone number';
              },
              onChanged: (value) {
                _numberKey.currentState.validate();
                setState(() {
                  secondaryNumber = value;
                });
              },
              onFieldSubmitted: (value) {submitAddRequest();},
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[850],
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(6),
                border: OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                labelText: 'Additional Phone Number',
                labelStyle: TextStyle(
                  fontSize: 14,
                ),
                helperText: '(optional)',
                prefixIcon: Icon(
                  Icons.phone_android,
                  size: 20,
                ),
                prefixText: '+91 ',
                prefixStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      submitAddRequest();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Add Request',
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context).primaryColor.withOpacity(0.7);
                          return Theme.of(context).primaryColor;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RequirementChip extends StatefulWidget {
  final String label;
  final Function toggle;
  const RequirementChip({Key key, this.label, this.toggle}) : super(key: key);

  @override
  _RequirementChipState createState() => _RequirementChipState();
}

class _RequirementChipState extends State<RequirementChip> {

  Color labelColor = Colors.grey[850];
  bool checkmark = false;
  bool selected = false;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FilterChip(
        backgroundColor: Colors.grey[350],
        selectedColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: labelColor,
          fontSize: 13,
        ),
        showCheckmark: checkmark,
        checkmarkColor: Colors.white,
        label: Text(widget.label),
        selected: selected,
        onSelected: (bool value) {
          widget.toggle(widget.label);
          if(value) {
            setState(() {
              labelColor = Colors.white;
              checkmark = true;
              selected = true;
            });
          }
          else {
            setState(() {
              labelColor = Colors.grey[850];
              checkmark = false;
              selected = false;
            });
          }
        },
      ),
    );
  }
}

