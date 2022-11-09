import 'package:formz/formz.dart';

enum NameValidationError { empty, invalid }

class RequiredName extends FormzInput<String, NameValidationError> {
  const RequiredName.pure([String value = '']) : super.pure(value);
  const RequiredName.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : NameValidationError.empty;
  }
}

enum AddressValidationError { empty, invalid }

class Address extends FormzInput<String, AddressValidationError> {
  const Address.pure([String value = '']) : super.pure(value);
  const Address.dirty([String value = '']) : super.dirty(value);

  @override
  AddressValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : AddressValidationError.empty;
  }
}

enum PhoneValidationError { empty, invalid }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure([String value = '']) : super.pure(value);
  const Phone.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneValidationError? validator(String? value) {}
}

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([String value = '']) : super.pure(value);
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String? value) {}
}

class Name extends FormzInput<String?, NameValidationError> {
  const Name.pure([String? value = '']) : super.pure(value);
  const Name.dirty([String? value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {}
}

enum ComboValidationError { empty, invalid }

class ComboField extends FormzInput<String, ComboValidationError> {
  const ComboField.pure([String value = '']) : super.pure(value);
  const ComboField.dirty([String value = '']) : super.dirty(value);

  @override
  ComboValidationError? validator(String? value) {
    return value != null ? null : ComboValidationError.empty;
  }
}

enum NumberValidationError { empty, invalid }

class Number extends FormzInput<double?, NumberValidationError> {
  const Number.pure([double? value]) : super.pure(value);
  const Number.dirty([double? value]) : super.dirty(value);

  @override
  NumberValidationError? validator(double? value) {}
}

class RequiredNumber extends FormzInput<String?, NumberValidationError> {
  const RequiredNumber.pure([String? value]) : super.pure(value);
  const RequiredNumber.dirty([String? value]) : super.dirty(value);

  @override
  NumberValidationError? validator(String? value) {
    return value != null && int.tryParse(value) != null
        ? null
        : NumberValidationError.empty;
  }
}

enum DatetimeValidationError { empty, invalid }

class Datetime extends FormzInput<DateTime?, DatetimeValidationError> {
  const Datetime.pure([DateTime? value]) : super.pure(value);
  const Datetime.dirty([DateTime? value]) : super.dirty(value);

  @override
  DatetimeValidationError? validator(DateTime? value) {
    return value != null ? null : DatetimeValidationError.empty;
  }
}