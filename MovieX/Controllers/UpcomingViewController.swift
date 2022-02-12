//
//  UpcomingViewController.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    //MARK: - Properties
    
    var titles:[Title] = [Title]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.idintifier)
        return table
    }()
    

    
    //MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
       configureNavBar()
       setupUpcomingTable()
        APICaller.shared.fetchTitleData(with: Constants.upcomingMoviesURL) { result in
            switch result{
            case .success (let trending):
                (self.titles = trending)
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }
                
            case .failure(let error):
                break
            }
        }

    }
    
    override func viewDidLayoutSubviews() {
        upcomingTable.frame = view.bounds
    }
    
    //MARK: - Helper methods
    
    func configureNavBar(){
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    
    
}

//MARK: - TableView implementation

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupUpcomingTable(){
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = upcomingTable.dequeueReusableCell(withIdentifier: TitleTableViewCell.idintifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        let title = titles[indexPath.row]
        cell.configure(with: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    
    
}
