// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'شجرة العائلة';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'دخول';

  @override
  String get needAccount => 'ليس لديك حساب؟ سجل الآن';

  @override
  String get welcomeMessage => 'مرحباً بكم في عائلتكم';

  @override
  String get profileTitle => 'ملفي الشخصي';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get logoutLabel => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get accountInfoTitle => 'معلومات الحساب';

  @override
  String get loginError => 'خطأ في تسجيل الدخول';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get enterEmailHint => 'أدخل عنوان بريدك الإلكتروني';

  @override
  String get sendButton => 'إرسال';

  @override
  String get resetEmailSent => 'تم إرسال بريد إعادة التعيين';

  @override
  String get genericError => 'خطأ';

  @override
  String get loginSubtitle => 'سجل الدخول للوصول إلى شجرة عائلتك';

  @override
  String get enterEmailError => 'الرجاء إدخال بريدك الإلكتروني';

  @override
  String get invalidEmailError => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get enterPasswordError => 'الرجاء إدخال كلمة المرور';

  @override
  String get forgotPasswordButton => 'نسيت كلمة المرور؟';

  @override
  String get notYetAccount => 'ليس لديك حساب بعد؟';

  @override
  String get signupButton => 'تسجيل';

  @override
  String get registrationSuccess => 'تم التسجيل بنجاح! في انتظار التحقق.';

  @override
  String get registrationError => 'خطأ في التسجيل';

  @override
  String get registerTitle => 'تسجيل';

  @override
  String get createAccountTitle => 'إنشاء حساب';

  @override
  String get registerSubtitle =>
      'يجب التحقق من حسابك بواسطة مسؤول قبل أن تتمكن من الوصول إلى شجرة العائلة.';

  @override
  String get emailLabelRequired => 'البريد الإلكتروني *';

  @override
  String get phoneOptionalLabel => 'الهاتف (اختياري)';

  @override
  String get passwordLabelRequired => 'كلمة المرور *';

  @override
  String get enterPasswordErrorShort => 'الرجاء إدخال كلمة مرور';

  @override
  String get passwordLengthError =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور *';

  @override
  String get confirmPasswordError => 'الرجاء تأكيد كلمة المرور';

  @override
  String get passwordMismatchError => 'كلمات المرور غير متطابقة';

  @override
  String get adminApprovalInfo => 'بعد التسجيل، سيقوم مسؤول بالتحقق من حسابك.';

  @override
  String get alreadyAccount => 'لديك حساب بالفعل؟';

  @override
  String get pendingApprovalTitle => 'في انتظار التحقق';

  @override
  String get pendingApprovalMessage =>
      'تم إنشاء حسابك بنجاح.\n\nيجب أن يقوم مسؤول بالتحقق من تسجيلك قبل أن تتمكن من الوصول إلى شجرة العائلة.\n\nستتلقى إشعارًا بمجرد الموافقة على حسابك.';

  @override
  String get devBecomeAdmin => '(DEV) كن مسؤولاً';

  @override
  String get devAdminSuccess => 'أنت الآن مسؤول!';

  @override
  String get navTrees => 'الأشجار';

  @override
  String get navSearch => 'بحث';

  @override
  String get navEvents => 'الأحداث';

  @override
  String get navProfile => 'البيانات';

  @override
  String get myFamilyTrees => 'أشجار عائلتي';

  @override
  String get newTree => 'شجرة جديدة';

  @override
  String get noFamilyTree => 'لا توجد شجرة عائلة';

  @override
  String get createFirstTree => 'أنشئ شجرتك الأولى للبدء';

  @override
  String get createTreeButton => 'إنشاء شجرة';

  @override
  String get membersCount => 'أعضاء';

  @override
  String get editAction => 'تعديل';

  @override
  String get deleteAction => 'حذف';

  @override
  String get deleteTreeTitle => 'حذف الشجرة';

  @override
  String deleteTreeConfirmation(Object name) {
    return 'هل أنت متأكد أنك تريد حذف \"$name\" وجميع أعضائها؟\n\nهذا الإجراء لا يمكن التراجع عنه.';
  }

  @override
  String get treeDeleted => 'تم حذف الشجرة';

  @override
  String get deleteError => 'خطأ أثناء الحذف';

  @override
  String get editTreeTitle => 'تعديل الشجرة';

  @override
  String get newTreeTitle => 'شجرة جديدة';

  @override
  String get treeNameLabel => 'اسم الشجرة *';

  @override
  String get treeNameHint => 'مثال: عائلة شريف';

  @override
  String get enterNameError => 'الرجاء إدخال اسم';

  @override
  String get nameLengthError => 'يجب أن يحتوي الاسم على حرفين على الأقل';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get descriptionHint => 'مثال: شجرة الجانب الأبوي';

  @override
  String get saveButton => 'حفظ';

  @override
  String get createTreeAction => 'إنشاء الشجرة';

  @override
  String treeExpanded(Object count) {
    return '$count أفراد';
  }

  @override
  String get treeCollapsed => 'إغلاق';

  @override
  String get adminTitle => 'الإدارة';

  @override
  String get adminPanel => 'لوحة المشرف';

  @override
  String get statisticsTitle => 'الإحصائيات';

  @override
  String get quickActionsTitle => 'إجراءات سريعة';

  @override
  String get manageUsersAction => 'إدارة المستخدمين';

  @override
  String get manageUsersSubtitle => 'التحقق من التسجيلات، تعيين المشرفين';

  @override
  String get manageTreesAction => 'إدارة الأشجار';

  @override
  String get manageTreesSubtitle => 'إنشاء شجرة وإضافة أعضاء';

  @override
  String get createEventAction => 'إنشاء حدث';

  @override
  String get createEventSubtitle => 'الإعلان عن زفاف، ولادة أو اجتماع';

  @override
  String get membersStat => 'الأعضاء';

  @override
  String get eventsStat => 'الأحداث';

  @override
  String get pendingTab => 'قيد الانتظار';

  @override
  String get approvedTab => 'الموافق عليهم';

  @override
  String get noPendingRequests => 'لا توجد طلبات معلقة';

  @override
  String get noApprovedUsers => 'لا يوجد مستخدمين موافق عليهم';

  @override
  String get approveAction => 'موافقة';

  @override
  String get rejectAction => 'رفض';

  @override
  String get confirmRejectTitle => 'تأكيد الرفض';

  @override
  String confirmRejectMessage(Object email) {
    return 'هل تريد حقًا رفض وحذف طلب $email؟';
  }

  @override
  String userApprovedMessage(Object email) {
    return 'تمت الموافقة على $email';
  }

  @override
  String get requestRejectedMessage => 'تم رفض الطلب';

  @override
  String roleChangedMessage(Object email, Object role) {
    return '$email أصبح الآن $role';
  }

  @override
  String get roleMember => 'عضو';

  @override
  String get roleModerator => 'مشرف';

  @override
  String get roleAdmin => 'مسؤول';

  @override
  String get addMemberTitle => 'إضافة عضو';

  @override
  String get identitySection => 'الهوية';

  @override
  String get birthSection => 'الميلاد';

  @override
  String get statusSection => 'الحالة';

  @override
  String get parentsSection => 'الوالدين (اختياري)';

  @override
  String get firstNameLabel => 'الاسم الأول *';

  @override
  String get fatherNameLabel => 'اسم الأب *';

  @override
  String get grandfatherNameLabel => 'اسم الجد *';

  @override
  String get birthPlaceInputLabel => 'مكان الميلاد *';

  @override
  String get deathDateInputLabel => 'تاريخ الوفاة';

  @override
  String get fatherInTreeLabel => 'الأب في الشجرة';

  @override
  String get motherInTreeLabel => 'الأم في الشجرة';

  @override
  String get notesInputLabel => 'ملاحظات (اختياري)';

  @override
  String get addToTreeButton => 'إضافة للشجرة';

  @override
  String memberAddedMessage(Object name) {
    return 'تمت إضافة $name للشجرة';
  }

  @override
  String get addMemberError => 'خطأ أثناء الإضافة';

  @override
  String get firstNameError => 'الاسم الأول مطلوب';

  @override
  String get fatherNameError => 'اسم الأب مطلوب';

  @override
  String get grandfatherNameError => 'اسم الجد مطلوب';

  @override
  String get birthPlaceError => 'مكان الميلاد مطلوب';

  @override
  String get genderMale => 'ذكر';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get statusAlive => 'حي';

  @override
  String get statusDeceased => 'متوفى';

  @override
  String get newEventTitle => 'حدث جديد';

  @override
  String get eventTypeLabel => 'نوع الحدث';

  @override
  String get detailsSection => 'التفاصيل';

  @override
  String get locationSection => 'المكان (اختياري)';

  @override
  String get eventTitleLabel => 'العنوان *';

  @override
  String get eventDateLabel => 'التاريخ *';

  @override
  String get eventTimeLabel => 'الوقت (اختياري)';

  @override
  String get eventLocationLabel => 'العنوان أو اسم المكان';

  @override
  String get eventMapsUrlLabel => 'رابط خرائط جوجل';

  @override
  String get eventTitleError => 'العنوان مطلوب';

  @override
  String get eventCreatedMessage => 'تم إنشاء الحدث بنجاح';

  @override
  String get eventCreationError => 'خطأ أثناء إنشاء الحدث';

  @override
  String get eventNotificationInfo => 'سيتلقى جميع الأعضاء إشعارًا لهذا الحدث.';

  @override
  String get searchTitle => 'بحث';

  @override
  String get searchHint => 'البحث عن عضو بالاسم...';

  @override
  String get familyStatsTitle => 'إحصائيات العائلة';

  @override
  String get totalStat => 'الإجمالي';

  @override
  String get menStat => 'رجال';

  @override
  String get womenStat => 'نساء';

  @override
  String get aliveStat => 'أحياء';

  @override
  String get deceasedStat => 'متوفون';

  @override
  String get allMembersTitle => 'جميع الأعضاء';

  @override
  String get noSearchResults => 'لم يتم العثور على نتائج';

  @override
  String get searchRetry => 'جرب اسماً آخر';

  @override
  String get eventsTitle => 'الأحداث';

  @override
  String get newEventButton => 'حدث جديد';

  @override
  String get noEvents => 'لا توجد أحداث';

  @override
  String get noEventsSubtitle => 'ستظهر الأحداث العائلية هنا';

  @override
  String get todaySection => 'اليوم';

  @override
  String get upcomingSection => 'قادمة';

  @override
  String get pastSection => 'سابقة';

  @override
  String get timeLabel => 'الوقت';

  @override
  String get locationLabel => 'المكان';

  @override
  String get openMapButton => 'فتح في خرائط جوجل';

  @override
  String get familyTreeTitle => 'شجرة العائلة';

  @override
  String get noTreeSelected => 'لم يتم تحديد شجرة';

  @override
  String get resetTooltip => 'إعادة تعيين';

  @override
  String get addMemberButton => 'إضافة';

  @override
  String get noMembersInTree => 'لا يوجد أعضاء في الشجرة';

  @override
  String get addFirstMember => 'ابدأ بإضافة أول فرد في العائلة.';

  @override
  String get noMembersAdmin => 'لم يقم المسؤول بإضافة أي أعضاء بعد.';

  @override
  String get addFirstMemberButton => 'إضافة العضو الأول';

  @override
  String get treeInstructions => 'قرص للتكبير • سحب للتحريك';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get infoTitle => 'معلومات';

  @override
  String get birthDateLabel => 'تاريخ الميلاد';

  @override
  String get birthPlaceLabel => 'مكان الميلاد';

  @override
  String get genderLabel => 'الجنس';

  @override
  String get siblingRankLabel => 'الترتيب بين الإخوة';

  @override
  String get ageLabel => 'العمر';

  @override
  String get yearsSuffix => 'سنة';

  @override
  String get deathDateLabel => 'تاريخ الوفاة';

  @override
  String get familyRelationsTitle => 'الروابط العائلية';

  @override
  String get fatherLabel => 'أب';

  @override
  String get motherLabel => 'أم';

  @override
  String get wifeLabel => 'زوجة';

  @override
  String get husbandLabel => 'زوج';

  @override
  String get childrenLabel => 'أطفال';

  @override
  String get sonLabel => 'ابن';

  @override
  String get daughterLabel => 'ابنة';

  @override
  String get noRelations => 'لا توجد روابط عائلية مسجلة';

  @override
  String get notesTitle => 'ملاحظات';

  @override
  String get treeUpdated => 'تم تحديث الشجرة';

  @override
  String get treeCreated => 'تم إنشاء الشجرة بنجاح';

  @override
  String get eventTypeWedding => 'زواج';

  @override
  String get eventTypeBirth => 'ولادة';

  @override
  String get eventTypeDeath => 'وفاة';

  @override
  String get eventTypeReunion => 'لقاء عائلي';

  @override
  String get eventTypeReligious => 'مناسبة دينية';

  @override
  String get eventTypeOther => 'أخرى';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get statusApproved => 'مقبول';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get linkedMemberTitle => 'ملفي في الشجرة';

  @override
  String get viewFullProfile => 'عرض الملف الكامل';

  @override
  String get permissionsTitle => 'صلاحياتي';

  @override
  String get permissionViewTree => 'عرض الشجرة';

  @override
  String get permissionEditMembers => 'تعديل الأعضاء';

  @override
  String get permissionCreateEvents => 'إنشاء أحداث';

  @override
  String get permissionManageUsers => 'إدارة المستخدمين';

  @override
  String get logoutAction => 'تسجيل الخروج';

  @override
  String get promotedToAdmin => 'أنت الآن مسؤول!';

  @override
  String get notProvided => 'غير محدد';

  @override
  String get eventTitleHint => 'مثال: حفل زفاف أحمد وفاطمة';

  @override
  String get eventLocationHint => 'مثال: قاعة الحفلات، الدار البيضاء';

  @override
  String get eventDescriptionHint => 'معلومات إضافية...';

  @override
  String get eventCreatedSuccess => 'تم إنشاء الحدث بنجاح';

  @override
  String get eventCreationErrorDefault => 'خطأ أثناء إنشاء الحدث';

  @override
  String get success => 'تمت العملية بنجاح';
}
