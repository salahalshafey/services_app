// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:photo_view/photo_view.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../builders/custom_alret_dialog.dart';
import '../builders/custom_snack_bar.dart';

import '../functions/string_manipulations_and_search.dart';
import 'linkify_text.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({
    required this.image,
    required this.imageSource,
    required this.radius,
    this.saveNetworkImageToLocalStorage = false,
    this.localStorageType = LocalStorage.applicationDocumentsDirectory,
    this.imageTitle,
    this.imageCaption,
    this.fit,
    this.shape = BoxShape.rectangle,
    this.border,
    this.borderRadius,
    this.containingShadow = false,
    this.showHighlight = false,
    this.showImageDialoge = false,
    this.showImageScreen = false,
    this.showLoadingIndicator = false,
    this.showLoadingProgress = true,
    this.loadingIndicatorType = LoadingIndicator.circle,
    this.errorBuilder,
    this.onTap,
    super.key,
  });

  ///  * [image] will represent a url if imageSource is [From.network],
  ///
  ///  * [image] will represent an asset source like "assets/images/image.jpg" if imageSource [From.asset],
  ///
  ///  * [image] will represent a path to the file if imageSource [From.file],
  ///
  ///  * [image] will represent a String converted from unit8List as {String.fromCharCodes(uint8list)} if imageSource [From.memory],
  final String image;
  final From imageSource;

  /// [radius] will multiply by 2 for both [width] and [height]
  final double radius;
  final bool saveNetworkImageToLocalStorage;

  /// * if [localStorageType] is [LocalStorage.applicationDocumentsDirectory] this means that the image will be saved in a location Hidden from the user but will not be removed by OS Cleanup, it will be removed when the App gets Uninstall.
  ///
  /// * if [localStorageType] is [LocalStorage.gallery] this means that the image will be saved in the Gallery.
  final LocalStorage localStorageType;

  /// the title that will be shown in the AppBar in [ImageScreen] if [showImageScreen] is true
  final String? imageTitle;

  /// the Caption that will be shown above the image in [ImageScreen] if [showImageScreen] is true
  final String? imageCaption;
  final BoxFit? fit;
  final BoxShape shape;
  final Border? border;

  /// Applies only to boxes with rectangular shapes; if [shape] is not [BoxShape.rectangle] error will be thrown.
  final BorderRadiusGeometry? borderRadius;
  final bool containingShadow;
  final bool showHighlight;
  final bool showImageDialoge;
  final bool showImageScreen;
  final bool showLoadingIndicator;
  final bool showLoadingProgress;
  final LoadingIndicator loadingIndicatorType;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  /// onTap will be ignored if showImageDialoge = true OR showImageScreen = true
  final void Function()? onTap;

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  @override
  Widget build(BuildContext context) {
    if (widget.imageSource == From.network &&
        widget.saveNetworkImageToLocalStorage) {
      return FutureBuilder(
          future: _imageLocalPath(widget.image),
          builder: ((context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: widget.radius * 2,
                height: widget.radius * 2,
              );
            }
            // if image already saved in a local storage
            if (snapshot.data != null) {
              final path = snapshot.data!;
              return _imagContainerBuilder(
                image: path,
                imageSource: From.file,
              );
            }
            // if the image is not saved before, download And Save it
            return FutureBuilder(
                future: _downloadAndSaveTheImage(
                  widget.image,
                  widget.localStorageType,
                ),
                builder: ((context, AsyncSnapshot<String> downloadSnapshot) {
                  if (downloadSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox(
                      width: widget.radius * 2,
                      height: widget.radius * 2,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  final path = downloadSnapshot.data!;
                  return _imagContainerBuilder(
                    image: path,
                    imageSource: From.file,
                  );
                }));
          }));
    }

    return _imagContainerBuilder();
  }

  _ImageContainer _imagContainerBuilder({String? image, From? imageSource}) {
    return _ImageContainer(
      image: image ?? widget.image,
      imageSource: imageSource ?? widget.imageSource,
      radius: widget.radius,
      imageTitle: widget.imageTitle,
      imageCaption: widget.imageCaption,
      fit: widget.fit,
      shape: widget.shape,
      border: widget.border,
      borderRadius: widget.borderRadius,
      containingShadow: widget.containingShadow,
      showHighlight: widget.showHighlight,
      showImageDialoge: widget.showImageDialoge,
      showImageScreen: widget.showImageScreen,
      showLoadingIndicator: widget.showLoadingIndicator,
      showLoadingProgress: widget.showLoadingProgress,
      loadingIndicatorType: widget.loadingIndicatorType,
      errorBuilder: widget.errorBuilder,
      onTap: widget.onTap,
      key: widget.key,
    );
  }

  Future<String?> _imageLocalPath(String networkImage) async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final docPath = '${docDir.path}/${networkImage.hashCode}.jpeg';
      final existsIndir = await File(docPath).exists();
      if (existsIndir) {
        return docPath;
      }
    } catch (_) {
      return null;
    }

    // return null if image not exists in a local path
    return null;
  }

  Future<String> _downloadAndSaveTheImage(
    String networkImage,
    LocalStorage storageType,
  ) async {
    try {
      if (storageType == LocalStorage.applicationDocumentsDirectory) {
        final docDir = await getApplicationDocumentsDirectory();
        final docPath = '${docDir.path}/${networkImage.hashCode}.jpeg';

        await Dio().download(
          networkImage,
          docPath,
        );
        return docPath;
      }

      final docDir = await getApplicationDocumentsDirectory();
      final docPath = '${docDir.path}/${networkImage.hashCode}.jpeg';

      await Dio().download(networkImage, docPath);
      await GallerySaver.saveImage(
        docPath,
        albumName: (await PackageInfo.fromPlatform()).appName,
      );
      return docPath;
    } catch (_) {
      return '';
    }
  }
}

