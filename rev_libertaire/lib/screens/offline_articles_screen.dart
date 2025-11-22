import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/offline_service.dart';

/// Écran affichant les articles sauvegardés hors ligne
class OfflineArticlesScreen extends StatefulWidget {
  const OfflineArticlesScreen({super.key});

  @override
  State<OfflineArticlesScreen> createState() => _OfflineArticlesScreenState();
}

class _OfflineArticlesScreenState extends State<OfflineArticlesScreen> {
  final OfflineService _offlineService = OfflineService();
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);
    final articles = await _offlineService.getOfflineArticles();
    setState(() {
      _articles = articles;
      _isLoading = false;
    });
  }

  Future<void> _deleteArticle(String fileName) async {
    await _offlineService.deleteOfflineArticle(fileName);
    await _loadArticles();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article supprimé'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _openArticle(Map<String, dynamic> article) async {
    final content = await _offlineService.getOfflineArticleContent(article['fileName']);
    
    if (content == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible de charger l\'article'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _OfflineArticleViewer(
            title: article['title'] ?? 'Article',
            content: content,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles hors ligne'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _articles.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aucun article hors ligne',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    final article = _articles[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF8B0000),
                          child: Icon(Icons.article, color: Colors.white),
                        ),
                        title: Text(
                          article['title'] ?? 'Sans titre',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Sauvegardé le ${_formatDate(article['savedAt'])}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteArticle(article['fileName']),
                        ),
                        onTap: () => _openArticle(article),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}

/// Widget pour afficher un article hors ligne
class _OfflineArticleViewer extends StatefulWidget {
  final String title;
  final String content;

  const _OfflineArticleViewer({
    required this.title,
    required this.content,
  });

  @override
  State<_OfflineArticleViewer> createState() => _OfflineArticleViewerState();
}

class _OfflineArticleViewerState extends State<_OfflineArticleViewer> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadHtmlString(_wrapHtmlContent(widget.content));
  }

  /// Enveloppe le contenu HTML avec un style propre
  String _wrapHtmlContent(String content) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      padding: 16px;
      line-height: 1.6;
      color: #333;
      background-color: #fff;
    }
    img {
      max-width: 100%;
      height: auto;
    }
    a {
      color: #8B0000;
      text-decoration: none;
    }
    h1, h2, h3 {
      color: #8B0000;
      margin-top: 24px;
      margin-bottom: 12px;
    }
    p {
      margin-bottom: 16px;
    }
    .offline-badge {
      background-color: #8B0000;
      color: white;
      padding: 8px 16px;
      border-radius: 20px;
      display: inline-block;
      margin-bottom: 16px;
      font-size: 14px;
      font-weight: bold;
    }
  </style>
</head>
<body>
  <div class="offline-badge">📖 Mode hors ligne</div>
  <h1>${widget.title}</h1>
  <hr>
  $content
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF0000), Colors.black],
              stops: [0.5, 0.5],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8B0000),
              ),
            ),
        ],
      ),
    );
  }
}
