class UserExtendInfoModel {
  final int? id;
  final int? outstanding;
  final int? authorPoint;
  final int? authorLevel;
  final int? viewerPoint;
  final int? viewerLevel;
  final String? bankName;
  final String? bankNumber;
  final String? bankAccountHolderName;
  final String? identifyNumber;
  final String? identifyBack;
  final String? identifyFront;
  final String? identifyFace;
  final String? signatureImage;
  final String? introduce;
  final String? noti;
  final String? setting;
  final String? timeUpdate;
  final String? timeCreate;
  final int? r;
  final String? linkAffiliate;
  final int? clickTime;

  UserExtendInfoModel({
    this.id,
    this.outstanding,
    this.authorPoint,
    this.authorLevel,
    this.viewerPoint,
    this.viewerLevel,
    this.bankName,
    this.bankNumber,
    this.bankAccountHolderName,
    this.identifyNumber,
    this.identifyBack,
    this.identifyFront,
    this.identifyFace,
    this.signatureImage,
    this.introduce,
    this.noti,
    this.setting,
    this.timeUpdate,
    this.timeCreate,
    this.r,
    this.linkAffiliate,
    this.clickTime,
  });

  factory UserExtendInfoModel.fromJson(Map<String, dynamic> json) {
    return UserExtendInfoModel(
      id: json['id'],
      outstanding: json['outstanding'],
      authorPoint: json['author_point'],
      authorLevel: json['author_level'],
      viewerPoint: json['viewer_point'],
      viewerLevel: json['viewer_level'],
      bankName: json['bank_name'],
      bankNumber: json['bank_number'],
      bankAccountHolderName: json['bank_account_holder_name'],
      identifyNumber: json['identify_number'],
      identifyBack: json['identify_back'],
      identifyFront: json['identify_front'],
      identifyFace: json['identify_face'],
      signatureImage: json['signature_image'],
      introduce: json['introduce'],
      noti: json['noti'],
      setting: json['setting'],
      timeUpdate: json['time_update'],
      timeCreate: json['time_create'],
      r: json['r'],
      linkAffiliate: json['link_affiliate'],
      clickTime: json['click_time'],
    );
  }
}
