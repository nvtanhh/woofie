import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MapSeacherFilterSelectPetBreedWidget extends StatelessWidget {
  final List<PetBreed> petBreeds;
  final List<PetBreed> selectedPetBreeds;
  final Function(PetBreed) onPetBreedSelected;

  const MapSeacherFilterSelectPetBreedWidget({
    super.key,
    required this.petBreeds,
    required this.onPetBreedSelected,
    this.selectedPetBreeds = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: petBreeds.map(_petBreedItem).toList(),
    );
  }

  Widget _petBreedItem(PetBreed petBreed) {
    String breedName = petBreed.name ?? '';
    if (breedName.contains('(')) {
      breedName = breedName.substring(0, breedName.indexOf('('));
    }
    final isSelected = selectedPetBreeds.contains(petBreed);
    return Padding(
      padding: EdgeInsets.only(right: 8.w, bottom: 6.w),
      child: GestureDetector(
        onTap: () => onPetBreedSelected(petBreed),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: isSelected ? UIColor.primary : UIColor.holder,
              borderRadius: BorderRadius.circular(10.r),),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              breedName,
              style: isSelected
                  ? UITextStyle.white_12_w500
                  : UITextStyle.body_12_medium,
            ),
          ),
        ),
      ),
    );
  }
}
