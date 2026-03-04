import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/cubit/entrepreneur_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/cubit/entrepreneur_state.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/details/details_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/portfolio/portfolio_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/services/services_page.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/ui/helpers/messages.dart';
import 'modules/rating/rating_page.dart';

class EntrepreneurPage extends StatefulWidget {
  final int entrepreneurId;
  const EntrepreneurPage({required this.entrepreneurId, super.key});

  @override
  State<EntrepreneurPage> createState() => _EntrepreneurPageState();
}

class _EntrepreneurPageState extends State<EntrepreneurPage>
    with TickerProviderStateMixin, Messages<EntrepreneurPage> {
  double stars = 0.0;
  TabController? _tabController;
  bool favorite = false;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  List<String> _computeTabs(Entrepreneur entrepreneur) {
    return [
      'Serviços',
      'Avaliações',
      if (entrepreneur.description?.isNotEmpty == true) 'Sobre',
      if (entrepreneur.imagesID?.isNotEmpty == true) 'Portfólio',
      'Detalhes',
    ];
  }

  // Garante que o TabController tenha o length correto.
  // Seguro chamar dentro de build() pois não chama setState.
  void _ensureTabController(int length) {
    if (_tabController?.length != length) {
      _tabController?.dispose();
      _tabController = TabController(length: length, vsync: this);
    }
  }

  double calculateStars(List<Rating> ratings) {
    stars = 0.0;
    for (var i = 0; i < ratings.length; i++) {
      stars = stars + ratings[i].rating;
    }
    stars = ratings.isNotEmpty ? stars / ratings.length : 0.0;
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<EntrepreneurCubit, EntrepreneurState>(
        listener: (context, state) {
          state.status.matchAny(
            error: () {
              showError(state.errorMessage ?? "Erro não Informado");
              Modular.to.pop();
            },
            any: () {},
          );
        },
        builder: (context, state) {
          if (state.entrepreneur != null) {
            final entrepreneur = state.entrepreneur!;
            final tabs = _computeTabs(entrepreneur);
            _ensureTabController(tabs.length);

            final screenHeight = MediaQuery.of(context).size.height;
            final screenWidth = MediaQuery.of(context).size.width;

            return Column(
              children: [
                // Imagem do perfil
                SizedBox(
                  height: screenHeight * 0.35,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Image.network(
                          '${Environments.get('BASE_URL')}/images/profile/${entrepreneur.id}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Image.asset(
                                'assets/images/dark_logo.png',
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top,
                        left: 0,
                        child: Container(
                          width: 40,
                          height: 30,
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () => Modular.to.pop(),
                              child: Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: context.colors.decorationPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Botão de compartilhar (top-right)
                      Positioned(
                        top: MediaQuery.of(context).padding.top,
                        right: 0,
                        child: Container(
                          width: 40,
                          height: 30,
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                SharePlus.instance.share(
                                  ShareParams(
                                    text:
                                        'https://mundiapp.com.br/entrepreneur?id=${entrepreneur.id}',
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.share,
                                size: 20,
                                color: context.colors.decorationPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: InkWell(
                          onTap: () => setState(() => favorite = !favorite),
                          child: Icon(
                            favorite ? Icons.favorite : Icons.favorite_outline,
                            size: 30,
                            color: favorite
                                ? context.colors.secondary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Conteúdo scrollável
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header com nome e avaliação
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entrepreneur.name,
                                      style:
                                          context.textStyles.textMedium.copyWith(
                                        color: const Color(0xFF212121),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      entrepreneur.fullAddress,
                                      maxLines: 3,
                                      style:
                                          context.textStyles.textRegular.copyWith(
                                        color: const Color(0xFFA4A4A4),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 10,
                                    color: context.colors.decorationPrimary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    calculateStars(entrepreneur.ratings ?? [])
                                        .toString(),
                                    style:
                                        context.textStyles.textMedium.copyWith(
                                      fontSize: 16,
                                      color: context.colors.decorationPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Tabs com scroll nativo
                          TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            dividerColor: Colors.transparent,
                          
                            padding: EdgeInsets.zero,
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorPadding: const EdgeInsets.only(right: 8),
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            indicator: BoxDecoration(
                              border: Border.all(
                                color: context.colors.decorationPrimary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            labelStyle:
                                context.textStyles.textMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                            unselectedLabelStyle:
                                context.textStyles.textMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            tabs: tabs
                                .map((tab) => Tab(height: 36, text: tab))
                                .toList(),
                          ),

                          const SizedBox(height: 16),

                          // TabBarView — children sempre correspondem ao length do controller
                          SizedBox(
                            height: screenHeight * 0.55,
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: [
                                ServicesPage(
                                  entrepreneur: entrepreneur,
                                  services: entrepreneur.works,
                                  entrepreneurId: entrepreneur.id,
                                ),
                                RatingPage(
                                  ratings: entrepreneur.ratings,
                                  stars: stars,
                                ),
                                if (entrepreneur.description?.isNotEmpty == true)
                                  _AboutTab(
                                      description: entrepreneur.description!),
                                if (entrepreneur.imagesID?.isNotEmpty == true)
                                  PortfolioPage(
                                    services: entrepreneur.works,
                                    images: entrepreneur.imagesID ?? [],
                                  ),
                                DetailsPage(
                                  address: entrepreneur.address,
                                  email: entrepreneur.email,
                                  phone: entrepreneur.phone,
                                  operation: entrepreneur.operation,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(color: context.colors.secondary),
            );
          }
        },
      ),
    );
  }
}

class _AboutTab extends StatefulWidget {
  final String description;

  const _AboutTab({required this.description});

  @override
  State<_AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<_AboutTab> {
  bool _expanded = false;

  static const int _collapseThreshold = 300;

  bool get _isLong => widget.description.length > _collapseThreshold;
  bool get _isShort => widget.description.length <= 150;

  @override
  Widget build(BuildContext context) {
    if (_isShort) return _buildShortLayout(context);
    return _buildLongLayout(context);
  }

  // Textos curtos: destaque centralizado estilo quote
  Widget _buildShortLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: 36,
            color: context.colors.secondary.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 16),
          Text(
            widget.description,
            textAlign: TextAlign.center,
            style: context.textStyles.textRegular.copyWith(
              fontSize: 16,
              height: 1.65,
              color: const Color(0xFF3A3A3A),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            Icons.format_quote_rounded,
            size: 36,
            color: context.colors.secondary.withValues(alpha: 0.35),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  // Textos longos: layout de leitura com collapse opcional
  Widget _buildLongLayout(BuildContext context) {
    final showCollapse = _isLong && !_expanded;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 4, bottom: 16, left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            children: [
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color: context.colors.secondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Sobre o profissional",
                style: context.textStyles.textMedium.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Texto com fade quando colapsado
          Stack(
            children: [
              Text(
                widget.description,
                maxLines: showCollapse ? 6 : null,
                overflow:
                    showCollapse ? TextOverflow.fade : TextOverflow.visible,
                softWrap: true,
                style: context.textStyles.textRegular.copyWith(
                  fontSize: 14,
                  height: 1.65,
                  color: const Color(0xFF3A3A3A),
                ),
              ),
              if (showCollapse)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0.95),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Botão ler mais / ler menos
          if (_isLong) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _expanded ? "Ler menos" : "Ler mais",
                    style: context.textStyles.textMedium.copyWith(
                      fontSize: 13,
                      color: context.colors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: context.colors.secondary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
