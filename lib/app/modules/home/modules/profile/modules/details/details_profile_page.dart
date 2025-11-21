import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_text_field.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/modules/details/cubit/details_profile_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/modules/details/cubit/details_profile_state.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/widgets/profile_tile.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../../../core/ui/helpers/messages.dart';

class DetailsProfilePage extends StatefulWidget {
  final String name;
  final int userId;

  const DetailsProfilePage({
    required this.name,
    required this.userId,
    super.key,
  });

  @override
  State<DetailsProfilePage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsProfilePage>
    with Messages<DetailsProfilePage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final telefone = TextEditingController();
  File? image;
  String? currentImageUrl;

  void _showImageOptionsModal() {
    final hasImage =
        image != null ||
            (currentImageUrl != null && currentImageUrl!.isNotEmpty);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Atualizar foto'),
                onTap: () async {
                  Navigator.pop(context);
                  handleImage();
                },
              ),
              if (hasImage)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remover foto',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await handleDeleteImage();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancelar'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleImage() async {
    final result = await pickImage();

    setState(() {
      image = result;
    });
  }

  Future<void> handleDeleteImage() async {
    setState(() {
      image = null;
      currentImageUrl = null;
    });

    await BlocProvider.of<DetailProfileCubit>(context).deleteImage(
      widget.userId,
    );
    showSuccess('Imagem removida com sucesso!');
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      showError('Não foi selecionada nenhuma imagem');
      return null;
    }

    final imageFile = File(image.path);
    try {
      await validateImageSize(imageFile);
      return imageFile;
    } catch (e) {
      return null;
    }
  }

  Future<void> validateImageSize(File imageFile) async {
    int sizeInBytes = await imageFile.length();
    double sizeInKB = sizeInBytes / 1024;

    if (sizeInKB > 2048) {
      showError('A imagem excede o tamanho máximo de 2MB');
      throw Exception('A imagem excede o tamanho máximo de 2MB');
    }
  }

  Widget _buildProfileImagePicker(String? imageUrl) {
    // Tamanho responsivo da imagem baseado na largura da tela
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth < 360 ? 100.0 : (screenWidth < 400 ? 110.0 : 120.0);
    final cameraIconSize = screenWidth < 360 ? 25.0 : 30.0;

    return Center(
      child: Column(
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagem de perfil
                  if (image != null)
                    Image.file(image!, fit: BoxFit.cover)
                  else if (imageUrl != null && imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.grey[300]);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ??
                                      1)
                                  : null,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Container(color: Colors.grey[300]),

                  // Overlay com botão de câmera
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showImageOptionsModal,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: cameraIconSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenWidth < 360 ? 12 : 16),
          Text(
            'Toque para alterar a foto',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: screenWidth < 360 ? 12 : 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Máximo 2MB',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: screenWidth < 360 ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Padding responsivo baseado no tamanho da tela
    final horizontalPadding = screenWidth < 360 ? 20.0 : (screenWidth < 400 ? 25.0 : 30.0);
    final verticalPadding = screenHeight < 700 ? 20.0 : (screenHeight < 800 ? 30.0 : 40.0);

    // Espaçamentos responsivos
    final fieldSpacing = screenHeight < 700 ? 12.0 : 15.0;
    final mainSpacing = screenHeight < 700 ? 20.0 : 30.0;
    final buttonSpacing = screenHeight < 700 ? 30.0 : 45.0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/dark_logo.png',
              height: screenWidth < 360 ? 20 : 25,
            )
          ],
        ),
      ),
      body: BlocConsumer<DetailProfileCubit, DetailProfileState>(
        listener: (context, state) {
          print("Usuario state > ${state.user.toString()}");
          name.text = state.user?.name ?? '';
          email.text = state.user?.email ?? '';
          telefone.text = state.user?.phone ?? '';
          currentImageUrl = state.user?.imageUrl ?? '';

          if(state.status == DetailsProfileStatus.updated) {
            showSuccess("Alterado com Sucesso !");
            Modular.to.navigate('/home/');
          }
        },
        builder: (context, state) {
          print("Usuario state > ${state.user.toString()}");

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight,
              ),
              child: BlurryContainer(
                color: const Color.fromRGBO(6, 14, 39, 1),
                width: 1.sw,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth < 360 ? 30 : 40),
                  topRight: Radius.circular(screenWidth < 360 ? 30 : 40),
                ),
                blur: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Componente de seleção de imagem de perfil
                    _buildProfileImagePicker(
                        '${Environments.get('BASE_URL')}/images/profile/user/${widget.userId}?t=${DateTime.now().millisecondsSinceEpoch}'
                    ),
                    SizedBox(height: mainSpacing),

                    AppTextField(
                      hintText: 'Nome',
                      label: 'Nome',
                      controller: name,
                    ),
                    SizedBox(height: fieldSpacing),
                    AppTextField(
                      hintText: 'Email',
                      label: 'Email',
                      controller: email,
                      validator: Validatorless.multiple([
                        Validatorless.email("E-mail inválido"),
                      ]),
                    ),
                    SizedBox(height: fieldSpacing),
                    AppTextField(
                      hintText: 'Telefone',
                      label: 'Telefone',
                      controller: telefone,
                      formatters: [MaskTextInputFormatter(mask: "(##) #####-####")],
                    ),
                    SizedBox(height: buttonSpacing),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: 'Alterar',
                          onPressed: () async {
                            BlocProvider.of<DetailProfileCubit>(context).updateUser(
                              widget.userId,
                              name.text,
                              email.text,
                              telefone.text,
                              image,
                            );
                          },
                        ),
                      ),
                    ),
                    // Espaço adicional para telas menores para evitar sobreposição do teclado
                    if (screenHeight < 700) SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}