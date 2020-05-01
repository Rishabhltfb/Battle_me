import 'dart:io';

import 'package:battle_me/scoped_models/main_scoped_model.dart';
import 'package:battle_me/screens/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

class Uploader extends StatefulWidget {
  final File file;
  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://cracknet-app.appspot.com');

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  void _startUpload() {
    /// Unique file name for the file
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return StreamBuilder<StorageTaskEvent>(
              stream: _uploadTask.events,
              builder: (_, snapshot) {
                var event = snapshot?.data?.snapshot;

                double progressPercent = event != null
                    ? event.bytesTransferred / event.totalByteCount
                    : 0;
                return Column(
                  children: [
                    _uploadTask.isComplete
                        ? Text('Successfuly Uploaded')
                        : Container(),

                    _uploadTask.isPaused
                        ? FlatButton(
                            child: Icon(Icons.play_arrow),
                            onPressed: _uploadTask.resume,
                          )
                        : Container(),

                    _uploadTask.isInProgress
                        ? FlatButton(
                            child: Icon(Icons.pause),
                            onPressed: _uploadTask.pause,
                          )
                        : Container(),

                    // Progress bar
                    LinearProgressIndicator(
                      value: progressPercent,
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    Text(
                      '${(progressPercent * 100).toStringAsFixed(2)} % ',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ],
                );
              });
        },
      );
    } else {
      // Allows user to decide when to start the upload
      return FlatButton.icon(
        color: Theme.of(context).accentColor,
        label: Text('Upload to Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}
