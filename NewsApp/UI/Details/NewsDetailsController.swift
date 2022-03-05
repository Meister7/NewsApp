//
//  NewsDetailsController.swift
//  NewsApp
//
//  Created by Эмир Кармышев on 19/2/22.
//

import Foundation
import UIKit
import SnapKit
import WebKit

class NewsDetailsController: UIViewController {
    
    var url: String? = nil
    
    private lazy var webView: WKWebView = {
       return WKWebView()
    }()
    
    override func viewDidLoad() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        webView.load(URLRequest(url: URL(string: url!)!))
    }
    
}
