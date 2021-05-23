import 'package:covid_app/services/locationData.dart';
import 'package:covid_app/services/requirementData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Filters extends StatefulWidget {
  final List<bool> requirementIsSelected;
  final List<bool> stateIsSelected;
  final Function applyFilters;
  const Filters(
      {Key key,
      this.requirementIsSelected,
      this.stateIsSelected,
      this.applyFilters})
      : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int selectedIndex = 0;

  void selectTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<bool> localRequirementIsSelected;
  List<bool> localStateIsSelected;

  List<String> requirementFilters = [];
  List<String> stateFilters = [];

  void editFilterRequirement(String req) {
    if (requirementFilters.contains(req)) {
      requirementFilters.remove(req);
    } else {
      requirementFilters.add(req);
    }
  }

  void editFilterState(String state) {
    if (stateFilters.contains(state)) {
      stateFilters.remove(state);
    } else {
      stateFilters.add(state);
    }
  }

  void reRender() {
    setState(() {});
  }

  @override
  void initState() {
    localRequirementIsSelected = List.from(widget.requirementIsSelected);
    localStateIsSelected = List.from(widget.stateIsSelected);
    List<String> requirementData = RequirementData().requirementData;
    List<Map<String, dynamic>> locationData = LocationData().locationData;
    for (int i = 0; i < requirementData.length; i++) {
      if (widget.requirementIsSelected[i]) {
        requirementFilters.add(requirementData[i]);
      }
    }
    for (int i = 0; i < locationData.length; i++) {
      if (widget.stateIsSelected[i]) {
        stateFilters.add(locationData[i]['state']);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    //var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    List<Widget> filterPages = [
      RequirementsFilter(
          isSelected: localRequirementIsSelected,
          editFilterRequirement: editFilterRequirement,
          reRender: reRender),
      StateFilter(
          isSelected: localStateIsSelected,
          editFilterState: editFilterState,
          reRender: reRender),
    ];

    return Container(
      height: screenHeight * 0.75,
      color: Colors.white,
      child: Column(
        children: [
          Material(
            elevation: 2,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        for (int i = 0;
                            i < localRequirementIsSelected.length;
                            i++) {
                          localRequirementIsSelected[i] = false;
                        }
                        for (int i = 0; i < localStateIsSelected.length; i++) {
                          localStateIsSelected[i] = false;
                        }
                        requirementFilters = [];
                        stateFilters = [];
                      });
                    },
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
                    color: Color(0xfff2f3f5),
                    child: ListView(
                      children: [
                        FilterLabel(
                          label: 'Requirements',
                          isActive: (selectedIndex == 0) ? true : false,
                          index: 0,
                          selectTab: selectTab,
                          isFilterUsed: (localRequirementIsSelected != null)
                              ? localRequirementIsSelected.contains(true)
                              : false,
                        ),
                        FilterLabel(
                          label: 'State / UT',
                          isActive: (selectedIndex == 1) ? true : false,
                          index: 1,
                          selectTab: selectTab,
                          isFilterUsed: (localStateIsSelected != null)
                              ? localStateIsSelected.contains(true)
                              : false,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                      margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
                      child: filterPages.elementAt(selectedIndex)),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, -2),
                    color: Colors.grey[350],
                    blurRadius: 2),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 10, vertical: 13)),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder()),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.applyFilters(
                          localRequirementIsSelected,
                          localStateIsSelected,
                          requirementFilters,
                          stateFilters);
                    },
                    child: Text(
                      'APPLY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .primaryColor
                                .withOpacity(0.7);
                          return Theme.of(context)
                              .primaryColor; // Use the component's default.
                        },
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 10, vertical: 13)),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterLabel extends StatefulWidget {
  final String label;
  final bool isActive;
  final int index;
  final Function selectTab;
  final isFilterUsed;
  const FilterLabel(
      {Key key,
      this.label,
      this.isActive,
      this.index,
      this.selectTab,
      this.isFilterUsed})
      : super(key: key);

  @override
  _FilterLabelState createState() => _FilterLabelState();
}

class _FilterLabelState extends State<FilterLabel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.selectTab(widget.index);
      },
      child: Container(
        color: (widget.isActive) ? Colors.white : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[850],
                    letterSpacing: 0.2,
                    fontWeight:
                        (widget.isActive) ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 15),
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                color: (widget.isFilterUsed)
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequirementsFilter extends StatefulWidget {
  final List<bool> isSelected;
  final Function editFilterRequirement;
  final Function reRender;
  const RequirementsFilter(
      {Key key, this.isSelected, this.editFilterRequirement, this.reRender})
      : super(key: key);

  @override
  _RequirementsFilterState createState() => _RequirementsFilterState();
}

class _RequirementsFilterState extends State<RequirementsFilter> {
  List<String> requirementData = RequirementData().requirementData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0.5,
          color: Colors.grey[600],
          endIndent: 10,
          indent: 10,
          thickness: 0.2),
      itemCount: requirementData.length,
      itemBuilder: (BuildContext context, int index) {
        return CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0.5),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            requirementData[index],
            style: TextStyle(
              color: Colors.grey[850],
              fontSize: 14,
            ),
          ),
          value: widget.isSelected[index],
          selected: widget.isSelected[index],
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool value) {
            setState(() {
              widget.isSelected[index] = value;
            });
            widget.editFilterRequirement(requirementData[index]);
            widget.reRender();
          },
        );
      },
    );
  }
}

class StateFilter extends StatefulWidget {
  final List<bool> isSelected;
  final Function editFilterState;
  final Function reRender;
  const StateFilter(
      {Key key, this.isSelected, this.editFilterState, this.reRender})
      : super(key: key);

  @override
  _StateFilterState createState() => _StateFilterState();
}

class _StateFilterState extends State<StateFilter> {
  List<Map<String, dynamic>> locationData = LocationData().locationData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0.5,
          color: Colors.grey[600],
          endIndent: 10,
          indent: 10,
          thickness: 0.2),
      itemCount: locationData.length,
      itemBuilder: (BuildContext context, int index) {
        return CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            locationData[index]['state'],
            style: TextStyle(
              color: Colors.grey[850],
              fontSize: 14,
            ),
          ),
          value: widget.isSelected[index],
          selected: widget.isSelected[index],
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool value) {
            setState(() {
              widget.isSelected[index] = value;
            });
            widget.editFilterState(locationData[index]['state']);
            widget.reRender();
          },
        );
      },
    );
  }
}
