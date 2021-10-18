import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'customInteractiveViewer.dart';
import 'mapIndexed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gallery Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Gallery Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController = PageController();
  TransformationController _transformationController = TransformationController();

  bool _isZoomedIn = false;
  // flag to block horizontal drag from PageView
  bool _isBlockHorizontalDrag = false;
  bool _isReachedLeftBoundary = false;
  bool _isReachedRightBoundary = false;

  int _pageNo = 0;

  List<String> _images = [
    'https://images.unsplash.com/photo-1616709555072-418df2a5b062?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80',
    'https://images.unsplash.com/photo-1632588417408-2ae5f733e4ec?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1493&q=80',
    'https://images.unsplash.com/photo-1616912839695-f9d00d78ea54?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=735&q=80',
    'https://images.unsplash.com/photo-1620878439728-a8f735a95e3f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80',
    'https://images.unsplash.com/photo-1623400518633-ee847bfd671a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80',
  ];

  bool _handleScroll(ScrollNotification notification) {
    // block horizontal drag from PageView if the drag is in the opposite direction after reached the boundaries
    if (_isZoomedIn) {
      if (_isReachedLeftBoundary && _pageController.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          _isBlockHorizontalDrag = true;
        });
      }

      if (_isReachedRightBoundary && _pageController.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          _isBlockHorizontalDrag = true;
        });
      }
    }

    return true;
  }

  void _onInteractionUpdate(var details) {
    // tap position in view's coordinate system
    double _viewX = 0;

    if (details is ScaleUpdateDetails) {
      _viewX = details.localFocalPoint.dx;
    } else if (details is DragUpdateDetails) {
      _viewX = details.localPosition.dx;
    }

    // tap postion in image's coordinate system
    double _imageX = 0;

    if (details is ScaleUpdateDetails) {
      _imageX = _transformationController.toScene(details.localFocalPoint).dx;
    } else if (details is DragUpdateDetails) {
      _imageX = _transformationController.toScene(details.localPosition).dx;
    }

    double _scale = _transformationController.value.getMaxScaleOnAxis();
    double _viewWidth = MediaQuery.of(context).size.width;

    // distances in x direction to boundaries in view's coordinate system
    double _dxToLeftBoundary = _imageX * _scale - _viewX;
    double _dxToRightBoundary = (_viewWidth - _imageX) * _scale - (_viewWidth - _viewX);

    if (_dxToLeftBoundary < 0.1) {
      _isReachedLeftBoundary = true;
    } else if (_dxToRightBoundary < 0.1) {
      _isReachedRightBoundary = true;
    } else {
      _isReachedLeftBoundary = false;
      _isReachedRightBoundary = false;
    }
  }

  void _onInteractionEnd(var details) {
    // using gesture to zoom out does not return an identity matrix but one close to it, therefore check the difference to the identity matrix
    _isZoomedIn = _transformationController.value.absoluteError(Matrix4.identity()) > 1e-9 ? true : false;

    if (_isZoomedIn && !(_isReachedLeftBoundary || _isReachedRightBoundary)) {
      setState(() {
        _isBlockHorizontalDrag = true;
      });
    } else {
      setState(() {
        _isBlockHorizontalDrag = false;
      });
    }
  }

  void _onPageChanged(int pageNo) {
    // reset zoom
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_transformationController.value != Matrix4.identity()) {
        _transformationController.value = Matrix4.identity();
      }

      setState(() {
        _pageNo = pageNo;
      });
    });

    setState(() {
      _isBlockHorizontalDrag = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScroll,
        child: PageView(
          allowImplicitScrolling: true,
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _images
              .mapIndexed(
                (image, i) => CustomInteractiveViewer(
                  // assign transformationController to the visible image only
                  transformationController: i == _pageNo ? _transformationController : null,
                  maxScale: 2.5,
                  minScale: 1,
                  onInteractionUpdate: _onInteractionUpdate,
                  onInteractionEnd: _onInteractionEnd,
                  isBlockHorizontalDrag: _isBlockHorizontalDrag,
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
