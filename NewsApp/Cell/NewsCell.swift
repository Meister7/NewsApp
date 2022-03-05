//
//  NewsCell.swift
//  NewsApp
//
//  Created by Эмир Кармышев on 19/2/22.
//

import Foundation
import SnapKit
import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
    
    private lazy var newsImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var newsTitle: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.textColor = .black
        view.text = "test123"
        return view
    }()
    
    private lazy var newsDexription: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = .black
        view.text = "test123"
        return view
    }()
    
    override func layoutSubviews() {
        addSubview(newsImage)
        newsImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(100)
        }
        
        addSubview(newsTitle)
        newsTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(newsDexription)
        newsDexription.snp.makeConstraints { make in
            make.top.equalTo(newsTitle.snp.bottom).offset(4)
            make.left.equalTo(newsImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    func fill(model: Article?) {
        newsTitle.text = model?.title
        newsDexription.text = model?.articleDescription
        
        if let url = model?.urlToImage {
            if let urlSS = URL(string: url) {
            newsImage.kf.setImage(with: urlSS)
            }
        }
    }
}
