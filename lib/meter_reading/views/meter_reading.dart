import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/app/bloc/app_bloc.dart';
import 'package:waterserver/bill/cubit/bill_cubit.dart';
import 'package:waterserver/home/bloc/home_bloc.dart';
import 'package:waterserver/meter_reading/cubit/meter_reading_cubit.dart';
import 'package:waterserver/meter_reading/repository/meter_reading_repository.dart';
import 'package:waterserver/meter_reading/table/meter_reading_table.dart';
import 'package:waterserver/widgets/custom_row.dart';
import 'package:waterserver/widgets/custom_text_form_box.dart';
import 'package:waterserver/widgets/info.dart';
import 'package:waterserver/widgets/month_picker.dart';

import '../form/meter_reading_form.dart';

part 'meter_reading_main.dart';
part 'meter_reading_form.dart';
part 'meter_reading_view.dart';

class MeterReadingManagement extends StatelessWidget {
  const MeterReadingManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppBloc>().state;
    if (appState.mysqlStatus != AppMysqlStatus.connected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (appState.mysqlStatus == AppMysqlStatus.disconnected)
            const Text('No database connection'),
          if (appState.mysqlStatus == AppMysqlStatus.connecting)
            const Center(
                child: SizedBox(
                    width: 64,
                    height: 16,
                    child: mt.LinearProgressIndicator())),
        ],
      );
    }

    return BlocProvider.value(
      value: context.read<MeterReadingCubit>(),
      child: const MeterReadingManagementView(),
    );
  }
}

class MeterReadingManagementView extends StatelessWidget {
  const MeterReadingManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeterReadingCubit, MeterReadingState>(
      listener: (context, state) {
        switch (state.status) {
          case HomeStatus.clear:
            context.read<HomeBloc>().add(HomeStatusCleared());
            break;
          case HomeStatus.loading:
            context.read<HomeBloc>().add(HomeStatusLoaded(state.message!));
            break;
          case HomeStatus.progress:
            // context.read<HomeBloc>().add(HomeStatusProgressed(
            //     message: state.message!, progress: state.progress!));
            break;
          case HomeStatus.success:
            break;
          case HomeStatus.error:
            context.read<HomeBloc>().add(HomeStatusError(state.message!));
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        return IndexedStack(
          index: state.page.index,
          children: [
            MeterReadingManagementMain(),
            MeterReadingManagementForm(),
            MeterReadingView(),
          ],
        );
      },
    );
  }
}
