import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:bocaboca/Helpers/Styles.dart';

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Basic date field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              locale: Locale('pt_br'),
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}

class BasicTimeField extends StatelessWidget {
  final format = DateFormat("hh:mm a");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Basic time field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
      ),
    ]);
  }
}

class BasicDateTimeField extends StatefulWidget {
  String label;
  var icon;
  DateTime selectedDate;
  bool enable;
  String startingdate;
  BasicDateTimeField(
      {this.label = 'Data',
      this.icon = FontAwesomeIcons.calendarAlt,this.startingdate,
      this.enable = true});

  _BasicDateTimeFieldState myAppState = new _BasicDateTimeFieldState();
  @override
  _BasicDateTimeFieldState createState() => myAppState;
  bool Validate() {
    return myAppState.Validate();
  }
}

typedef ValidCallback = void Function();

class _BasicDateTimeFieldState extends State<BasicDateTimeField> {
  final format = DateFormat("dd/MM/yyyy HH:mm");
  TextEditingController controller = TextEditingController();

  bool hasBeenPressed = false;

  bool Validate() {
    if (controller.text != null) {
      try {
        DateTime v = format.parse(controller.text);
        print('AQUI ${v.toIso8601String()}');
        if (v.millisecondsSinceEpoch != null) {
          // print('Retornou AQUI');
          widget.selectedDate =
              DateTime.fromMillisecondsSinceEpoch(v.millisecondsSinceEpoch);
          return true;
        } else {
          setState(() {
            hasBeenPressed = true;
          });
          return false;
        }
      } catch (err) {
        print('Erro: ${err.toString()}');
        setState(() {
          hasBeenPressed = true;
        });
        return false;
      }
    } else {
      setState(() {
        hasBeenPressed = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = TextEditingController(text: widget.startingdate == null? '':widget.startingdate,);
    return Column(children: <Widget>[
      DateTimeField(
        controller: controller,
        format: format,
        autovalidate: true,
        enabled: widget.enable,
        onChanged: (v) {
          if (hasBeenPressed) {
            if (controller.text.isEmpty) {
              return 'É necessário selecionar a data';
            }
            if (v != null) {
              if (v.millisecondsSinceEpoch != null) {
                widget.selectedDate = DateTime.fromMillisecondsSinceEpoch(
                    v.millisecondsSinceEpoch);
              } else {
                return 'Erro: Data Invalida';
              }
            } else {
              return 'Erro: Data Invalida';
            }
          }
        },
        validator: (v) {
          if (hasBeenPressed) {
            if (controller.text.isEmpty) {
              return 'É necessário selecionar a data';
            }
            if (v != null) {
              if (v.millisecondsSinceEpoch != null) {
                widget.selectedDate = DateTime.fromMillisecondsSinceEpoch(
                    v.millisecondsSinceEpoch);
              } else {
                return 'Erro: Data Invalida';
              }
            } else {
              return 'Erro: Data Invalida';
            }
          }
        },
        decoration: InputDecoration(
            hintText: 'mm/dd hh:mm',
            labelText: widget.label,
            icon: Icon(
              widget.icon,
              color: corPrimaria,
            ),
            hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontStyle: FontStyle.italic)),
        onShowPicker: (context, currentValue) async {
          hasBeenPressed = true;
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );

            widget.selectedDate = DateTime.utc(
                date.year, date.month, date.day, time.hour, time.minute);
            print('AQUI ' + widget.selectedDate.toIso8601String());
            print('AQUI MES ${widget.selectedDate.month}');
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    ]);
  }
}

class IosStylePickers extends StatefulWidget {
  @override
  _IosStylePickersState createState() => _IosStylePickersState();
}

class _IosStylePickersState extends State<IosStylePickers> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  DateTime value;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('iOS style pickers (${format.pattern})'),
      DateTimeField(
        initialValue: value,
        format: format,
        onShowPicker: (context, currentValue) async {
          await showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoDatePicker(
                  onDateTimeChanged: (DateTime date) {
                    value = date;
                  },
                );
              });
          setState(() {});
          return value;
        },
      ),
    ]);
  }
}

class ComplexDateTimeField extends StatefulWidget {
  @override
  _ComplexDateTimeFieldState createState() => _ComplexDateTimeFieldState();
}

class _ComplexDateTimeFieldState extends State<ComplexDateTimeField> {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final initialValue = DateTime.now();

  bool autoValidate = false;
  bool readOnly = true;
  bool showResetIcon = true;
  DateTime value = DateTime.now();
  int changedCount = 0;
  int savedCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Complex date & time field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
        autovalidate: autoValidate,
        validator: (date) => date == null ? 'Invalid date' : null,
        initialValue: initialValue,
        onChanged: (date) => setState(() {
          value = date;
          changedCount++;
        }),
        onSaved: (date) => setState(() {
          value = date;
          savedCount++;
        }),
        resetIcon: showResetIcon ? Icon(Icons.delete) : null,
        readOnly: readOnly,
        decoration: InputDecoration(
            helperText: 'Changed: $changedCount, Saved: $savedCount, $value'),
      ),
      CheckboxListTile(
        title: Text('autoValidate'),
        value: autoValidate,
        onChanged: (value) => setState(() => autoValidate = value),
      ),
      CheckboxListTile(
        title: Text('readOnly'),
        value: readOnly,
        onChanged: (value) => setState(() => readOnly = value),
      ),
      CheckboxListTile(
        title: Text('showResetIcon'),
        value: showResetIcon,
        onChanged: (value) => setState(() => showResetIcon = value),
      ),
    ]);
  }
}

class Clock24Example extends StatelessWidget {
  final format = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('24 hour clock'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child),
          );
          return DateTimeField.convert(time);
        },
      ),
    ]);
  }
}

class LocaleExample extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Changing the pickers\' language'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: DateTime.now(),
            lastDate: DateTime(2100),
            builder: (context, child) => Localizations.override(
              context: context,
              locale: Locale('pt_br'),
              child: child,
            ),
          );
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              builder: (context, child) => Localizations.override(
                context: context,
                locale: Locale('pt_br'),
                child: child,
              ),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    ]);
  }
}
