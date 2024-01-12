import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrijourney/screens/recipe_detail.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../widgets/recipe_card.dart';
import 'helper_screens/add_recipe.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  void openAddRecipeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddRecipeScreen(),
      ),
    );
  }

  void viewRecipeDetail(recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final UserModel? user = Provider.of<UserProvider>(context).getUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: openAddRecipeScreen,
              backgroundColor: kPrimaryGreen,
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              title: const Text('Recipes'),
              backgroundColor: kPrimaryGreen,
              //   actions: [
              //     IconButton(
              //       onPressed: () {
              //         // Perform search action
              //       },
              //       icon: const Icon(Icons.search),
              //     ),
              //     IconButton(
              //       onPressed: () {
              //         // Perform sort action
              //       },
              //       icon: const Icon(Icons.sort),
              //     ),
              //   ],
              bottom: const TabBar(
                indicatorColor: kWhite,
                tabs: [
                  Tab(text: "System Recipe"),
                  Tab(text: "My Recipe"),
                  Tab(text: "Saved"),
                ],
              ),
            ),
            body: TabBarView(children: [
              //* Steam builder for all recipes
              getRecipe("admin"), //recipes created by admin
              getRecipe(user!.uid), //recipe created by current user
              getSavedRecipe(user.uid) // get all saved recipe
            ])),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> getRecipe(String uid) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      // stream: firebaseFirestore.collection('recipes').snapshots(),
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .where('uid', isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final recipes = snapshot.data!.docs.map((doc) => doc.data()).toList();

        if (recipes.length == 0) {
          return Center(
            child: Text("No Recipe Yet. CREATE ONE!"),
          );
        } else {
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RecipeCard(
                recipe: recipes[index],
                onTap: () {
                  viewRecipeDetail(recipes[index]);
                },
              ),
            ),
          );
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> getSavedRecipe(
      String uid) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .where('savedBy', arrayContains: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final recipes = snapshot.data!.docs.map((doc) => doc.data()).toList();

        if (recipes.length == 0) {
          return Center(
            child: Text("No Recipe Yet. CREATE ONE!"),
          );
        } else {
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RecipeCard(
                recipe: recipes[index],
                onTap: () {
                  viewRecipeDetail(recipes[index]);
                },
              ),
            ),
          );
        }
      },
    );
  }
}
