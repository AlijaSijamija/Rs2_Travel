import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/route_ticket/agency_profit_report.dart';
import 'package:travel_admin/model/route_ticket/route_profit_report.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/agency_provider.dart';
import 'package:travel_admin/providers/route_ticket.dart';
import 'package:travel_admin/widgets/master_screen.dart';

class AgencyReportScreen extends StatefulWidget {
  const AgencyReportScreen({super.key});

  @override
  State<AgencyReportScreen> createState() => _AgencyReportScreenState();
}

class _AgencyReportScreenState extends State<AgencyReportScreen> {
  late final RouteTicketProvider _ticketProvider;
  late final AgencyProvider _agencyProvider;

  List<AgencyProfitReportModel> _agencyProfits = [];
  List<RouteProfitReportModel> _routeProfits = [];
  SearchResult<AgencyModel>? _agencyResult;
  int? _selectedAgencyId;
  String? selectedYear;

  List<DropdownItem> dropdownItems = [
    DropdownItem(2025, '2025'),
    DropdownItem(2024, '2024'),
    DropdownItem(2023, '2023'),
    DropdownItem(2022, '2022'),
    DropdownItem(2021, '2021'),
    DropdownItem(2020, '2020'),
    DropdownItem(2019, '2019'),
  ];

  List<DropdownItem> busTypes = [
    DropdownItem(1, 'Mini'),
    DropdownItem(2, 'Midi'),
    DropdownItem(3, 'Standard'),
    DropdownItem(4, 'Luxury')
  ];
  List<int> selectedBusTypes = [];

  @override
  void initState() {
    super.initState();
    _ticketProvider = context.read<RouteTicketProvider>();
    _agencyProvider = context.read<AgencyProvider>();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final agencies = await _agencyProvider.get();
    var filter = {'year': 2025};
    final agencyProfits =
        await _ticketProvider.getAgencyProfitReport(filter: filter);
    setState(() {
      _agencyResult = agencies;
      _agencyProfits = agencyProfits;
      selectedYear = "2025";
    });
  }

  Map<String, dynamic> _buildFilter() {
    return {
      'year': selectedYear,
      'agencyId': _selectedAgencyId,
      'busTypes': selectedBusTypes.isEmpty ? null : selectedBusTypes,
    };
  }

  Future<void> _onAgencySelected(int? agencyId) async {
    final filter = _buildFilter();
    filter['agencyId'] = agencyId;

    if (agencyId == null) {
      // Svi -> učitavamo profite po agencijama
      final agencyProfits =
          await _ticketProvider.getAgencyProfitReport(filter: filter);
      setState(() {
        _selectedAgencyId = null;
        _agencyProfits = agencyProfits;
        _routeProfits = []; // očisti rute
      });
    } else {
      final routeProfits =
          await _ticketProvider.getRouteProfitReport(filter: filter);
      setState(() {
        _selectedAgencyId = agencyId;
        _routeProfits = routeProfits;
        _agencyProfits = []; // očisti agencije
      });
    }
  }

