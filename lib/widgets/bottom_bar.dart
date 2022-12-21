import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  var selectedIndex = 0;

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                index: 0,
                onTap: handleItemSelected,
                lable: 'messaging',
                icon: CupertinoIcons.bubble_left_bubble_right_fill,
                isSelected: (selectedIndex == 0),
              ),
              _NavigationBarItem(
                index: 1,
                onTap: handleItemSelected,
                lable: 'Notification',
                icon: CupertinoIcons.bell_solid,
                isSelected: (selectedIndex == 1),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              //   child: GlowingActionButton(
              //       color: AppColors.secondary,
              //       icon: CupertinoIcons.add,
              //       onPressed: () {
              //         showDialog(
              //           context: context,
              //           builder: (BuildContext context) => const Dialog(
              //             child: AspectRatio(
              //               aspectRatio: 8 / 7,
              //               child: ContactsPage(),
              //             ),
              //           ),
              //         );
              //       }),
              // ),
              _NavigationBarItem(
                index: 2,
                onTap: handleItemSelected,
                lable: 'Calls',
                icon: CupertinoIcons.phone_fill,
                isSelected: (selectedIndex == 2),
              ),
              _NavigationBarItem(
                index: 3,
                onTap: handleItemSelected,
                lable: 'Contacts',
                icon: CupertinoIcons.person_2_fill,
                isSelected: (selectedIndex == 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    Key? key,
    required this.lable,
    required this.icon,
    required this.index,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final int index;
  final String lable;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(lable,
                style: isSelected
                    ? const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      )
                    : const TextStyle(
                        fontSize: 11,
                      )),
          ],
        ),
      ),
    );
  }
}
