import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetask/models/people.dart';

class DatabaseServices {
  final CollectionReference peopleCollection =
      FirebaseFirestore.instance.collection('peoplelist');

  Future updateInfo(String name, String imgUrl) async {
    final dataAdd = {
      'name': name,
      'imagefront': imgUrl,
    };

    var ref = peopleCollection.doc('peoplelist');
    var data = {
      'peoplelist': FieldValue.arrayUnion([dataAdd])
    };
    return await ref.set(data, SetOptions(merge: true));
  }

  Future deletePeopleItem(String name, String imgUrl) async {
    final dataRemove = {
      'name': name,
      'imagefront': imgUrl,
    };

    var ref = peopleCollection.doc('peoplelist');
    await ref.update(
      {
        'peoplelist': FieldValue.arrayRemove([dataRemove])
      },
    );
  }

  List<People> _getPeopleListfromSnapshot(DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data().toString().contains('peoplelist')
        ? (documentSnapshot.get('peoplelist') as List).map(
            (human) {
              return People(
                name: human['name'],
                imageUrl: human['imagefront'],
              );
            },
          ).toList()
        : const [];
  }

  Stream<List<People>> get peopleListStream {
    return peopleCollection
        .doc('peoplelist')
        .snapshots()
        .map(_getPeopleListfromSnapshot);
  }
}
