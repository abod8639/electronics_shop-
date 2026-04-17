import 'package:flutter/material.dart';
import 'package:electronics_shop/features/search/presentation/widgets/search_input_group.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/features/search/presentation/controllers/product_search_controller.dart';
import 'package:electronics_shop/features/home/presentation/widgets/price_filter_slider.dart';

const double _horizontalPadding = 16.0;
const double _verticalPadding = 12.0;
const double _searchBarHeight = 56.0;
const double _iconButtonSize = 48.0;

class CyberpunkShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cut = 12.0;
    path.moveTo(cut, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cut);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: _searchBarHeight + _verticalPadding * 2,
      titleSpacing: _horizontalPadding,
      title: const Hero(
        tag: 'searchBar',
        child: Material(color: Colors.transparent, 
        child:  SearchInputGroup()
        ),
      ),
    );
  }
}

Widget buildFilterButton({
  required ProductSearchController controller,
  required AppLocalizations l10n,
  Function()? onTap,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Container(
        width: _iconButtonSize,
        height: _iconButtonSize,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF00F7).withValues(alpha: .3),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipPath(
          clipper: CyberpunkShapeClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                right: const BorderSide(color: Color(0xFFFF00F7), width: 3),
                top: const BorderSide(color: Color(0xFFFF00F7), width: 1),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Color(0xFFFF00F7)),
              onPressed: onTap,
              tooltip: l10n.filter,
            ),
          ),
        ),
      );
    },
  );
}


void showFilterBottomSheet(BuildContext context, AppLocalizations l10n) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildHandle(context)),
            const SizedBox(height: 24),
            Text(
              l10n.filterProducts,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.priceOnRequest
                  .replaceAll("on request", '')
                  .replaceAll("عند الطلب", ''),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const PriceFilterSlider(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
  );
}

Widget _buildHandle(BuildContext context) => Container(
  width: 40,
  height: 4,
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.outlineVariant,
    borderRadius: BorderRadius.circular(2),
  ),
);
