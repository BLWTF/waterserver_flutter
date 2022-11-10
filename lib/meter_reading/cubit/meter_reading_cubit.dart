import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/home/bloc/home_bloc.dart';
import 'package:waterserver/meter_reading/meter_reading.dart';

part 'meter_reading_state.dart';

class MeterReadingCubit extends Cubit<MeterReadingState> {
  final ContractRepository _contractRepository;
  final MeterReadingRepository _meterReadingRepository;

  MeterReadingCubit({
    required ContractRepository contractRepository,
    required MeterReadingRepository meterReadingRepository,
  })  : _contractRepository = contractRepository,
        _meterReadingRepository = meterReadingRepository,
        super(const MeterReadingState(page: MeterReadingManagementPage.main));
}
