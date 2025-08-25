import 'package:json_annotation/json_annotation.dart';

part 'chronic_urticaria_initial_record.g.dart';

// @JsonSerializable()
// class ChronicUrticariaInitialRecord {
//   // Thông tin cơ bản của bệnh nhân
//   String? fullName; // Họ và tên
//   String? nationalId; // Số căn cước
//   String? age; // Tuổi (có thể ghi tháng nếu < 6 tuổi)
//   String? gender; // Giới tính (0: Nam, 1: Nữ)
//   String? phoneNumber; // Số điện thoại
//   String? addressArea; // Khu vực (Thành thị, Nông thôn,...)
//   String? occupation; // Nghề nghiệp
//   String? exposureHistory; // Tiền sử tiếp xúc
//   String? recordOpenDate; // Ngày mở hồ sơ
//   String? examinationDate; // Ngày khám

//   // Bệnh án mạn tính lần 1 - phần chung
//   String? continuousOutbreak6Weeks; // Đợt bệnh ≥ 6 tuần
//   String? rashOrAngioedema; // Loại tổn thương: Sẩn phù, Phù mạch,...
//   String? firstOutbreakSinceWeeks; // Lần đầu tổn thương từ bao nhiêu tuần
//   String? outbreakCount; // Số đợt bị mày đay (≥ 2 lần/tuần)

//   // Đợt 1
//   String? outbreak1StartMonth;
//   String? outbreak1StartYear;
//   String? outbreak1EndMonth;
//   String? outbreak1EndYear;
//   String? outbreak1TreatmentReceived;
//   String? outbreak1DrugResponse;
//   String? outbreak1DrugResponseSymptom;

//   // Đợt 2
//   String? outbreak2StartMonth;
//   String? outbreak2StartYear;
//   String? outbreak2EndMonth;
//   String? outbreak2EndYear;
//   String? outbreak2TreatmentReceived;
//   String? outbreak2DrugResponse;
//   String? outbreak2DrugResponseSymptom;

//   // Đợt 3
//   String? outbreak3StartMonth;
//   String? outbreak3StartYear;
//   String? outbreak3EndMonth;
//   String? outbreak3EndYear;
//   String? outbreak3TreatmentReceived;
//   String? outbreak3DrugResponse;
//   String? outbreak3DrugResponseSymptom;

//   // Đợt hiện tại
//   String? currentOutbreakStartMonth;
//   String? currentOutbreakStartYear;
//   String? currentOutbreakEndMonth;
//   String? currentOutbreakEndYear;
//   String? currentOutbreakWeeks; // Tự động tính
//   String? currentTreatmentReceived;
//   String? currentDrugResponse;
//   String? currentDrugResponseSymptom;

//   String? drugName; // Tên thuốc đã dùng
//   String? drugDuration; // Thời gian dùng thuốc
//   String? drugDosage; // Liều dùng thuốc

//   // Sẩn phù
//   String? rashAppearanceTime; // Thời điểm nốt đỏ xuất hiện
//   List<String>?
//       rashTriggerFactors; // Yếu tố kích thích nốt đỏ (multiple choice)
//   List<String>? rashWorseningFactors; // Yếu tố làm nặng bệnh (multiple choice)
//   String? rashFoodTriggerDetail; // Chi tiết thức ăn gây nặng
//   String? rashDrugTriggerDetail; // Chi tiết thuốc gây nặng
//   List<String>? rashLocation; // Vị trí nốt đỏ (multiple choice)
//   Map<String, List<String>>? rashLocationImages; // Ảnh theo từng vị trí
//   String? rashSizeOnTreatment; // Kích thước nốt đỏ khi dùng thuốc
//   String? rashSizeNoTreatment; // Kích thước nốt đỏ khi không dùng thuốc
//   String? rashBorder; // Ranh giới nốt đỏ
//   String? rashShape; // Hình dạng nốt đỏ
//   String? rashColor; // Màu sắc nốt đỏ
//   String? rashDurationOnTreatment; // Thời gian tồn tại nốt đỏ khi dùng thuốc
//   String? rashDurationNoTreatment; // Thời gian tồn tại khi không dùng thuốc
//   List<String>? rashSurface; // Đặc điểm bề mặt (multiple choice)
//   String? rashTimeOfDay; // Thời gian trong ngày nốt đỏ xuất hiện
//   String? rashCountPerDay; // Số lượng nốt đỏ trung bình/ngày
//   String? rashSensation; // Cảm giác tại vị trí nốt đỏ

