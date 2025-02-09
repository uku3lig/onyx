part of 'agenda_cubit.dart';

enum AgendaStatus {
  initial,
  loading,
  ready,
  cacheReady,
  dateUpdated,
  error,
  haveToChooseManualy,
  updateDayCount,
  updateAnimating,
}

class AgendaState {
  AgendaStatus status;
  List<Day> realDays;
  int wantedDate;

  AgendaState({
    this.status = AgendaStatus.initial,
    this.realDays = const [],
    required this.wantedDate,
  });

  AgendaState copyWith({
    AgendaStatus? status,
    List<Day>? realDays,
    int? wantedDate,
  }) {
    return AgendaState(
      status: status ?? this.status,
      realDays: realDays ?? this.realDays,
      wantedDate: wantedDate ?? this.wantedDate,
    );
  }

  int getDayIndex(
      {required DateTime date,
      required SettingsModel settings,
      bool useRealDays = false}) {
    List<Day> tmpDays = (useRealDays) ? realDays : days(settings);
    int distance = tmpDays.length;
    int index = -1;

    for (int i = 0; i < tmpDays.length; i++) {
      if ((tmpDays[i].date.difference(date).inDays).abs() < distance) {
        distance = (tmpDays[i].date.difference(date).inDays).abs();
        index = i;
      }
    }
    return index;
  }

  List<Day> days(SettingsModel settingsModel) {
    List<Day> realDays = List.from(this.realDays);
    realDays = realDays
        .where((element) =>
            !settingsModel.agendaDisabledDays.contains(element.date.weekday))
        .toList();

    int todayWeekday = DateTime.now().weekday;
    for (var i = 0; i < 7; i++) {
      //use for to ensure that we don't loop forever
      if (settingsModel.agendaDisabledDays.contains(todayWeekday)) {
        todayWeekday += 1;
      } else {
        todayWeekday = todayWeekday.positiveModulo(7);
        break;
      }
    }
    int todayOffset;
    if (settingsModel.agendaWeekReference >= 8) {
      todayOffset = settingsModel.agendaWeekRerenceAlignement - 2;
    } else {
      todayOffset = todayWeekday -
          (settingsModel.agendaWeekReference -
              settingsModel.agendaWeekRerenceAlignement -
              1);
    }
    todayOffset = todayOffset.positiveModulo(settingsModel.agendaWeekLength);
    int todayIndex = getDayIndex(
        date: DateTime.now(), settings: settingsModel, useRealDays: true);

    if (todayIndex != -1) {
      int paddingBeforeCount = (todayOffset - todayIndex)
          .positiveModulo(settingsModel.agendaWeekLength);
      int paddingAfterCount = (settingsModel.agendaWeekLength -
              ((realDays.length + paddingBeforeCount) %
                  settingsModel.agendaWeekLength))
          .clamp(0, settingsModel.agendaWeekLength - 1);

      int postPaddingCount = 0;
      List<Day> paddingBefore = [];
      for (int i = 0; i < paddingBeforeCount + postPaddingCount; i++) {
        DateTime date = realDays.first.date
            .subtract(Duration(days: paddingBeforeCount - i));
        if (settingsModel.agendaDisabledDays.contains(date.weekday)) {
          postPaddingCount++;
        } else {
          paddingBefore.add(Day(date, const []));
        }
      }

      postPaddingCount = 0;
      List<Day> paddingAfter = [];
      for (int i = 0; i < paddingAfterCount + postPaddingCount; i++) {
        DateTime date = realDays.last.date.add(Duration(days: i + 1));
        if (settingsModel.agendaDisabledDays.contains(date.weekday)) {
          postPaddingCount++;
        } else {
          paddingAfter.add(Day(date, const []));
        }
      }

      return [
        ...paddingBefore,
        ...realDays,
        ...paddingAfter,
      ];
    }

    // Si aucune correspondance n'est trouvée pour aujourd'hui, retourner simplement les jours réels.
    return realDays;
  }
}
