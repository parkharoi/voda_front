
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda_front/common/app_colors.dart';
import 'package:voda_front/models/chat_message.dart';
import 'package:voda_front/viewmodels/chat_view_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면에 들어오면 뷰모델 새로 생성 (대화 초기화)
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(),
      child: const _ChatScreenContent(),
    );
  }
}

class _ChatScreenContent extends StatefulWidget {
  const _ChatScreenContent();

  @override
  State<_ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<_ChatScreenContent> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("윌로우", style: TextStyle(color: AppColors.textBlack, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 1. 채팅 리스트 영역
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: chatViewModel.messages.length,
              itemBuilder: (context, index) {
                final message = chatViewModel.messages[index];
                return _buildBubble(message);
              },
            ),
          ),

          // 2. 로딩 인디케이터 (윌로우가 입력 중...)
          if (chatViewModel.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(0xFFFF8895),
                    child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text("윌로우가 생각하고 있어요...", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),

          // 3. 입력창 영역
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "이야기를 건네보세요",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      // 엔터 치면 전송
                      onSubmitted: (_) => _handleSend(chatViewModel),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _handleSend(chatViewModel),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFFF8895),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 전송 처리 함수
  void _handleSend(ChatViewModel viewModel) {
    if (_textController.text.trim().isEmpty) return;

    viewModel.sendMessage(_textController.text);
    _textController.clear();

    // 스크롤 맨 아래로 내리기
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 말풍선 위젯
  Widget _buildBubble(ChatMessage message) {
    final isMe = message.isUser;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFF8895) : Colors.grey.shade100, // 나: 핑크, 윌로우: 회색
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(5),
            bottomRight: isMe ? const Radius.circular(5) : const Radius.circular(20),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}