import 'package:izlyclient/izlyclient.dart';
import 'package:lyon1agendaclient/lyon1agendaclient.dart';
import 'package:lyon1casclient/lyon1casclient.dart';
import 'package:lyon1mailclient/lyon1mailclient.dart';
import 'package:lyon1tomussclient/lyon1tomussclient.dart';
import 'package:onyx/core/cache_service.dart';
import 'package:onyx/screens/settings/settings_export.dart';

Future<void> hiveInit({String? cachePath, String? permanentPath}) async {
  CacheService.registerAdapter<SettingsModel>(SettingsModelMapper.fromJson);

  CacheService.registerAdapter<IzlyCredential>(IzlyCredentialMapper.fromJson);
  CacheService.registerAdapter<IzlyQrCode>(IzlyQrCodeMapper.fromJson);
  CacheService.registerAdapter<PlatCrous>(PlatCrousMapper.fromJson);
  CacheService.registerAdapter<RestaurantModel>(RestaurantModelMapper.fromJson);
  CacheService.registerAdapter<IzlyPaymentModel>(
      IzlyPaymentModelMapper.fromJson);

  //TOMUSS
  CacheService.registerAdapter<Enumeration>(EnumerationMapper.fromJson);
  CacheService.registerAdapter<Grade>(GradeMapper.fromJson);
  CacheService.registerAdapter<Presence>(PresenceMapper.fromJson);
  // CacheService.registerAdapter<>( ,PresenceColorMapper.);
  CacheService.registerAdapter<Semester>(SemesterMapper.fromJson);
  CacheService.registerAdapter<StageCode>(StageCodeMapper.fromJson);
  CacheService.registerAdapter<Teacher>(TeacherMapper.fromJson);
  CacheService.registerAdapter<TeachingUnit>(TeachingUnitMapper.fromJson);
  CacheService.registerAdapter<TomussText>(TomussTextMapper.fromJson);
  CacheService.registerAdapter<Upload>(UploadMapper.fromJson);
  CacheService.registerAdapter<URL>(URLMapper.fromJson);

  //CAS
  CacheService.registerAdapter<Credential>(CredentialMapper.fromJson);

  //CALENDAR
  CacheService.registerAdapter<Agenda>(AgendaMapper.fromJson);
  CacheService.registerAdapter<Day>(DayMapper.fromJson);
  CacheService.registerAdapter<Event>(EventMapper.fromJson);

  //MAIL
  CacheService.registerAdapter<Action>(ActionMapper.fromJson);
  CacheService.registerAdapter<Mail>(MailMapper.fromJson);
  CacheService.registerAdapter<MailBox>(MailBoxMapper.fromJson);

  CacheService.init(cachePath: path, permanentPath: "/tmp/onyx/perma");
}
