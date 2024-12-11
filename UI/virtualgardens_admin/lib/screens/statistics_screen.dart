import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/nalozi.dart';
import 'package:virtualgardens_admin/models/search_result.dart';
import 'package:virtualgardens_admin/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_admin/models/zaposlenici.dart';
import 'package:virtualgardens_admin/providers/nalozi_provider.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';
import 'package:virtualgardens_admin/providers/utils.dart';
import 'package:virtualgardens_admin/providers/zaposlenici_provider.dart';
import 'package:virtualgardens_admin/screens/zaposlenici_list_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late NarudzbaProvider _narudzbaProvider;

  List<int>? monthlyStatistic;
  List<FlSpot>? spots;

  bool isLoading = true;
  bool isLoadingSave = false;

  final TextEditingController _godinaEditingController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _narudzbaProvider = context.read<NarudzbaProvider>();

    super.initState();

    initForm();
  }

  initForm() async {
    var year = DateTime.now().year;

    monthlyStatistic = await _narudzbaProvider.MonthlyStatistics(year: year);

    spots = monthlyStatistic!.asMap().entries.map((e) {
      return FlSpot(e.key.toInt() + 1, e.value.toDouble());
    }).toList();

    _godinaEditingController.text = "";

    setState(() {
      isLoading = false;
      isLoadingSave = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        FullScreenLoader(
            isLoading: isLoading,
            child: Container(
              margin: const EdgeInsets.only(
                  left: 40, right: 40, top: 20, bottom: 10),
              color: const Color.fromRGBO(235, 241, 224, 1),
              child: Column(
                children: [_buildBanner(), _buildMain()],
              ),
            )),
        "Statistika");
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: const Color.fromRGBO(32, 76, 56, 1),
      width: double.infinity,
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(size: 45, color: Colors.white, Icons.analytics),
            SizedBox(
              width: 10,
            ),
            Text("Statistika",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "arial",
                    color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _buildMain() {
    return Expanded(
      child: Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(32, 76, 56, 1),
          ),
          margin: const EdgeInsets.all(15),
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: const Color.fromRGBO(235, 241, 224, 1),
                    child: Column(children: [
                      Expanded(
                        child: _buildStatistic1(),
                      ),
                      Expanded(child: _buildStatistic2())
                    ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color.fromRGBO(235, 241, 224, 1),
                    child: _buildStatistic3(),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildStatistic3() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: Container());
  }

  Widget _buildStatistic1() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: _godinaEditingController,
                        decoration: InputDecoration(label: Text("Godina")),
                        style: TextStyle(decorationColor: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          isLoading = true;
                          setState(() {});
                          var year =
                              int.tryParse(_godinaEditingController.text);
                          monthlyStatistic =
                              await _narudzbaProvider.MonthlyStatistics(
                                  year: year ?? 2024);
                          isLoading = false;

                          spots = monthlyStatistic!.asMap().entries.map((e) {
                            return FlSpot(
                                e.key.toInt() + 1, e.value.toDouble());
                          }).toList();
                          setState(() {});
                        },
                        child: const Text("Pretraga")),
                  ],
                ),
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: LineChart(LineChartData(
                      titlesData: const FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true)),
                          rightTitles: AxisTitles(
                              axisNameWidget: Text(
                            "Broj narudzbi",
                            style: TextStyle(color: Colors.black),
                          )),
                          topTitles: AxisTitles(
                            axisNameWidget: (Text("Mjesec",
                                style: TextStyle(color: Colors.black))),
                          )),
                      lineBarsData: [
                        LineChartBarData(
                            dotData: const FlDotData(show: true),
                            spots: spots ?? [],
                            belowBarData:
                                BarAreaData(show: true, color: Colors.white54),
                            aboveBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.shade100.withOpacity(0.3)),
                            color: Colors.green.shade600)
                      ],
                    )),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildStatistic2() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(32, 76, 56, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PieChart(PieChartData(sections: [
            PieChartSectionData(
                value: 10,
                color: Colors.blue,
                radius: 60,
                title: "sdlkfjsdlksdjfsldkjflksdaf",
                titleStyle: TextStyle(color: Colors.white)),
            PieChartSectionData(
                value: 30,
                color: Colors.red,
                radius: 60,
                titleStyle: TextStyle(color: Colors.white)),
            PieChartSectionData(
                value: 40,
                color: Colors.orange,
                radius: 60,
                titleStyle: TextStyle(color: Colors.white)),
            PieChartSectionData(
                value: 10,
                color: Colors.purple,
                radius: 60,
                titleStyle: TextStyle(color: Colors.white))
          ])),
        ));
  }
}
