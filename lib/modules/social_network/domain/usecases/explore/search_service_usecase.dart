import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';

@lazySingleton
class SearchServiceUsecase {
  Future<List<Service>> call(String keyWord) async {
    await Future.delayed(const Duration(seconds: 1));
    if (keyWord.isEmpty) {
      return <Service>[];
    } else {
      return <Service>[
        Service(
          id: 0,
          name: "Animal Emergency",
          logo: "https://animalemergencyhospital.net/wp-content/uploads/2021/04/animal-emergency-hospital.png",
        ),
        Service(
          id: 1,
          name: "Công Ty TNHH Kimipet Việt Nam",
          logo: "https://kimipet.vn/wp-content/uploads/2017/05/logo.png",
        ),
        Service(
          id: 2,
          name: "Bệnh Viện Thú Y Petcare",
          logo: "https://petcare.vn/wp-content/uploads/2016/06/petcarevn_logo.png",
        ),
      ];
    }
  }
}
