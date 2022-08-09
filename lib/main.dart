import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Main(),
        );
      },
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  late SharedPreferences prefs;

  initialPref() async {
    prefs = await SharedPreferences.getInstance();
    getFromPref();
  }

  @override
  void initState() {
    initialPref();
    super.initState();
  }

  static List<String> _taskTitle = [];
  static List<String> _taskSubtitle = [];
  static List<String> _isDone = [];
  String _tasktitle = '';
  String _tasksubtitle = '';

  ////print preview
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 32.h),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 27, 0).r,
            child: Row(children: [
              Image.asset('images/gridview.png'),
              SizedBox(width: 35.w),
              Text(
                'My Tasks',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xffFA6262),
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    size: 23.0.sp,
                    color: const Color(0xffD1CDCD),
                  )),
            ]),
          ),
          SizedBox(height: 49.h),
          Padding(
            padding: const EdgeInsets.only(left: 20).r,
            child: Text(
              'What\'s on your mind?',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xffF97D7D),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          SizedBox(height: 39.h),
          Expanded(
            child: ListView.builder(
                itemCount: _taskSubtitle.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(22, 6, 39, 6).r,
                    child: InkWell(
                      onLongPress: () {
                        showBottomSheet(
                            _taskTitle[index], _taskSubtitle[index], index);
                        _tasktitle = _taskTitle[index];
                        _tasksubtitle = _taskSubtitle[index];
                      },
                      child: Container(
                        height: 99.h,
                        decoration: BoxDecoration(
                          // color: Colors.green,
                          color: _isDone[index] == '1'
                              ? Colors.green
                              : const Color(0xffFF4444),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: taskTile(
                            _taskTitle[index], _taskSubtitle[index], index),
                      ),
                    ),
                  );
                }),
          )
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffFF0000),
          onPressed: () {
            showBottomSheet(null, null, null);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void showBottomSheet(String? title, String? subtitle, int? index) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
        backgroundColor: Colors.white,
        // context: context,
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          // builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: 312.h,
                child: Padding(
                  padding: const EdgeInsets.only(left: 19, right: 19).r,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Container(
                                height: 6.h,
                                width: 143.w,
                                color: const Color(0xff797979)),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        const Text('Todo Title'),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: 330.w,
                          child: TextFormField(
                              initialValue: title,
                              decoration: InputDecoration(
                                  hintText: 'Todo title.....',
                                  hintStyle: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.r))),
                              onChanged: (value) {
                                _tasktitle = value;
                              }),
                        ),
                        SizedBox(height: 12.h),
                        const Text('Task'),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: 330.w,
                          child: TextFormField(
                              initialValue: subtitle,
                              decoration: InputDecoration(
                                  hintText: 'Write anything in your mind',
                                  hintStyle: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.r))),
                              onChanged: (value) {
                                _tasksubtitle = value;
                              }),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        InkWell(
                          onTap: () {
                            if (_tasktitle.isNotEmpty && index == null) {
                              addTask();
                            } else if (_tasktitle.isNotEmpty) {
                              editTask(index);
                            }

                            _tasksubtitle = '';
                            _tasktitle = '';

                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 57.h,
                              width: 359.w,
                              decoration: BoxDecoration(
                                color: const Color(0xff9D1212),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                  child: Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ))),
                        )
                      ]),
                ),
              ),
            ),
          );
        });
  }

  taskTile(title, subtitle, index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 11, 0).r,
      child: Row(children: [
        InkWell(
          onTap: () {
            setState(() {
              _isDone[index] = (_isDone[index] == '0' ? '1' : '0');
              saveToPref();
            });
          },
          child: Image.asset(
            'images/check-square.png',
          ),
        ),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10).r,
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        const Spacer(),
        InkWell(
            onDoubleTap: () {
              removeTask(index);
            },
            child: Image.asset('images/trash.png'))
      ]),
    );
  }

  void addTask() {
    _taskTitle.add(_tasktitle);
    _taskSubtitle.add(_tasksubtitle);
    _isDone.add('0');
    saveToPref();
    setState(() {});
  }

  void editTask(index) {
    _taskTitle[index] = _tasktitle;
    _taskSubtitle[index] = _tasksubtitle;
    saveToPref();
    setState(() {});
  }

  void removeTask(index) {
    _taskTitle.removeAt(index);
    _taskSubtitle.removeAt(index);
    _isDone.removeAt(index);
    saveToPref();
    setState(() {});
  }

  void saveToPref() {
    prefs.setStringList('tasktitle', _taskTitle);
    prefs.setStringList('tasksubtitle', _taskSubtitle);
    prefs.setStringList('isDone', _isDone);
  }

  void getFromPref() {
    _taskTitle = prefs.getStringList('tasktitle') ?? [];
    _taskSubtitle = prefs.getStringList('tasksubtitle') ?? [];
    _isDone = prefs.getStringList('isDone') ?? [];
    setState(() {});
  }
}
