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
    
    var downloadButtonShouldBeHidden = false
    
   private var titleIsStored = false
    
     var currentTitle:Title?
  
    private var downloadsVC = DownloadsViewController()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titlePoster: UIImageView = {
       let poster = UIImageView()
        poster.translatesAutoresizingMaskIntoConstraints = false
        return poster
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
        button.setTitle("Download", for: .normal)
       button.layer.borderColor = UIColor.white.cgColor
       button.layer.borderWidth = 1
       button.layer.cornerRadius = 5
       button.translatesAutoresizingMaskIntoConstraints = false
         return button
    }()
    
    //MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        configureButtonsActions()
        configureTitlePreview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDownloadButtonVisibility()
        checkIfTitleIsStoredWith(titleID: currentTitle?.id ?? 0)
    }
    
    //MARK: - Helper Methods
    
   private func configureUI(){
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(titleOverview)
        view.addSubview(downloadButton)
        view.backgroundColor = .black
    }
    
   private func configureConstraints(){
        
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
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
        let titlePosterConstraints = [
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
            webView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/3.5)
       ]
       
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(titleOverviewConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraint)
        NSLayoutConstraint.activate(titlePosterConstraints)
    }
    
    private func configureTitlePreview(){
        titleLabel.text    = currentTitle?.original_title ?? currentTitle?.original_name ?? "unknown"
        titleOverview.text = currentTitle?.overview ?? "Sorry, No description available for this title currently!"
       // Get youtube trailer link
        APICaller.shared.getYoutubeTrailerIdWith(query: currentTitle?.original_title ?? currentTitle?.original_name ?? "", url: Constants.youtubeSearchBaseURL) {[weak self] results in
            switch results {
                
            case .success(let videoID):
                guard let trailerURL = URL(string: Constants.youtubePlayerBaseURL+videoID) else {return}
                DispatchQueue.main.async {
                    self?.webView.load(URLRequest(url: trailerURL))
                }
                
            case .failure(let error):
                print(error)
                guard let backupURL = URL(string: Constants.backupTrailerURL) else {return}
                self?.webView.load(URLRequest(url: backupURL))
                
            }
        }
    }
    
   private func persistTitle(){
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
    
   private func checkIfTitleIsStoredWith(titleID:Int){
        // Check if the title is stored already to handle the download button
        if DataPersistenceMAnager.shared.checkIfTitleIsStoredWith(titleID) {
            titleIsStored = true
            updateDownloadButtonUI()
            downloadButton.layer.borderColor = UIColor.green.cgColor
            downloadButton.titleLabel?.text = "Downloaded"
        } else {
            titleIsStored = false
            updateDownloadButtonUI()
            downloadButton.layer.borderColor = UIColor.white.cgColor
            downloadButton.titleLabel?.text = "Download"
        }
    }
        
    private func updateDownloadButtonUI(){
        if titleIsStored {
            downloadButton.performSpringAnimation()
            downloadButton.isEnabled = false
            downloadButton.layer.borderColor = UIColor.green.cgColor
            downloadButton.setTitle("Downloaded", for: .normal)
        } else {
            downloadButton.isEnabled = true
            downloadButton.layer.borderColor = UIColor.white.cgColor
            downloadButton.setTitle("Download", for: .normal)
        }
    }
    
    private func checkDownloadButtonVisibility(){
         if downloadButtonShouldBeHidden {
             downloadButton.isHidden = true
         } else {
             return
         }
     }
    
    //MARK: - Buttons Actions
    
   private func configureButtonsActions(){
        downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
    }
    
    @objc private func downloadButtonAction(){
        persistTitle()
        titleIsStored = true
        downloadButton.layer.borderColor = UIColor.green.cgColor
        updateDownloadButtonUI()
    }
}