//   // Phù mạch
//   String? angioedemaCount; // Số lần sưng phù
//   List<String>? angioedemaLocation; // Vị trí sưng phù (multiple choice)
//   Map<String, List<String>>? angioedemaLocationImages; // Ảnh theo từng vị trí
//   List<String>? angioedemaSurface; // Đặc điểm bề mặt phù mạch (multiple choice)
//   String? angioedemaDurationOnTreatment; // Thời gian tồn tại khi dùng thuốc
//   String?
//       angioedemaDurationNoTreatment; // Thời gian tồn tại khi không dùng thuốc
//   String? angioedemaTimeOfDay; // Thời gian xuất hiện phù mạch trong ngày
//   String? angioedemaSensation; // Cảm giác tại vị trí phù mạch

//   // Câu hỏi chung sau sẩn phù & phù mạch
//   String? emergencyVisitHistory; // Từng khám cấp cứu/nằm viện
//   String? breathingDifficultyHistory; // Từng khó thở trong đợt bệnh này chưa

//   // Tiền sử - bệnh sử
//   String? pastOutbreakHistory; // Bệnh sử các đợt trước đây
//   String? previousTreatment; // Đã từng điều trị trước đó
//   String? previousTreatmentDetails; // Chi tiết thuốc, liều, đáp ứng
//   String? personalAtopyHistory; // Tiền sử mắc bệnh lý cơ địa (cá nhân)
//   String? personalThyroidDiseaseHistory; // Tiền sử bệnh tuyến giáp
//   String? personalAutoimmuneHistory; // Tiền sử bệnh tự miễn
//   String? personalOtherDiseaseHistory; // Tiền sử bệnh lý khác
//   String? personalDrugFoodAllergyHistory; // Tiền sử dị ứng thuốc/ thức ăn
//   String? personalAnaphylaxisHistory; // Tiền sử phản vệ
//   String? familyChronicUrticariaHistory; // Tiền sử gia đình mắc mày đay
//   String? familyAtopyHistory; // Tiền sử gia đình mắc bệnh lý cơ địa
//   String? familyAutoimmuneHistory; // Tiền sử gia đình mắc bệnh tự miễn
//   String? familyHistoryDetail; // Chi tiết bệnh gia đình

//   // Khám thực thể
//   String? fever; // Có sốt hay không
//   String? feverTemperature; // Nhiệt độ khi sốt
//   String? pulseRate; // Mạch (lần/phút)
//   String? bloodPressure; // Huyết áp (mmHg)
//   String? organAbnormality; // Có bất thường cơ quan
//   String? organAbnormalityDetail; // Mô tả chi tiết

//   // Chuẩn đoán sơ bộ
//   String? preliminaryDiagnosis;

//   // Kết quả test
//   String? dermatographismTest;
//   String? fricScore;
//   String? itchScoreNRS;
//   String? painScoreNRS;
//   String? burningScoreNRS;

//   String? coldUrticariaTemptest;
//   String? positiveTemperature;
//   String? itchScoreNRSCold;
//   String? painScoreNRSCold;
//   String? burningScoreNRSCold;

//   String? coldUrticariaIceTest;
//   String? timeThreshold;
//   String? itchScoreNRSIce;
//   String? painScoreNRSIce;
//   String? burningScoreNRSIce;

//   String? cholinergicUrticariaTest;
//   String? lesionAppearanceTime;
//   String? itchScoreNRSCholine;
//   String? painScoreNRSCholine;
//   String? burningScoreNRSCholine;

//   String? cusiScore;
//   String? otherCause;
//   String? uctScore;
//   String? actScore;

