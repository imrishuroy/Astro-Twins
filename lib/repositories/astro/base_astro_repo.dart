import '/models/astrologer.dart';

abstract class BaseAstroRepository {
  Future<List<Astrologer?>> getAstrologers();
}
