//
//  ContentView.swift
//  delete
//
//  Created by Blake  on 2020-02-23.
//  Copyright © 2020 b. All rights reserved.
//

//UIViewRepresentable, wraps UIKit views for use with SwiftUI
import SwiftUI
import WebKit

public struct WebBrowserView {

    private let webView: WKWebView = WKWebView()
    public func load(url: URL) {
        webView.load(URLRequest(url: url))
    }
    public class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {

        var parent: WebBrowserView

        init(parent: WebBrowserView) {
            self.parent = parent
        }

        public func webView(_: WKWebView, didFail: WKNavigation!, withError: Error) {
            // ...
        }

        public func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            // ...
        }

        public func webView(_: WKWebView, didFinish: WKNavigation!) {
            // ...
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // ...
        }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }

        public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

#if os(macOS) // macOS Implementation (iOS version omitted for brevity)
extension WebBrowserView: NSViewRepresentable {

    public typealias NSViewType = WKWebView

    public func makeNSView(context: NSViewRepresentableContext<WebBrowserView>) -> WKWebView {

        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        return webView
    }

    public func updateNSView(_ nsView: WKWebView, context: NSViewRepresentableContext<WebBrowserView>) {

    }
}
#endif
struct BrowserView: View {
    private let browser = WebBrowserView()
    var url: String
    init(url: String) {
        print(url)
        self.url = url
        
    }
    var body: some View {
        HStack {
            browser
                .onAppear() {
                    self.browser.load(url: URL(string: self.url)!)
                }
        }
        .padding()
    }
}

struct ContentView: View {
    @State private var selection = 0
    var body: some View {
        GeometryReader { geo in
            TabView(selection: self.$selection){
                Text("Hello")
                    .tabItem {
                        Text("Home")
                }.tag(0)
                BrowserView(url: "https://reddit.com").tabItem {
                    Text("Social")
                }.frame(width: geo.size.width, height: geo.size.height )
                    .tag(1)
                BrowserView(url: "https://gmail.com").tabItem {
                    Text("Email")
                }.frame(width: geo.size.width, height: geo.size.height)
                .tag(2)
            }.frame(height: geo.size.height)
        }.padding()
    }
}
    

//struct ContentView: View {
//    var body: some View {
//        VStack {
//        Text("Hello, World!")
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            Text("Hello, World!")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//            Text("Hello, World!")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
