import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vo_ninja/modules/settings_tap_page/settings_tap_cubit/settings_tap_cubit.dart';
import 'package:vo_ninja/modules/settings_tap_page/settings_tap_cubit/settings_tap_state.dart';
import 'package:vo_ninja/modules/taps_page/taps_page.dart';

import '../../generated/l10n.dart';
import '../../shared/network/local/cash_helper.dart';
import '../../shared/style/color.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final transactionsPageCubit = SettingsTapCubit.get(context);
    setState(() {
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        String uid;
        uid = await CashHelper.getData(key: 'uid');
        await transactionsPageCubit.getAllTransaction(uid);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsPageCubit = SettingsTapCubit.get(context);
    return BlocConsumer<SettingsTapCubit, SettingsTapState>(
        listener: (BuildContext context, SettingsTapState state) {},
        builder: (BuildContext context, SettingsTapState state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.lightColor,
              appBar: AppBar(
                backgroundColor: AppColors.lightColor,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.mainColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const TapsPage()));
                  },
                ),
                centerTitle: true,
                title: Text(
                  S.of(context).transaction,
                  style: const TextStyle(
                      color: AppColors.mainColor, fontWeight: FontWeight.bold),
                ),
              ),
              body: WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TapsPage()),
                  );
                  return true;
                },
                child: isLoading
                    ? const Center(
                        child: Image(
                        image: AssetImage('assets/img/ninja_gif.gif'),
                        height: 100,
                        width: 100,
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              height: MediaQuery.of(context).size.width * .14,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _headerText("Date"),
                                  _headerText("Status"),
                                  _headerText("Points"),
                                  _headerText("Cash"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView.separated(
                                  itemCount:
                                      transactionsPageCubit.transactions.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(color: Colors.grey),
                                  itemBuilder: (context, index) {
                                    final transaction = transactionsPageCubit
                                        .transactions[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _dataText(transaction.approvedAt ??
                                              transaction.createdAt ??
                                              DateTime.now()),
                                          Text(
                                            transaction.status ?? '',
                                            style: TextStyle(
                                              color: transaction.status ==
                                                      'Approved'
                                                  ? Colors.green
                                                  : Colors.amber,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          _dataText2(
                                              '${transaction.points.toInt()} pts'),
                                          _dataText2(
                                              '${transaction.price.toInt()} EGP'),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          );
        });
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _dataText(DateTime dateTime) {
    String formattedDate =
        DateFormat('d MMM').format(dateTime); // Formats like "1 Jan"

    return Text(
      formattedDate,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _dataText2(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white),
    );
  }
}