class _ImageContainer extends StatefulWidget {
  const _ImageContainer({
    required this.image,
    required this.imageSource,
    required this.radius,
    this.imageTitle,
    this.imageCaption,
    this.fit,
    this.shape = BoxShape.rectangle,
    this.border,
    this.borderRadius,
    this.containingShadow = false,
    this.showHighlight = false,
    this.showImageDialoge = false,
    this.showImageScreen = false,
    this.showLoadingIndicator = false,
    this.showLoadingProgress = true,
    this.loadingIndicatorType = LoadingIndicator.circle,
    this.errorBuilder,
    this.onTap,
    super.key,
  });

  final String image;
  final From imageSource;
  final double radius;
  final String? imageTitle;
  final String? imageCaption;
  final BoxFit? fit;
  final BoxShape shape;
  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final bool containingShadow;
  final bool showHighlight;
  final bool showImageDialoge;
  final bool showImageScreen;
  final bool showLoadingIndicator;
  final bool showLoadingProgress;
  final LoadingIndicator loadingIndicatorType;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final void Function()? onTap;

  @override
  State<_ImageContainer> createState() => __ImageContainerState();
}

class __ImageContainerState extends State<_ImageContainer> {
  double _opacity = 0.0;
  double _offset = 4;
  late Border _border;