  Future<void> _generateAndDownloadPdf() async {
    try {
      final filter = _buildFilter();
      final pdfData = await _ticketProvider.getPdfData(filter: filter);
      final pdf = pw.Document();

      // Cover page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            final isAllAgencies = _selectedAgencyId == null;
            final agencyName = isAllAgencies
                ? 'All Agencies'
                : (_agencyResult?.result
                        .firstWhere((a) => a.id == _selectedAgencyId)
                        .name ??
                    '');
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('Payment Report',
                      style: pw.TextStyle(
                          fontSize: 32, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Text('Year: $selectedYear',
                      style: const pw.TextStyle(fontSize: 18)),
                  pw.Text('Agency: $agencyName',
                      style: const pw.TextStyle(fontSize: 18)),
                  pw.SizedBox(height: 50),
                  pw.Text(
                      'Generated on: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
                      style: const pw.TextStyle(
                          fontSize: 12, color: PdfColors.grey)),
                ],
              ),
            );
          },
        ),
      );

      // Payment details per line
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            final headers = [
              'Line / Route',
              'Seats',
              'Tickets Sold',
              'Income (BAM)',
              'Expense (BAM)',
              'Profit (BAM)'
            ];
            final dataRows = pdfData.map((item) {
              return [
                item.name ?? 'Unknown',
                busSeats[item.busType] ?? '',
                item.ticketsSold?.toString() ?? '0',
                item.income?.toStringAsFixed(2) ?? '0.00',
                item.expense?.toStringAsFixed(2) ?? '0.00',
                item.profit?.toStringAsFixed(2) ?? '0.00',
              ];
            }).toList();

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                    _selectedAgencyId == null
                        ? 'Payment Details (All Agencies)'
                        : 'Payment Details',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  border: null,
                  headers: headers,
                  data: dataRows,
                  headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellHeight: 30,
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.centerRight,
                    2: pw.Alignment.centerRight,
                    3: pw.Alignment.centerRight,
                    4: pw.Alignment.centerRight,
                  },
                ),
              ],
            );
          },
        ),
      );

      final Uint8List pdfFile = await pdf.save();
      final outputDir = await getTemporaryDirectory();
      final outputFile = File('${outputDir.path}/report.pdf');
      await outputFile.writeAsBytes(pdfFile);

      await OpenFile.open(outputFile.path);
      await FileSaver.instance.saveFile('Report', pdfFile, 'pdf');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    }
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: 8),
          Expanded(
            child: DropdownButton<int>(
              value: _selectedAgencyId,
              hint: Text('Select agency'),
              onChanged: (value) {
                _onAgencySelected(value);
              },
              items: [
                DropdownMenuItem<int>(
                  value: null,
                  child: Text('All agencies'),
                ),
                ...?_agencyResult?.result?.map((item) {
                  return DropdownMenuItem<int>(
                    value: item.id,
                    child: Text(item.name ?? ""),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: selectedYear,
              hint: Text('Select year'),
              onChanged: (newValue) async {
                setState(() {
                  selectedYear = newValue;
                });

                if (_selectedAgencyId == null) {
                  var filter = _buildFilter();
                  final agencyProfits = await _ticketProvider
                      .getAgencyProfitReport(filter: filter);
                  setState(() {
                    _agencyProfits = agencyProfits;
                  });
                } else {
                  _onAgencySelected(_selectedAgencyId);
                }
              },
              items: dropdownItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item.value.toString(),
                  child: Text(item.displayText),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Map<int, String> busSeats = {
    1: "10-20 seats", // Mini
    2: "21-35 seats", // Midi
    3: "36-50 seats", // Standard
    4: "51+ seats", // Luxury
  };

  Widget _buildBusTypeCheckboxes() {
    return Wrap(
      spacing: 8,
      children: busTypes.map((bus) {
        return Tooltip(
          message: busSeats[bus.value] ?? "",
          child: FilterChip(
            label: Text(bus.displayText),
            selected: selectedBusTypes.contains(bus.value),
            onSelected: (selected) async {
              setState(() {
                if (selected) {
                  selectedBusTypes.add(bus.value);
                } else {
                  selectedBusTypes.remove(bus.value);
                }
              });

              // ponovo učitaj podatke (agencije ili rute zavisno šta je odabrano)
              await _onAgencySelected(_selectedAgencyId);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDownloadButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.download),
        label: const Text("Download PDF"),
        onPressed: _generateAndDownloadPdf,
      ),
    );
  }

  Widget _buildChart() {
    final isAgencyChart = _selectedAgencyId == null;
    final dataList = isAgencyChart ? _agencyProfits : _routeProfits;

    if (dataList.isEmpty) {
      return const Center(child: Text("No available data"));
    }
    final barWidth = dataList.length < 4 ? 32 : 18;
    final groupSpace = dataList.length < 4 ? 32 : 16;

    final barGroups = dataList.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final value = isAgencyChart
          ? (item as AgencyProfitReportModel).totalProfit ?? 0
          : (item as RouteProfitReportModel).totalProfit ?? 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: isAgencyChart ? Colors.blue : Colors.green,
            width: barWidth.toDouble(),
            borderRadius: BorderRadius.circular(4),
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    final maxY = dataList
            .map((e) => isAgencyChart
                ? (e as AgencyProfitReportModel).totalProfit ?? 0
                : (e as RouteProfitReportModel).totalProfit ?? 0)
            .fold<double>(0, (prev, el) => el > prev ? el : prev) +
        20;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: BarChart(
        BarChartData(
          maxY: (maxY < 10) ? 10 : maxY * 1.2,
          barGroups: barGroups,
          groupsSpace: groupSpace.toDouble(),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true, drawHorizontalLine: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  final name = index >= 0 && index < dataList.length
                      ? (isAgencyChart
                          ? (dataList[index] as AgencyProfitReportModel)
                                  .agencyName ??
                              ''
                          : (dataList[index] as RouteProfitReportModel)
                                  .routeName ??
                              '')
                      : '';
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: Transform.rotate(
                      angle: -0.5,
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          name,
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.grey.shade700,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final value = rod.toY.toStringAsFixed(2);
                final label = isAgencyChart
                    ? (_agencyProfits[group.x.toInt()].agencyName ?? '')
                    : (_routeProfits[group.x.toInt()].routeName ?? '');
                return BarTooltipItem(
                  '$label\n$value BAM',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails() {
    if (_selectedAgencyId == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Profit by agencies",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._agencyProfits.map((a) => Text(
              "${a.agencyName}: ${a.totalProfit?.toStringAsFixed(2) ?? '0'} BAM")),
        ],
      );
    } else {
      final agencyName = _agencyResult?.result
              .firstWhere((a) => a.id == _selectedAgencyId)
              .name ??
          '';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profit by routes for agency: $agencyName",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._routeProfits.map((r) => Text(
              "${r.routeName}: ${r.totalProfit?.toStringAsFixed(2) ?? '0'} BAM")),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Report"),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdown(),
            const SizedBox(height: 8),
            _buildBusTypeCheckboxes(),
            const SizedBox(height: 8),
            _buildDownloadButton(),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, // <<< bitno
                children: [
                  Expanded(child: _buildChart()),
                  const SizedBox(height: 12),
                  _buildDetails(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownItem {
  final int value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}
