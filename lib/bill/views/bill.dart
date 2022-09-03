import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/print/views/bill_preview.dart';
import 'package:waterserver/utilities/generics/cap_first.dart';
import 'package:waterserver/utilities/generics/number_format.dart';
import 'package:waterserver/widgets/custom_row.dart';
import 'package:waterserver/widgets/info.dart';
import 'package:waterserver/widgets/month_picker.dart';

part 'bill_main.dart';
part 'bill_view.dart';

class BillManagement extends StatelessWidget {
  const BillManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<BillCubit>(),
      child: const BillManagementView(),
    );
  }
}

class BillManagementView extends StatelessWidget {
  const BillManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillCubit, BillState>(
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
          children: const [
            BillManagementMain(),
            BillView(),
          ],
        );
      },
    );
  }
}
