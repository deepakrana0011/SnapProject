import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:snap_app/constants/validations.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:snap_app/helper/dialog_helper.dart';
import 'package:snap_app/locator.dart';
import 'package:snap_app/provider/voice_provider.dart';
import 'package:snap_app/view/base_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart' as path;

class VoiceScreen extends StatelessWidget {
  VoiceScreen({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  VoiceProvider voiceProvider = locator<VoiceProvider>();
  String _timerText = '00:00:00';

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return GestureDetector(
      onTap: () {
        CommonWidgets.hideKeyboard(context);
      },
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: ColorConstants.backgroundColor,
          appBar: CommonWidgets.appBar(context, "voice".tr()),
          body: BaseView<VoiceProvider>(
            onModelReady: (provider)  {
              voiceProvider = provider;
              _mPlayer!.openPlayer().then((value) {
                _mPlayerIsInited = true;
                provider.updateRecord(true);
              });
              openTheRecorder(context).then((value) {
                _mRecorderIsInited = true;
                provider.updateRecord(true);
              });
            },
            builder: (context, provider, _) {
              return Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
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
                       // makeBody(),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: DimensionConstants.d40.h,
                              ),
                              Container(
                                child: Center(
                                  child: Text(_timerText).regularText(ColorConstants.colorRed, DimensionConstants.d46.sp, TextAlign.center),
                                ),
                              ),
                              SizedBox(height: DimensionConstants.d20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CommonWidgets.recordStopBtn(
                                    icon: Icons.mic,
                                    iconColor: ColorConstants.colorRed,
                                    onPressFunc:  _mRecorder!.isStopped ? (){
                                      record(context);
                                    } : (){
                                      DialogHelper.showMessage(context, "Recording in going on");
                                    },
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  CommonWidgets.recordStopBtn(
                                    icon: Icons.stop,
                                    iconColor: ColorConstants.colorRed,
                                    onPressFunc: _mRecorder!.isStopped ? (){
                                      //DialogHelper.showMessage(context, "Recording stop");
                                    } : stopRecorder,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    elevation: 9.0, primary: Colors.red),
                                onPressed: getPlaybackFn(),
                                icon:  Icon(
                                  _mPlayer!.isPlaying
                                      ? Icons.stop : Icons.play_arrow
                                ),
                                label: Text(
                                  _mPlayer!.isPlaying
                                      ? "Stop" :  "Play",
                                        style: TextStyle(
                                          fontSize: 28,
                                        ),
                                      )
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              DimensionConstants.d20.w,
                              DimensionConstants.d55.h,
                              DimensionConstants.d20.w,
                              0.0),
                          child: Column(
                            children: [
                              emailTextField(),
                              SizedBox(height: DimensionConstants.d21.h),
                              provider.state == ViewState.busy
                                  ? const CircularProgressIndicator()
                                  : GestureDetector(
                                onTap: () async {
                                  if(_formKey.currentState!.validate()){
                                    if(_mRecorder!.isStopped){
                                      try{
                                        var recording = await _mRecorder!.getRecordURL(path: _mPath);
                                        provider.sendRecording(context, emailController.text, File(recording.toString())).then((value) {
                                          emailController.clear();
                                        });
                                      } catch(err){
                                        DialogHelper.showMessage(context, "something_went_wrong".tr());
                                      }
                                    } else{
                                      DialogHelper.showMessage(context, "Recording in going on");
                                    }

                                  }
                                },
                                child: CommonWidgets.commonBtn(
                                    context,
                                    "next".tr(),
                                    DimensionConstants.d63.h,
                                    DimensionConstants.d330.w),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      controller: emailController,
      style: ViewDecoration.textFieldStyle(
          DimensionConstants.d12, FontWeight.w400, ColorConstants.colorBlack),
      decoration: ViewDecoration.inputDecorationForEmailTextField(
          "email_address".tr(),
          EdgeInsets.fromLTRB(DimensionConstants.d23.w,
              DimensionConstants.d26.h, 0.0, DimensionConstants.d19.h)),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "email_required".tr();
        } else if (!Validations.emailValidation(
            value.trim())) {
          return "invalid_email".tr();
        } else {
          return null;
        }
      },
    );
  }

  // Below code is for voice recorder.
  static const theSource = AudioSource.microphone;

  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  final FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  final FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  var _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  StreamSubscription? _recorderSubscription;

  Future<void> _initializeExample() async {
    await _mPlayer?.closePlayer();
    await _mPlayer?.openPlayer();
    await _mPlayer?.setSubscriptionDuration(Duration(milliseconds: 10));
    await _mRecorder?.setSubscriptionDuration(Duration(milliseconds: 10));
    await initializeDateFormatting();
  }

  Future<void> openTheRecorder(BuildContext context) async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      // if (status != PermissionStatus.granted) {
      //   throw RecordingPermissionException('Microphone permission not granted');
      // } else
        if(status == PermissionStatus.permanentlyDenied){
        CommonWidgets.permissionErrorDialog(context, "microphone_permission".tr(), "microphone_permission_not_granted".tr());
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
    await _initializeExample();
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

  Future<void> record(BuildContext context) async {
    var status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      DialogHelper.showMessage(context, "microphone_permission_not_granted".tr());
    } else{
      _mRecorder!
          .startRecorder(
        toFile: _mPath,
        codec: _codec,
        audioSource: theSource,
      ).then((value) {
        voiceProvider.updateRecord(true);
      });
      _recorderSubscription = _mRecorder!.onProgress!.listen((e) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            e.duration.inMilliseconds,
            isUtc: true);
        var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

        _timerText = txt.substring(0, 8);
        voiceProvider.updateRecord(true);
      });
      // _recorderSubscription!.cancel();
  //    await voiceProvider.writeFileToStorage1(_mPath);
    }
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      //var url = value;
      _mplaybackReady = true;
      cancelRecorderSubscriptions();
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

  getRecorderFn(BuildContext context)  {
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

  Widget makeBody(BuildContext context) {
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
              onPressed: getRecorderFn(context),
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
