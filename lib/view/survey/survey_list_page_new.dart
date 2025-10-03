import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/theme/theme.dart';
import '../../controller/survey_controller.dart';
import '../../model/survey_model.dart';
import 'add_survey_page.dart';

class SurveyListPage extends StatefulWidget {
  final String surveyorId;

  const SurveyListPage({
    Key? key,
    required this.surveyorId,
  }) : super(key: key);

  @override
  State<SurveyListPage> createState() => _SurveyListPageState();
}

class _SurveyListPageState extends State<SurveyListPage> {
  final _surveyController = Get.put(SurveyController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSurveys();
    });
  }

  Future<void> _loadSurveys() async {
    await _surveyController.fetchSurveys(widget.surveyorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Citizen Surveys', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadSurveys,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadSurveys,
        child: Obx(() {
          if (_surveyController.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading surveys...'),
                ],
              ),
            );
          }

          if (_surveyController.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _surveyController.errorMessage.value,
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadSurveys,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }

          if (_surveyController.surveys.isEmpty) {
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.note_alt_outlined,
                          size: 48,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No surveys yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to add your first survey',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                RefreshIndicator(onRefresh: _loadSurveys, child: ListView()),
              ],
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _surveyController.surveys.length,
            itemBuilder: (context, index) {
              final survey = _surveyController.surveys[index];
              return _buildSurveyCard(survey);
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        onPressed: () => Get.to(() => const AddSurveyPage()),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Survey', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSurveyCard(SurveyModel survey) {
    final loc = survey.location;
    final locationLines = [
      if (loc.district.isNotEmpty) 'District: ${loc.district}',
      if (loc.block.isNotEmpty) 'Block: ${loc.block}',
      if (loc.gpWard.isNotEmpty) 'GP/Ward: ${loc.gpWard}',
      if (loc.villageStreet.isNotEmpty) 'Village/Street: ${loc.villageStreet}',
      if (loc.state.isNotEmpty) 'State: ${loc.state}',
      'Coordinates: ${loc.latitude.toStringAsFixed(6)}, ${loc.longitude.toStringAsFixed(6)}',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      survey.citizenName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildStatusChip(survey.status),
                ],
              ),
              const SizedBox(height: 8),
              Text('Phone: ${survey.phoneNumber}', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  survey.category,
                  style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ),
            ]),
          ),
          if (survey.attachmentUrls.isNotEmpty)
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: survey.attachmentUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.dialog(
                        Dialog(
                          backgroundColor: Colors.transparent,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              InteractiveViewer(
                                child: Image.network(
                                  survey.attachmentUrls[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Get.back()),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(image: NetworkImage(survey.attachmentUrls[index]), fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_rounded, size: 16, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: locationLines.map((line) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(line, style: TextStyle(color: AppColors.textSecondary)),
                    )).toList(),
                  ),
                ),
                Text(
                  DateFormat('MMM d, y').format(survey.createdAt),
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'reviewed':
        color = Colors.blue;
        break;
      case 'resolved':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
