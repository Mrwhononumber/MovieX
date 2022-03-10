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
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.idintifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    //MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDiscoverTable()
        fetchTitles()
        setupSearchController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    //MARK: - Helper methods
    
    func configureUI(){
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        view.addSubview(discoverTable)
    }
    
    func setupDiscoverTable(){
        discoverTable.delegate = self
        discoverTable.dataSource = self
    }
    
    func setupSearchController(){
        searchController.searchResultsUpdater = self
    }
    
    func fetchTitles(){
        APICaller.shared.fetchTitleData(with: Constants.discoverMoviesURL) { [weak self] result in
            switch result{
            case .success (let discoverTitles):
                (self?.titles = discoverTitles)
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print (error)
            }
        }
    }
}

//MARK: - TableView implementation

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTitle = titles[indexPath.row]
        let previewVC = TitlePreviewViewController()
        previewVC.currentTitle = selectedTitle
        navigationController?.pushViewController(previewVC, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              query.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
              }
        resultController.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now()+1.8) {
            APICaller.shared.searchWith(query: query, url: Constants.searchQueryBaseURL) { results in
                switch results{
                case .success(let fetchedSearchedTitles):
                    DispatchQueue.main.async {
                        resultController.titles = fetchedSearchedTitles
                        resultController.searchResultsCollectionView.reloadData()
                    }
                   
                case .failure(let error):
                    print (error)
                }
            }
        }
    }
}

//MARK: - searchResultsViewcontroller delegate implementation

extension SearchViewController:SearchResultsViewControllerDelegate {
    
    
    func SearchResultsViewControllerDidTapTitle(title: Title) {
        
            let PreviewVC = TitlePreviewViewController()
            PreviewVC.currentTitle = title
            navigationController?.pushViewController(PreviewVC, animated: true)
    }
}
