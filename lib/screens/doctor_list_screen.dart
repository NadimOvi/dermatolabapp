import 'package:flutter/material.dart';
import '../models/detection_result.dart';
import '../models/doctor_info.dart';
import '../repositories/location_repository.dart';
import '../widgets/doctor_card.dart';
import '../utils/constants.dart';

class DoctorListScreen extends StatefulWidget {
  final DetectionResult detectionResult;

  const DoctorListScreen({
    super.key,
    required this.detectionResult,
  });

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final LocationRepository _locationRepository = LocationRepository();
  List<DoctorInfo>? _doctors;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNearbyDoctors();
  }

  Future<void> _loadNearbyDoctors() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final doctors = await _locationRepository.findNearbyDoctors();
      setState(() {
        _doctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.findDoctors),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: AppColors.errorColor),
                      const SizedBox(height: 16),
                      Text(_error!),
                      ElevatedButton(
                        onPressed: _loadNearbyDoctors,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _doctors == null || _doctors!.isEmpty
                  ? const Center(child: Text('No dermatologists found nearby'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                      itemCount: _doctors!.length,
                      itemBuilder: (context, index) {
                        return DoctorCard(doctor: _doctors![index]);
                      },
                    ),
    );
  }
}
