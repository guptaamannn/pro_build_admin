import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pro_build_admin/core/model/user_record.dart';
import 'package:pro_build_admin/ui/shared/input_decoration.dart';
import 'package:pro_build_admin/ui/views/payment_view.dart';
import 'package:pro_build_admin/ui/views/payments_view.dart';
import 'package:provider/provider.dart';

import '/core/model/invoice.dart';
import '/core/model/user.dart';
import '/core/utils/formatter.dart';
import '/core/viewModel/user_model.dart';
import '/ui/views/user_edit_view.dart';
import '/ui/widgets/dumbbell_spinner.dart';
import '/ui/widgets/image_avatar.dart';
import '/ui/widgets/info_widget.dart';
import 'payment_form.dart';

class UserView extends StatelessWidget {
  static const String id = '/user';
  final String userId;

  const UserView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel model = context.read<UserModel>();
    return Scaffold(
      body: StreamBuilder<User>(
        stream: model.getUserStream(userId),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: DumbbellSpinner());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }
          if (snapshot.data == null || !snapshot.hasData) {
            return const Center(child: Text("No Data"));
          }

          return _BuildBody(user: snapshot.data!);
        },
      ),
    );
  }
}

class _BuildBody extends StatelessWidget {
  final User user;
  const _BuildBody({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<UserModel>().refreshDp(user.id!);
      },
      child: CustomScrollView(
        slivers: [
          _AppBar(user: user),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ComsBar(user: user),
                const Divider(),
                _DetailsCard(user: user),
                addSpace(),
                UsageCalendar(userId: user.id!),
                _LastTransaction(user: user),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      pinned: true,
      expandedHeight: 300,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          user.name!,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground
        ],
        background: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CachedImageAvatar(
                fileName: user.id!,
                name: user.name,
                radius: 80,
                hasDp: user.dpUrl != null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(user.id!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComsBar extends StatelessWidget {
  final User user;
  const _ComsBar({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () =>
              context.read<UserModel>().callUser(user.phone.toString()),
        ),
        IconButton(
          icon: const Icon(Icons.message_rounded),
          onPressed: () =>
              context.read<UserModel>().messageUser(user.phone.toString()),
        ),
        IconButton(
          icon: const Icon(Icons.mail),
          onPressed: () => context.read<UserModel>().mailUser(user),
        ),
        IconButton(
          icon: const Icon(Icons.payment_rounded),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => PaymentForm(user: user)));
          },
        ),
      ],
    );
  }
}

class UsageCalendar extends HookWidget {
  final String userId;
  const UsageCalendar({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Usage Calendar", style: Theme.of(context).textTheme.labelLarge),
        FutureBuilder<UserRecord?>(
          future: context.read<UserModel>().getUserRecords(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshot.data == null || snapshot.hasError) {
              return const ListTile(
                title: Text("No Records"),
              );
            }
            List<MarkedDate> markedDates = snapshot.data!.days!
                .map(
                  (e) => MarkedDate(
                      color: e.date!.isAfter(e.eDate!)
                          ? Theme.of(context).colorScheme.tertiaryContainer
                          : Theme.of(context).colorScheme.secondaryContainer,
                      date: e.date!),
                )
                .toList();

            return CalendarCarousel(
                height: 400,
                weekendTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                firstDayOfWeek: 0,
                weekdayTextStyle:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
                todayBorderColor: Colors.transparent,
                todayButtonColor:
                    Theme.of(context).colorScheme.primaryContainer,
                multipleMarkedDates:
                    MultipleMarkedDates(markedDates: markedDates),
                headerTextStyle: Theme.of(context).textTheme.labelLarge,
                daysTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                isScrollable: true,
                pageScrollPhysics: const RangeMaintainingScrollPhysics());
          },
        ),
      ],
    );
  }
}

class _LastTransaction extends StatelessWidget {
  final User user;
  const _LastTransaction({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Last Transaction", style: Theme.of(context).textTheme.labelLarge),
        FutureBuilder<Invoice?>(
          future: context.read<UserModel>().getLastTransaction(user.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshot.data == null || !snapshot.hasData) {
              return const ListTile(title: Text("No transaction found"));
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Baseline(
                    baselineType: TextBaseline.alphabetic,
                    baseline: 18,
                    child:
                        Text(Formatter.dayAndMonth(snapshot.data!.orderDate!)),
                  ),
                  title:
                      Text(snapshot.data!.order![0].description!.toUpperCase()),
                  trailing: Text("Rs " + snapshot.data!.totalAmount.toString()),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) =>
                                PaymentView(invoice: snapshot.data!)));
                  },
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentsView(
                            userId: user.id,
                          ),
                        ),
                      );
                    },
                    child: const Text("View all"),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final User user;
  const _DetailsCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Info(type: "Phone", data: user.phone.toString()),
                    ),
                    Expanded(
                      child: Info(type: "E-mail", data: user.email.toString()),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child:
                          Info(type: "Address", data: user.address.toString()),
                    ),
                    Expanded(
                      child: Info(
                        type: "Joined-date",
                        data: Formatter.fromDateTime(user.joinedDate),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Info(
                            type: "Expiration-date",
                            data: Formatter.fromDateTime(user.eDate),
                          ),
                          TextButton(
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021, 02, 01),
                                lastDate: DateTime(2029, 01, 01),
                              );
                              if (newDate != null) {
                                context
                                    .read<UserModel>()
                                    .updateEDate(user, newDate);
                              }
                            },
                            child: const Text("Update"),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<int>(
                        future: context.read<UserModel>().useAfterEnd(user),
                        initialData: 0,
                        builder: (context, AsyncSnapshot<int> snapshot) => Info(
                            type: "After Subscription",
                            data: "${snapshot.data.toString()} days"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserEditView(user: user),
                ),
              );
            },
            child: const Icon(Icons.edit_outlined),
          ),
        ),
      ],
    );
  }
}
