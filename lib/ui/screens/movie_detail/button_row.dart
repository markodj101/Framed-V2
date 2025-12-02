import 'package:flutter/material.dart';
import 'package:framed_v2/utils/utils.dart';
import 'package:framed_v2/ui/text_icon.dart';

typedef OnFavoriteSelected = void Function();

class ButtonRow extends StatefulWidget {
  final bool favoriteSelected;
  final OnFavoriteSelected onFavoriteSelected;
  const ButtonRow({
    super.key,
    required this.favoriteSelected,
    required this.onFavoriteSelected,
  });

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> with TickerProviderStateMixin {
  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _sizeAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _sizeController, curve: Curves.easeInOut),
    );
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(begin: Colors.white, end: Colors.red).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 0, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          TextIcon(
            text: Text(
              'Favorite',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            icon: IconButton(
              onPressed: () {
                widget.onFavoriteSelected();
              },
              icon: widget.favoriteSelected
                  ? AnimatedBuilder(
                      animation: Listenable.merge([
                        _sizeController,
                        _colorController,
                      ]),
                      builder: (context, child) {
                        return Icon(
                          Icons.favorite_outlined,
                          size: 21 * _sizeAnimation.value,
                          color: _colorAnimation.value,
                        );
                      },
                    )
                  : Icon(Icons.favorite_border, color: Colors.white),
            ),
          ),
          addHorizontalSpace(32),
          TextIcon(
            text: Text('Rate', style: Theme.of(context).textTheme.labelSmall),
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.thumbs_up_down_outlined,
                color: Colors.white,
              ),
            ),
          ),
          addHorizontalSpace(32),
          TextIcon(
            text: Text('Share', style: Theme.of(context).textTheme.labelSmall),
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
