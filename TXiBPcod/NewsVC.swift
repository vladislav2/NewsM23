//
//  NewsVC.swift
//  TXiBPcod
//
//  Created by user on 30.12.2020.
//

import UIKit
import WebKit

class NewsVC: UIViewController {
  
  var articleURL = ""

  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var newsWebView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    settingWebView()
  }
  
  func settingWebView() {
    guard let url = URL(string: articleURL) else { return }
    let request = URLRequest(url: url)
    newsWebView.load(request)
    newsWebView.allowsBackForwardNavigationGestures = true
    newsWebView.navigationDelegate = self
    newsWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(newsWebView.estimatedProgress)
    }
  }
  
  private func showProgressView() {
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
      self.progressView.alpha = 1
    }, completion: nil)
  }
  
  private func hideProgressView() {
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
      self.progressView.alpha = 0
    }, completion: nil)
  }
}

extension NewsVC: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    showProgressView()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    hideProgressView()
  }
  
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    hideProgressView()
  }
}
