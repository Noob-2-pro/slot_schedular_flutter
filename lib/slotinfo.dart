import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'components/slotchip.dart';

class SlotInfo extends StatefulWidget {
  const SlotInfo({Key? key}) : super(key: key);

  @override
  State<SlotInfo> createState() => _SlotInfoState();
}

class _SlotInfoState extends State<SlotInfo> {
  int isSelected = -1;
  List availableDays = [1, 2, 3, 4, 5, 6];
  List availableSlots = [];
  List notAvailableDays = [];
  int selectedWeekDay = 1;
  bool isDateSelected = false;
  String? bookedTime;
  List finalSlots = [
    [
      '16:0',
      '18:30',
      50,
      10,
      [1, 3, 5]
    ],
    [
      '9:30',
      '11:30',
      40,
      0,
      [1, 3, 5, 6, 2]
    ]
  ];
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  DateTime today = DateTime.now();
  DateTime bookingDateTime = DateTime.now();

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  covertIntoDateTime(dynamic element) {
    TimeOfDay startTime1 = TimeOfDay(
        hour: int.parse(element[0].toString().split(':')[0]), minute: int.parse(element[0].toString().split(':')[1]));
    TimeOfDay endTime1 = TimeOfDay(
        hour: int.parse(element[1].toString().split(':')[0]), minute: int.parse(element[1].toString().split(':')[1]));

    final now = DateTime.now();
    startTime = DateTime(now.year, now.month, now.day, startTime1.hour, startTime1.minute);
    endTime = DateTime(now.year, now.month, now.day, endTime1.hour, endTime1.minute);
    setState(() {});
  }

  slotmaker(List slotForTheDay) {
    slotForTheDay.forEach((element) {
      int gap = element[3];
      int duration = element[2];
      covertIntoDateTime(element);
      DateTime to = startTime;

      while (endTime.compareTo(startTime) == 1) {
        to = startTime.add(Duration(minutes: duration));
        availableSlots.add('${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(to)}');
        startTime = to.add(Duration(minutes: gap));
        if (endTime.compareTo(startTime) == 0) {
          break;
        }
      }
    });
  }

