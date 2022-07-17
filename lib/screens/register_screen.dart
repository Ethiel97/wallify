import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/size_config.dart';
import 'package:mobile/utils/text_styles.dart';
import 'package:mobile/utils/validators.dart';
import 'package:mobile/widgets/back_button.dart';
import 'package:mobile/widgets/curved_container.dart';
import 'package:mobile/widgets/custom_button.dart';
import 'package:mobile/widgets/f_input_decoration.dart';
import 'package:provider/provider.dart';

import '../utils/app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameTEC = TextEditingController(text: ''),
      emailTEC = TextEditingController(text: ''),
      passwordTEC = TextEditingController(text: '');

  late AuthProvider _authProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Size? formContainerSize;
  Offset? formContainerPosition;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSize();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _authProvider = Provider.of<AuthProvider>(context);
  }

  getSize() {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;

    setState(() {
      formContainerSize = renderBox.size;
      formContainerPosition = renderBox.localToGlobal(Offset.zero);
    });

    print('POSITION $formContainerPosition');
  }

  void register() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'email': emailTEC.text,
        'password': passwordTEC.text,
        'username': usernameTEC.text,
      };

      await _authProvider.register(data);
      //send to verify phone number
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
            backgroundColor: AppColors.primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              const CurvedContainer(),
              ListView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(25),
                  vertical: getProportionateScreenHeight(12),
                ),
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: getProportionateScreenWidth(8),
                      top: size.height * 0.08,
                    ),
                    child: Image.asset(
                      "assets/images/ico.png",
                      fit: BoxFit.contain,
                      height: 60,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: getProportionateScreenWidth(30),
                      top: getProportionateScreenWidth(0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(Get.context!)!.create_account,
                      style: TextStyles.textStyle.apply(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          key: _key,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(Constants.kBorderRadius),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                                color: AppColors.darkColor.withOpacity(.03),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: fInputDecoration(
                                  AppLocalizations.of(Get.context!)!.pseudo,
                                  theme,
                                  contentPadding: 12.0,
                                ),
                                controller: usernameTEC,
                                validator: usernameValidator,
                                style: TextStyles.textStyle
                                    .apply(fontSizeDelta: -2),
                              ),
                              SizedBox(
                                height: getProportionateScreenWidth(4),
                              ),
                              TextFormField(
                                decoration: fInputDecoration(
                                  AppLocalizations.of(Get.context!)!.email,
                                  theme,
                                  contentPadding: 12.0,
                                ),
                                controller: emailTEC,
                                validator: emailValidator,
                                style: TextStyles.textStyle
                                    .apply(fontSizeDelta: -2),
                              ),
                              SizedBox(
                                height: getProportionateScreenWidth(4),
                              ),
                              TextFormField(
                                decoration: fInputDecoration(
                                  AppLocalizations.of(Get.context!)!.password,
                                  theme,
                                  contentPadding: 12.0,
                                ),
                                style: TextStyles.textStyle
                                    .apply(fontSizeDelta: -2),
                                controller: passwordTEC,
                                validator: passwordValidator,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                              ),
                              SizedBox(
                                height: getProportionateScreenWidth(40),
                              ),
                              /*SizedBox(
                                height: getProportionateScreenWidth(10),
                              ),
                              SignUpButtons(theme),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(150),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(Get.context!)!.already_registered,
                        style: TextStyles.textStyle.apply(
                          fontSizeDelta: -2,
                          color: AppColors.darkColor,

                        ),
                      ),
                      InkWell(
                        child: Text(
                          AppLocalizations.of(Get.context!)!.login,
                          style: TextStyles.textStyle.apply(
                            color: AppColors.darkColor,
                            fontSizeDelta: -2,
                            fontWeightDelta: 4,
                          ),
                        ),
                        onTap: () {
                          Get.toNamed(login);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 36,
                left: 24,
                child: MyBackButton(
                  backgroundColor: Colors.white,
                  iconColor: AppColors.accentColor,
                  transparentize: false,
                ),
              ),
              Positioned.fill(
                top: (formContainerSize?.height ??
                    0 + getProportionateScreenWidth(30)),
                left: 50,
                right: 50,
                child: Center(child: signUpButtons(theme)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpButtons(theme) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: getProportionateScreenWidth(20),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CustomButton(

              text: AppLocalizations.of(Get.context!)!.register.toUpperCase(),
              color: AppColors.accentColor,
              processing: _authProvider.appStatus == AppStatus.processing,
              onTap: register,
            ),
          ),
        ]);
  }
}
