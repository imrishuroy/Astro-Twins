import '/blocs/auth/auth_bloc.dart';
import '/constants/constants.dart';
import '/widgets/display_image.dart';

import '/screens/nav/bloc/nav_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '/enums/nav_item.dart';

class BottomNavBar extends StatelessWidget {
  final NavItem? navItem;
  final Function(NavItem)? onitemSelected;

  const BottomNavBar({
    Key? key,
    required this.navItem,
    required this.onitemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: BottomNavigationBar(
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(color: Colors.orange),
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: NavItem.values.indexOf(navItem!),
        onTap: (index) => onitemSelected!(NavItem.values[index]),
        items: NavItem.values.map((item) {
          return BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ItemIcon(item: item),
            ),
            label: _label(item),
          );
        }).toList(),
      ),
    );
  }
}

class ItemIcon extends StatelessWidget {
  final NavItem item;
  const ItemIcon({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authBloc = context.read<AuthBloc>();
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        switch (item) {
          case NavItem.dashboard:
            return SvgPicture.asset(
              'assets/svgs/twins.svg',
              height: 20.0,
              width: 20.0,
              color: state.item == NavItem.dashboard ? Colors.red : Colors.grey,
              fit: BoxFit.cover,
            );
          case NavItem.astrologers:
            return SvgPicture.asset(
              'assets/svgs/astrologer.svg',
              height: 20.0,
              width: 20.0,
              color: state.item == NavItem.astrologers
                  ? Contants.primaryColor
                  : Colors.grey,
              fit: BoxFit.cover,
            );

          case NavItem.match:
            return SvgPicture.asset(
              'assets/svgs/match.svg',
              height: 20.0,
              width: 20.0,
              color: state.item == NavItem.match
                  ? Contants.primaryColor
                  : Colors.grey,
              fit: BoxFit.cover,
            );

          case NavItem.profile:
            return _authBloc.state.user?.profileImg != null
                ? CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Contants.primaryColor,
                    child: CircleAvatar(
                      radius: 8.7,
                      child: ClipOval(
                        child: DisplayImage(
                          imageUrl: _authBloc.state.user?.profileImg,
                          fit: BoxFit.cover,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                    ),
                  )
                : Icon(
                    Icons.account_circle,
                    color: state.item == NavItem.profile
                        ? Contants.primaryColor
                        : Colors.grey,
                  );

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

String _label(NavItem item) {
  if (item == NavItem.dashboard) {
    return 'Astro Twins';
  } else if (item == NavItem.match) {
    return 'Your Match';
  } else if (item == NavItem.astrologers) {
    return 'Astrologers';
  } else if (item == NavItem.profile) {
    return 'Profile';
  }

  return '';
}
