import 'package:flutter/material.dart';
import 'package:my_first_project/models/objectif.dart';
import 'package:my_first_project/pages/client/add_objectif_page.dart';
import 'package:my_first_project/services/objectif.dart';
import 'package:my_first_project/widgets/appbar_widget.dart';
import 'package:my_first_project/widgets/circular_widget.dart';
import 'package:my_first_project/widgets/error_message_widget.dart';
import 'package:my_first_project/widgets/info_message_widget.dart';

class ObjectifsPage extends StatefulWidget {
  static const routeName = "/ObjectifsPage";
  const ObjectifsPage({super.key});

  @override
  State<ObjectifsPage> createState() => _ObjectifsPageState();
}

class _ObjectifsPageState extends State<ObjectifsPage> {
  bool isLoading = false;
  ObjectifService objectifService = ObjectifService();
  List<Objectif> objectifs = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      objectifs = await objectifService.getAllObjectifsByUser();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Objectifs Financiers"),
      body: SafeArea(
        child: isLoading
            ? CircularWidget(Colors.white)
            : errorMessage != ""
                ? ErrorMessageWidget(errorMessage)
                : objectifs.isEmpty
                    ? InfoMessageWidget("Aucun objectif trouvé !")
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              itemCount: objectifs.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  leading: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  title: Text(objectifs[index].name),
                                  trailing: Text(
                                    '${objectifs[index].amount.toStringAsFixed(2)} DT',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddObjectifPage()));
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
