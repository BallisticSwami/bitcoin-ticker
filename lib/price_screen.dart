import 'package:bitcointicker/coin_data.dart';
import 'package:bitcointicker/utilities/networking.dart';
import 'package:bitcointicker/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  bool darkTheme = false;

  String currentCurrency = 'USD';
  List<double> conversionFactor = [0, 0, 0, 0, 0];
  bool listDragged = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String coinURL =
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin,dogecoin,tether&vs_currencies=';

  var f = NumberFormat("###,###,###.#########", "en_US");

  void _getExchangeRates() async {
    var url = '$coinURL$currentCurrency';
    NetworkHelper netHelper = NetworkHelper(url);
    var data = await netHelper.getData();
    setState(() {
      conversionFactor[0] =
          data["bitcoin"]["${currentCurrency.toLowerCase()}"].toDouble();
      conversionFactor[1] =
          data["ethereum"]["${currentCurrency.toLowerCase()}"].toDouble();
      conversionFactor[2] =
          data["litecoin"]["${currentCurrency.toLowerCase()}"].toDouble();
      conversionFactor[3] =
          data["tether"]["${currentCurrency.toLowerCase()}"].toDouble();
      conversionFactor[4] =
          data["dogecoin"]["${currentCurrency.toLowerCase()}"].toDouble();
    });
  }

  @override
  void initState() {
    super.initState();
    _getExchangeRates();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      setState(() {
        darkTheme = true;
      });
    } else {
      setState(() {
        darkTheme = false;
      });
    }
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          //backgroundColor: Colors.grey[900],
          tooltip: 'Select Currency',
          //elevation: 1,
          onPressed: () {
            if (listDragged == true) {
              Navigator.pop(context);
              setState(() {
                listDragged = false;
              });
            } else {
              setState(() {
                listDragged = true;
              });
              _scaffoldKey.currentState
                  .showBottomSheet<Null>((BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.builder(
                    itemCount: currenciesList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(currenciesList[index]),
                        onTap: () {
                          setState(() {
                            currentCurrency = currenciesList[index];
                            _getExchangeRates();
                            listDragged = false;
                            Navigator.pop(context);
                          });
                        },
                      );
                    },
                  ),
                );
              });
            }
          },
          child: Icon(Icons.attach_money),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  darkTheme ? Brightness.light : Brightness.dark,
              systemNavigationBarColor: darkTheme ? Colors.black : Colors.white,
              systemNavigationBarIconBrightness:
                  darkTheme ? Brightness.light : Brightness.dark),
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            left: SizeConfig.safeBlockHorizontal * 5,
                            top: SizeConfig.safeBlockVertical * 1.7),
                        child: Text(
                          'Coin\nTicker',
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 6.5,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 2.5,
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: imgList.length,
                            itemBuilder: (context, index) {
                              return CoinCard(
                                  imageName: imgList[index],
                                  heading: imgList[index],
                                  subtitle:
                                      '1 ${cryptoList[index]} = ${f.format(conversionFactor[index])} $currentCurrency');
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: listDragged ? true : false,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  color: Colors.black.withOpacity(listDragged ? 0.3 : 0),
                ),
              )
            ],
          ),
        ));
  }
}

class CoinCard extends StatefulWidget {
  final String imageName;
  final String heading;
  final String subtitle;

  CoinCard({@required this.imageName, @required this.heading, this.subtitle});

  @override
  _CoinCardState createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.safeBlockVertical * 14,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.safeBlockHorizontal * 5,
            0,
            SizeConfig.safeBlockHorizontal * 5,
            SizeConfig.safeBlockVertical * 2),
        child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 0,
            child: Row(children: [
              Image.asset(
                'assets/${widget.imageName.toLowerCase()}.png',
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: SizeConfig.safeBlockHorizontal * 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.heading,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5.2,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 0.8,
                    ),
                    Text(widget.subtitle,
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.8,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              )
            ])),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
