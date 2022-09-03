import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    hide
        Icon,
        IconButton,
        Scrollbar,
        ListTile,
        Card,
        Tooltip,
        ButtonStyle,
        Divider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/area/area.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/tariff/tariff.dart';
import 'package:waterserver/utilities/generics/cap_first.dart';
import 'package:waterserver/widgets/custom_row.dart';
import 'package:waterserver/widgets/info.dart';

part 'contract_main.dart';
part 'contract_form.dart';
part 'contract_view.dart';

class ContractManagement extends StatelessWidget {
  const ContractManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ContractCubit>(),
      child: const ContractManagementView(),
    );
  }
}

class ContractManagementView extends StatelessWidget {
  const ContractManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContractCubit, ContractState>(
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
            ContractManagementMain(),
            ContractManagementForm(),
            ContractView(),
          ],
        );
      },
    );
  }
}
