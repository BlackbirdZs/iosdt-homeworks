//
//  MainTableViewController.swift
//  DocApp
//
//  Created by Anton Kruglov on 25.11.2026.
//

import UIKit

class MainTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var fileManagerService: FileManagerServiceProtocol = FileManagerService(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])

    private var isSortingEnabled = true
    private var isPhotoSizeEnabled = true
    
    var displayedItems: [String] {
        let items = fileManagerService.contentsOfDirectory
        return isSortingEnabled ? items.sorted() : items.sorted(by: >)
    }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSortingEnabled = UserDefaults.standard.bool(forKey: "isSortingEnabled")
        isPhotoSizeEnabled = UserDefaults.standard.bool(forKey: "isPhotoSizeEnabled")
        tableView.reloadData()
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
        imagePickerSetup()
    }

    func getFileSize(at path: String) -> String {
        let fileManager = FileManager.default
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path)
            if let size = attributes[.size] as? Int64 {
                return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
            }
        } catch {
            print("error: \(error.localizedDescription)")
        }
        return ""
    }

    func imagePickerSetup() {
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
        return displayedItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let itemName = displayedItems[indexPath.row]
        var cellConfig = UIListContentConfiguration.cell()
        let filePath = fileManagerService.path + "/" + itemName
        var isFolder = false
        var objBool: ObjCBool = false
        FileManager.default.fileExists(atPath: filePath, isDirectory: &objBool)
        isFolder = objBool.boolValue
        
        if isPhotoSizeEnabled && !isFolder {
            let size = getFileSize(at: filePath)
            cellConfig.text = "\(itemName) (\(size))"
        } else {
            cellConfig.text = itemName
        }
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
            let itemName = displayedItems[indexPath.row]
            if let originalIndex = fileManagerService.contentsOfDirectory.firstIndex(of: itemName) {
                fileManagerService.removeContent(at: originalIndex)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemName = displayedItems[indexPath.row]
        let filePath = fileManagerService.path + "/" + itemName
        var isFolder = false
        var objBool: ObjCBool = false
        FileManager.default.fileExists(atPath: filePath, isDirectory: &objBool)
        isFolder = objBool.boolValue
        if isFolder {
            let mainVc = MainTableViewController()
            mainVc.fileManagerService = FileManagerService(path: filePath)
            navigationController?.pushViewController(mainVc, animated: true)
        } else {
            TextPicker.shared.showMessage(in: self, message: "File tapped", title: "Attention")
        }
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
