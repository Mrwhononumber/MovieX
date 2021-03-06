//
//  HomeViewController.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let sectionTitles: [String]  = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let headerView: HeroHeaderUIView = {
        let header = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 450))
        return header
    }()
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    //MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeFeedTableView()
        configureHeader()
        configureNavBar()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    //MARK: - Helper Methods
    
    private func configureUI(){
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.alpha = 0.5
        view.backgroundColor = .black
        view.addSubview(homeFeedTable)
        title = "MovieX"
    }
    
    private func configureNavBar() {
        var appLogo = UIImage(named: "MoviexLogo")
        appLogo = appLogo?.withRenderingMode(.alwaysOriginal)
        let logoButton = UIBarButtonItem(image: appLogo, style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = logoButton
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        profileButton.tintColor = .white
        navigationItem.rightBarButtonItem = profileButton
    }
    
    private func configureHomeFeedTableView(){
        homeFeedTable.delegate   = self
        homeFeedTable.dataSource = self
    }
    
    private func configureHeader(){
        APICaller.shared.fetchTitleData(with: Constants.trendingMoviesURL) {[weak self] results in
            switch results {
                
            case .success(let fetchedRandomTitle):
                DispatchQueue.main.async {
                    guard let randomTitle = fetchedRandomTitle.randomElement() else {return}
                    self?.headerView.configureHeroView(with: randomTitle)
                    self?.headerView.delegate = self
                    self?.homeFeedTable.tableHeaderView = self?.headerView
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
//MARK: -  TableView Implementation

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20,
                                         y: header.bounds.origin.y,
                                         width: 100,
                                         height: header.bounds.height)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = homeFeedTable.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {return UITableViewCell()}
        
        cell.delegate = self
        
        switch indexPath.section {
            
        case HomeTableViewSections.TrendingMovies.rawValue:
            
            APICaller.shared.fetchTitleData(with: Constants.trendingMoviesURL) { result in
                switch result {
                    
                case .success(let trendingMovies):
                    cell.configureCellTitles(with: trendingMovies)
                    
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            
            
        case HomeTableViewSections.TrendingTv.rawValue:
            
            APICaller.shared.fetchTitleData(with: Constants.trendingTvURL) { result in
                switch result {
                    
                case .success(let trendingTv):
                    cell.configureCellTitles(with: trendingTv)
                    
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            
        case HomeTableViewSections.Popular.rawValue:
            
            APICaller.shared.fetchTitleData(with: Constants.popularMoviesURL) { result in
                switch result {
                    
                case .success(let popularMovies):
                    cell.configureCellTitles(with: popularMovies)
                    
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        case HomeTableViewSections.UpcomingMovies.rawValue:
            
            APICaller.shared.fetchTitleData(with: Constants.upcomingMoviesURL) { result in
                switch result {
                    
                case .success(let upcomingMovies):
                    cell.configureCellTitles(with: upcomingMovies)
                    
                case .failure(let error):
                    print(error.rawValue)
                }
            }
            
        case HomeTableViewSections.TopRated.rawValue:
            
            APICaller.shared.fetchTitleData(with: Constants.topRatedMoviesURL) { result in
                switch result {
                    
                case .success(let topRated):
                    cell.configureCellTitles(with: topRated)
                    
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        default:
            break
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

//MARK: - CollectionView Cell Delegate

extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func CollectionViewTableViewCellDidGetTapped(_cell: CollectionViewTableViewCell, title: Title) {
        let previewVC = TitlePreviewViewController()
        previewVC.currentTitle = title
        navigationController?.pushViewController(previewVC, animated: true)
    }
}

//MARK: - HeroHeader Delegate

extension HomeViewController: HeroHeaderUIViewDelegate {
    func didTapTrailerButton(title: Title) {
        let previewVC = TitlePreviewViewController()
        previewVC.currentTitle = title
        navigationController?.pushViewController(previewVC, animated: true)
    }
}

