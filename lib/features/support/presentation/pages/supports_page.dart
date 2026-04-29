import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/constants/app_text_styles.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import '../controllers/support_providers.dart';
import '../widgets/support_category_card.dart';
import '../widgets/support_card.dart';

class SupportsPage extends ConsumerWidget {
  const SupportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsState = ref.watch(supportControllerProvider);
    final faqs = ref.watch(supportFAQProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(l10n),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(l10n),
                  const SizedBox(height: 24),
                  _buildSearchBar(l10n, ref),
                  const SizedBox(height: 32),
                  _buildSectionTitle(l10n.popularTopics),
                  const SizedBox(height: 16),
                  _buildCategoriesGrid(l10n),
                  const SizedBox(height: 32),
                  _buildSectionTitle(l10n.contactSupport),
                  const SizedBox(height: 16),
                  _buildContactOptions(l10n),
                  const SizedBox(height: 32),
                  _buildSectionTitle(l10n.myTickets, trailing: l10n.viewAll),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _buildTicketsList(ticketsState),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildSectionTitle(l10n.frequentlyAskedQuestions),
                  const SizedBox(height: 16),
                  _buildFAQList(faqs),
                  const SizedBox(height: 24),
                  _buildViewAllFAQButton(l10n),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppColors.backgroundDark.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.helpSupport.toUpperCase(),
        style: AppTextStyles.h3.copyWith(
          fontFamily: 'monospace',
          letterSpacing: 2,
          color: AppColors.cyan,
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.howCanWeHelp,
          style: AppTextStyles.h2.copyWith(
            color: AppColors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.cyan,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) =>
            ref.read(supportSearchQueryProvider.notifier).state = value,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          hintText: l10n.searchHelp,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
          prefixIcon: const Icon(Icons.search, color: AppColors.cyan),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.cyan.withValues(alpha: 0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.cyan.withValues(alpha: 0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.cyan),
          ),
          filled: true,
          fillColor: AppColors.surfaceDark,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        if (trailing != null)
          TextButton(
            onPressed: () {},
            child: Text(
              trailing,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.cyan,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoriesGrid(AppLocalizations l10n) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        SupportCategoryCard(
          icon: Icons.local_shipping_outlined,
          title: l10n.shippingReturns,
          onTap: () {},
        ),
        SupportCategoryCard(
          icon: Icons.payment_outlined,
          title: l10n.paymentsBilling,
          onTap: () {},
        ),
        SupportCategoryCard(
          icon: Icons.inventory_2_outlined,
          title: l10n.orderStatus,
          onTap: () {},
        ),
        SupportCategoryCard(
          icon: Icons.security_outlined,
          title: l10n.accountSecurity,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildContactOptions(AppLocalizations l10n) {
    return Row(
      children: [
        _buildContactCard(
            Icons.chat_bubble_outline, l10n.liveChat, AppColors.cyan),
        const SizedBox(width: 12),
        _buildContactCard(
            Icons.email_outlined, l10n.sendEmail, AppColors.magenta),
        const SizedBox(width: 12),
        _buildContactCard(Icons.phone_outlined, l10n.callUs, AppColors.primary),
      ],
    );
  }

  Widget _buildContactCard(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsList(AsyncValue ticketsState) {
    return ticketsState.when(
      data: (items) {
        if (items.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('No active tickets',
                  style: TextStyle(color: AppColors.grey)),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => SupportCard(entity: items[index]),
              childCount: items.length,
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Center(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: AppColors.cyan),
        )),
      ),
      error: (err, stack) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error: $err',
              style: const TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }

  Widget _buildFAQList(List<Map<String, String>> faqs) {
    return Column(
      children: faqs.map((faq) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.05)),
          ),
          child: Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: AppColors.cyan,
              collapsedIconColor: AppColors.grey,
              title: Text(
                faq['question']!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    faq['answer']!,
                    style:
                        AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildViewAllFAQButton(AppLocalizations l10n) {
    return Center(
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.cyan),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(
          l10n.viewAllFAQ.toUpperCase(),
          style: AppTextStyles.button.copyWith(
            color: AppColors.cyan,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}
