import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:izlyclient/izlyclient.dart';
import 'package:onyx/core/widgets/core_widget_export.dart';
import 'package:onyx/screens/izly/izly_export.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IzlyPaymentHistory extends StatelessWidget {
  const IzlyPaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IzlyCubit, IzlyState>(
      buildWhen: (previous, current) =>
          previous.izlyClient != current.izlyClient,
      builder: (context, izlyState) {
        return FutureBuilder(
          future: IzlyLogic.getUserPayments(izlyState.izlyClient!),
          builder: (context, state) {
            Widget body;
            if (izlyState.izlyClient == null) {
              body = const StateDisplayingPage(
                message: "Vous n'êtes pas encore connecté à Izly",
              );
            } else if (!state.hasData) {
              body = CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 7.sp,
              );
            } else {
              body = SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 5,
                      ),
                      shrinkWrap: true,
                      itemCount: state.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Color colorBackground;
                        state.data![index].isSucess
                            ? colorBackground = Colors.green
                            : colorBackground = Colors.red;

                        return Container(
                          decoration: BoxDecoration(
                            color: colorBackground,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          margin: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.data![index].paymentTime,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.data![index].amountSpent,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return SafeArea(
              child: Material(
                child: CommonScreenWidget(
                  header: const IzlyRechargeHeaderWidget(
                      title: "Historique des paiements"),
                  body: Center(
                    child: body,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
