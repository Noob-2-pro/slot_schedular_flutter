import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'components/durationGap.dart';
import 'components/multiSelectChip.dart';
import 'components/staticCard.dart';

class SlotSchedular extends StatefulWidget {
  const SlotSchedular({Key? key}) : super(key: key);

  @override
  State<SlotSchedular> createState() => _SlotSchedularState();
}

class _SlotSchedularState extends State<SlotSchedular> {
  List<Map<int, String>> days = [
    {1: 'Mon'},
    {2: 'Tue'},
    {3: 'Wed'},
    {4: 'Thur'},
    {5: 'Fri'},
    {6: 'Sat'},
    {7: 'Sun'},
  ];
  TimeOfDay? pickedTime = TimeOfDay.now();
  TimeOfDay? startTime = TimeOfDay.now();
  TimeOfDay? endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  int duration = 30;
  int gap = 0;
  List selectedRepeatDays = [];
  List selectedDays = [];
  List finalSlots = [];

// format of finalSlots = [startTime, endTime, duration, gap, selectedRepeatDays];

  timePicker(BuildContext context) async {
    pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    pickedTime ??= TimeOfDay.now();
    return pickedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("make slots"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, [finalSlots, selectedDays]);
              },
              icon: Icon(Icons.arrow_back))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: SingleChildScrollView(
          child: Column(children: [
            availability(),
            SizedBox(
              height: 10.h,
            ),
            addTimings(),
            SizedBox(
              height: 20.h,
            ),
            const Text("Added Slots"),
            Column(
              children: availableSlots() ?? [Container()],
            ),
          ]),
        ),
      ),
    );
  }

  availableSlots() {
    List<Widget> addedSlots = [];
    finalSlots.forEach((element) {
      TimeOfDay startTime1 = TimeOfDay(
          hour: int.parse(element[0].toString().split(':')[0]), minute: int.parse(element[0].toString().split(':')[1]));
      TimeOfDay endTime1 = TimeOfDay(
          hour: int.parse(element[1].toString().split(':')[0]), minute: int.parse(element[1].toString().split(':')[1]));

      addedSlots.add(Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 8.w),
          child: Wrap(
            spacing: 15.w,
            children: [
              staticCard(
                "Start time",
                startTime1.format(context),
              ),
              staticCard(
                "End time",
                endTime1.format(context),
              ),
              staticCard(
                "Duration",
                '${element[2]}',
              ),
              staticCard(
                "Gap",
                '${element[3]}',
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Days to repeat"),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Wrap(
                            spacing: 3.w,
                            children: List.generate(
                              days.length,
                              (index) {
                                return ChoiceChip(
                                  label: Text(days[index].values.first),
                                  selected: element[4].contains(days[index].keys.first),
                                  onSelected: (val) {},
                                  selectedColor: Colors.green,
                                  disabledColor: Colors.grey.shade100,
                                );
                              },
                            )),
                      ),
                      deletslot(element),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    });

    return addedSlots;
  }

  Widget addTimings() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Slots schedule"),
        ),
        SizedBox(
          height: 10.h,
        ),
        Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 8.w),
            child: Column(
              children: [
                Wrap(
                  spacing: 10.w,
                  children: [
                    Column(
                      children: [
                        const Text("Start Time"),
                        InkWell(
                          onTap: () async {
                            startTime = await timePicker(context);
                            setState(() {});
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(startTime!.format(context).toString()),
                            ),
                            borderOnForeground: true,
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("End Time"),
                        InkWell(
                          onTap: () async {
                            endTime = await timePicker(context);
                            setState(() {});
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(endTime!.format(context).toString()),
                            ),
                            borderOnForeground: true,
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                    durationGap(
                      duration,
                      "Duration",
                      onChanged: (value) {
                        duration = value!;
                        setState(() {});
                      },
                    ),
                    durationGap(
                      gap,
                      "Gap",
                      onChanged: (value) {
                        gap = value!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Days to repeat"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Wrap(
                              spacing: 3.w,
                              runSpacing: -10.h,
                              children: List.generate(
                                days.length,
                                (index) {
                                  int dayNo = days[index].keys.first;
                                  return multiSelectChip(
                                    selectedValues: selectedRepeatDays,
                                    label: days[index],
                                    onSelect: (value) {
                                      setState(() {
                                        selectedRepeatDays.contains(dayNo)
                                            ? selectedRepeatDays.remove(dayNo)
                                            : selectedRepeatDays.add(
                                                dayNo,
                                              );
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Flexible(child: addMoreButton()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget deletslot(dynamic element) {
    return InkWell(
      onTap: () {
        finalSlots.remove(element);
        setState(() {});
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Delete slot"),
              SizedBox(
                width: 10.w,
              ),
              const Icon(
                Icons.delete_forever_rounded,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addMoreButton() {
    return InkWell(
      onTap: () {
        List repeatdays = List.unmodifiable(selectedRepeatDays);
        String slotStartTime = '${startTime!.hour}:${startTime!.minute}';
        String slotEndTime = '${endTime!.hour}:${endTime!.minute}';
        finalSlots.add([slotStartTime, slotEndTime, duration, gap, repeatdays]);
        setState(() {});
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add slot"),
              SizedBox(
                width: 10.w,
              ),
              const Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }

  Column availability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Availability"),
        // chip(
        //     text: canEdit ? 'save' : 'Edit',
        //     color: canEdit ? Colors.blue.shade200 : Colors.yellow.shade300,
        //     onPressed: () {
        //       setState(() {
        //         canEdit = !canEdit;
        //       });
        //     }),
        Wrap(
          spacing: 5.w,
          children: List.generate(
            days.length,
            (index) {
              int dayNo = days[index].keys.first;
              return multiSelectChip(
                selectedValues: selectedDays,
                label: days[index],
                onSelect: (value) {
                  setState(() {
                    selectedDays.contains(dayNo)
                        ? selectedDays.remove(dayNo)
                        : selectedDays.add(
                            dayNo,
                          );
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
