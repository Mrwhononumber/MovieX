//
//  SearchViewController.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Properties
 
    private var titles:[Title] = [Title]()
    
    private let discoverTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.idintifier)
        return table
    }()
    
    //MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDiscoverTable()
        fetchTitles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    //MARK: - Helper methods
    
    func configureUI(){
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
    }
    
    func fetchTitles(){
        APICaller.shared.fetchTitleData(with: Constants.discoverMoviesURL) { result in
            switch result{
            case .success (let discoverTitles):
                (self.titles = discoverTitles)
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                break
            }
        }
    }
}

//MARK: - TableView implementation

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupDiscoverTable(){
        discoverTable.delegate = self
        discoverTable.dataSource = self
        view.addSubview(discoverTable)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = discoverTable.dequeueReusableCell(withIdentifier: TitleTableViewCell.idintifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
