import 'package:mbw204_club_ina/data/models/sos.dart';

class SosRepo {
  List<Sos> getSosList() {
    List<Sos> sosList = [
      Sos(id: 1, name: 'Ambulance', 
        icon: 'assets/icons/ic-ambulance.png', desc: 'Sebar permintaan tolong Ambulan',
        type: 'sos.emergency'
      ),
      Sos(id: 2, name: 'Accident', 
        icon: 'assets/icons/ic-accident.png', desc: 'Sebar permintaan tolong Kecelakaan',
        type: 'sos.accident' 
      ),
      Sos(
        id: 3, name: 'Trouble', 
        icon: 'assets/icons/ic-trouble.png', desc: 'Sebar permintaan tolong Mogok',
        type: 'sos.emergency'  
      ),
      Sos(
        id: 3, name: 'Manual Guide', 
        icon: 'assets/icons/ic-manual-guide.png', desc: 'Dokumen komunikasi yang bertujuan memberikan bantuan untuk penggunaan suatu sistem',
        type: 'sos.emergency'  
      ),
    ];
    return sosList;
  }
}