import 'dart:async';

import 'package:waterserver/cache/cache.dart';
import 'package:waterserver/database/database.dart';

import '../models/models.dart';

class AreaRepository {
  final MysqlDatabaseRepository _mysqlDatabaseRepository;
  final CacheClient _cache;

  AreaRepository(
      {required MysqlDatabaseRepository mysqlDatabaseRepository,
      CacheClient? cache})
      : _cache = cache ?? CacheClient(),
        _mysqlDatabaseRepository = mysqlDatabaseRepository;

  static const districtsCacheKey = '__districts_cache_key';
  static const zonesCacheKey = '__zones_cache_key';
  static const subzonesCacheKey = '__subzones_cache_key';
  static const roundsCacheKey = '__rounds_cache_key';

  List<District>? get districtsCache {
    return _cache.read<List<District>>(key: districtsCacheKey);
  }

  set districtsCache(List<District>? districts) {
    _cache.write<List<District>>(key: districtsCacheKey, value: districts!);
  }

  Map<String, List<Zone>> get zonesCache {
    return _cache.read<Map<String, List<Zone>>>(key: zonesCacheKey) ?? {};
  }

  set zonesCache(Map<String, List<Zone>> zones) {
    _cache.write<Map<String, List<Zone>>>(key: zonesCacheKey, value: zones);
  }

  Map<String, List<Subzone>> get subzonesCache {
    return _cache.read<Map<String, List<Subzone>>>(key: subzonesCacheKey) ?? {};
  }

  set subzonesCache(Map<String, List<Subzone>> subzones) {
    _cache.write<Map<String, List<Subzone>>>(
        key: subzonesCacheKey, value: subzones);
  }

  Map<String, List<Round>> get roundsCache {
    return _cache.read<Map<String, List<Round>>>(key: roundsCacheKey) ?? {};
  }

  set roundsCache(Map<String, List<Round>> rounds) {
    _cache.write<Map<String, List<Round>>>(key: roundsCacheKey, value: rounds);
  }

  Future<List<District>> getDistricts() async {
    try {
      if (districtsCache == null) {
        final rows =
            await _mysqlDatabaseRepository.get(table: 'district', limit: 100);
        districtsCache = rows.map((row) => District.fromFPMap(row)).toList();
        return districtsCache!;
      }

      return districtsCache!;
    } on TimeoutException catch (_) {
      return getDistricts();
    }
  }

  Future<List<Zone>> getZones(String district) async {
    final rows = await _mysqlDatabaseRepository.get(
        table: 'zone', where: {'district': district}, limit: 100);
    final zones = rows.map((row) => Zone.fromFPMap(row)).toList();
    return zonesCache.putIfAbsent(district, () => zones);
  }

  Future<List<Subzone>> getSubzones(String zone) async {
    final district = zone.getAreaCode(AreaType.district);
    final zoneCode = zone.getAreaCode(AreaType.zone);
    final rows = await _mysqlDatabaseRepository.get(
        table: 'subzone',
        where: {'district': district, 'zone': zoneCode},
        limit: 100);
    final subzones = rows.map((row) => Subzone.fromFPMap(row)).toList();
    return subzonesCache.putIfAbsent(zone, () => subzones);
  }

  Future<List<Round>> getRounds(String subzone) async {
    final district = subzone.getAreaCode(AreaType.district);
    final zone = subzone.getAreaCode(AreaType.zone);
    final subzoneCode = subzone.getAreaCode(AreaType.subzone);
    final rows = await _mysqlDatabaseRepository.get(
        table: 'rounds',
        where: {'district': district, 'zone': zone, 'subzone': subzoneCode},
        limit: 100);
    final rounds = rows.map((row) => Round.fromFPMap(row)).toList();
    return roundsCache.putIfAbsent(subzone, () => rounds);
  }
}
