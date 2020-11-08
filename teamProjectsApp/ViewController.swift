//
//  ViewController.swift
//  teamProjectsApp
//
//  Created by McEntire, Allison on 11/8/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var userTeams = [Team]() {
        didSet {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.startAnimating()
        fetchUserData()
        
    }
    
    func fetchUserData() {
        if let url = URL(string: "https://frameio-swift-exercise.herokuapp.com/projects?include=team") {
            
            let session = SessionManager.shared.session
            
                    let task = session.dataTask(with: url, completionHandler: { data, response, error in
                        
                        if error != nil {
                            print(error ?? "ERROR")
                            return
                        }
                        
                        // Serialize the data into an object
                        do {
                            let json = try JSONDecoder().decode(UserData.self, from: data! )
                                try JSONSerialization.jsonObject(with: data!, options: [])
                            if let displayData = json.data {
                                for data in displayData {
                                    if let relationships = data.relationships, let team = relationships.team {
                                        if !self.userTeams.contains(team) {
                                            self.userTeams.append(team)
                                        }
                                    }
                                }
                            }
                            
                        } catch {
                            print("Error during JSON serialization: \(error.localizedDescription)")
                        }
                        
                    })
                    task.resume()
            
            
        }
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userTeams.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = "TEST"
        cell.detailTextLabel?.text = "testing"
        return cell
    }
    
    
}
