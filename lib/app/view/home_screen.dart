import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:im_stepper/stepper.dart';
import 'package:rootally_task/app/components/circular_loader.dart';
import 'package:rootally_task/app/components/snackbar.dart';
import 'package:rootally_task/app/model/data_access.dart';
import 'package:rootally_task/app/model/excercise_session.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  int currentIndex = 0;
  int activeStep = 0;
  ScrollController sCtrl = ScrollController();
  bool sessionStarted = false;
  bool completionStatus = false;

  DataAccess dataFetch = DataAccess();
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int iconLength = 0;
  int currentSession = -1;
  bool isLoading = false;
  List<Session> sessions = <Session>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    assignSession();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            widget.currentIndex = value;
          });
        },
        showUnselectedLabels: true,
        showSelectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        currentIndex: widget.currentIndex,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today_outlined,
            ),
            activeIcon: Icon(
              Icons.calendar_today_outlined,
            ),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
            ),
            activeIcon: Icon(
              Icons.category,
            ),
            label: 'Rehab',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assistant_navigation,
            ),
            activeIcon: Icon(
              Icons.assistant_navigation,
            ),
            label: 'Demo',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            activeIcon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          setState(() {});
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(const Color(0xff255FD5)),
          side: MaterialStateProperty.all(
            const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          fixedSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width / 2.6,
                MediaQuery.of(context).size.height / 16),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide.none,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.only(
            left: 5,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
              ),
              Text(
                'Start Session',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 65, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning Jane',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.grey[850],
              ),
            ),
            Text(
              'You have $iconLength sessions today!',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[700]),
            ),
            isLoading
                ? Center(child: buildLoader())
                : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: IconStepper(
                            stepRadius: 17,
                            activeStep: widget.activeStep,
                            direction: Axis.vertical,
                            enableStepTapping: true,
                            activeStepBorderColor: Colors.transparent,
                            enableNextPreviousButtons: false,
                            icons: List.generate(
                              iconLength,
                              (index) {
                                setState(() {});
                                return sessions[index].sessionStatus ?? false
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xff255fd5),
                                      )
                                    : const Icon(
                                        Icons.radio_button_unchecked,
                                        size: 25,
                                        color: Colors.grey,
                                      );
                              },
                              growable: true,
                            ),
                            lineColor: Colors.grey,
                            lineLength: media.height / 5,
                            stepColor: Colors.transparent,
                            onStepReached: (index) {
                              setState(() {
                                widget.activeStep = index;
                              });
                            },
                            lineDotRadius: 0.75,
                            alignment: Alignment.topLeft,
                            activeStepBorderPadding: 0,
                            activeStepBorderWidth: 0,
                            stepPadding: 0,
                            scrollingDisabled: false,
                            activeStepColor: Colors.transparent,
                          ),
                        ),
                        Expanded(
                          child: isLoading
                              ? Center(child: buildLoader())
                              : FirebaseAnimatedList(
                                  query: widget.dataFetch.dataFetch(),
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder:
                                      (context, snapshot, animation, index) {
                                    var json =
                                        snapshot.value as Map<dynamic, dynamic>;
                                    final data = Session.fromJson(json);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, bottom: 5),
                                      child: Container(
                                        width: media.width / 2,
                                        height: media.height / 5,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          left: 15,
                                          right: 5,
                                          bottom: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                width: media.width / 3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      'Session ${index + 1}',
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .local_activity,
                                                            size: 13,
                                                            color: Color(
                                                                0xff5FA0CA),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 4.0),
                                                            child: Text(
                                                              data.sessionName
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xff5FA0CA),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12),
                                                              softWrap: true,
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    data.performedAt ?? false
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  widget
                                                                      .dataFetch
                                                                      .dataRef
                                                                      .child(
                                                                          'session${index + 1}')
                                                                      .child(
                                                                          'status')
                                                                      .set(
                                                                          true);
                                                                  assignSession();
                                                                });
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xff255FD5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                ),
                                                                width: media
                                                                        .width /
                                                                    3.5,
                                                                height: media
                                                                        .height /
                                                                    32,
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    'Completed',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    data.performedAt ?? false
                                                        ? Expanded(
                                                            child: RichText(
                                                              softWrap: true,
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              text: TextSpan(
                                                                  children: [
                                                                    const TextSpan(
                                                                      text:
                                                                          'Performed At',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    TextSpan(
                                                                        text:
                                                                            '\n${data.performedTime?.hour ?? '-'}:${data.performedTime?.minute ?? '-'} PM',
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                        ))
                                                                  ]),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              currentSession =
                                                                  index;
                                                              setState(() {});
                                                              widget.dataFetch
                                                                  .dataRef
                                                                  .child(
                                                                      'session${index + 1}')
                                                                  .child('time')
                                                                  .set(DateTime
                                                                          .now()
                                                                      .toString());
                                                              widget.dataFetch
                                                                  .dataRef
                                                                  .child(
                                                                      'session${index + 1}')
                                                                  .child(
                                                                      'performed')
                                                                  .set(true);
                                                            },
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .play_arrow_outlined,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                index == 0
                                                                    ? const Text(
                                                                        'Start Session',
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      )
                                                                    : Expanded(
                                                                        child:
                                                                            Text(
                                                                          'Finish Session $index to start',
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                data.imageSource.toString(),
                                                scale: 2,
                                                fit: BoxFit.fill,
                                                loadingBuilder: (context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return buildLoader();
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  //FUNCTION TO POPULATE LIST WITH THE FETCHED SESSION DATA.
  Future<void> assignSession() async {
    setState(() {
      isLoading = true;
    });
    sessions = await DataAccess.getSessions();
    print(sessions);
    setState(() {
      iconLength = sessions.length;
      if (sessions.isEmpty) {
        isLoading = false;
        showSnackBar(context: context, messg: 'Some Internal Error');
      } else {
        isLoading = false;
      }
    });
  }

  Future<void> checkCompletionStatus() async {}
}
