import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_app_bar_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/message_options_widget.dart';
import './widgets/quick_reply_widget.dart';

class AiChatAssistant extends StatefulWidget {
  const AiChatAssistant({Key? key}) : super(key: key);

  @override
  State<AiChatAssistant> createState() => _AiChatAssistantState();
}

class _AiChatAssistantState extends State<AiChatAssistant>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final List<String> _quickReplies = [
    'How to identify cassava diseases?',
    'Best planting practices',
    'Pest control methods',
    'Harvesting tips',
    'Soil preparation',
    'Weather concerns',
  ];

  bool _isOnline = true;
  bool _isRecording = false;
  bool _isTyping = false;
  bool _isLoading = true;
  late AnimationController _typingAnimationController;

  // Mock AI responses for cassava farming
  final Map<String, String> _aiResponses = {
    'disease':
        'Common cassava diseases include Cassava Mosaic Disease (CMD), Cassava Brown Streak Disease (CBSD), and Bacterial Blight. Look for yellowing leaves, brown streaks on stems, or wilting plants. Early detection is key for effective treatment.',
    'planting':
        'Plant cassava during the rainy season. Use healthy stem cuttings 15-20cm long. Plant at 45-degree angle, leaving 5cm above ground. Space plants 1m apart in rows 1.5m apart for optimal growth.',
    'pest':
        'Common pests include cassava mealybug, green spider mite, and whiteflies. Use integrated pest management: remove infected plants, apply neem oil, introduce beneficial insects, and maintain field hygiene.',
    'harvest':
        'Cassava is ready for harvest 8-12 months after planting. Leaves turn yellow and drop. Carefully dig around plants to avoid damaging roots. Harvest during dry weather for better storage.',
    'soil':
        'Cassava grows well in well-drained, sandy-loam soils with pH 5.5-6.5. Clear land, remove weeds, and make ridges or mounds. Add organic matter like compost to improve soil fertility.',
    'weather':
        'Cassava needs 1000-1500mm annual rainfall. Plant at start of rainy season. Protect from strong winds and flooding. During dry spells, mulch around plants to retain moisture.',
    'default':
        'I\'m here to help with cassava farming questions! You can ask me about diseases, planting, pest control, harvesting, soil preparation, or weather concerns. What would you like to know?'
  };

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _initializeChat();
    _checkConnectivity();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _messages.add({
        'message':
            'Hello! I\'m your CassavaDoctor AI assistant. I\'m here to help you with cassava farming questions, disease identification, and best practices. How can I assist you today?',
        'isUser': false,
        'timestamp': DateTime.now(),
        'isTyping': false,
      });
      _isLoading = false;
    });

    _scrollToBottom();
    await _loadChatHistory();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _isOnline = results.isNotEmpty && results.first != ConnectivityResult.none;
      });

      if (_isOnline) {
        Fluttertoast.showToast(
          msg: "Connection restored - Full AI features available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Offline mode - Limited responses available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  Future<void> _loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final chatHistory = prefs.getStringList('chat_history') ?? [];

      for (String messageJson in chatHistory.take(50)) {
        // In a real app, you would parse JSON here
        // For now, we'll skip loading previous messages to keep it simple
      }
    } catch (e) {
      print('Error loading chat history: \$e');
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final chatHistory = _messages.map((msg) => msg.toString()).toList();
      await prefs.setStringList('chat_history', chatHistory.take(100).toList());
    } catch (e) {
      print('Error saving chat history: \$e');
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({
        'message': message,
        'isUser': true,
        'timestamp': DateTime.now(),
        'isTyping': false,
      });
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();
    _generateAIResponse(message);
    _saveChatHistory();
  }

  Future<void> _generateAIResponse(String userMessage) async {
    await Future.delayed(
        Duration(milliseconds: 1500 + (userMessage.length * 50)));

    String response = _getAIResponse(userMessage.toLowerCase());

    setState(() {
      _isTyping = false;
      _messages.add({
        'message': response,
        'isUser': false,
        'timestamp': DateTime.now(),
        'isTyping': false,
      });
    });

    _scrollToBottom();
    _saveChatHistory();
  }

  String _getAIResponse(String message) {
    if (message.contains('disease') ||
        message.contains('sick') ||
        message.contains('problem')) {
      return _aiResponses['disease']!;
    } else if (message.contains('plant') ||
        message.contains('grow') ||
        message.contains('cultivation')) {
      return _aiResponses['planting']!;
    } else if (message.contains('pest') ||
        message.contains('insect') ||
        message.contains('bug')) {
      return _aiResponses['pest']!;
    } else if (message.contains('harvest') ||
        message.contains('ready') ||
        message.contains('mature')) {
      return _aiResponses['harvest']!;
    } else if (message.contains('soil') ||
        message.contains('ground') ||
        message.contains('preparation')) {
      return _aiResponses['soil']!;
    } else if (message.contains('weather') ||
        message.contains('rain') ||
        message.contains('season')) {
      return _aiResponses['weather']!;
    } else {
      return _aiResponses['default']!;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onQuickReplyTap(String suggestion) {
    _messageController.text = suggestion;
    _sendMessage();
  }

  void _startVoiceRecording() {
    setState(() {
      _isRecording = true;
    });

    HapticFeedback.mediumImpact();
    Fluttertoast.showToast(
      msg: "Voice recording started",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Simulate voice recording
    Future.delayed(Duration(seconds: 3), () {
      if (_isRecording) {
        _stopVoiceRecording();
      }
    });
  }

  void _stopVoiceRecording() {
    setState(() {
      _isRecording = false;
    });

    HapticFeedback.lightImpact();

    // Simulate voice-to-text conversion
    final voiceMessages = [
      'How do I identify cassava diseases?',
      'What are the best planting practices?',
      'When should I harvest my cassava?',
      'How do I prepare the soil for cassava?',
    ];

    final randomMessage =
        voiceMessages[DateTime.now().millisecond % voiceMessages.length];
    _messageController.text = randomMessage;

    Fluttertoast.showToast(
      msg: "Voice converted to text",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showMessageOptions(String message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MessageOptionsWidget(
        message: message,
        onCopy: () => _copyMessage(message),
        onShare: () => _shareMessage(message),
        onSave: () => _saveMessage(message),
        onPlayAudio: () => _playAudio(message),
      ),
    );
  }

  void _copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    Fluttertoast.showToast(
      msg: "Message copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _shareMessage(String message) {
    // In a real app, you would use share_plus package
    Fluttertoast.showToast(
      msg: "Sharing message...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _saveMessage(String message) {
    Fluttertoast.showToast(
      msg: "Message saved for later",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _playAudio(String message) {
    Fluttertoast.showToast(
      msg: "Playing audio...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showChatMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'file_download',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Export Chat'),
              onTap: () {
                Navigator.pop(context);
                _exportChat();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text('Clear Chat'),
              onTap: () {
                Navigator.pop(context);
                _clearChat();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings-panel');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _exportChat() {
    final chatContent = _messages
        .map((msg) => '${msg['isUser'] ? 'You' : 'AI'}: ${msg['message']}')
        .join('\n\n');

    Clipboard.setData(ClipboardData(text: chatContent));
    Fluttertoast.showToast(
      msg: "Chat exported to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Chat'),
        content: Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              Navigator.pop(context);
              _initializeChat();
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: ChatAppBarWidget(
        isOnline: _isOnline,
        onMenuPressed: _showChatMenu,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          itemCount: _messages.length + (_isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _messages.length && _isTyping) {
                              return ChatMessageWidget(
                                message: '',
                                isUser: false,
                                timestamp: DateTime.now(),
                                isTyping: true,
                              );
                            }

                            final message = _messages[index];
                            return ChatMessageWidget(
                              message: message['message'],
                              isUser: message['isUser'],
                              timestamp: message['timestamp'],
                              onLongPress: () =>
                                  _showMessageOptions(message['message']),
                            );
                          },
                        ),
                ),
                QuickReplyWidget(
                  suggestions: _quickReplies,
                  onSuggestionTap: _onQuickReplyTap,
                ),
                ChatInputWidget(
                  controller: _messageController,
                  onSend: _sendMessage,
                  onVoiceStart: _startVoiceRecording,
                  onVoiceStop: _stopVoiceRecording,
                  isRecording: _isRecording,
                  isEnabled: !_isTyping,
                ),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 3.h),
          Text(
            'Initializing AI Assistant...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'smart_toy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 15.w,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Welcome to CassavaGuard AI',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'I\'m here to help you with cassava farming questions, disease identification, and agricultural best practices.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              'Try asking:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),
            ..._quickReplies
                .take(3)
                .map(
                  (suggestion) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.5.h),
                    child: Text(
                      '• $suggestion',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}