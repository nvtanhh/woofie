import 'package:flutter/material.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget_model.dart';
import 'package:suga_core/suga_core.dart';

class AdoptionPetDetailWidget extends StatefulWidget {
  @override
  _AdoptionPetDetailState createState() => _AdoptionPetDetailState();
}

class _AdoptionPetDetailState extends BaseViewState<AdoptionPetDetailWidget, AdoptionPetDetailWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ,
      ),
    );
  }

  @override
  AdoptionPetDetailWidgetModel createViewModel() => injector<AdoptionPetDetailWidgetModel>();
}
