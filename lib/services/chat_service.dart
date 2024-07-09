import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/models/message.dart';
import 'package:social_media_app/utils/firebase.dart';

class ChatService {
  FirebaseStorage storage = FirebaseStorage.instance;

  sendMessage(Message message, String chatId) async {
    //will send message to chats collection with the usersId
    await chatRef.doc("$chatId").collection("messages").add(message.toJson());
    //will update "lastTextTime" to the last time a text was sent
    await chatRef.doc("$chatId").update({"lastTextTime": Timestamp.now()});
  }

  Future<String> sendFirstMessage(Message message, String recipient) async {
    User user = firebaseAuth.currentUser!;
    DocumentReference ref = await chatRef.add({
      'users': [recipient, user.uid],
    });
    await sendMessage(message, ref.id);
    return ref.id;
  }

  Future<String> uploadImage(File image, String chatId) async {
    Reference storageReference = storage.ref().child("chats").child(chatId).child(uuid.v4());
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  //determine if a user has read a chat and updates how many messages are unread
  setUserRead(String chatId, User user, int count) async {
    DocumentSnapshot snap = await chatRef.doc(chatId).get();
    if (!snap.exists) {
      // If the document doesn't exist, initialize it with an empty 'reads' field
      await chatRef.doc(chatId).set({
        'reads': {user.uid: count},
      }, SetOptions(merge: true));
    } else {
      Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
      Map<String, dynamic> reads = data['reads'] ?? {};
      reads[user.uid] = count;
      await chatRef.doc(chatId).update({'reads': reads});
    }
  }

  //determine when a user has start typing a message
  setUserTyping(String chatId, User user, bool userTyping) async {
    DocumentSnapshot snap = await chatRef.doc(chatId).get();
    if (!snap.exists) {
      // If the document doesn't exist, initialize it with an empty 'typing' field
      await chatRef.doc(chatId).set({
        'typing': {user.uid: userTyping},
      }, SetOptions(merge: true));
    } else {
      Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
      Map<String, dynamic> typing = data['typing'] ?? {};
      typing[user.uid] = userTyping;
      await chatRef.doc(chatId).update({'typing': typing});
    }
  }
}
