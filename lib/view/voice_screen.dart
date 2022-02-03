import 'package:audio_session/audio_session.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/decoration.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/route_constants.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:snap_app/locator.dart';
import 'package:snap_app/provider/voice_provider.dart';
import 'package:snap_app/view/base_view.dart';


class VoiceScreen extends StatelessWidget {
  VoiceScreen({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  VoiceProvider voiceProvider = locator<VoiceProvider>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.backgroundColor,
        appBar: CommonWidgets.appBar(context, "voice".tr()),
        body: BaseView<VoiceProvider>(
          onModelReady: (provider){
            voiceProvider = provider;
            _mPlayer!.openPlayer().then((value) {

              _mPlayerIsInited = true;
             provider.updateRecord(true);
            });

            openTheRecorder().then((value) {
                _mRecorderIsInited = true;
                provider.updateRecord(true);
            });
          },
          builder: (context, provider, _){
            return  Form(
              key: _formKey,
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: double.infinity,
                margin: EdgeInsets.only(top: DimensionConstants.d36.h),
                padding: EdgeInsets.only(top: DimensionConstants.d73.h),
                decoration: BoxDecoration(
                  color: ColorConstants.colorWhite,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(DimensionConstants.d44.r),
                    topLeft: Radius.circular(DimensionConstants.d44.r),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    //  mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: DimensionConstants.d73.h),
                      CommonWidgets.goodMorningText(),
                      makeBody(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            DimensionConstants.d20.w, DimensionConstants.d55.h,
                            DimensionConstants.d20.w, 0.0),
                        child: Column(
                          children: [
                            emailTextField(),
                            SizedBox(height: DimensionConstants.d21.h),
                            GestureDetector(
                              onTap: () {
                                //    Navigator.pushNamed(context, RouteConstants.otpVerify);
                              },
                              child: CommonWidgets.commonBtn(context, "next".tr(),
                                  DimensionConstants.d63.h,
                                  DimensionConstants.d330.w),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),),
            );
          },
        )
      ),
    );
  }

  Widget emailTextField() {
    return SizedBox(
      height: DimensionConstants.d63.h,
      child: TextFormField(
        controller: emailController,
        style: ViewDecoration.textFieldStyle(
            DimensionConstants.d12, FontWeight.w400, ColorConstants.colorBlack),
        decoration: ViewDecoration.inputDecorationForEmailTextField(
            "email_address".tr(), EdgeInsets.fromLTRB(
            DimensionConstants.d23.w, DimensionConstants.d26.h, 0.0,
            DimensionConstants.d19.h)),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          // if (value!.trim().isEmpty) {
          //   return "email_required".tr();
          // } else if (!Validations.emailValidation(
          //     value.trim())) {
          //   return "invalid_email".tr();
          // } else {
          //   return null;
          // }
        },
      ),
    );
  }

  static const theSource = AudioSource.microphone;

  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  final FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  final FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  var _mRecorderIsInited = false;
  bool _mplaybackReady = false;


  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }


  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      voiceProvider.updateRecord(true);
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {

        //var url = value;
        _mplaybackReady = true;
     voiceProvider.updateRecord(true);
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
        fromURI: _mPath,
        //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
        whenFinished: () {
          voiceProvider.updateRecord(true);
        })
        .then((value) {
      voiceProvider.updateRecord(true);
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      voiceProvider.updateRecord(true);
    });
  }

  getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  Widget makeBody() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(3),
          height: 80,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFFFAF0E6),
            border: Border.all(
              color: Colors.indigo,
              width: 3,
            ),
          ),
          child: Row(children: [
            ElevatedButton(
              onPressed: getRecorderFn(),
              //color: Colors.white,
              //disabledColor: Colors.grey,
              child: Text(_mRecorder!.isRecording ? 'Stop' : 'Record'),
            ),
            SizedBox(
              width: 20,
            ),
            Text(_mRecorder!.isRecording
                ? 'Recording in progress'
                : 'Recorder is stopped'),
          ]),
        ),
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(3),
          height: 80,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFFFAF0E6),
            border: Border.all(
              color: Colors.indigo,
              width: 3,
            ),
          ),
          child: Row(children: [
            ElevatedButton(
              onPressed: getPlaybackFn(),
              //color: Colors.white,
              //disabledColor: Colors.grey,
              child: Text(_mPlayer!.isPlaying ? 'Stop' : 'Play'),
            ),
            SizedBox(
              width: 20,
            ),
            Text(_mPlayer!.isPlaying
                ? 'Playback in progress'
                : 'Player is stopped'),
          ]),
        ),
      ],
    );
  }
}
