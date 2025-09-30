import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:intro_slider/intro_slider.dart';

import '../../../../common/config/models/onboarding_config.dart';
import '../../../../common/config/models/onboarding_item_config.dart';
import '../../../../widgets/onboarding/multi_language_text_button.dart';
import '../../../home/change_language_mixin.dart';
import '../../onboarding_mixin.dart';

class OnBoardingV1 extends StatefulWidget {
  final OnBoardingConfig config;
  const OnBoardingV1({
    super.key,
    required this.config,
  });

  @override
  State<OnBoardingV1> createState() => _OnBoardingV1State();
}

class _OnBoardingV1State extends State<OnBoardingV1>
    with ChangeLanguage, OnBoardingMixin {
  @override
  OnBoardingConfig get config => widget.config;

  List<ContentConfig> getSlides(List<OnBoardingItemConfig> data) {
    final slides = <ContentConfig>[];

    for (var i = 0; i < data.length; i++) {
      final isLastItem = i == data.length - 1;

      var slide = ContentConfig(
        title: data[i].title,
        description: data[i].desc,
        marginTitle: const EdgeInsets.only(
          top: 100.0,
          bottom: 50.0,
        ),
        maxLineTextDescription: 2,
        styleTitle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
        ),
        backgroundColor: Colors.white,
        marginDescription: const EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 0),
        styleDescription: const TextStyle(
          fontSize: 15.0,
        ),
        foregroundImageFit: BoxFit.fitWidth,
        centerWidget: isLastItem
            ? _renderButtonWidget(data[i].image)
            : FluxImage(
                imageUrl: data[i].image,
                fit: BoxFit.fitWidth,
              ),
      );
      slides.add(slide);
    }
    return slides;
  }

  Widget _renderButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget _renderButtonWidget(String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FluxImage(
          imageUrl: imagePath,
          fit: BoxFit.fitWidth,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (isEnableLogin) ...[
                _renderButton(S.of(context).signIn, onTapSignIn),
                if (isEnableRegister)
                  _renderButton(S.of(context).signUp, onTapSignUp),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.config.items;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          IntroSlider(
            key: UniqueKey(),
            listContentConfig: getSlides(data),
            renderSkipBtn:
                MultiLanguageTextButton(getText: () => S.of(context).skip),
            renderDoneBtn:
                MultiLanguageTextButton(getText: () => S.of(context).done),
            renderPrevBtn:
                MultiLanguageTextButton(getText: () => S.of(context).prev),
            renderNextBtn:
                MultiLanguageTextButton(getText: () => S.of(context).next),
            isShowDoneBtn: true,
            onDonePress: onTapDone,
          ),
          if (widget.config.showLanguage) iconLanguage(),
        ],
      ),
    );
  }
}
