import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/domain/models/person.model.dart';
import 'package:immich_mobile/providers/api.provider.dart';
import 'package:immich_mobile/repositories/api.repository.dart';
import 'package:immich_mobile/services/api.service.dart';
import 'package:openapi/api.dart';

final personApiRepositoryProvider = Provider((ref) => PersonApiRepository(ref.watch(apiServiceProvider)));

class PersonApiRepository extends ApiRepository {
  final ApiService _apiService;

  PersonApiRepository(this._apiService);

  PeopleApi get _api => _apiService.peopleApi;

  Future<List<PersonDto>> getAll() async {
    final dto = await checkNull(_api.getAllPeople());
    return dto.people.map(_toPerson).toList();
  }

  /// Fetches the people visible on [assetId] from the server.
  ///
  /// The local sync DB only ever receives faces for assets the viewer owns, so for an
  /// asset shared with the viewer through a Space this must go to the server. The
  /// asset-info endpoint resolves those faces to the Space's people exactly like the web
  /// app (see `AssetService.get`), which keeps mobile at parity with web. See issue #727.
  Future<List<DriftPerson>> getAssetPeople(String assetId) async {
    final info = await checkNull(_apiService.assetsApi.getAssetInfo(assetId));
    return info.people
        .where((person) => !person.isHidden)
        .map((person) => _toDriftPerson(person, info.ownerId))
        .toList();
  }

  static DriftPerson _toDriftPerson(PersonWithFacesResponseDto dto, String ownerId) {
    // The asset-info DTO does not carry created/faceAsset fields; the people strip does
    // not render them, so mirror updatedAt and leave the face-asset unset.
    final updatedAt = dto.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return DriftPerson(
      id: dto.id,
      createdAt: updatedAt,
      updatedAt: updatedAt,
      ownerId: ownerId,
      name: dto.name,
      isFavorite: dto.isFavorite ?? false,
      isHidden: dto.isHidden,
      color: dto.color,
      birthDate: dto.birthDate,
    );
  }

  Future<PersonDto> update(String id, {String? name, DateTime? birthday}) async {
    final birthdayUtc = birthday == null ? null : DateTime.utc(birthday.year, birthday.month, birthday.day);
    final dto = PersonUpdateDto(
      name: name == null ? const Optional.absent() : Optional.present(name),
      birthDate: birthdayUtc == null ? const Optional.absent() : Optional.present(birthdayUtc),
    );
    final response = await checkNull(_api.updatePerson(id, dto));
    return _toPerson(response);
  }

  static PersonDto _toPerson(PersonResponseDto dto) => PersonDto(
    birthDate: dto.birthDate,
    id: dto.id,
    isHidden: dto.isHidden,
    name: dto.name,
    thumbnailPath: dto.thumbnailPath,
  );
}
