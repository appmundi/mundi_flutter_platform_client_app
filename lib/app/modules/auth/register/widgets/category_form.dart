part of '../register_page.dart';

class _CategoryForm extends StatefulWidget {
  final VoidCallback onSubmit;
  final VoidCallback onReturn;

  const _CategoryForm({
    required this.onSubmit,
    required this.onReturn,
  });

  @override
  State<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<_CategoryForm> {
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;
  final List<int> _selectedIds = [];

  static const int _maxSelection = 3;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final repository = Modular.get<ICategoryRepository>();
      final categories = await repository.getAll();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar categorias: $e');
      setState(() {
        _errorMessage = 'Erro ao carregar categorias. Tente novamente.';
        _isLoading = false;
      });
    }
  }

  void _onCategoryChanged(Category category, bool? value) {
    setState(() {
      final isSelected = value ?? false;
      if (isSelected) {
        if (_selectedIds.length < _maxSelection) {
          _selectedIds.add(category.id);
        }
      } else {
        _selectedIds.remove(category.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPadding(
      bgImagePath: 'assets/images/ellipses/register/registerEllipses6.png',
      child: Column(
        children: [
          MundiAppBar(
            showButton: true,
            onButtonPress: widget.onReturn,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: .1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: BlurryContainer(
                      color: const Color.fromRGBO(11, 22, 70, .2),
                      blur: 30,
                      width: .87.sw,
                      height: 140,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      borderRadius: BorderRadius.circular(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quais tipos de serviços você mais se interessa?",
                            textAlign: TextAlign.center,
                            style: context.textStyles.titleBold.copyWith(
                              fontSize: 25,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Escolha entre 1 e 3 serviços para exibirmos na sua tela inicial.",
                    style: context.textStyles.textMedium.copyWith(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  else if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        children: [
                          Text(
                            _errorMessage!,
                            style: context.textStyles.textMedium.copyWith(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _loadCategories,
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._categories.map((category) {
                      final isSelected = _selectedIds.contains(category.id);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: CategoryCheckbox(
                          text: category.type,
                          value: isSelected,
                          onChanged: (bool? value) {
                            _onCategoryChanged(category, value);
                          },
                        ),
                      );
                    }),
                  const SizedBox(height: 20),
                  AppButton(
                    width: .85.sw,
                    text: 'Seguir',
                    onPressed: _isLoading ? null : widget.onSubmit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