  @override
  void initState() {
    _border = widget.border ??
        Border.all(
          width: 0,
          color: Colors.white.withOpacity(1),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        Container(
          width: 2 * widget.radius,
          height: 2 * widget.radius,
          decoration: BoxDecoration(
            border: _border,
            shape: widget.shape,
            color: Colors.white,
            boxShadow: widget.containingShadow == false
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 5.0,
                      offset: Offset(_offset, _offset),
                      spreadRadius: 0.5,
                    ),
                  ],
            borderRadius: widget.borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: Hero(
            tag: widget.image,
            child: widget.imageSource == From.asset
                ? Image.asset(
                    widget.image,
                    fit: widget.fit,
                    errorBuilder: widget.errorBuilder ?? _errorBuilder,
                  )
                : widget.imageSource == From.network
                    ? Image.network(
                        widget.image,
                        fit: widget.fit,
                        loadingBuilder: widget.showLoadingIndicator
                            ? _loadingBuilder
                            : null,
                        errorBuilder: widget.errorBuilder ?? _errorBuilder,
                      )
                    : widget.imageSource == From.file
                        ? Image.file(
                            File(widget.image),
                            fit: widget.fit,
                            errorBuilder: widget.errorBuilder ?? _errorBuilder,
                          )
                        : Image.memory(
                            Uint8List.fromList(widget.image.codeUnits),
                            fit: widget.fit,
                            errorBuilder: widget.errorBuilder ?? _errorBuilder,
                          ),
          ),
        ),
        Container(
          width: 2 * widget.radius,
          height: 2 * widget.radius,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(_opacity),
            border: _border,
            shape: widget.shape,
            borderRadius: widget.borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkResponse(
            onHighlightChanged:
                widget.showHighlight ? _onHighlightChanged : null,
            onTap: (widget.showImageDialoge || widget.showImageScreen)
                ? () {
                    if (widget.showImageDialoge) {
                      _showImageDialog(context, widget.showImageScreen);
                    } else if (widget.showImageScreen) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageScreen(
                            widget.image,
                            widget.imageSource,
                            widget.imageTitle ?? ' ',
                            widget.imageCaption,
                            widget.errorBuilder,
                          ),
                        ),
                      );
                    }
                  }
                : widget.onTap ?? (widget.showHighlight ? () {} : null),
          ),
        ),
      ],
    );
  }

  Widget _loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;

    return Center(
      child: widget.loadingIndicatorType == LoadingIndicator.circle
          ? CircularProgressIndicator(
              value: widget.showLoadingProgress
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            )
          : LinearProgressIndicator(
              value: widget.showLoadingProgress
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
    );
  }

  Widget _errorBuilder(BuildContext context, Object error,
          StackTrace? stackTrace) => // return scafold
      Center(
        child: Icon(
          Icons.broken_image,
          size: 40,
          color: Colors.grey.shade400,
        ),
      );
  //const Center(child: Text('Some errors occurred!'));

  void _onHighlightChanged(bool changed) {
    if (changed) {
      setState(() {
        _offset = 1;
        _opacity = 0.3;
        _border = _border.copyWith(width: _border.bottom.width * 1.5);
      });
    } else {
      setState(() {
        _offset = 4;
        _opacity = 0.0;
        _border = _border.copyWith(width: _border.bottom.width / 1.5);
      });
    }
  }

  void _showImageDialog(BuildContext context, bool showImageScreen) {
    /*final screenHeight = MediaQuery.of(context).size.height;
    var imageDialogHeight = 0.0;
    if (screenHeight < 400) {
      imageDialogHeight = screenHeight * 0.8;
    } else {
      imageDialogHeight = screenHeight * 0.5;
    }*/

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    Navigator.of(context).push(
      PageRouteBuilder(
          opaque: false,
          barrierDismissible: true,
          pageBuilder: (context, _, __) {
            return Scaffold(
              backgroundColor: Colors.black54,
              body: Column(
                children: [
                  _popBuilder(context),
                  Expanded(
                    flex: isPortrait ? 1 : 5,
                    child: Row(
                      children: [
                        _popBuilder(context),
                        Hero(
                          tag: widget.image,
                          child: GestureDetector(
                            onTap: () {
                              if (!showImageScreen) return;
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageScreen(
                                    widget.image,
                                    widget.imageSource,
                                    widget.imageTitle ?? ' ',
                                    widget.imageCaption,
                                    widget.errorBuilder,
                                  ),
                                ),
                              );
                            },
                            child: widget.imageSource == From.asset
                                ? Image.asset(
                                    widget.image,
                                    fit: widget.fit,
                                    errorBuilder:
                                        widget.errorBuilder ?? _errorBuilder,
                                  )
                                : widget.imageSource == From.network
                                    ? Image.network(
                                        widget.image,
                                        fit: widget.fit,
                                        loadingBuilder:
                                            widget.showLoadingIndicator
                                                ? _loadingBuilder
                                                : null,
                                        errorBuilder: widget.errorBuilder ??
                                            _errorBuilder,
                                      )
                                    : widget.imageSource == From.file
                                        ? Image.file(
                                            File(widget.image),
                                            fit: widget.fit,
                                            errorBuilder: widget.errorBuilder ??
                                                _errorBuilder,
                                          )
                                        : Image.memory(
                                            Uint8List.fromList(
                                                widget.image.codeUnits),
                                            fit: widget.fit,
                                            errorBuilder: widget.errorBuilder ??
                                                _errorBuilder,
                                          ),
                          ),
                        ),
                        _popBuilder(context),
                      ],
                    ),
                  ),
                  _popBuilder(context),
                ],
              ),
            );
          }),
    );
  }

  Expanded _popBuilder(BuildContext context) => Expanded(
        child: GestureDetector(onTap: () => Navigator.of(context).pop()),
      );
}

