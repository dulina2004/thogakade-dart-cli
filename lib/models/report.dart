class Report {
  static int _reportCounter = 0;

  final String reportID;
  final DateTime generatedDate;
  final Map<String, dynamic> summary;

  Report({
    String? reportID,
    DateTime? generatedDate,
    required this.summary,
  })  : reportID = reportID ?? _generateReportID(),
        generatedDate = generatedDate ?? DateTime.now();

  static String _generateReportID() {
    _reportCounter++;
    return 'R${_reportCounter.toString().padLeft(3, '0')}';
  }

  Map<String, dynamic> toJson() {
    return {
      'reportID': reportID,
      'generatedDate': generatedDate.toIso8601String(),
      'summary': summary,
    };
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportID: json['reportID'],
      generatedDate: DateTime.parse(json['generatedDate']),
      summary: Map<String, dynamic>.from(json['summary']),
    );
  }

  @override
  String toString() {
    return 'Report{id: $reportID, date: $generatedDate, summary: $summary}';
  }
}