  slotsToShow(int selectedWeekDay) {
    availableSlots = [];
    List slotsforTheDay = finalSlots.where((element) {
      List days = element[4];
      if (days.contains(selectedWeekDay)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    slotmaker(slotsforTheDay);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      isSelected = -1;
      DateTime value = args.value as DateTime;
      bookingDateTime = value;
      availableSlots = [];
      slotsToShow(value.weekday);
    }
    setState(() {});
  }

  @override
  void initState() {
    List daystoBlackout = [1, 2, 3, 4, 5, 6, 7];
    notAvailableDays = daystoBlackout.where((item) => !availableDays.contains(item)).toList();
    //TODO : fetch list of available days at init state and store in availableDays variable
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Book your Service",
                // style: bodyTextStyle.copyWith(fontSize: 18.sp, fontFamily: robottoFontTextStyle),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Text(
                  "Choose your appointment date",
                  // style: bodyTextStyle.copyWith(color: Colors.grey, fontSize: 15.sp, fontFamily: robottoFontTextStyle),
                ),
              ),
            ],
          ),
          SfDateRangePicker(
            enablePastDates: false,
            minDate: today.subtract(const Duration(days: 60)),
            maxDate: today.add(const Duration(days: 240)),
            monthViewSettings: const DateRangePickerMonthViewSettings(
              firstDayOfWeek: 1,
            ),
            onSelectionChanged: _onSelectionChanged,
            selectableDayPredicate: (DateTime dateTime) {
              if (notAvailableDays.contains(dateTime.weekday)) {
                return false;
              }
              return true;
            },
          ),
          slots(),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
                onPressed: () {
                  if (isSelected != -1) {
                    // send api req for booking slot
                    // TimeOfDay bookingTime = DateTime()
                    int hour = int.parse(bookedTime!.split(':')[0]);
                    int min = int.parse(bookedTime!.split(' ')[0].split(':')[1]);
                    String amPm = bookedTime!.split(' ')[1];
                    if (amPm == 'PM') {
                      hour += 12;
                    }
                    bookingDateTime =
                        DateTime(bookingDateTime.year, bookingDateTime.month, bookingDateTime.day, hour, min);
                    print(bookingDateTime);
                  }
                },
                child: const Center(
                  child: Text("Confirm Booking"),
                )),
          ),
        ],
      ),
    );
  }

  Widget slots() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Text(
              "Available Slots",
              // style: bodyTextStyle.copyWith(color: Colors.grey, fontSize: 15.sp, fontFamily: robottoFontTextStyle),
            ),
          ),
          Wrap(
              spacing: 8.w,
              children: List.generate(
                availableSlots.length,
                (index) => SlotChip(
                  text: availableSlots[index],
                  index: index,
                  isSelected: isSelected,
                  onTap: (value) {
                    setState(() {
                      isSelected = index;
                    });
                    print(availableSlots);
                    bookedTime = availableSlots[index].toString().split('-')[0].toString();
                    // print(bookedTime);
                  },
                ),
              )),
        ],
      ),
    );
  }

  // calendar() {
  //   return //calendar body
  //       Padding(
  //     padding: const EdgeInsets.only(
  //       left: 15,
  //       right: 15,
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Text(
  //               "Book your Service",
  //               // style: bodyTextStyle.copyWith(fontSize: 18.sp, fontFamily: robottoFontTextStyle),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12.h),
  //         Row(
  //           children: [
  //             Text(
  //               "Choose your appointment date",
  //               // style: bodyTextStyle.copyWith(color: Colors.grey, fontSize: 15.sp, fontFamily: robottoFontTextStyle),
  //             ),
  //           ],
  //         ),
  //         Material(
  //           elevation: 1,
  //           child: Container(
  //             // margin: EdgeInsets.only(top: 30),
  //             child: Transform.scale(
  //               scale: 0.9,
  //               child: CalendarCarousel<Event>(
  //                 // markedDatesMap: markedDateMap,
  //                 customGridViewPhysics: BouncingScrollPhysics(),
  //                 onDayPressed: (date, events) {
  //                   setState(() {
  //                     bookingDates = date;
  //                     print(bookingDates);
  //                     print(events);
  //                   });
  //                 },
  //                 // headerTextStyle: headingTextStyle.copyWith(
  //                 //   fontFamily: robottoFontTextStyle,
  //                 //   fontSize: 13.sp,
  //                 // ),
  //                 pageSnapping: true,
  //                 nextDaysTextStyle: TextStyle(color: Colors.white),
  //                 prevDaysTextStyle: TextStyle(color: Colors.white),
  //                 leftButtonIcon: Icon(Icons.arrow_back_ios, size: 16),
  //                 rightButtonIcon: Icon(Icons.arrow_forward_ios, size: 16),
  //                 showOnlyCurrentMonthDate: false,
  //                 todayButtonColor: Colors.yellow,
  //                 selectedDayButtonColor: Colors.orange,
  //                 markedDateMoreShowTotal: true,
  //                 showWeekDays: true,
  //                 firstDayOfWeek: 1,
  //                 weekFormat: false,
  //                 showHeader: true,
  //                 height: 340.h,
  //                 selectedDateTime: bookingDates,
  //                 targetDateTime: bookingDates, // targetDateTime,
  //                 showIconBehindDayText: true,
  //                 markedDateShowIcon: true,
  //                 markedDateIconMaxShown: 2,
  //                 // weekdayTextStyle: bodyTextStyle.copyWith(fontSize: 15.sp, color: Color(0xff191919)),
  //                 //            daysTextStyle: mediumRegularTextStyle,
  //                 // weekendTextStyle: bodyTextStyle.copyWith(fontSize: 15.sp, color: Color(0xff191919)),
  //                 // selectedDayTextStyle: bodyTextStyle.copyWith(color: Colors.white, fontSize: 15.sp),
  //                 markedDateIconBuilder: (event) {
  //                   return event.icon ?? Icon(Icons.help_outline);
  //                 },
  //                 minSelectedDate: bookingDates.subtract(Duration(days: 360)),
  //                 maxSelectedDate: bookingDates.add(Duration(days: 360)),
  //                 onCalendarChanged: (DateTime date) {
  //                   // this.setState(() {
  //                   //   print('hello');
  //                   //   model.targetDateTime = date;
  //                   //   model.currentMonth =
  //                   //       DateFormat.yMMM().format(model.targetDateTime);
  //                   // });
  //                 },
  //                 customWeekDayBuilder: (weekday, weekdayName) {
  //                   return Text(
  //                     "$weekdayName",
  //                   );
  //                 },
  //                 customDayBuilder: (
  //                   isSelectable,
  //                   index,
  //                   isSelectedDay,
  //                   isToday,
  //                   isPrevMonthDay,
  //                   textStyle,
  //                   isNextMonthDay,
  //                   isThisMonthDay,
  //                   day,
  //                 ) {
  //                   return isPrevMonthDay
  //                       ? Container()
  //                       : isNextMonthDay
  //                           ? Container()
  //                           : Container(
  //                               decoration: BoxDecoration(
  //                                 shape: BoxShape.circle,
  //                                 color: Colors.grey.withOpacity(0.5),
  //                               ),
  //                               child: Center(
  //                                 child: Text(
  //                                   "${day.day}",
  //                                   // style: bodyTextStyle.copyWith(
  //                                   // fontSize: 12.sp,
  //                                   // fontFamily: robottoFontTextStyle,
  //                                   // ),
  //                                 ),
  //                               ),
  //                             );
  //                 },
  //                 onDayLongPressed: (DateTime date) {
  //                   //                Get.to(GiftScreen());
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 12.h),
  //         SizedBox(height: 12.h),
  //       ],
  //     ),
  //   );
  // }

}
