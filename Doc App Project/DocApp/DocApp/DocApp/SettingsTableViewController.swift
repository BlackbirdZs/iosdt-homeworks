//
//  SettingsTableViewController.swift
//  DocApp
//
//  Created by Anton Kruglov on 27.11.2026.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    var isSortingOn: Bool = true
    var isPhotoSizeOn: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSortingOn = UserDefaults.standard.bool(forKey: "isSortingEnabled")
        isPhotoSizeOn = UserDefaults.standard.bool(forKey: "isPhotoSizeEnabled")
        tableView.reloadData()
    }

    func setupView() {
        view.backgroundColor = .systemBackground
    }

    @objc func sortSwitchTapped(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isSortingEnabled")
    }

    @objc func photoSizeSwitchTapped(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "isPhotoSizeEnabled")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        if indexPath.row == 0 {
            config.text = "Sort content"
            config.image = UIImage(systemName: "arrow.up.arrow.down")
            let switchView = UISwitch()
            switchView.isOn = isSortingOn
            switchView.addTarget(self, action: #selector(sortSwitchTapped), for: .valueChanged)
            cell.accessoryView = switchView
        } else if indexPath.row == 1 {
            config.text = "Photo size"
            config.image = UIImage(systemName: "photo.on.rectangle")
            let switchView = UISwitch()
            switchView.isOn = isPhotoSizeOn
            switchView.addTarget(self, action: #selector(photoSizeSwitchTapped), for: .valueChanged)
            cell.accessoryView = switchView
        } else {
            config.text = "Change password"
            config.image = UIImage(systemName: "lock.rotation")
            cell.accessoryType = .disclosureIndicator
        }
        cell.contentConfiguration = config
        cell.selectionStyle = .default
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            let passChangeVc = PasswordChangeViewController()
            let passNav = UINavigationController(rootViewController: passChangeVc)
            present(passNav, animated: true)
        }
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
