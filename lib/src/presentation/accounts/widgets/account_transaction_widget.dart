import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/common.dart';
import '../../../data/accounts/data_sources/local_account_data_manager.dart';
import '../../../data/category/data_sources/category_local_data_source.dart';
import '../../../domain/account/entities/account.dart';
import '../../../domain/category/entities/category.dart';
import '../../../domain/expense/entities/expense.dart';
import '../../summary/widgets/expense_item_widget.dart';
import '../../widgets/paisa_card.dart';
import '../../widgets/paisa_empty_widget.dart';

class AccountTransactionWidget extends StatelessWidget {
  const AccountTransactionWidget({
    Key? key,
    required this.accountLocalDataSource,
    required this.categoryLocalDataSource,
    required this.expenses,
    this.isScroll = false,
  }) : super(key: key);

  final LocalAccountDataManager accountLocalDataSource;
  final LocalCategoryManagerDataSource categoryLocalDataSource;
  final List<Expense> expenses;
  final bool isScroll;
  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return EmptyWidget(
        title: context.loc.emptyExpensesMessage,
        icon: Icons.money_off_rounded,
        description: context.loc.emptyExpensesDescription,
      );
    }
    return ScreenTypeLayout(
      mobile: ListView(
        physics: isScroll ? null : const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
            title: Text(
              context.loc.transactionHistory,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                textStyle: Theme.of(context).textTheme.titleLarge,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            itemBuilder: (_, index) {
              final Account? account = accountLocalDataSource
                  .fetchAccountFromId(expenses[index].accountId)
                  ?.toEntity();
              final Category? category = categoryLocalDataSource
                  .fetchCategoryFromId(expenses[index].categoryId)
                  ?.toEntity();
              if (category == null || account == null) {
                return ExpenseItemWidget(
                  expense: expenses[index],
                  account: account!,
                  category: Category(
                    icon: MdiIcons.bankTransfer.codePoint,
                    name: 'Code',
                    color: Colors.amber.value,
                  ),
                );
              } else {
                return ExpenseItemWidget(
                  expense: expenses[index],
                  account: account,
                  category: category,
                );
              }
            },
          ),
        ],
      ),
      tablet: ListView(
        padding: const EdgeInsets.only(bottom: 128),
        shrinkWrap: true,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
            title: Text(
              context.loc.transactionHistory,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PaisaCard(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (_, index) {
                  final Account account = accountLocalDataSource
                      .fetchAccountFromId(expenses[index].accountId)!
                      .toEntity();
                  final Category category = categoryLocalDataSource
                      .fetchCategoryFromId(expenses[index].categoryId)!
                      .toEntity();
                  return ExpenseItemWidget(
                    expense: expenses[index],
                    account: account,
                    category: category,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
