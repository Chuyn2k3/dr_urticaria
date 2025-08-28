import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'acute_urticaria_form_screen.dart';
import 'chronic_urticaria_initial_form_screen.dart';
import 'chronic_urticaria_followup_form_screen.dart';

class UrticariaFormSelectorScreen extends StatefulWidget {
  const UrticariaFormSelectorScreen({Key? key}) : super(key: key);

  @override
  State<UrticariaFormSelectorScreen> createState() =>
      _UrticariaFormSelectorScreenState();
}

class _UrticariaFormSelectorScreenState
    extends State<UrticariaFormSelectorScreen> {
  int _currentStep = 0;
  String? _duration;
  String? _previousTreatment;
  String? _formType;

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  void _navigateToForm() {
    Widget targetScreen;

    switch (_formType) {
      case 'acute':
        targetScreen = const AcuteUrticariaFormScreen();
        break;
      case 'chronic_initial':
        targetScreen = const ChronicUrticariaInitialFormScreen();
        break;
      case 'chronic_followup':
        targetScreen = const ChronicUrticariaInitialFormScreen();
        //ChronicUrticariaFollowupFormScreen();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  Widget _previousButton(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(99),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _previousButton(
                () => GoRouter.of(context).pop(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.local_hospital,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Bệnh viện Da liễu',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Hệ thống bệnh án điện tử',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: IntrinsicHeight(child: _buildStepContent())),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildWelcomeStep();
      case 1:
        return _buildDurationStep();
      case 2:
        return _buildTreatmentStep();
      case 3:
        return _buildResultStep();
      default:
        return _buildWelcomeStep();
    }
  }

  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Icon(
            Icons.assignment,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          const Text(
            'Chào mừng bạn đến với\nHệ thống bệnh án mày đay',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chúng tôi sẽ hướng dẫn bạn chọn loại bệnh án phù hợp\nthông qua một vài câu hỏi đơn giản',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Bắt đầu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Icon(
            Icons.schedule,
            size: 80,
            color: Colors.orange,
          ),
          const SizedBox(height: 24),
          const Text(
            'Thời gian bị bệnh',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bạn đã bị mày đay trong bao lâu?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          _buildOptionCard(
            'Dưới 6 tuần',
            'Triệu chứng xuất hiện gần đây',
            Icons.access_time,
            Colors.green,
            () => setState(() => _duration = 'under_6_weeks'),
            _duration == 'under_6_weeks',
          ),
          const SizedBox(height: 16),
          _buildOptionCard(
            'Từ 6 tuần trở lên',
            'Triệu chứng kéo dài hoặc tái phát',
            Icons.history,
            Colors.orange,
            () => setState(() => _duration = 'over_6_weeks'),
            _duration == 'over_6_weeks',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Quay lại'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _duration != null ? _nextStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tiếp theo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentStep() {
    if (_duration == 'under_6_weeks') {
      // Nếu dưới 6 tuần -> form cấp tính
      setState(() => _formType = 'acute');
      WidgetsBinding.instance.addPostFrameCallback((_) => _nextStep());
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Icon(
            Icons.medical_services,
            size: 80,
            color: Colors.purple,
          ),
          const SizedBox(height: 24),
          const Text(
            'Lịch sử điều trị',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bạn đã từng được điều trị mày đay tại bệnh viện chúng tôi chưa?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          _buildOptionCard(
            'Chưa từng điều trị',
            'Lần đầu tiên đến khám',
            Icons.person_add,
            Colors.blue,
            () => setState(() => _previousTreatment = 'first_time'),
            _previousTreatment == 'first_time',
          ),
          const SizedBox(height: 16),
          _buildOptionCard(
            'Đã từng điều trị',
            'Đến tái khám hoặc theo dõi',
            Icons.history,
            Colors.orange,
            () => setState(() => _previousTreatment = 'follow_up'),
            _previousTreatment == 'follow_up',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Quay lại'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _previousTreatment != null
                      ? () {
                          if (_previousTreatment == 'first_time') {
                            setState(() => _formType = 'chronic_initial');
                          } else {
                            setState(() => _formType = 'chronic_followup');
                          }
                          _nextStep();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tiếp theo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultStep() {
    String formTitle = '';
    String formDescription = '';
    Color formColor = Colors.blue;
    IconData formIcon = Icons.assignment;

    switch (_formType) {
      case 'acute':
        formTitle = 'Bệnh án cấp tính';
        formDescription = 'Dành cho bệnh nhân mới mắc bệnh (dưới 6 tuần)';
        formColor = Colors.green;
        formIcon = Icons.flash_on;
        break;
      case 'chronic_initial':
        formTitle = 'Bệnh án mãn tính lần 1';
        formDescription = 'Dành cho bệnh nhân mãn tính lần đầu khám';
        formColor = Colors.blue;
        formIcon = Icons.assignment_ind;
        break;
      case 'chronic_followup':
        formTitle = 'Bệnh án tái khám';
        formDescription = 'Dành cho bệnh nhân đã từng điều trị';
        formColor = Colors.orange;
        formIcon = Icons.assignment_returned;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Icon(
            formIcon,
            size: 80,
            color: formColor,
          ),
          const SizedBox(height: 24),
          const Text(
            'Loại bệnh án phù hợp',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: formColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: formColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  formIcon,
                  size: 48,
                  color: formColor,
                ),
                const SizedBox(height: 16),
                Text(
                  formTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: formColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _currentStep = 0;
                    _duration = null;
                    _previousTreatment = null;
                    _formType = null;
                  }),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Làm lại'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _navigateToForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: formColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Bắt đầu điền form'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
