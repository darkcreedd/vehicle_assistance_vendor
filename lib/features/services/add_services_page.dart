import 'package:flutter/material.dart';

import '../../../shared/widgets/bottom_sheet_appbar.dart';
import '../../shared/data/vehicle_service.dart';

class AddServicesPage extends StatefulWidget {
  const AddServicesPage({super.key});

  @override
  State<AddServicesPage> createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  List<int> selectedIndices = [];

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bottomSheetAppBar(context, "Add Services"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Select the services you offer in your workshop"),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: double.maxFinite,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(
                  vehicleServices.length,
                  (index) => GestureDetector(
                    onTap: () {
                      toggleSelection(index);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: selectedIndices.contains(index)
                            ? const BorderSide(width: 2, color: Colors.blue)
                            : BorderSide.none,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(vehicleServices[index].image),
                            ),
                            Text(vehicleServices[index].name),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Custom Service",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "If you offer any other service but isn't listed above, enter it below to be added.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 5,
                ),
                const TextField(),
              ],
            ),
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 50)),
                onPressed: () {},
                child: Text(
                  "Save",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