//   // Cận lâm sàng
//   String? wbc;
//   String? eo;
//   String? ba;
//   String? crp;
//   String? esr;
//   String? ft3;
//   String? ft4;
//   String? tsh;
//   String? totalIgE;
//   String? antiTPO;
//   String? anaHep2;
//   String? depositionPattern;
//   String? thyroidUltrasound;
//   String? autologousSerumSkinTest;
//   String? whealDiameter;
//   String? otherLabTests;

//   // Chẩn đoán xác định
//   String? finalDiagnosis;

//   // Điều trị
//   String? treatmentMedications;

//   // Hẹn khám lại
//   String? followUpDate;

//   ChronicUrticariaInitialRecord();

//   factory ChronicUrticariaInitialRecord.fromJson(Map<String, dynamic> json) =>
//       _$ChronicUrticariaInitialRecordFromJson(json);

//   Map<String, dynamic> toJson() => _$ChronicUrticariaInitialRecordToJson(this);
// }

@JsonSerializable(explicitToJson: true)
class ChronicUrticariaInitialRecord {
  int? patientId;
  String? symptoms;
  String? notes;

  PersonalInfo? personalInfo;
  GeneralInfo? generalInfo;
  Rash? rash;
  Angioedema? angioedema;
  MedicalHistory? medicalHistory;
  PhysicalExam? physicalExam;
  DiseasedHistory? diseasedHistory;
  Diagnosis? diagnosis;
  Treatment? treatment;

  ChronicUrticariaInitialRecord();

  factory ChronicUrticariaInitialRecord.fromJson(Map<String, dynamic> json) =>
      _$ChronicUrticariaInitialRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ChronicUrticariaInitialRecordToJson(this);
}

@JsonSerializable()
class PersonalInfo {
  String? fullName;
  String? nationalId;
  String? age;
  int? gender; // 0 = Nam, 1 = Nữ
  String? phoneNumber;
  String? addressArea;
  String? occupation;
  String? exposureHistory;
  String? recordOpenDate;
  String? examinationDate;

  PersonalInfo();

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalInfoToJson(this);
}

@JsonSerializable()
class GeneralInfo {
  bool? continuousOutbreak6Weeks;
  String? rashOrAngioedema;
  int? firstOutbreakSinceWeeks;
  int? outbreakCount;
  // Đợt 1
  String? outbreak1StartMonth;
  String? outbreak1StartYear;
  String? outbreak1EndMonth;
  String? outbreak1EndYear;
  String? outbreak1TreatmentReceived;
  String? outbreak1DrugResponse;
  String? outbreak1DrugResponseSymptom;

  // Đợt 2
  String? outbreak2StartMonth;
  String? outbreak2StartYear;
  String? outbreak2EndMonth;
  String? outbreak2EndYear;
  String? outbreak2TreatmentReceived;
  String? outbreak2DrugResponse;
  String? outbreak2DrugResponseSymptom;

  // Đợt 3
  String? outbreak3StartMonth;
  String? outbreak3StartYear;
  String? outbreak3EndMonth;
  String? outbreak3EndYear;
  String? outbreak3TreatmentReceived;
  String? outbreak3DrugResponse;
  String? outbreak3DrugResponseSymptom;

  // Đợt hiện tại
  String? currentOutbreakStartMonth;
  String? currentOutbreakStartYear;
  String? currentOutbreakEndMonth;
  String? currentOutbreakEndYear;
  String? currentOutbreakWeeks; // Tự động tính
  String? currentTreatmentReceived;
  String? currentDrugResponse;
  String? currentDrugResponseSymptom;

  String? drugName; // Tên thuốc đã dùng
  String? drugDuration; // Thời gian dùng thuốc
  String? drugDosage; // Liều dùng thuốc

  GeneralInfo();

  factory GeneralInfo.fromJson(Map<String, dynamic> json) =>
      _$GeneralInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralInfoToJson(this);
}

