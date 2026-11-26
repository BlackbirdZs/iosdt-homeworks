//
//  MainTableViewController.swift
//  DocApp
//
//  Created by Anton Kruglov on 25.11.2026.
//

import UIKit

class MainTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var fileManagerService: FileManagerServiceProtocol = FileManagerService(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func setupView() {
        view.backgroundColor = .systemBackground
        title = fileManagerService.title
    }

    func setupNavItems() {
        let folderButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapPlus))

        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "folder.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(didTapFolder))
        navigationItem.rightBarButtonItems = [folderButton, addButton]
    }

    @objc func didTapFolder() {
        TextPicker.shared.addFolderAlert(in: self) { [weak self] text in
            guard let self else { return }
            fileManagerService.createDirectory(with: text)
            tableView.reloadData()
        }
    }

    @objc func didTapPlus() {
        colorPickerSetup()
    }

    func colorPickerSetup() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .pageSheet
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        let fileName = UUID().uuidString + ".jpg"
        fileManagerService.createFile(with: imageData, name: fileName)
        picker.dismiss(animated: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fileManagerService.contentsOfDirectory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var cellConfig = UIListContentConfiguration.cell()
        let isFolder = fileManagerService.isItemInFolder(index: indexPath.row)
        cellConfig.text = fileManagerService.contentsOfDirectory[indexPath.row]
        cellConfig.image = UIImage(systemName: isFolder ? "folder.fill" : "photo.fill")
        cell.contentConfiguration = cellConfig
        cell.selectionStyle = .default
        cell.accessoryType = isFolder ? .disclosureIndicator : .none
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileManagerService.removeContent(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fileManagerService.isItemInFolder(index: indexPath.row) {
            let mainVc = MainTableViewController()
            mainVc.fileManagerService = FileManagerService(path: fileManagerService.path + "/" + fileManagerService.contentsOfDirectory[indexPath.row])
            navigationController?.pushViewController(mainVc, animated: true)
        }
    }

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
