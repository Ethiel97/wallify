import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/utils/app_router.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/back_button.dart';
import 'package:mobile/widgets/custom_button.dart';
import 'package:mobile/widgets/f_input_decoration.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameTEC = TextEditingController(text: ''),
      passwordTEC = TextEditingController(text: '');

  /*TextEditingController usernameTEC =
  TextEditingController(text: 'fakedeliver'),
      passwordTEC = TextEditingController(text: 'Anonymous!2020@@');*/
  late AuthProvider _authProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _authProvider = Provider.of<AuthProvider>(context);
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      var data = {
        'identifier': usernameTEC.text,
        'password': passwordTEC.text,
      };

      await _authProvider.login(data);
      /*if (_authProvider.status == Status.authenticated) {
        _formKey.currentState?.reset();

        Timer(const Duration(milliseconds: 500), () {
          Get.offAndToNamed(landing);
        });
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.zero,
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(25),
              ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: getProportionateScreenWidth(10),
                          top: size.height * 0.04,
                        ),
                        child: Image.asset(
                          "assets/images/ico.png",
                          fit: BoxFit.contain,
                          height: Get.height / 4,
                          width: double.infinity,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          bottom: getProportionateScreenWidth(10),
                          top: size.height * 0.05,
                        ),
                        child: Text(
                          AppLocalizations.of(Get.context!)!.login,
                          style: TextStyles.textStyle.apply(
                            color: AppColors.darkColor,
                            fontSizeDelta: 4,
                            fontWeightDelta: 5,
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: fInputDecoration(
                          AppLocalizations.of(Get.context!)!.pseudo,
                          theme,
                        ),
                        controller: usernameTEC,
                        validator: usernameValidator,
                        style: TextStyles.textStyle.apply(
                          color: AppColors.darkColor,
                          fontSizeDelta: -2,
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenWidth(15),
                      ),
                      TextFormField(
                        decoration: fInputDecoration(
                          AppLocalizations.of(Get.context!)!.password,
                          theme,
                        ),
                        controller: passwordTEC,
                        keyboardType: TextInputType.visiblePassword,
                        validator: passwordValidator,
                        obscureText: true,
                        style: TextStyles.textStyle.apply(
                          color: AppColors.darkColor,
                          fontSizeDelta: -2,
                        ),
                      ),
                      signInButtons(theme),
                      SizedBox(
                        height: getProportionateScreenWidth(20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(Get.context!)!.no_account,
                            style: TextStyles.textStyle.apply(
                                fontSizeDelta: -2, color: AppColors.darkColor),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Flexible(
                            child: InkWell(
                              child: Text(
                                AppLocalizations.of(Get.context!)!
                                    .create_account,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.subtitle1?.apply(
                                  color: AppColors.darkColor,
                                  fontSizeDelta: -2,
                                  fontWeightDelta: 3,
                                ),
                              ),
                              onTap: () {
                                Get.toNamed(RouteName.register);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 36,
              left: 24,
              child: MyBackButton(
                backgroundColor: AppColors.accentColor,
                iconColor: Colors.white,
                transparentize: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signInButtons(theme) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: getProportionateScreenWidth(34),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CustomButton(
              text: AppLocalizations.of(Get.context!)!.validate.toUpperCase(),
              processing: _authProvider.status == Status.authenticating,
              color: AppColors.accentColor,
              onTap: login,
            ),
          ),
        ],
      );
}
