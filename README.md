# time_slot_maker

An app module to schedule slots and book slots for appointment booking feature.

## about 
I got a task to implement slot booking functiionality - display slots on a UI screen in various chips , select one and confirm but slot booking functionality was not there , i searched a but didn't find any code in dart , so decided write it myself.

So , through time_slot_maker app module , there are two screens - \ 
* _Slotinfo.dart_ - this screen display the slots for a particular day using [Syncfusion_flutter_datePicker](https://pub.dev/packages/syncfusion_flutter_datepicker)
* _slot_schedular.dart_ - this screen is to create slot timings based on various factors such as start time, end time, gap between slots, duration of one slot in a time interval,days to reoeat that slot etc. user can also select date and time on which they are not available for which I have used [flutter_datetime_picker](https://pub.dev/packages/flutter_datetime_picker).



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
