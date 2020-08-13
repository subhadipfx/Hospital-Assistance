import 'package:covid_hospital_app/data_model.dart';
import 'package:covid_hospital_app/hospital_list.dart';
import 'package:covid_hospital_app/tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slider_button/slider_button.dart';

import 'api.dart';

class HospitalResultsPage extends StatefulWidget {
  final position;
  final address;

  HospitalResultsPage({@required this.position, @required this.address});
  @override
  _HospitalResultsPageState createState() => _HospitalResultsPageState();
}

class _HospitalResultsPageState extends State<HospitalResultsPage> {
  bool isLoading ;
  List<Hospital> hospitals ;
  HospitalResults hospitalResults = HospitalResults();

  @override
  void initState() {
    // TODO: implement initState
    hospitals = [];
    super.initState();
    isLoading = true;
    getResults();
  }

  Future<void> getResults() async {
    hospitals.clear();
    setState(() {
      isLoading = true;
    });
    await hospitalResults.fetchResults(widget.position, context);
    hospitals = hospitalResults.hospitals;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.grey[400],
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
//        floatingActionButton: OpenContainer(
//          closedElevation: 8,
//          closedColor: Colors.transparent,
//          closedShape: CircleBorder(),
//          closedBuilder: (context, openContainer) => FloatingActionButton(
//            backgroundColor: Colors.green[300],
//            child: Icon(Icons.gps_fixed),
//            onPressed: openContainer,
//          ),
//          openBuilder: (context, _) => GetLocationHome(),
//        ),
        body: RefreshIndicator(
          onRefresh: getResults,
          color: Colors.black,
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    elevation: 8,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: SvgPicture.asset('assets/vectors/hospital.svg', width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth,),
                    ),
                    backgroundColor: Colors.white,
                    title: Text('Hospitals near you', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
                    brightness: Brightness.light,
                    leading: IconButton(
                      splashRadius: 20,
                      onPressed: ()=> Navigator.pop(context),
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                    ),
                  ),
//              SliverToBoxAdapter(
//                child: SvgPicture.asset('assets/vectors/hospital.svg', width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth,),
//              ),
                  if(isLoading)
                    SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                        backgroundColor: Colors.transparent,
                        minHeight: 2,
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((isLoading ? 'Finding ' : '') +'Support Services nearest to:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                          Container(height: 8,),
                          Text(widget.address ?? 'Your Location'),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => HospitalList(hospital: hospitals[index]),
                      childCount: hospitals.length,
                    ),
                  ),
                  if (!isLoading && hospitals.length == 0)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Text('No hospitals found.'),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 92,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: SliderButton(
                  action: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackingScreen(position: widget.position,)));
                  },
                  alignLabel: Alignment.center,
                  backgroundColor: Colors.red,
                  baseColor: Colors.white,
                  shimmer: true,
                  vibrationFlag: false,
                  highlightedColor: Colors.black54,
                  height: 60,
                  width: MediaQuery.of(context).size.width - 32,
                  boxShadow: BoxShadow(
                    color: Colors.black38,
                    blurRadius: 8,
                    spreadRadius: 4,
                  ),
                  radius: 8,
                  label: Text(
                    'Book Ambulance',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, letterSpacing: 2),
                  ),
                  icon: Icon(FontAwesomeIcons.ambulance, color: Colors.red,),
                  dismissible: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
