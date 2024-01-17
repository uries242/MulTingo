//
//  LanguageSelectionViewController.swift
//  Multingo4
//
//  Created by Teyko on 1/13/24.
//
//
//import Foundation
//import UIKit
//
//class LanguageSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    weak var delegate: LanguageSelectionDelegate?
//    let availableLanguages = ["es", "fr", "ht", "de"]  // Add more languages as needed
//    let cellIdentifier = "LanguageCell"
//
//    @IBOutlet var tableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
//    }
//
//    // MARK: - UITableViewDataSource
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return availableLanguages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
//
//        // Customize the cell if needed
//        cell.textLabel?.text = availableLanguages[indexPath.row]
//
//        return cell
//    }
//
//    // MARK: - UITableViewDelegate
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedLanguage = availableLanguages[indexPath.row]
//        delegate?.didSelectLanguage(selectedLanguage)
//        dismiss(animated: true, completion: nil)
//    }
//}
