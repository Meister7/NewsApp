//
//  ViewController.swift
//  NewsApp
//
//  Created by Эмир Кармышев on 19/2/22.
//

import UIKit
import SnapKit

class MainController: UIViewController {
    
    private lazy var searchField: UITextField = {
       let view = UITextField()
        view.placeholder = "Search"
        view.autocorrectionType = .no
        return view
    }()
    
    private lazy var searchButton: UIButton = {
       let view = UIButton()
        view.setTitle("Search", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.addTarget(self, action: #selector(clickSearch(view:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var newsTableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var newsNumber: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textColor = .gray
        view.textAlignment = .center
        return view
    }()
    
    private lazy var star: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named:  "star"), for: .normal)
        return view
    }()
    
    
    private var models: NewsModel? = nil
    
    @objc func clickSearch(view: UIButton) {
        var search = String()
        var error = true
        
        if searchField.text == nil {
            let alert = UIAlertController(title: "Error", message: "Enter news to search!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
            present(alert,animated: true)
            error = true
        } else {
            search = searchField.text ?? String()
            error = false
        }
        
        search = search.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if error == true {
            
            let alert = UIAlertController(title: "Error", message: "Check if the data entered is correct.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
            present(alert,animated: true)
            error = true
            
        } else {
            let url = URL(string: "https://newsapi.org/v2/everything?q=\(search)&from=2022-01-27&sortBy=publishedAt&apiKey=b930c4e49a69475c9e815d5b93efe2ed")
            
            URLSession.shared.dataTask(with: url!) { data, response, error in
                
                if let error = error {
                    print("json error")
                    print(error)
                } else {
                    self.models = try! JSONDecoder().decode(NewsModel.self, from: data!)
                    DispatchQueue.main.async {
                        self.newsNumber.text = "\(self.models?.articles?.count ?? 0) news items found for your request"
                        if self.models?.articles?.count == 0 {
                            let alert = UIAlertController(title: "Error", message: "There are no news for your request", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
                            self.present(alert,animated: true)
                        }
                        self.newsTableView.reloadData()
                    }
                }
            }.resume()
        }
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            title = "News"
            
            view.addSubview(searchField)
            searchField.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(80)
                make.left.equalToSuperview().offset(10)
                make.width.equalTo(200)
            }
            
            view.addSubview(searchButton)
            searchButton.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(80)
                make.right.equalToSuperview().offset(10)
                make.left.equalTo(searchField.snp.right).offset(10)
            }
            
            view.addSubview(newsNumber)
            newsNumber.snp.makeConstraints { make in
                make.top.equalTo(searchField.snp.bottom)
                make.centerX.equalToSuperview()
                make.height.equalTo(30)
            }
            
            view.addSubview(newsTableView)
            newsTableView.snp.makeConstraints{ make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(searchField.snp.bottom).offset(10)
            }
            
            view.addSubview(star)
            star.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(40)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(view.frame.height / 20)
                make.width.equalTo(view.frame.height / 20)
            }
        }
        
    }
    extension MainController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let url = models?.articles?[indexPath.row].url
            let controller = NewsDetailsController()
            controller.url = url
            controller.title = models?.articles?[indexPath.row].title
            navigationController?.pushViewController(controller, animated: true)
            
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return models?.articles?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = NewsCell()
            let model = models?.articles?[indexPath.row]
            
            cell.fill(model: model)
            return cell
        }
        
    }
    

