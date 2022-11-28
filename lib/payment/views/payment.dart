import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/app/app.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/payment/payment.dart';
import 'package:waterserver/widgets/custom_row.dart';
import 'package:waterserver/widgets/custom_text_form_box.dart';
import 'package:waterserver/widgets/future_suggest_box.dart';
import 'package:waterserver/widgets/info.dart';
import 'package:waterserver/widgets/month_picker.dart';
import 'package:waterserver/utilities/generics/number_format.dart';
import 'package:waterserver/utilities/generics/datetime_to_string.dart';

part 'payment_main.dart';
part 'payment_form.dart';
part 'payment_view.dart';

class PaymentManagement extends StatelessWidget {
  const PaymentManagement({super.key});

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
      value: context.read<PaymentCubit>(),
      child: const PaymentManagementView(),
    );
  }
}

class PaymentManagementView extends StatelessWidget {
  const PaymentManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
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
            PaymentManagementMain(),
            PaymentManagementForm(),
            PaymentView(),
          ],
        );
      },
    );
  }
}
