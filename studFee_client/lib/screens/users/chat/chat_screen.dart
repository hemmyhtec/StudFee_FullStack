import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:studfees/util/config.dart';
import 'package:video_player/video_player.dart';

import '../../../models/message_model.dart';
import '../../../provider/user_provider.dart';

class ChatScreen extends StatefulWidget {
  final String receiver;
  const ChatScreen({super.key, required this.receiver});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  Duration? _position;
  Duration? _duration;
  String? _positionText;
  String? _durationText;
  List<dynamic> _messages = [];
  bool _showMediaPreview = false;
  VideoPlayerController? _videoPlayerController;
  AudioPlayer? _audioPlayer;
  final TextEditingController _messageController = TextEditingController();

  File? _mediaFIle;

  @override
  void dispose() {
    _messageController.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }
    if (_audioPlayer != null) {
      _audioPlayer!.stop();
      _audioPlayer!.release();
    }
    super.dispose();
  }

  void _getMessages() async {
    final user = Provider.of<UserProvider>(context).user;
    http.Response response = await http.get(
      Uri.parse('$url/chats/${user.admissionNumber}/${widget.receiver}'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-auth-token': user.token,
      },
    );
    final data = jsonDecode(response.body);
    setState(() {
      _messages = data;
      print(_messages);
    });
  }

  @override
  void initState() {
    _getMessages();
    super.initState();
  }

  void _sendMessage() async {
    final user = Provider.of<UserProvider>(context).user;
    final message = _messageController.text;
    if (message.isNotEmpty || _mediaFIle != null) {
      final data = {
        'sender': user.admissionNumber,
        'receiver': widget.receiver,
        'message': message,
      };
      if (_mediaFIle != null) {
        final mimeType = lookupMimeType(_mediaFIle!.path);
        final mediaFile = await MultipartFile.fromPath(
          'file',
          _mediaFIle!.path,
          contentType: MediaType.parse(mimeType!),
        );
        data['media'] = mediaFile.filename!;
      }

      await http.post(
        Uri.parse('$url/createChats'),
        body: jsonEncode(data),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'x-auth-token': user.token,
        },
      );
      _messageController.clear();
      setState(() {
        _mediaFIle = null;
        _showMediaPreview = false;
      });
      _getMessages();
    }
  }

  void _chooseFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      for (final file in result.files) {
        final mimeType = lookupMimeType(file.path!);
        if (mimeType?.startsWith('image') == true) {
          final CloudinaryResponse response = await Config.cloudinary
              .uploadFile(CloudinaryFile.fromFile(file.path!,
                  resourceType: CloudinaryResourceType.Image));
          setState(() {
            _mediaFIle = response.secureUrl as File?;
            _showMediaPreview = true;
          });
        } else if (mimeType?.startsWith('audio') == true) {
          _audioPlayer = AudioPlayer();
          await _audioPlayer!.setSourceUrl(file.path!);
          final CloudinaryResponse response = await Config.cloudinary
              .uploadFile(CloudinaryFile.fromFile(file.path!,
                  resourceType: CloudinaryResourceType.Auto));
          setState(() {
            _mediaFIle = response.secureUrl as File?;
            _showMediaPreview = true;
          });
        } else if (mimeType?.startsWith('video') == true) {
          _videoPlayerController = VideoPlayerController.file(File(file.path!));
          await _videoPlayerController!.initialize();
          final CloudinaryResponse response = await Config.cloudinary
              .uploadFile(CloudinaryFile.fromFile(file.path!,
                  resourceType: CloudinaryResourceType.Video));
          setState(() {
            _mediaFIle = response.secureUrl as File?;
            _showMediaPreview = true;
          });
        }
      }
    }
  }

  Widget _buildMessage(Message message) {
    final user = Provider.of<UserProvider>(context).user;
    return Row(
      mainAxisAlignment: message.sender == user.admissionNumber
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: message.sender == user.admissionNumber
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (message.message.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                    color: message.sender == user.admissionNumber
                        ? Colors.blue
                        : Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(message.message),
                ),
              if (message.mediaUrl != null)
                _buildMediaPreview(message.mediaUrl!),
              Text(
                message.date.toString(),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey.shade500,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMediaPreview(String url) {
    if (_showMediaPreview) {
      if (url.endsWith('.mp4')) {
        return AspectRatio(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController!),
        );
      } else if (url.endsWith('.mp3')) {
        return Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _audioPlayer!.state == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed: () {
                    if (_audioPlayer!.state == PlayerState.playing) {
                      _audioPlayer!.pause();
                    } else {
                      _audioPlayer!.resume();
                    }
                    setState(() {});
                  },
                ),
                Expanded(
                  child: Slider(
                    value: _position!.inMilliseconds.toDouble(),
                    min: 0.0,
                    max: _duration!.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _audioPlayer!
                            .seek(Duration(milliseconds: value.toInt()));
                      });
                    },
                  ),
                ),
                Text(
                  '${_positionText ?? ''} / ${_durationText ?? ''}',
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            if (_duration != null)
              StreamBuilder<Duration>(
                stream: _audioPlayer!.onDurationChanged,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  _durationText = durationToString(duration);
                  _duration = duration;
                  return Container();
                },
              ),
            if (_position != null && _duration != null)
              StreamBuilder<Duration>(
                stream: _audioPlayer!.onPositionChanged,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  _positionText = durationToString(position);
                  _position = position;
                  return Container();
                },
              ),
          ],
        );
      } else {
        return Image.network(
          url,
          fit: BoxFit.cover,
          height: 200,
          width: 200,
        );
      }
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            _showMediaPreview = true;
            if (url.endsWith('.mp4')) {
              _videoPlayerController = VideoPlayerController.network(url);
              _videoPlayerController!.initialize();
            } else if (url.endsWith('.mp3')) {
              _audioPlayer = AudioPlayer();
              _audioPlayer!.setSourceUrl(url);
              _audioPlayer!.resume();
            }
          });
        },
        child: Image.network(
          url,
          fit: BoxFit.cover,
          height: 200,
          width: 200,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          if (_showMediaPreview)
            Container(
              color: Colors.black,
              child: _mediaFIle!.path.endsWith('.mp4')
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio)
                  : Container(),
            ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {
                    _chooseFile();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    _chooseFile();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
