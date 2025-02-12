import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:virtualgardens_admin/helpers/fullscreen_loader_2.dart';
import 'package:virtualgardens_admin/layouts/master_screen.dart';
import 'package:virtualgardens_admin/models/statistics_dtos/statistics.dart';
import 'package:virtualgardens_admin/providers/helper_providers/utils.dart';
import 'package:virtualgardens_admin/providers/narudzbe_provider.dart';

class StatisticsScreen extends StatefulWidget {
  final int? sentYear;
  const StatisticsScreen({super.key, this.sentYear});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late NarudzbaProvider _narudzbaProvider;

  Map<String, dynamic> availableYears = {};
  int selectedYear = DateTime.now().year;

  StatisticsDTO? monthlyStatistic;
  double average = 0.0;
  double averagePrihodi = 0.0;
  List<FlSpot>? spots = [];
  List<FlSpot>? spotsPrihodi = [];
  List<Color> gradientColors = [
    Colors.blue,
    Colors.red,
  ];
  bool showAvg = false;
  bool showAvgPrihodi = false;
  List<Widget> actions = [];
  bool isLoading = true;

  final TextEditingController _godinaEditingController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _narudzbaProvider = context.read<NarudzbaProvider>();
    selectedYear = widget.sentYear ?? DateTime.now().year;
    initForm();
    super.initState();
  }

  initForm() async {
    for (var i = 2024; i <= DateTime.now().year; i++) {
      availableYears[i.toString()] = i;
    }
    await _fetchStatistic(selectedYear);
    actions.add(Row(
      children: [
        _buildPrintPdfButton(),
        const SizedBox(
          width: 5,
        ),
        _buildPrintButton(),
        const SizedBox(
          width: 5,
        ),
        _buildDropdown(),
        const SizedBox(
          width: 5,
        )
      ],
    ));
  }

  _fetchStatistic(int year) async {
    monthlyStatistic = await _narudzbaProvider.monthlyStatistics(year: year);

    spots = monthlyStatistic!.narudzbe.asMap().entries.map((e) {
      return FlSpot(e.key.toInt() + 1, e.value.toDouble());
    }).toList();

    spotsPrihodi = monthlyStatistic!.prihodi.asMap().entries.map((e) {
      return FlSpot(e.key.toInt() + 1, e.value.toDouble());
    }).toList();

    var sum = 0;
    for (var i = 0; i < monthlyStatistic!.narudzbe.length; i++) {
      sum += monthlyStatistic!.narudzbe[i];
    }
    average = double.tryParse(
        (sum / monthlyStatistic!.narudzbe.length).toStringAsFixed(2))!;

    double sumPrihodi = 0;
    for (var i = 0; i < monthlyStatistic!.prihodi.length; i++) {
      sumPrihodi += monthlyStatistic!.prihodi[i];
    }
    averagePrihodi = double.tryParse(
        (sumPrihodi / monthlyStatistic!.prihodi.length).toStringAsFixed(2))!;

    _godinaEditingController.text = "";
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        FullScreenLoader2(
          isList: true,
          title: "Statistika",
          actions: actions,
          isLoading: isLoading,
          child: Column(
            children: [_buildMain()],
          ),
        ),
        "Statistika");
  }

  Widget _buildMain() {
    return Expanded(
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
                child: Column(children: [
                  Expanded(
                    child: _buildStatistic3(),
                  ),
                  Expanded(child: _buildStatistic4())
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistic1() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(3, 43, 43, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AspectRatio(
            aspectRatio: 2,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Broj narudžbi po mjesecima',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, left: 6),
                        child: LineChart(
                          showAvg
                              ? avgData(spots!, average, false)
                              : mainData(spots!, false),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(
                  width: 60,
                  height: 34,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        showAvg = !showAvg;
                      });
                    },
                    child: Text(
                      'avg',
                      style: TextStyle(
                        fontSize: 12,
                        color: showAvg
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildStatistic2() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(3, 43, 43, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Najaktivniji kupci (Broj narudžbi po kupcu)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData(false),
                  borderData: borderData,
                  barGroups: barGroups,
                  gridData: const FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: monthlyStatistic != null &&
                          monthlyStatistic!.kupci.isNotEmpty
                      ? (monthlyStatistic?.kupci.first.brojNarudzbi
                                  .toDouble() ??
                              0) +
                          1
                      : 0,
                ),
              ),
            ),
          ]),
        ));
  }

  Widget _buildStatistic3() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(3, 43, 43, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AspectRatio(
            aspectRatio: 2,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Prihodi po mjesecima',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, left: 6),
                        child: LineChart(
                          showAvgPrihodi
                              ? avgData(spotsPrihodi!, averagePrihodi, true)
                              : mainData(spotsPrihodi!, true),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(
                  width: 60,
                  height: 34,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        showAvgPrihodi = !showAvgPrihodi;
                      });
                    },
                    child: Text(
                      'avg',
                      style: TextStyle(
                        fontSize: 12,
                        color: showAvgPrihodi
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildStatistic4() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(3, 43, 43, 1),
        ),
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Najaktivniji zaposlenici (Broj narudžbi po zaposleniku)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData(true),
                  borderData: borderData,
                  barGroups: barGroupsWorkers,
                  gridData: const FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: monthlyStatistic != null &&
                          monthlyStatistic!.workers.isNotEmpty
                      ? (monthlyStatistic?.workers.first.brojNarudzbi
                                  .toDouble() ??
                              0) +
                          1
                      : 0,
                ),
              ),
            ),
          ]),
        ));
  }

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: "$selectedYear",
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        items: availableYears.entries
            .map((item) => DropdownMenuItem(
                  value: item.key.toString(),
                  child: Text(item.value.toString(),
                      style: const TextStyle(color: Colors.black)),
                ))
            .toList(),
        onChanged: (value) async {
          if (value != null) {
            selectedYear = int.tryParse(value.toString())!;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: ((context) =>
                    StatisticsScreen(sentYear: selectedYear))));
          }
        },
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 3:
        text = '3';
        break;
      case 5:
        text = '5';
        break;
      case 7:
        text = '7';
        break;
      case 10:
        text = '10';
        break;
      case 15:
        text = '15';
        break;
      case 20:
        text = '20';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget leftTitleWidgetsPrihodi(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 1000:
        text = '1k';
        break;
      case 3000:
        text = '3k';
        break;
      case 5000:
        text = '5k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('FEB', style: style);
        break;

      case 4:
        text = const Text('APR', style: style);
        break;

      case 6:
        text = const Text('JUN', style: style);
        break;

      case 8:
        text = const Text('AUG', style: style);
        break;

      case 10:
        text = const Text('OCT', style: style);
        break;

      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData avgData(
      List<FlSpot> spots, double averageValue, bool isPrihodi) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 244, 37, 1),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          if (isPrihodi) {
            if (value.toInt() % 1000 == 0) {
              return const FlLine(
                color: Color.fromARGB(255, 0, 129, 234),
                strokeWidth: 1,
              );
            } else {
              return const FlLine(
                color: Color.fromARGB(0, 0, 129, 234),
                strokeWidth: 1,
              );
            }
          } else {
            return const FlLine(
              color: Color.fromARGB(255, 0, 129, 234),
              strokeWidth: 1,
            );
          }
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget:
                isPrihodi ? leftTitleWidgetsPrihodi : leftTitleWidgets,
            reservedSize: 42,
            interval: isPrihodi ? 1000 : 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5)),
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: isPrihodi ? 5000 : 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(1, averageValue),
            FlSpot(2, averageValue),
            FlSpot(3, averageValue),
            FlSpot(4, averageValue),
            FlSpot(5, averageValue),
            FlSpot(6, averageValue),
            FlSpot(7, averageValue),
            FlSpot(8, averageValue),
            FlSpot(9, averageValue),
            FlSpot(10, averageValue),
            FlSpot(11, averageValue),
            FlSpot(12, averageValue),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(List<FlSpot> spots, bool isPrihodi) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          if (isPrihodi) {
            if (value.toInt() % 1000 == 0) {
              return const FlLine(
                color: Color.fromARGB(255, 0, 129, 234),
                strokeWidth: 1,
              );
            } else {
              return const FlLine(
                color: Color.fromARGB(0, 0, 129, 234),
                strokeWidth: 1,
              );
            }
          } else {
            return const FlLine(
              color: Color.fromARGB(255, 0, 129, 234),
              strokeWidth: 1,
            );
          }
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.red,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget:
                isPrihodi ? leftTitleWidgetsPrihodi : leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5)),
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: isPrihodi
          ? ((monthlyStatistic?.prihodi
                      .reduce(
                          (value, element) => value > element ? value : element)
                      .toDouble()) ??
                  0) +
              1000
          : ((monthlyStatistic?.narudzbe
                      .reduce(
                          (value, element) => value > element ? value : element)
                      .toDouble()) ??
                  0) +
              1,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    text = monthlyStatistic != null && monthlyStatistic!.kupci.isNotEmpty
        ? "${monthlyStatistic!.kupci[value.toInt()].korisnik.ime} ${monthlyStatistic!.kupci[value.toInt()].korisnik.prezime}"
        : "";

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget getTitlesWorkers(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    text = monthlyStatistic != null && monthlyStatistic!.workers.isNotEmpty
        ? "${monthlyStatistic!.workers[value.toInt()].zaposlenik.ime} ${monthlyStatistic!.workers[value.toInt()].zaposlenik.prezime}"
        : "";

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData titlesData(bool isWorker) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          interval: 1,
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: isWorker ? getTitlesWorkers : getTitles,
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.blue.shade800,
          Colors.red,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups {
    var groups = <BarChartGroupData>[];
    if (monthlyStatistic != null) {
      for (var i = 0; i < monthlyStatistic!.kupci.length; i++) {
        groups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: monthlyStatistic!.kupci[i].brojNarudzbi.toDouble(),
                gradient: _barsGradient,
              )
            ],
            showingTooltipIndicators: [0],
          ),
        );
      }
    }
    return groups;
  }

  List<BarChartGroupData> get barGroupsWorkers {
    var groups = <BarChartGroupData>[];
    if (monthlyStatistic != null) {
      for (var i = 0; i < monthlyStatistic!.workers.length; i++) {
        groups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: monthlyStatistic!.workers[i].brojNarudzbi.toDouble(),
                gradient: _barsGradient,
              )
            ],
            showingTooltipIndicators: [0],
          ),
        );
      }
    }
    return groups;
  }

  Future<pw.MultiPage> _buildContent() async {
    final ByteData bytes = await rootBundle.load('assets/images/logo.png');
    final Uint8List list = bytes.buffer.asUint8List();
    final companyLogo = pw.MemoryImage(list);

    const primaryColor = PdfColor.fromInt(0x1E2C2F);
    const secondaryColor = PdfColor.fromInt(0x204C38);

    return pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Container(
            color: primaryColor,
            padding: const pw.EdgeInsets.all(10),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  height: 60,
                  width: 60,
                  child: pw.Image(companyLogo),
                ),
                pw.SizedBox(width: 15),
                pw.Text(
                  "Virtual Gardens",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Kupci",
              style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: secondaryColor)),
          pw.SizedBox(height: 5),
          pw.TableHelper.fromTextArray(
            headers: ["Ime i prezime", "Email", "Broj narudzbi"],
            data: monthlyStatistic!.kupci.map((customer) {
              final korisnik = customer.korisnik;
              return [
                "${korisnik.ime} ${korisnik.prezime}",
                korisnik.email,
                customer.brojNarudzbi.toString()
              ];
            }).toList(),
            border: pw.TableBorder.all(width: 1, color: primaryColor),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: secondaryColor),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
          pw.Text("Zaposlenici",
              style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: secondaryColor)),
          pw.SizedBox(height: 5),
          pw.TableHelper.fromTextArray(
            headers: ["Ime i prezime", "Email", "Broj narudzbi"],
            data: monthlyStatistic!.workers.map((worker) {
              final zaposlenik = worker.zaposlenik;
              return [
                "${zaposlenik.ime} ${zaposlenik.prezime}",
                zaposlenik.email,
                worker.brojNarudzbi.toString()
              ];
            }).toList(),
            border: pw.TableBorder.all(width: 1, color: primaryColor),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: secondaryColor),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
          pw.Text("Broj narudzbi po mjesecima",
              style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: secondaryColor)),
          pw.SizedBox(height: 5),
          pw.TableHelper.fromTextArray(
            headers: ["Mjesec", "Broj"],
            data: List.generate(
                12,
                (index) => [
                      "${index + 1}",
                      monthlyStatistic!.narudzbe[index].toString()
                    ]),
            border: pw.TableBorder.all(width: 1, color: primaryColor),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: secondaryColor),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
          pw.Text("Prihodi po mjesecu",
              style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: secondaryColor)),
          pw.SizedBox(height: 5),
          pw.TableHelper.fromTextArray(
            headers: ["Mjesec", "Prihod"],
            data: List.generate(
                12,
                (index) => [
                      "${index + 1}",
                      "${monthlyStatistic!.prihodi[index].toString()} KM"
                    ]),
            border: pw.TableBorder.all(width: 1, color: primaryColor),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: secondaryColor),
            cellAlignment: pw.Alignment.centerLeft,
          ),
        ];
      },
    );
  }

  Widget _buildPrintButton() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
          onPressed: () async {
            final pdf = pw.Document();
            pdf.addPage(await _buildContent());

            String? outputFilePath = await FilePicker.platform.saveFile(
              dialogTitle: "Spremite Vaš PDF izvještaj",
              fileName: "statisticki_izvjestaj_$selectedYear.pdf",
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            if (outputFilePath != null) {
              final file = File(outputFilePath);
              try {
                await file.writeAsBytes(await pdf.save());
                if (mounted) {
                  await buildSuccessAlert(context, "PDF spremljen",
                      "PDF je spremljen u odabranu mapu na lokaciji : \n$outputFilePath",
                      isDoublePop: false);
                }
              } on Exception catch (e) {
                if (mounted) {
                  await buildErrorAlert(context, "Greška", e.toString(), e);
                }
              }
            } else {
              debugPrint("User canceled file saving.");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: const Text(
            "Izvještaj",
            style: TextStyle(color: Color.fromRGBO(3, 43, 43, 1)),
          )),
    );
  }

  Widget _buildPrintPdfButton() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: () async {
          final pdf = pw.Document();

          pdf.addPage(await _buildContent());
          try {
            var response = await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async => await pdf.save(),
            );

            if (mounted && response) {
              await buildSuccessAlert(
                  context, "Uspješan ispis", "PDF je uspješno ispisan",
                  isDoublePop: false);
            } else if (mounted && !response) {
              await buildErrorAlert(
                  context,
                  "Odustali ste od ispisa",
                  "Odustali ste od ispisa",
                  Exception("Odustali ste od ispisa"));
            }
          } on Exception catch (e) {
            if (mounted) {
              await buildErrorAlert(context, "Greška", e.toString(), e);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: const Text(
          "Print PDF",
          style: TextStyle(color: Color.fromRGBO(3, 43, 43, 1)),
        ),
      ),
    );
  }
}
