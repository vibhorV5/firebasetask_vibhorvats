import 'package:firebasetask/models/people.dart';
import 'package:firebasetask/services/database_services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 500,
          color: Colors.amber,
          child: StreamBuilder(
            stream: DatabaseServices().peopleListStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                var peopleList = snapshot.data! as List<People>;
                return ListView.builder(
                  itemCount: peopleList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.purple,
                      child: Row(
                        children: [
                          Container(
                            child: Text(peopleList[index].name),
                          ),
                          Container(
                            height: 20,
                            width: 50,
                            child: Image.network(peopleList[index].imageUrl),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await DatabaseServices().deletePeopleItem(
                                  peopleList[index].name,
                                  peopleList[index].imageUrl);
                            },
                            child: Container(
                              child: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Text('Error');
              }
            },
          ),
        ),
        TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: 'Enter a name',
            suffixIcon: IconButton(
              onPressed: textEditingController.clear,
              icon: Icon(Icons.clear),
            ),
          ),
          onChanged: (val) {
            textEditingController.text = val;
          },
        ),
        TextField(
          controller: imageUrlController,
          decoration: InputDecoration(
            hintText: 'Enter an image url',
            suffixIcon: IconButton(
              onPressed: textEditingController.clear,
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            //imageUrl
            // 'https://firebasestorage.googleapis.com/v0/b/murpanara-ecom.appspot.com/o/collection1%2Fnightlovefront.png?alt=media&token=12e48285-a279-4f0e-b942-fbb539f3919d'
            await DatabaseServices().updateInfo(
                textEditingController.text, imageUrlController.text);
          },
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.blue,
            child: Text('Set Data'),
          ),
        ),
      ],
    );
  }
}
