import 'package:mbw204_club_ina/data/models/onboarding.dart';

class OnBoardingRepo{
  List<OnboardingModel> getOnBoardingList() {
    List<OnboardingModel> onboarding = [
      OnboardingModel('assets/images/onboarding-1.jpg','Di Aplikasi', 'Aplikasi yang memberikan kemudahan untuk seluruh pengguna Mercedez Benz W204 tentang informasi dan layanan'),
      OnboardingModel('assets/images/onboarding-2.jpg','Aplikasi \nMBW204 Club Indonesia', 'Aplikasi ini terdapat informasi berita dan event bertujuan untuk pengguna Mercedez Benz W204 secara cepat dan tepat'),
      OnboardingModel('assets/images/onboarding-3.jpg','Aplikasi \nMBW204 Club Indonesia', 'Aplikasi ini terdapat tombol Panic Button bertujuan untuk panggilan darurat atau emergency secara cepat dan tepat'),
      OnboardingModel('assets/images/onboarding-4.jpg','Aplikasi \nMBW204 Club Indonesia', 'Aplikasi yang memberikan kemudahan untuk seluruh pengguna Mercedez Benz W204 dalam mencari kebutuhan yang diinginkan'),
    ];
    return onboarding;
  }
}