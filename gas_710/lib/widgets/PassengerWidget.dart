import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class PassengerWidget extends StatelessWidget {
  final Contact passenger;
  final int index;
  final DismissDirectionCallback onDismissed;
  final GestureLongPressCallback onLongPress;

  final String noPhoneError = "NO PHONE NUMBER PROVIDED";

  PassengerWidget({
    Key key,
    @required this.passenger,
    @required this.index,
    @required this.onDismissed,
    @required this.onLongPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: onDismissed,
      child: Card(
        elevation: 4.0,
        child: ListTile(
          onLongPress: onLongPress,
          leading: (passenger.avatar != null &&
                passenger.avatar.length > 0)
            ? CircleAvatar(
                backgroundImage:
                    MemoryImage(passenger.avatar),
                maxRadius: 30,)
            : CircleAvatar(
                child: Text(passenger.initials(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  )
                ),
                backgroundColor: Colors.purple,
                maxRadius: 30,
              ),
          title: Text(
            passenger.displayName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          subtitle: Text(passenger.phones.isEmpty ? noPhoneError :
            passenger.phones.first.value.toString()
          ),
          trailing: Text((index + 1).toString()),
        )
      )
    );
  }
}