@JsonSerializable()
class Rash {
  //   // Sẩn phù
//   String? rashAppearanceTime; // Thời điểm nốt đỏ xuất hiện
//   List<String>?
//       rashTriggerFactors; // Yếu tố kích thích nốt đỏ (multiple choice)
//   List<String>? rashWorseningFactors; // Yếu tố làm nặng bệnh (multiple choice)
//   String? rashFoodTriggerDetail; // Chi tiết thức ăn gây nặng
//   String? rashDrugTriggerDetail; // Chi tiết thuốc gây nặng
//   List<String>? rashLocation; // Vị trí nốt đỏ (multiple choice)
//   Map<String, List<String>>? rashLocationImages; // Ảnh theo từng vị trí
//   String? rashSizeOnTreatment; // Kích thước nốt đỏ khi dùng thuốc
//   String? rashSizeNoTreatment; // Kích thước nốt đỏ khi không dùng thuốc
//   String? rashBorder; // Ranh giới nốt đỏ
//   String? rashShape; // Hình dạng nốt đỏ
//   String? rashColor; // Màu sắc nốt đỏ
//   String? rashDurationOnTreatment; // Thời gian tồn tại nốt đỏ khi dùng thuốc
//   String? rashDurationNoTreatment; // Thời gian tồn tại khi không dùng thuốc
//   List<String>? rashSurface; // Đặc điểm bề mặt (multiple choice)
//   String? rashTimeOfDay; // Thời gian trong ngày nốt đỏ xuất hiện
//   String? rashCountPerDay; // Số lượng nốt đỏ trung bình/ngày
//   String? rashSensation; // Cảm giác tại vị trí nốt đỏ
  String? rashAppearanceTime;
  List<String>? rashTriggerFactors;
  List<String>? rashWorseningFactors;
  String? rashFoodTriggerDetail;
  String? rashDrugTriggerDetail;
  List<String>? rashLocation;
  Map<String, List<String>>? rashLocationImages;
  String? rashSizeOnTreatment;
  String? rashSizeNoTreatment;
  String? rashBorder;
  String? rashShape;
  String? rashColor;
  String? rashDurationOnTreatment;
  String? rashDurationNoTreatment;
  List<String>? rashSurface;
  String? rashTimeOfDay;
  String? rashCountPerDay;
  String? rashSensation;

  Rash();

  factory Rash.fromJson(Map<String, dynamic> json) => _$RashFromJson(json);
  Map<String, dynamic> toJson() => _$RashToJson(this);
}

@JsonSerializable()
class Angioedema {
  //   // Phù mạch
//   String? angioedemaCount; // Số lần sưng phù
//   List<String>? angioedemaLocation; // Vị trí sưng phù (multiple choice)
//   Map<String, List<String>>? angioedemaLocationImages; // Ảnh theo từng vị trí
//   List<String>? angioedemaSurface; // Đặc điểm bề mặt phù mạch (multiple choice)
//   String? angioedemaDurationOnTreatment; // Thời gian tồn tại khi dùng thuốc
//   String?
//       angioedemaDurationNoTreatment; // Thời gian tồn tại khi không dùng thuốc
//   String? angioedemaTimeOfDay; // Thời gian xuất hiện phù mạch trong ngày
//   String? angioedemaSensation; // Cảm giác tại vị trí phù mạch

  int? angioedemaCount;
  List<String>? angioedemaLocation;
  Map<String, List<String>>? angioedemaLocationImages;
  List<String>? angioedemaSurface;
  String? angioedemaDurationOnTreatment;
  String? angioedemaDurationNoTreatment;
  String? angioedemaTimeOfDay;
  String? angioedemaSensation;

  Angioedema();

  factory Angioedema.fromJson(Map<String, dynamic> json) =>
      _$AngioedemaFromJson(json);
  Map<String, dynamic> toJson() => _$AngioedemaToJson(this);
}

@JsonSerializable()
class DiseasedHistory {
//   // Câu hỏi chung sau sẩn phù & phù mạch
  String? emergencyVisitHistory; // Từng khám cấp cứu/nằm viện
  String? breathingDifficultyHistory; // Từng khó thở trong đợt bệnh này chưa

  DiseasedHistory();

  factory DiseasedHistory.fromJson(Map<String, dynamic> json) =>
      _$DiseasedHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$DiseasedHistoryToJson(this);
}

