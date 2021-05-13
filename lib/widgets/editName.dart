import 'package:covid_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class EditName extends StatefulWidget {

  final String initialName;
  final String uid;

  const EditName({Key key, this.initialName, this.uid}) : super(key: key);

  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {

  final _nameKey = GlobalKey<FormFieldState>();
  String _name = '';

  @override
  void initState() {
    _name = widget.initialName;
    super.initState();
  }

  void submitEditName() async {
    FocusScope.of(context).unfocus();
    if (_nameKey.currentState.validate()) {
      context.loaderOverlay.show();
      try {
        await DatabaseService(uid: widget.uid).updateName(_name);
        context.loaderOverlay.hide();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name updated successfully!'), behavior: SnackBarBehavior.floating,));
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
          'Edit Name',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            children: [
              TextFormField(
                key: _nameKey,
                initialValue: widget.initialName,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if(value==null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  _nameKey.currentState.validate();
                  setState(() {
                    _name=value;
                  });
                },
                onFieldSubmitted: (value) {
                  submitEditName();
                },
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
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.person, size: 20),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: submitEditName,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Update Name',
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
      ),
    );
  }
}
