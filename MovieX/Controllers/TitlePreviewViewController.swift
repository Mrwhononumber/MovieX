//
//  TitlePreviewViewController.swift
//  MovieX
//
//  Created by Basem El kady on 2/14/22.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    //MARK: - Properties

    private var currentTitle:Title?
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private let titleOverview: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemPink
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    //MARK: - VC Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        configureButtonsActions()
    }
    
    //MARK: - Helper Methods
    
    func configureUI(){
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(titleOverview)
        view.addSubview(downloadButton)
        view.backgroundColor = .systemBackground
    }
    
    func configureConstraints(){
       
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2),
            webView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3.5)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        let titleOverviewConstraints = [
            titleOverview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            titleOverview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleOverview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12)
        ]
        let downloadButtonConstraint = [
            downloadButton.topAnchor.constraint(equalTo: titleOverview.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
       
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(titleOverviewConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraint)
    }
    
    func configure(with title:Title, videoID: String){
        titleLabel.text    = title.original_title ?? title.original_name ?? "unknown"
        titleOverview.text = title.overview ?? "Sorry, No description available for this title currently!"
        currentTitle = title
        guard let trailerURL = URL(string: Constants.youtubePlayerBaseURL+videoID) else {return}
        webView.load(URLRequest(url: trailerURL))
    }
    
    func persistTitle(){
        guard let currentTitle = currentTitle else {return}
        DataPersistenceMAnager.shared.saveTitleToDataBaseWith(currentTitle) { results in
            switch results{
            case .success(_):
                print("Data got saved succesfuly!")
                
            case .failure(let error):
                print (error)
            }
        }
    }
    
    //MARK: - Buttons Actions
    
    func configureButtonsActions(){
        downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
    }
    
    @objc func downloadButtonAction(){
        persistTitle()
    }
}
