import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/filter_widget.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/services/widgets/service_text_field.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/services/widgets/service_tile.dart';

import '../../../../../../models/work.dart';

class ServicesPage extends StatefulWidget {
  final List<Work> services;
  final int? entrepreneurId;
  final Entrepreneur entrepreneur;
  const ServicesPage({super.key, required this.services, this.entrepreneurId,required this.entrepreneur});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final TextEditingController _filterController = TextEditingController();
  late List<Work> servicesFiltered;

  @override
  void initState() {
    servicesFiltered = widget.services;
    _filterController.addListener(() {
      if (_filterController.text != '') {
        servicesFiltered = widget.services
            .where((Work element) => element.title
                .toLowerCase()
                .contains(_filterController.text.toLowerCase()))
            .toList();
        setState(() {});
      } else {
        servicesFiltered = widget.services;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: ServiceTextField(
              controller: _filterController,
              hintText: 'Pesquise aqui a especialidade...',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 20,
                );
              },
              shrinkWrap: true,
              itemCount: servicesFiltered.length,
              itemBuilder: (context, index) {
                final service = servicesFiltered[index];
                return ServiceTile(
                    service: service, entrepreneurId: widget.entrepreneurId!,entrepreneur: widget.entrepreneur,);
              },
            ),
          ),
        ],
      ),
    );
  }
}
