import 'package:paisa/src/data/currencies/models/country_model.dart';
import 'package:paisa/src/domain/currencies/entities/country.dart';

extension CountryHelper on CountryModel {
  Country toEntity() {
    return Country(
      code: code,
      name: name,
      symbol: symbol,
      flag: flag,
      decimalDigits: decimalDigits,
      number: number,
      namePlural: namePlural,
      thousandsSeparator: thousandsSeparator,
      decimalSeparator: decimalSeparator,
      spaceBetweenAmountAndSymbol: spaceBetweenAmountAndSymbol,
      symbolOnLeft: symbolOnLeft,
      pattern: pattern,
    );
  }
}
