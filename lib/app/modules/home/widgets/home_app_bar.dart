import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'category_tile.dart';
import '../../../core/ui/widgets/gradient_text_field.dart';

class HomeAppBar extends StatefulWidget {
  final TextEditingController searchController;

  const HomeAppBar({required this.searchController, super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: const Color(0xFF060E31),
      padding: EdgeInsets.only(top: 1.statusBar + 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 31,
          ),
          const SizedBox(
            height: 25,
          ),
           GradientTextField(
            hintText: 'Pesquisa aqui a especialidade...',
            prefixIcon: Icons.search,
            controller: widget.searchController,
          ),
          const SizedBox(
            height: 15,
          ),
         /* const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CategoryTile(
                image: 'assets/images/scissors.png',
                title: "Barbeiro",
              ),
              CategoryTile(
                image: 'assets/images/beauty.png',
                title: "Salão de Beleza",
              ),
              CategoryTile(
                image: 'assets/images/health.png',
                title: "Saúde e Bem-estar",
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
