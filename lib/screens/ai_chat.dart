import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:nutrijourney/utils/constants.dart';

import '../utils/env.dart';

class AIChatBot extends StatefulWidget {
  const AIChatBot({Key? key}) : super(key: key);

  @override
  State<AIChatBot> createState() => _AIChatBotState();
}

class _AIChatBotState extends State<AIChatBot> {

  final _openAI = OpenAI.instance.build(
    token: OPEN_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
          seconds: 20),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser = ChatUser(
      id: '1', firstName: "Lei", lastName: "Guang");
  final ChatUser _gptUser = ChatUser(
      id: '2', firstName: "A", lastName: ".I   Nutrijourney");

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUser = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nutri AI Chat "),
        ),
        body: DashChat(
          currentUser: _currentUser,
          typingUsers: _typingUser,
          messageOptions: const MessageOptions(
            currentUserContainerColor: kBlack,
            containerColor: kPrimaryGreen,
            textColor: kWhite,
          ),
          onSend: (ChatMessage m) {
            getChatRespone(m);
          },
          messages: _messages,


        )
    );
  }


    Future<void> getChatRespone(ChatMessage m) async {
      setState(() {
        _messages.insert(0, m);
        _typingUser.add(_gptUser);
      });

      List<Messages> _messagesHistory = _messages.reversed.map((m) {
        if (m.user == _currentUser) {
          return Messages(role: Role.user, content: m.text);
        } else {
          return Messages(role: Role.assistant, content: m.text);
        }
      }).toList();

      //pass history to chat
      final request = ChatCompleteText(
          model: GptTurbo0301ChatModel(),
          messages: _messagesHistory,
          maxToken: 200,
      );

      final response = await _openAI.onChatCompletion(request: request);

      for(var element in response!.choices){
        if(element.message != null ){
          setState(() {
            _messages.insert(
                0,
              ChatMessage(
                  user: _gptUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content
                  ),
            );
          });
        }
      }

      setState(() {
        _typingUser.remove(_gptUser);
      });

    }
}
