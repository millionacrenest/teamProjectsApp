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
    
    private var userTeams = [Included]()
    
    private var userProjects = [Data]() {
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
                            
                            if let userTeams = json.included {
                                self.userTeams.append(contentsOf: userTeams)
                            }
                            
                            if let displayData = json.data {
                                for data in displayData {
                                    if data.type == "projects" {
                                        self.userProjects.append(data)
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "RECENT"
        } else {
            return userTeams[section - 1].attributes?.name
        }
    }
    
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

        if section == 0 {
            return userProjects.count
        } else {
            let sectionTeam = userTeams[section - 1]
            let sectionProjects = userProjects.filter { $0.relationships?.team?.id == sectionTeam.id }
            return sectionProjects.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        
        if indexPath.section == 0 {
           
            let dateSortedProjects = userProjects.sorted {
                $0.attributes?.updated_at ?? "" < $1.attributes?.updated_at ?? ""
            }
            
            cell.detailTextLabel?.isHidden = false
            let project = dateSortedProjects[indexPath.row]
            cell.textLabel?.text = project.attributes?.name
            cell.detailTextLabel?.text = project.relationships?.team?.id
            
        } else {
            let sectionTeam = userTeams[indexPath.section - 1]
            let sectionProjects = userProjects.filter { $0.relationships?.team?.id == sectionTeam.id }
            let project = sectionProjects[indexPath.row]
            
            cell.textLabel?.text = project.attributes?.name
            cell.detailTextLabel?.isHidden = true
            
        }
        
        
        return cell
    }
    
    
}
