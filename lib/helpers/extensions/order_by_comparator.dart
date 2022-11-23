import '../../blocs/blocs.dart';

import '../../models/models.dart';

extension OrderByComparator on OrderBy {
  int comparator(Partita a, Partita b) {
    switch (this) {
      case OrderBy.DATA_DESC:
        return b.data.compareTo(a.data);
      case OrderBy.DATA_ASC:
        return a.data.compareTo(b.data);
      case OrderBy.ID_DESC:
        return b.id.compareTo(a.id);
      case OrderBy.ID_ASC:
        return a.id.compareTo(b.id);
    }
  }
}
