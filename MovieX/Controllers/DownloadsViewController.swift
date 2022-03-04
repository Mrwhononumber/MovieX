//
//  DownloadsViewController.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    //MARK: - Properties
        
    private var titles: [StoredTitle] = [StoredTitle]()
    
    private let downloadsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.idintifier)
        return table
    }()
    
    //MARK: - VC Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDownloadsTable()
    }
    
    override func viewDidLayoutSubviews() {
        downloadsTable.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchStoredTitles()
    }
    
    //MARK: - Helper functions
    
    private func configureUI(){
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(downloadsTable)
    }
    
    private func setupDownloadsTable(){
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
    }
    
    private func fetchStoredTitles() {
        DataPersistenceMAnager.shared.loadStoredTitlesFromDataBase {[weak self] results in
            switch results {
            case .success(let storedTitles):
                self?.titles = storedTitles
                self?.downloadsTable.reloadData()
            case .failure(let error):
                print (error)
            }
        }
    }
}

//MARK: - TableView implementation

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = downloadsTable.dequeueReusableCell(withIdentifier: TitleTableViewCell.idintifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        let storedTitle = titles[indexPath.row]
        let title = Title(id: Int(storedTitle.id), media_type: storedTitle.media_type, original_name: storedTitle.original_name, original_title: storedTitle.original_title, poster_path: storedTitle.poster_path, overview: storedTitle.overview, vote_count: Int(storedTitle.vote_count), release_date: storedTitle.release_date, vote_average: storedTitle.vote_average)
        cell.configure(with: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            let titleToDelete = titles[indexPath.row]
            DataPersistenceMAnager.shared.deleteStoredTitlefromDataBase(titleToDelete) { results in
                switch results {
                case .success(_):
                    print("Succesful delition")
                case .failure(let error):
                    print(error)
                }
            }
            self.titles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedStoredTitle = titles[indexPath.row]
        let selectedTitle = Title(id: Int(selectedStoredTitle.id), media_type: selectedStoredTitle.media_type, original_name: selectedStoredTitle.original_name, original_title: selectedStoredTitle.original_title, poster_path: selectedStoredTitle.poster_path, overview: selectedStoredTitle.overview, vote_count: Int(selectedStoredTitle.vote_count), release_date: selectedStoredTitle.release_date, vote_average: selectedStoredTitle.vote_average)
        let previewVC = TitlePreviewViewController()
        APICaller.shared.getYoutubeTrailerIdWith(query: selectedTitle.original_title ?? selectedTitle.original_name ?? "", url: Constants.youtubeSearchBaseURL) { results in
            switch results {
                
            case .success(let trailerID):
                DispatchQueue.main.async {
                    previewVC.configure(with: selectedTitle, videoID: trailerID)
                }
                
            case .failure(let error):
                previewVC.configure(with: selectedTitle, videoID: "")
                print(error)
            }
        }
        previewVC.downloadButtonShouldBeHidden = true
        navigationController?.pushViewController(previewVC, animated: true)
    }
}