//   // Câu hỏi chung sau sẩn phù & phù mạch
//   String? emergencyVisitHistory; // Từng khám cấp cứu/nằm viện
//   String? breathingDifficultyHistory; // Từng khó thở trong đợt bệnh này chưa
@JsonSerializable()
class MedicalHistory {
//   // Tiền sử - bệnh sử
  String? pastOutbreakHistory; // Bệnh sử các đợt trước đây
  String? previousTreatment; // Đã từng điều trị trước đó
  String? previousTreatmentDetails; // Chi tiết thuốc, liều, đáp ứng
  String? personalAtopyHistory; // Tiền sử mắc bệnh lý cơ địa (cá nhân)
  String? personalThyroidDiseaseHistory; // Tiền sử bệnh tuyến giáp
  String? personalAutoimmuneHistory; // Tiền sử bệnh tự miễn
  String? personalOtherDiseaseHistory; // Tiền sử bệnh lý khác
  String? personalDrugFoodAllergyHistory; // Tiền sử dị ứng thuốc/ thức ăn
  String? personalAnaphylaxisHistory; // Tiền sử phản vệ
  String? familyChronicUrticariaHistory; // Tiền sử gia đình mắc mày đay
  String? familyAtopyHistory; // Tiền sử gia đình mắc bệnh lý cơ địa
  String? familyAutoimmuneHistory; // Tiền sử gia đình mắc bệnh tự miễn
  String? familyHistoryDetail; // Chi tiết bệnh gia đình

  MedicalHistory();

  factory MedicalHistory.fromJson(Map<String, dynamic> json) =>
      _$MedicalHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalHistoryToJson(this);
}

@JsonSerializable()
class PhysicalExam {
  // Khám thực thể
  String? fever; // Có sốt hay không
  String? feverTemperature; // Nhiệt độ khi sốt
  String? pulseRate; // Mạch (lần/phút)
  String? bloodPressure; // Huyết áp (mmHg)
  String? organAbnormality; // Có bất thường cơ quan
  String? organAbnormalityDetail; // Mô tả chi tiết

  // Chuẩn đoán sơ bộ
  String? preliminaryDiagnosis;

  PhysicalExam();

  factory PhysicalExam.fromJson(Map<String, dynamic> json) =>
      _$PhysicalExamFromJson(json);
  Map<String, dynamic> toJson() => _$PhysicalExamToJson(this);
}

@JsonSerializable()
class Diagnosis {
  // Kết quả test
  String? dermatographismTest;
  String? fricScore;
  String? itchScoreNRS;
  String? painScoreNRS;
  String? burningScoreNRS;

  String? coldUrticariaTemptest;
  String? positiveTemperature;
  String? itchScoreNRSCold;
  String? painScoreNRSCold;
  String? burningScoreNRSCold;

  String? coldUrticariaIceTest;
  String? timeThreshold;
  String? itchScoreNRSIce;
  String? painScoreNRSIce;
  String? burningScoreNRSIce;

  String? cholinergicUrticariaTest;
  String? lesionAppearanceTime;
  String? itchScoreNRSCholine;
  String? painScoreNRSCholine;
  String? burningScoreNRSCholine;

  String? cusiScore;
  String? otherCause;
  String? uctScore;
  String? actScore;

  // Cận lâm sàng
  String? wbc;
  String? eo;
  String? ba;
  String? crp;
  String? esr;
  String? ft3;
  String? ft4;
  String? tsh;
  String? totalIgE;
  String? antiTPO;
  String? anaHep2;
  String? depositionPattern;
  String? thyroidUltrasound;
  String? autologousSerumSkinTest;
  String? whealDiameter;
  String? otherLabTests;

  // Chẩn đoán xác định
  String? finalDiagnosis;

  Diagnosis();

  factory Diagnosis.fromJson(Map<String, dynamic> json) =>
      _$DiagnosisFromJson(json);
  Map<String, dynamic> toJson() => _$DiagnosisToJson(this);
}

@JsonSerializable()
class Treatment {
  // Điều trị
  String? treatmentMedications;

  // Hẹn khám lại
  String? followUpDate;

  Treatment();

  factory Treatment.fromJson(Map<String, dynamic> json) =>
      _$TreatmentFromJson(json);
  Map<String, dynamic> toJson() => _$TreatmentToJson(this);
}