class ImageScreen extends StatefulWidget {
  const ImageScreen(
    this.image,
    this.imageSource,
    this.title,
    this.caption,
    this.errorBuilder, {
    super.key,
  });

  final String image;
  final From imageSource;
  final String title;
  final String? caption;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool _showAppBar = true;

  void _toggolShowingAppBar() {
    setState(() {
      _showAppBar = !_showAppBar;
    });
  }

  /* @override
  void dispose() {
    // This will show both the top status bar and the bottom navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final captionMaxHeight = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _showAppBar
          ? AppBar(
              title: FittedBox(child: Text(widget.title)),
              backgroundColor: Colors.black54,
              elevation: 0,
              actions: [
                DownloadButton(widget.image, widget.imageSource),
                _ShareButton(
                  image: widget.image,
                  imageSource: widget.imageSource,
                  title: widget.title,
                  caption: widget.caption,
                ),
                const SizedBox(width: 10),
              ],
            )
          : null,
      body: Stack(
        children: [
          GestureDetector(
            onTap: _toggolShowingAppBar,
            child: Container(
              color: Colors.black,
              child: PhotoView(
                heroAttributes: PhotoViewHeroAttributes(tag: widget.image),
                imageProvider: widget.imageSource == From.asset
                    ? AssetImage(widget.image)
                    : widget.imageSource == From.network
                        ? NetworkImage(widget.image)
                        : widget.imageSource == From.file
                            ? FileImage(File(widget.image)) as ImageProvider
                            : MemoryImage(
                                Uint8List.fromList(widget.image.codeUnits)),
                initialScale: PhotoViewComputedScale.contained * 1.0,
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.contained * 4.0, // 3.0
                errorBuilder: widget.errorBuilder,
              ),
            ),
          ),
          if (widget.caption != null && _showAppBar)
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: widget.caption!.textHeight(context) > captionMaxHeight
                    ? captionMaxHeight
                    : null,
                /*  height: widget.caption!.length > 700
                    ? MediaQuery.of(context).size.height * 0.6
                    : null,*/
                alignment: Alignment.center,
                child: SelectableLinkifyText(
                  text: widget.caption!,
                  textAlign: TextAlign.justify,
                  textDirection: firstCharIsRtl(widget.caption!)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  linkStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    // decoration: TextDecoration.underline,
                  ),
                  onOpen: (link, linkType) {
                    if (linkType == TextType.phoneNumber) {
                      launchUrl(Uri.parse('tel:$link'));
                    } else if (linkType == TextType.email) {
                      launchUrl(Uri.parse('mailto:$link'));
                    } else if (link.startsWith('www.')) {
                      launchUrl(
                        Uri.parse('https:$link'),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      launchUrl(
                        Uri.parse(link),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DownloadButton extends StatefulWidget {
  const DownloadButton(this.image, this.imageSource, {super.key});

  final String image;
  final From imageSource;

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool _imageDownloaded = false;
  bool _isImageDownloading = false;

  /*Future<bool> _checkIfImageAlreadySavedInGallery() async {
    final tempDir =
        await getApplicationDocumentsDirectory(); // should be getGalleryDirectory or something like that
    final path = '${tempDir.path}/${widget.image.hashCode}.jpeg';

    return (await File(path).exists());
  }*/

  void _loadingState(bool state) {
    setState(() {
      _isImageDownloading = state;
    });
  }

  void _saveImageToGallery() async {
    bool? savedToGallery;

    try {
      _loadingState(true);
      final path = await _saveAnySourceOfImageToTempDir(
        widget.image,
        widget.imageSource,
      );

      savedToGallery = await GallerySaver.saveImage(
        path,
        albumName: (await PackageInfo.fromPlatform()).appName,
      );
    } catch (error) {
      _loadingState(false);
      showCustomAlretDialog(
        context: context,
        title: AppLocalizations.of(context)!.error,
        content: AppLocalizations.of(context)!.errorHappenedWhileSavingTheImage,
        titleColor: Colors.red,
      );
      return;
    }

    _loadingState(false);
    if (savedToGallery == null || !savedToGallery) {
      showCustomAlretDialog(
        context: context,
        title: AppLocalizations.of(context)!.error,
        content: AppLocalizations.of(context)!.errorHappenedWhileSavingTheImage,
        titleColor: Colors.red,
      );

      return;
    }

    setState(() {
      _imageDownloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isImageDownloading
        ? const Center(child: CircularProgressIndicator())
        : IconButton(
            icon: !_imageDownloaded
                ? const Icon(Icons.download)
                : const Icon(Icons.download_done, color: Colors.white),
            tooltip: !_imageDownloaded
                ? AppLocalizations.of(context)!.saveToGallery
                : AppLocalizations.of(context)!.imageSavedToGallery,
            onPressed: !_imageDownloaded ? _saveImageToGallery : null,
          );
  }
}

class _ShareButton extends StatefulWidget {
  const _ShareButton({
    required this.image,
    required this.imageSource,
    this.title,
    this.caption,
  });

  final String image;
  final From imageSource;
  final String? title;
  final String? caption;

  @override
  State<_ShareButton> createState() => __ShareButtonState();
}

class __ShareButtonState extends State<_ShareButton> {
  bool _isLoading = false;

  void _loadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> _share() async {
    //final box = context.findRenderObject() as RenderBox?;

    try {
      _loadingState(true);
      final imagePath = await _saveAnySourceOfImageToTempDir(
          widget.image, widget.imageSource);

      _loadingState(false);
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: widget.caption,
        subject: widget.title,
        //sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } catch (error) {
      _loadingState(false);
      showCustomSnackBar(
        context: context,
        content: AppLocalizations.of(context)!
            .errorHappenedWhileTryingToShareTheImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : IconButton(
            tooltip: AppLocalizations.of(context)!.share,
            onPressed: _share,
            icon: const Icon(Icons.share),
          );
  }
}

Future<String> _getTempPathOfTheImage(String image) async {
  final tempDir = await getTemporaryDirectory();
  return '${tempDir.path}/${image.hashCode}.jpeg';
}

Future<String> _saveAnySourceOfImageToTempDir(
  String image,
  From imageSource,
) async {
  String path = image;

  if (imageSource == From.network) {
    path = await _getTempPathOfTheImage(image);

    await Dio().download(image, path);
  } else if (imageSource == From.asset) {
    final byteData = await rootBundle.load(image);

    path = await _getTempPathOfTheImage(image);

    final file = File(path);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  } else if (imageSource == From.memory) {
    path = await _getTempPathOfTheImage(image);

    final file = File(path);
    await file.writeAsBytes(Uint8List.fromList(image.codeUnits));
  }

  return path;
}

extension on Border {
  Border copyWith({
    Color? color,
    double? width,
    BorderStyle? style,
  }) =>
      Border.all(
        color: color ?? top.color,
        width: width ?? top.width,
        style: style ?? top.style,
      );
}

///
/// this extension used to calculate the the acual height of the text
/// above the image screen (caption)
///
extension on String {
  Size get textSize {
    // text style that used inside SelectableLinkifyText
    TextStyle textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 18,
    );

    // Create a TextPainter
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: textStyle),
      textAlign: TextAlign.justify,
      textDirection:
          firstCharIsRtl(this) ? TextDirection.rtl : TextDirection.ltr,
    );

    // Layout constraints, if any
    textPainter.layout();

    return Size(textPainter.width, textPainter.height);
  }

  /// calculate the the acual height of the text
  ///
  double textHeight(BuildContext context) {
    // 20 is the padding arround the text
    const padding = 20;

    final availableWidth = MediaQuery.of(context).size.width - padding;
    final lines = split("\n")..add("\n");

    double totalHeight = 0.0;
    for (final line in lines) {
      final lineSize = line.textSize;
      var actualLineCountNumbers = (lineSize.width / availableWidth).ceil();

      if (actualLineCountNumbers == 0) {
        actualLineCountNumbers = 1;
      }

      totalHeight += actualLineCountNumbers * lineSize.height;
    }

    return totalHeight + padding;
  }
}

enum From {
  network,
  asset,
  file,
  memory,
}

enum LoadingIndicator {
  circle,
  linear,
}

enum LocalStorage {
  applicationDocumentsDirectory,
  gallery,
}
