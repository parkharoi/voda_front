import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda_front/common/app_colors.dart'; // 공용 컬러 파일
import 'package:voda_front/models/chat_message.dart';
import 'package:voda_front/viewmodels/chat_view_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 대화 기록 초기화 상태
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
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 상태 감지
    final chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // 1. 채팅 리스트 영역
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.willowGreenBg,
                    child: Icon(Icons.eco, size: 16, color: AppColors.willowGreenIcon),
                  ),
                  SizedBox(width: 10),
                  Text("윌로우가 답장을 쓰고 있어요...", style: TextStyle(color: AppColors.textGray, fontSize: 12)),
                ],
              ),
            ),

          // 3. 일기 요약 생성 버튼 (조건 충족 시 하단에 등장)
          // 스크린샷처럼 입력창 바로 위에 뜹니다.
          if (chatViewModel.canSummarize && !chatViewModel.isSummarizing)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _buildSummaryButton(chatViewModel),
            ),

          // 요약 중일 때 로딩 표시
          if (chatViewModel.isSummarizing)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),

          // 4. 입력창 영역
          _buildInputArea(chatViewModel),
        ],
      ),
    );
  }

  // 상단 앱바 (윌로우 프로필)
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.willowGreenBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: AppColors.willowGreenIcon, size: 24),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "윌로우",
                style: TextStyle(color: AppColors.textBlack, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "AI 친구",
                style: TextStyle(color: AppColors.textGray, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 말풍선 (스크린샷 스타일)
  Widget _buildBubble(ChatMessage message) {
    final isMe = message.isUser;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.inputBg, // 나: 핑크, AI: 연회색
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4), // 꼬리 방향
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isMe ? Colors.white : AppColors.textBlack,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  // 일기 요약 생성하기 버튼 (스크린샷 2번 스타일)
  Widget _buildSummaryButton(ChatViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _handleSummary(viewModel),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.secondaryPink, width: 1), // 연한 핑크 테두리
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
        label: const Text(
          "일기 요약 생성하기",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // 하단 입력창
  Widget _buildInputArea(ChatViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // 아래쪽 여백 추가
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(25), // 둥근 입력창
                ),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: "메시지를 입력하세요...",
                    hintStyle: TextStyle(color: AppColors.textGray, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onSubmitted: (_) => _handleSend(viewModel),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 전송 버튼 (핑크색 둥근 사각형)
            GestureDetector(
              onTap: () => _handleSend(viewModel),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16), // 스크린샷과 동일한 둥근 사각형
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 메시지 전송 로직
  void _handleSend(ChatViewModel viewModel) {
    if (_textController.text.trim().isEmpty) return;

    viewModel.sendMessage(_textController.text);
    _textController.clear();

    _scrollToBottom();
  }

  // 요약 버튼 클릭 로직
  void _handleSummary(ChatViewModel viewModel) async {
    bool success = await viewModel.requestAiSummary();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✨ 오늘 대화가 일기로 저장되었어요!")),
      );
      // 성공 후 로직 (예: 화면 이동)
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("일기 생성에 실패했어요. 잠시 후 다시 시도해주세요.")),
      );
    }
  }

  void _scrollToBottom() {
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
}