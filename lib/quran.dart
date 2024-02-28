import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quran extends StatefulWidget {
  final int? tdd;
  final int? voc;
  const Quran({
    super.key,
    required this.tdd,
    required this.voc,
  });

  @override
  State<Quran> createState() => _QuranState();
}

Color? backColor;
Color? itemColor;
IconData? ic;
int? td = 0;
int? volume = 0;
final audioPlayer = AudioPlayer();
bool isPlaying = false;
Duration duration = Duration.zero;
Duration position = Duration.zero;
String? asset = 'a (1).mp3';
String? nam = 'البروج';
Map data = {
  'names': [
    "البروج",
    "الإنشقاق",
    "الإنفطار",
    "التكوير",
    "عبس",
    "النازعات",
    "النبأ",
    "المرسلات",
    "الانسان",
    "القيامة",
    "المدثر",
    "المزمل",
    "الجن",
    "نوح",
    "المعارج",
    "الحاقة",
    "القلم",
    "الملك",
    "التحريم",
    "الطلاق",
    "التغابن",
  ],
  'times': [
    '02:25',
    '02:27',
    '02:16',
    '02:07',
    '03:21',
    '04:19',
    '04:14',
    '04:31',
    '04:57',
    '03:51',
    '05:23',
    '04:53',
    '05:31',
    '04:36',
    '04:51',
    '06:15',
    '06:46',
    '07:08',
    '06:06',
    '06:43',
    '07:27',
  ],
};
//format time
String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
}

//set audio
Future setAudio(String fff) async {
  audioPlayer.setReleaseMode(ReleaseMode.loop);
  final player = AudioCache(prefix: 'assets/السالمي1/');
  final lin = await player.load(fff);
  audioPlayer.setSourceUrl(
    lin.toString(),
  );
}

//Light Mode
light() {
  backColor = const Color(0xff44a1a0);
  itemColor = const Color(0xff0d5c63);
  ic = Icons.light_mode;
  td = 1;
}

//Dark Mode
dark() {
  backColor = Colors.black;
  itemColor = const Color.fromARGB(255, 30, 34, 39);
  ic = Icons.dark_mode;
  td = 0;
}

//Set Mode
settt() {
  if (td == 0) {
    dark();
  } else if (td == 1) {
    light();
  }
}

class _QuranState extends State<Quran> {
  @override
  void initState() {
    td = widget.tdd!;
    volume = widget.voc!;
    super.initState();
    setAudio(asset!);
    settt();
    //listeners
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPositin) {
      setState(() {
        position = newPositin;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: itemColor,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: itemColor,
          leadingWidth: 0,
          leading: const SizedBox(),
          actions: [
            //set sounds
            GestureDetector(
              onTap: () async {
                SharedPreferences prefSound =
                    await SharedPreferences.getInstance();
                setState(() {
                  if (volume == 0) {
                    final paly1 = AudioPlayer();
                    paly1.play(AssetSource("sounds/click-button-140881.mp3"));
                  }
                  if (volume == 0) {
                    volume = 1;
                  } else {
                    volume = 0;
                  }
                });
                prefSound.setInt("Mute", volume!);
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                child: Icon(
                  volume == 0 ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width.toDouble() / 14,
                ),
              ),
            ),
            //set colors
            GestureDetector(
              onTap: () async {
                SharedPreferences prefColor =
                    await SharedPreferences.getInstance();
                setState(() {
                  if (volume == 0) {
                    final paly1 = AudioPlayer();
                    paly1.play(AssetSource("sounds/click-button-140881.mp3"));
                  }
                  if (td == 0) {
                    light();
                  } else if (td == 1) {
                    dark();
                  }
                });
                prefColor.setInt("Dark", td!);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: 4,
                  left: 16,
                ),
                child: Icon(
                  ic,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width.toDouble() / 14,
                ),
              ),
            ),
          ],
          title: Text(
            'منصور السالمي',
            style: TextStyle(
              fontFamily: 'BigVesta-Arabic-Regular',
              fontSize: MediaQuery.of(context).size.width / 18,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 184,
          decoration: BoxDecoration(
            color: itemColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //audio player lable
              Text(
                'سورة $nam - القارئ منصور السالمي',
                style: TextStyle(
                  wordSpacing: 4,
                  fontFamily: 'BigVesta-Arabic-Regular',
                  fontSize: MediaQuery.of(context).size.width / 30,
                  color: Colors.white,
                ),
              ),
              //slider
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  await audioPlayer.resume();
                },
                activeColor: backColor,
                inactiveColor: Colors.white12,
              ),
              //timers
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTime(position),
                      style: TextStyle(
                        fontFamily: 'BigVesta-Arabic-Regular',
                        fontSize: MediaQuery.of(context).size.width / 30,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      formatTime(duration),
                      style: TextStyle(
                        fontFamily: 'BigVesta-Arabic-Regular',
                        fontSize: MediaQuery.of(context).size.width / 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //forward 10
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (volume == 0) {
                          final paly1 = AudioPlayer();
                          paly1.play(
                              AssetSource("sounds/click-button-140881.mp3"));
                        }
                        audioPlayer.seek(
                          Duration(
                            seconds: position.inSeconds.toInt() - 10,
                          ),
                        );
                      });
                    },
                    child: const Icon(
                      Icons.forward_10,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  //play and pause
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: backColor,
                    child: IconButton(
                        onPressed: () async {
                          setState(() {
                            if (volume == 0) {
                              final paly1 = AudioPlayer();
                              paly1.play(AssetSource(
                                  "sounds/click-button-140881.mp3"));
                            }
                          });
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.resume();
                          }
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 32,
                        )),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  //replay 10
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (volume == 0) {
                          final paly1 = AudioPlayer();
                          paly1.play(
                              AssetSource("sounds/click-button-140881.mp3"));
                        }
                        audioPlayer.seek(
                          Duration(
                            seconds: position.inSeconds.toInt() + 10,
                          ),
                        );
                      });
                    },
                    child: const Icon(
                      Icons.replay_10,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < 21; i++)
                //change surah
                GestureDetector(
                    onTap: () async {
                      setState(() {
                        if (volume == 0) {
                          final paly1 = AudioPlayer();
                          paly1.play(
                              AssetSource("sounds/click-button-140881.mp3"));
                        }
                        setAudio('a (${i + 1}).mp3');
                        nam = data['names'][i];
                      });
                      await audioPlayer.resume();
                    },
                    child: suraItem(
                      context,
                      data['names'][i],
                      data['times'][i],
                    )),
            ],
          ),
        ));
  }

  //sura item
  Column suraItem(
    BuildContext context,
    String str1,
    String str2,
  ) {
    return Column(
      children: [
        Container(
          color: backColor,
          height: 54,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/unnamed.jpg',
                  width: 48,
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 44,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'سورة $str1',
                        style: TextStyle(
                          fontFamily: 'BigVesta-Arabic-Regular',
                          fontSize: MediaQuery.of(context).size.width / 24,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        str2,
                        style: TextStyle(
                          fontFamily: 'BigVesta-Arabic-Regular',
                          fontSize: MediaQuery.of(context).size.width / 32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          height: 4,
          color: itemColor,
          thickness: 0.5,
        ),
      ],
    );
  }
}
