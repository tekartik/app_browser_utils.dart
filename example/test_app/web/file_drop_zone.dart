// ignore: deprecated_member_use
import 'dart:html'; // ignore: avoid_web_libraries_in_flutter
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:tekartik_common_utils/common_utils_import.dart';

bool _debugLog = false; // devWarning(true);

class FileDropZoneWidget {
  StreamSubscription<MouseEvent>? _onDragOverSubscription;
  StreamSubscription<MouseEvent>? _onDropSubscription;
  StreamSubscription<MouseEvent>? _onDragLeaveSubscription;
  StreamSubscription<Event>? _fileSelectionSubscription;
  final _dragStateStreamController = StreamController<_DragState>.broadcast();
  final _pointStreamController = StreamController<Point<double>?>.broadcast();

  void _onDragOver(MouseEvent value) {
    if (_debugLog) {
      print('_onDragOver: $value');
    }
    value.stopPropagation();
    value.preventDefault();
    _pointStreamController.sink
        .add(Point<double>(value.layer.x.toDouble(), value.layer.y.toDouble()));
    _dragStateStreamController.sink.add(_DragState.dragging);
  }

  void _onDrop(MouseEvent value) {
    if (_debugLog) {
      print('_onDrop: $value');
    }
    value.stopPropagation();
    value.preventDefault();
    _pointStreamController.sink.add(null);
    _addFiles(value.dataTransfer.files!);
  }

  void _onDragLeave(MouseEvent value) {
    if (_debugLog) {
      print('_onDragLeave: $value');
    }
    _dragStateStreamController.sink.add(_DragState.notDragging);
  }

  void _addFiles(List<File> newFiles) {
    var reader = FileReader();
    var lock = Lock();
    var index = 0;
    void stream() {
      () async {
        var data = reader.result;
        if (data is Uint8List) {
          Uint8List sub;
          var newIndex = data.length;
          if (newIndex > index) {
            sub = data.sublist(index, newIndex);
            index = newIndex;
            await lock.synchronized(() async {
              //await sleep(300);
              print('saving ${sub.length}');
            });
          }
        }
      }();
    }

    for (var file in newFiles) {
      print('file: ${file.name}');
      print('type: ${file.type}');
      print('size: ${file.size}');

      reader.readAsArrayBuffer(file);
      reader.onLoadStart.listen((pe) {
        print('start ${pe.loaded}/${pe.total}');
      });
      reader.onLoad.listen((pe) {
        print('load ${pe.loaded}/${pe.total}');
      });
      reader.onProgress.listen((pe) {
        print('progress ${pe.loaded}/${pe.total}');
        if (reader.result is List<int>) {
          print((reader.result as List).length);
        }
        stream();
      });
      reader.onLoadEnd.listen((pe) {
        print('end ${pe.loaded}/${pe.total}');
        print(reader.result.runtimeType);
        if (reader.result is List<int>) {
          print((reader.result as List).length);
        }
        stream();
      });
    }
    /*
    this.setState(() {
      this._files = this._files..addAll(newFiles);
      print(this._files);
    });

     */
  }

  void init() {
    _onDragOverSubscription = document.body!.onDragOver.listen(_onDragOver);
    _onDropSubscription = document.body!.onDrop.listen(_onDrop);
    _onDragLeaveSubscription = document.body!.onDragLeave.listen(_onDragLeave);
    //this._inputElement = FileUploadInputElement();//..style.display = 'none';
    //this._fileSelectionSubscription = this._inputElement.onChange.listen(_fileSelection);
  }

  void dispose() {
    _onDropSubscription?.cancel();
    _onDragOverSubscription?.cancel();
    _onDragLeaveSubscription?.cancel();
    _fileSelectionSubscription?.cancel();
    _dragStateStreamController.close();
    _pointStreamController.close();
    //super.dispose();
  }
/*
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints boxConstraints) => Stack(
      key: _stackKey,
      children: <Widget>[
        AnimatedContainer(
          curve: Curves.linear,
          duration: Duration(seconds: 1),
          width: double.infinity,
          height: double.infinity,
          color: this._files.isEmpty
              ? const Color(0xFF81d4fa)
              : const Color(0xFFff80ab),
          child: Padding(
            padding: const EdgeInsets.all(45),
            child: DottedBorder(
              color: const Color(0xFF263238),
              strokeWidth: 5.0,
              gap: 24.0,
              child: Center(
                child: Text(
                  'DropZONE',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: boxConstraints.maxWidth / 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF37474f),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          width: 140,
          height: 140,
          child: IconButton(
            alignment: Alignment.center,
            icon: Icon(
              Icons.settings,
            ),
            color: const Color(0xFF37474f),
            iconSize: 120,
            tooltip: 'Settings',
            onPressed: () async {
              //this._inputElement.click();

              await FileUploadInputElement().onChange.first;
              print('settings');
            },
          ),
        ),
        StreamBuilder(
            initialData: null,
            stream: this._pointStreamController.stream,
            builder: (BuildContext context,
                AsyncSnapshot<Point<double>> snapPoint) {
              var contained = false;
              Offset local;
              try {
                var renderObject = _stackKey.currentContext
                    .findRenderObject() as RenderBox;
                var size = renderObject.size;

                local = renderObject.globalToLocal(Offset(
                    snapPoint?.data?.x ?? -1.0,
                    snapPoint?.data?.y ?? -1.0));
                print('size $size point ${snapPoint?.data} $local');
                if (local.dx >= 0 &&
                    local.dy >= 0 &&
                    local.dx <= size.width &&
                    local.dy <= size.height) {
                  contained = true;
                }
                print('$size');
              } catch (_) {}
              return (snapPoint.data == null ||
                  snapPoint.data is! Point<double> ||
                  snapPoint.data == const Point<double>(0.0, 0.0))
                  ? Container()
                  : StreamBuilder(
                  initialData: null,
                  stream: this._dragStateStreamController.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<_DragState> snapState) =>
                  (snapState.data == null ||
                      snapState.data is! _DragState ||
                      snapState.data ==
                          _DragState.notDragging ||
                      local == null)
                      ? Container()
                      : Positioned(
                    height: 140,
                    width: 140,
                    left: local.dx,
                    top: local.dy,
                    child: Icon(
                      Icons.file_upload,
                      size: 120,
                      color: contained
                          ? Colors.white
                          : const Color(0xFFffa726),
                    ),
                  ));
            }),
      ],
    ),
  );

 */
}

enum _DragState {
  dragging,
  notDragging,
}
