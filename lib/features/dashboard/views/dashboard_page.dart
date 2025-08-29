import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/app_theme.dart';
import 'package:task_manager/features/tasks/views/all_tasks_page.dart';
import 'package:task_manager/features/tasks/views/create_task_page.dart';
import 'package:task_manager/features/tasks/views/home_page.dart';
import 'package:task_manager/features/dashboard/views/widgets/bottom_nav.dart';
import 'package:task_manager/utils/dimensions.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  bool _canExit = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _pageIndex);

    _screens = [
      const HomePage(),
      const CreateTaskPage(),
      const AllTasksPage(),
    ];

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async{
        if(_pageIndex != 0) {
          _setPage(0);
        }else {
          if(_canExit) {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Back Press Again to Exit', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.card)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
            margin:  EdgeInsets.all(Dimensions.marginSizeTen),
          ));
          _canExit = true;

          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        bottomNavigationBar: FancyBottomBar(
          index: _pageIndex,
          onTap: _setPage,
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

}
