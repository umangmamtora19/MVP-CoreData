//
//  DashboardVC.swift
//  MVP+CoreData
//
//  Created by Umang on 16/06/23.
//

import UIKit

class DashboardVC: UIViewController {
    
    //    MARK: - Outlets
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblUsers: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    //    MARK: - Variables
    let presenter: DashboardPresenter = DashboardPresenter()
    var userList = [AddedUsers]()
    
    //    MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.setViewDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchUsers()
    }
}

//    MARK: - Common functions
extension DashboardVC {
    func setupUI() {
        btnAdd.roundedCorners()
    }
}

//    MARK: - Actions
extension DashboardVC {
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "MVP+CoreData", message: "Are you want to logout?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { action in
            UserDefaults.standard.set(false, forKey: Keys.isLoggedIn)
            UserDefaults.standard.set(0, forKey: Keys.userId)
            UserDefaults.standard.synchronize()
            scenedelegate?.checkRootController()
        }
        let noAction = UIAlertAction(title: "No", style: .default)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true)
    }
    
    @IBAction func btnAddUser(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
        vc.isForAdd = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

//      MARK: - DashboardPresenterDelegate Methods
extension DashboardVC: DashboardPresenterDelegate {
    func userFetched(userList: [AddedUsers], message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if userList.count > 0 {
                self.lblNoData.isHidden = true
            } else {
                self.lblNoData.isHidden = false
            }
            self.userList = userList
            self.tblUsers.reloadData()
        }
    }
}

//    MARK: - TableView Delegate Methods
extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTVC") as? DashboardTVC else {
            return UITableViewCell()
        }
        let item = userList[indexPath.row]
        cell.lblFName.text = item.fname
        cell.lblLName.text = item.lname
        cell.imgProfile.image = UIImage(data: item.profile ?? Data())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
        let item = userList[indexPath.row]
        vc.fname = item.fname ?? ""
        vc.lname = item.lname ?? ""
        vc.profile = UIImage(data: item.profile ?? Data()) ?? UIImage()
        vc.userIdToUpdate = item.id
        navigationController?.pushViewController(vc, animated: true)
    }
}
