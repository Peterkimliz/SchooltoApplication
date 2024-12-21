import 'package:flutter/material.dart';
import 'package:schoolsto/controllers/DriverController.dart';
import 'package:schoolsto/widgets/common_text.dart';
import 'package:schoolsto/widgets/custom_button.dart';
import 'package:get/get.dart';

class CarAdd extends StatelessWidget {
   CarAdd({super.key});
  Drivercontroller drivercontroller=Get.find<Drivercontroller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        surfaceTintColor: Colors.grey,
        title: CommonText(
          name: "Add Car",
          fontFamily: "RedHatMedium",
          fontWeight: FontWeight.bold,
          textSize: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(10)
        ,child: Form(
            key: drivercontroller.formKeyCar,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                CommonText(name: "Vehicle Plate",fontFamily: "RedHatMedium",),
                const SizedBox(height: 5),
                TextFormField(
                  controller: drivercontroller.textEdittingControllerVehicleType,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vehicle type is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                      )),
                ),
                const SizedBox(height: 20,),
                CommonText(name: "Vehicle Plate",fontFamily: "RedHatMedium",),
                const SizedBox(height: 5),
                TextFormField(
                  controller: drivercontroller.textEdittingControllerVehiclePlate,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vehicle plate is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                      )),
                ),
                SizedBox(height: 20,),

                CustomButton(title: "Save", onTap: (){
                  drivercontroller.saveCar();
                })

              ],
            ),
        ),),
      ),
    );
  }
}
