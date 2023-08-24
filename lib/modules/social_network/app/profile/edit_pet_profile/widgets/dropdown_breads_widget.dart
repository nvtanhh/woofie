import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';

class DropdownBreadsWidget extends StatelessWidget {
  final List<PetBreed> breads;
  final PetBreed? initValue;
  final Rx<PetBreed?> petBreedSelected = Rx<PetBreed?>(null);

  final Function(PetBreed) onPetBreadChange;

  DropdownBreadsWidget({
    super.key,
    required this.breads,
    required this.onPetBreadChange,
    required this.initValue,
  }) {
    petBreedSelected.value = initValue;
  }

  @override
  Widget build(BuildContext context) {
    printInfo(info: petBreedSelected.value?.name ?? "");
    printInfo(info: breads.toString());
    return Obx(
      () => DropdownButton<PetBreed>(
        items: breads
            .map(
              (e) => DropdownMenuItem<PetBreed>(
                value: e,
                child: Text(e.name ?? ""),
              ),
            )
            .toList(),
        value: petBreedSelected.value,
        isExpanded: true,
        onChanged: (e) {
          petBreedSelected.value = e;
        },
      ),
    );
  }
}
