//
//  WebViewUI.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 14/6/24.
//
import SwiftUI
import WebKit


struct WebViewUI: View {
    @State public var hiddenBackButton: Bool = false
    let uRLString: String
    
    var body: some View {
        NavegationBarView(hiddenBackButton: $hiddenBackButton) {
                WebView(uRLString: uRLString)
        }
    }
}


struct WebView: UIViewRepresentable {
    
    let webView: WKWebView
    let uRLString: String
    
    init(uRLString: String) {
        webView = WKWebView(frame: .zero)
        self.uRLString = uRLString
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        return webView
        
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: URL(string: uRLString)!))
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }
    
    class WebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            guard let url = navigationAction.request.url,
                  let scheme = url.scheme else {
                decisionHandler(.cancel)
                return
            }
            
            if (scheme.lowercased() == "mailto") {
                Utils.openUrl(url)
                // here I decide to .cancel, do as you wish
                decisionHandler(.cancel)
                return
            }
            
            if navigationAction.navigationType == .linkActivated  {
                if let host = url.host, !host.hasPrefix("something whatever you want to handle deeplink") {
                    Utils.openUrl(url)
                    decisionHandler(.cancel)
                    return
                }
            }
            
            decisionHandler(.allow)
        }
    }
    
}
