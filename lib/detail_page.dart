import 'package:flutter/material.dart';
import 'base_network.dart';
import 'detail_matches_model.dart';
import 'matches_model.dart';

class MatchDetail extends StatefulWidget {
  final MatchesModel? detail;
  const MatchDetail({Key? key, required this.detail}) : super(key: key);

  @override
  State<MatchDetail> createState() => _MatchDetailState();
}

class _MatchDetailState extends State<MatchDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Match ID : ${widget.detail?.id}",
                  style: const TextStyle(
                      fontSize: 16
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: BaseNetwork.get("matches/${widget.detail?.id}"),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingSection();
            } else if (snapshot.hasError) {
              debugPrint(snapshot.toString());
              return _buildErrorSection();
            } else if (snapshot.hasData) {
              DetailMatchesModel matchModel = DetailMatchesModel.fromJson(snapshot.data);
              return _buildSuccessSection(matchModel);
            } else {
              return _buildErrorSection();
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(DetailMatchesModel data) {
    HomeTeamDetail? home = data.homeTeam!;
    AwayTeamDetail? away = data.awayTeam!;
    Statistics? homeStats = home.statistics!;
    Statistics? awayStats = away.statistics!;
    int ballPossHome = (homeStats.ballPossession!.round());
    int ballPossAway = (awayStats.ballPossession!.round());
    int passAccHome = ((homeStats.passesCompleted!.toDouble() /
        homeStats.passes!.toDouble()) * 100).round();
    int passAccAway = ((awayStats.passesCompleted!.toDouble() /
        awayStats.passes!.toDouble()) * 100).round();


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 150,
                        height: 120,
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(
                                'https://countryflagsapi.com/png/${widget.detail!
                                    .homeTeam!.name!}'))),
                    Padding(padding: const EdgeInsets.all(8)),
                    Text(("${widget.detail!.homeTeam!.name!}")),
                  ],

                ),
                Text(
                  " ${widget.detail!.homeTeam!.goals} - ${widget.detail!.awayTeam!
                      .goals} ",
                  style: const TextStyle(
                      fontSize: 20
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 150,
                        height: 120,
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(
                                'https://countryflagsapi.com/png/${widget.detail!
                                    .awayTeam!.name!}'))),
                    Padding(padding: const EdgeInsets.all(8)),
                    Text(("${widget.detail!.awayTeam!.name!}")),
                  ],

                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            Text(
                "Stadium : ${data.venue}"
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            Text(
                "Stadium : ${data.location}"
            ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                )
              ),
              padding: const EdgeInsets.all(16),
              // child: Card(
              //     shape: RoundedRectangleBorder(
              //     side: BorderSide(
              //       width: 3,
              //     ),
              //   ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Statistics", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$ballPossHome%"),
                          Text("Ball Possession"),
                          Text("$ballPossAway%"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${homeStats!.attemptsOnGoal}"),
                          Text("Shots"),
                          Text("${awayStats!.attemptsOnGoal}")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${homeStats!.kicksOnTarget}"),
                          Text("Shots on Goal"),
                          Text("${awayStats!.kicksOnTarget}")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${homeStats!.corners}"),
                          Text("Corners"),
                          Text("${awayStats!.corners}")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${homeStats!.offsides}"),
                          Text("Offsides"),
                          Text("${awayStats!.offsides}")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${homeStats!.foulsCommited}"),
                          Text("Fouls Committed"),
                          Text("${awayStats!.foulsCommited}")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$passAccHome%"),
                          Text("Pass Accuracy"),
                          Text("$passAccAway%")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const Padding(padding: EdgeInsets.only(top: 8)),
            const Text("Referees :", style: TextStyle(fontSize: 20)),
            const Padding(padding: EdgeInsets.only(top: 8)),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: data.officials!.map((ofc) {
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 200,
                        width: 130,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // if you need this
                            side: BorderSide(
                              color: Colors.black.withOpacity(0.1),
                              width: 3,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 80,
                                  child: const Image(
                                    image: NetworkImage(
                                        'data:image/png;base64,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'),
                                  ),
                                ),
                                Text(
                                  "${ofc.name}",
                                  textAlign: TextAlign.center,style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "(${ofc.role})",
                                  textAlign: TextAlign.center,style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        )
                    );
                  }).toList(),
                )
            )
          ],
        ),
      ),
    );
  }
}


