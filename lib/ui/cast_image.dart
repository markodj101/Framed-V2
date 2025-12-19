import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/ui/theme/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CastImage extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String? character;

  const CastImage({
    super.key,
    required this.imageUrl,
    required this.name,
    this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start, // Top align
      children: [
        SizedBox(width: 76, height: 78, child: getAvatar()),
        addVerticalSpace(6),
        Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.white,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (character != null && character!.isNotEmpty) ...[
          addVerticalSpace(2),
          Align(
            alignment: Alignment.center,
            child: AutoSizeText(
              character!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }


  Widget getAvatar() {
    if (imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 38,
        backgroundImage: CachedNetworkImageProvider(
          imageUrl,
          maxHeight: 76,
          maxWidth: 76,
        ),
      );
    } else {
      return const CircleAvatar(
        radius: 38,
        backgroundColor: buttonGrey,
        child: Icon(Icons.person, size: 40, color: Colors.black),
      );
    }
  }


}
