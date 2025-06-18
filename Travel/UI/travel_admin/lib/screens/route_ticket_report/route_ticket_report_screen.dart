import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_admin/model/agency/agency.dart';
import 'package:travel_admin/model/route_ticket/agency_profit_report.dart';
import 'package:travel_admin/model/route_ticket/route_profit_report.dart';
import 'package:travel_admin/model/search_result.dart';
import 'package:travel_admin/providers/agency_provider.dart';
import 'package:travel_admin/providers/route_ticket.dart';
import 'package:travel_admin/screens/users/user_list_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _ticketProvider = context.read<RouteTicketProvider>();
    _agencyProvider = context.read<AgencyProvider>();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final agencies = await _agencyProvider.get();
    final agencyProfits = await _ticketProvider.getAgencyProfitReport();
    setState(() {
      _agencyResult = agencies;
      _agencyProfits = agencyProfits;
      selectedYear = "2025";
    });
  }

  Future<void> _onAgencySelected(int agencyId) async {
    final routeProfits = await _ticketProvider.getRouteProfitReport(agencyId);
    setState(() {
      _selectedAgencyId = agencyId;
      _routeProfits = routeProfits;
    });
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: DropdownButton<int>(
              value: _selectedAgencyId,
              hint: Text('Select agency'),
              onChanged: (value) {
                if (value != null) _onAgencySelected(value);
              },
              items: [
                DropdownMenuItem<int>(
                  value: null, // Use null value for "All" option
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
              onChanged: (newValue) async {},
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

  Widget _buildChart() {
    final isAgencyChart = _selectedAgencyId == null;
    final dataList = isAgencyChart ? _agencyProfits : _routeProfits;

    if (dataList.isEmpty) {
      return const Center(child: Text("Nema dostupnih podataka"));
    }

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
            width: 18,
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
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: barGroups,
          groupsSpace: 16,
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
                        width: 60,
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
                  '$label\n$value KM',
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
          const Text("Profit po svim agencijama",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._agencyProfits.map((a) => Text(
              "${a.agencyName}: ${a.totalProfit?.toStringAsFixed(2) ?? '0'} KM")),
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
          Text("Profit po rutama za agenciju: $agencyName",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._routeProfits.map((r) => Text(
              "${r.routeName}: ${r.totalProfit?.toStringAsFixed(2) ?? '0'} KM")),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profit po agencijama")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdown(),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
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
