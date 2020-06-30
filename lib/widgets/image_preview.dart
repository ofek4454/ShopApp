import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String imageURL;

  ImagePreview({@required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10),
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey),
      ),
      alignment: Alignment.center,
      child: imageURL.isEmpty
          ? Text(
              'image preview',
              textAlign: TextAlign.center,
            )
          : Image.network(
              imageURL,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return Center(
                    child: Text(
                  'url isnt an image',
                  textAlign: TextAlign.center,
                ));
              },
              loadingBuilder: (ctx, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
