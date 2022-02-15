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
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate   = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        configureHeader()
   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    //MARK: - Helper Methods
    
    
    func configureNavBar() {
        var appLogo = UIImage(named: "MoviexLogo")
        appLogo = appLogo?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: appLogo, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
    }
    
    func configureHeader(){
        APICaller.shared.fetchTitleData(with: Constants.trendingMoviesURL) { results in
            switch results {
          
            case .success(let fetchedRandomTitle):
                DispatchQueue.main.async {
                    guard let randomTitle = fetchedRandomTitle.randomElement() else {return}
                    self.headerView.configure(with: randomTitle)
                    self.homeFeedTable.tableHeaderView = self.headerView
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
    
    // Push NavBar when scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    

}

extension HomeViewController: CollectionViewTableViewCellDelegate {
  
    func CollectionViewTableViewCellDidGetTapped(_cell: CollectionViewTableViewCell, title: Title, videoID: String) {
        DispatchQueue.main.async {
            let vc = TitlePreviewViewController()
            vc.configure(with: title, videoID: videoID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

