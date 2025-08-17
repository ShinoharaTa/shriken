import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nostr_core_dart/nostr.dart';
import 'package:shriken/class/connection.dart';
import 'package:shriken/class/encrypt.dart';
import 'package:shriken/components/modal.dart';
import 'package:shriken/theme/elegant_theme.dart';

class PostScreen extends StatefulWidget {
  final String? postText;

  const PostScreen({Key? key, this.postText}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with TickerProviderStateMixin {
  final EncryptManager _encryptManager = EncryptManager();
  late TextEditingController _textController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPosting = false;
  int _maxLength = 280;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.postText);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _post() async {
    if (_textController.text.trim().isEmpty || _isPosting) return;

    setState(() {
      _isPosting = true;
    });

    // ハプティックフィードバック
    HapticFeedback.mediumImpact();

    try {
      String? nsec = await _encryptManager.getItem("nsec");
      if (nsec != null) {
        Event event = Nip1.textNote(
          _textController.text,
          Nip19.decodePrivkey(nsec) ?? "",
        );
        
        Connect.sharedInstance.sendEventRelays(event, [
          "wss://relay-jp.nostr.wirednet.jp/",
          "wss://yabu.me/",
          "wss://r.kojira.io/",
          "wss://relay-jp.shino3.net/",
        ]);

        // 成功フィードバック
        HapticFeedback.lightImpact();
        _showSuccessSnackBar();
        _textController.clear();
      } else {
        _showErrorSnackBar('秘密鍵が設定されていません');
      }
    } catch (e) {
      _showErrorSnackBar('投稿に失敗しました: $e');
    } finally {
      setState(() {
        _isPosting = false;
      });
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: ElegantTheme.accentGreen),
            const SizedBox(width: 8),
            const Text('投稿が完了しました'),
          ],
        ),
        backgroundColor: ElegantTheme.darkCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ElegantTheme.darkCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textLength = _textController.text.length;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = textLength / _maxLength;

    return Scaffold(
      body: Container(
        decoration: isDark
            ? const BoxDecoration(gradient: ElegantTheme.backgroundGradient)
            : null,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ヘッダー
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // メイン投稿エリア
                    Expanded(
                      child: ElegantCard(
                        gradient: isDark ? ElegantTheme.cardGradient : null,
                        child: Column(
                          children: [
                            // プロフィール部分
                            _buildProfileSection(),
                            const SizedBox(height: 24),

                            // 投稿入力
                            Expanded(child: _buildPostInput()),
                            
                            // フッター
                            _buildFooter(progress, textLength),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Nostrヒント
                    _buildNostrHint(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: ElegantTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Post',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Share your thoughts with the world',
                style: TextStyle(
                  fontSize: 16,
                  color: ElegantTheme.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: ElegantTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Posting to Nostr',
                style: TextStyle(
                  fontSize: 14,
                  color: ElegantTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostInput() {
    return TextField(
      controller: _textController,
      decoration: const InputDecoration(
        hintText: 'What\'s happening?\n\nShare your thoughts, ideas, or updates...',
        border: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
      style: const TextStyle(
        fontSize: 18,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      onChanged: (text) => setState(() {}),
    );
  }

  Widget _buildFooter(double progress, int textLength) {
    return Column(
      children: [
        const Divider(height: 32),
        Row(
          children: [
            // アクションボタン
            _buildActionButton(Icons.image_outlined, 'Photo'),
            const SizedBox(width: 16),
            _buildActionButton(Icons.gif_box_outlined, 'GIF'),
            const SizedBox(width: 16),
            _buildActionButton(Icons.poll_outlined, 'Poll'),
            
            const Spacer(),
            
            // 文字数表示
            _buildCharacterCount(progress, textLength),
            const SizedBox(width: 16),
            
            // 投稿ボタン
            _buildPostButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ElegantTheme.accentBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: ElegantTheme.accentBlue,
        ),
      ),
    );
  }

  Widget _buildCharacterCount(double progress, int textLength) {
    final color = textLength > _maxLength 
        ? Colors.red 
        : ElegantTheme.accentBlue;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: 3,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (textLength > _maxLength - 20)
          Text(
            '${_maxLength - textLength}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
      ],
    );
  }

  Widget _buildPostButton() {
    final canPost = _textController.text.trim().isNotEmpty && 
                   _textController.text.length <= _maxLength;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: canPost && !_isPosting ? _post : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canPost ? ElegantTheme.accentBlue : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isPosting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Post',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildNostrHint() {
    return ElegantCard(
      gradient: ElegantTheme.primaryGradient,
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Your posts are published to the Nostr network',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
