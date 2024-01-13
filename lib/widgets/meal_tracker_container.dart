import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class MealTrackerContainer extends StatelessWidget {
  String mealType;
  String selectedDate;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  MealTrackerContainer({Key? key, required this.mealType, required this.selectedDate}) : super(key: key);

  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final UserModel? user =
        Provider.of<UserProvider>(context, listen: false).getUser;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        // border: Border.all(color: kLightGreen),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          //show meal type, and  calories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealType,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const RecipeScreen()),
                  // );
                },
                child: const Text('Add Plan'),
              ),
            ],
          ),
          //fetch meal
          StreamBuilder(
              stream: firestore
                  .collection('users')
                  .doc(user?.email)
                  .collection('tracker')
                  .doc(selectedDate)
                  .collection(selectedDate)
                  .where('mealType', isEqualTo: mealType )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: const Text("No Meal Found, ADD MEAL NOW"),
                    ),
                  );
                }

                // Calculate total calories
                double totalCalories = snapshot.data!.docs.fold(0.0, (sum, doc) {
                  return sum + (doc['calories'] as num);
                });

                return Column(
                  children: [
                    Text(
                      '$mealType Calories :  $totalCalories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var meal = snapshot.data!.docs[index].data();
                        var documentId = snapshot.data!.docs[index].id;
                        return _buildMealPlanItem(meal, documentId, user?.email);
                      },
                    ),
                    const SizedBox(height: 10.0),
                  ],
                );
            },
          ),
        ],
      ),
    );
  }
}


Widget _buildMealPlanItem(meal, documentId, userEmail) {

  return Container(
    margin: EdgeInsets.all(4),
    child: ListTile(
      title: Text(
        meal['mealName'],
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${meal['calories']} cal',
            style: const TextStyle(fontSize: 16.0),
          ),

        ],
      ),
      leading: Image.network(
        meal['imageUrl'],
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.redAccent.shade200,
        ),
        onPressed: () {
          // _confirmDeleteMeal(userEmail, documentId, _formatDate(currentDate));
        },
      ),
    ),
  );
}
