import UIKit


class ViewController: UIViewController {

    //MARK: - IB Outlets
    @IBOutlet var firstTranslationOutput: UITextView!
    @IBOutlet var secondTranslationOutput: UITextView!
    @IBOutlet var thirdTranslationOutput: UITextView!
    
    @IBOutlet var inputTranslationBox: UITextView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func translateButtonPressed(_ sender: UIButton) {
       
        // To handle an empty input
        guard let inputText = inputTranslationBox.text, !inputText.isEmpty else {
            return
        }

        let targetLanguages = ["es", "fr", "ht"]

        translateTexts(text: inputText, targetLanguages: targetLanguages)
    }

    func translateTexts(text: String, targetLanguages: [String]) {
        // Clear previous translations
        firstTranslationOutput.text = ""
        secondTranslationOutput.text = ""
        thirdTranslationOutput.text = ""
        
        // Iterate through target languages and index them
        for (index, targetLanguage) in targetLanguages.enumerated() {
           
        // Select the appropriate UITextView based on the index
            var currentTextView: UITextView
            switch index {
            case 0:
                currentTextView = firstTranslationOutput
            case 1:
                currentTextView = secondTranslationOutput
            case 2:
                currentTextView = thirdTranslationOutput
            default:
                // Handle additional target languages if needed
                continue
            }
            
            // Call the translateText function for each target language
            translateText(textToTranslate: text, targetLanguage: targetLanguage, textView: currentTextView)
        }
    }

        
// Translation logic
    func translateText(textToTranslate: String, targetLanguage: String, textView: UITextView) {
        let apiKey = "AIzaSyDSUgVp8M7dBql7rdEXZJ7ibETMpllqoL8"
        let encodedText = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedApiKey = apiKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(encodedApiKey)&q=\(encodedText)&target=\(targetLanguage)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("No data received.")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                if let translations = json?["data"] as? [String: Any],
                   let translatedText = translations["translations"] as? [[String: Any]],
                   let translation = translatedText.first?["translatedText"] as? String {

                    DispatchQueue.main.async {
                       
                        // Decode HTML entities
                        do {
                            let decodedString = try NSAttributedString(data: translation.data(using: .utf8) ?? Data(), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string
                            textView.text = decodedString
                        } catch {
                            print("Error decoding HTML entities: \(error)")
                        }
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        task.resume()
    }
}

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

            
//            for (index, targetLanguage) in targetLanguages.enumerated() {
//                guard let url = buildTranslationURL(text: text, targetLanguage: targetLanguage) else {
//                    // Handle URL construction error
//                    continue
//                }
//
//                // Make HTTP request
//                URLSession.shared.dataTask(with: url) { (data, response, error) in
//                    if let error = error {
//                        // Handle HTTP request error
//                        print("Translation error: \(error.localizedDescription)")
//                        return
//                    }
//
//                    if let data = data,
//                       let translation = String(data: data, encoding: .utf8) {
//                        // Process and update the respective text view
//                        DispatchQueue.main.async {
//                            switch index {
//                            case 0:
//                                self.firstTranslationOutput.text = "\(targetLanguage.uppercased()): \(translation)"
//                            case 1:
//                                self.secondTranslationOutput.text = "\(targetLanguage.uppercased()): \(translation)"
//                            case 2:
//                                self.thirdTranslationOutput.text = "\(targetLanguage.uppercased()): \(translation)"
//                            default:
//                                break
//                            }
//                        }
//                    }
//                }.resume()
//            }
//        }
//
//        func buildTranslationURL(text: String, targetLanguage: String) -> URL? {
//            // Construct URL for translation API (replace with your actual API endpoint)
//            let baseURL = "https://translation-api.example.com/translate"
//            let apiKeyQueryParam = "apiKey=\(apiKey)"
//            let textQueryParam = "text=\(text)"
//            let targetLanguageQueryParam = "targetLanguage=\(targetLanguage)"
//
//            let urlString = "\(baseURL)?\(apiKeyQueryParam)&\(textQueryParam)&\(targetLanguageQueryParam)"
//
//            return URL(string: urlString)
//        }
//    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
////MARK: - INSTANCE PROPERTIES
//    var translationBoxes: [UITextView] = []
//    var selectedLanguage: String = ""
//
//    
////MARK: - VDL
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//        
////MARK: - IB ACTIONS
//    @IBAction func translateButtonPressed(_ sender: Any) {
//        let textToTranslate = inputTranslationBox.text ?? " "
//        let targetLanguage = "fr"
//        
//        // Use the first available translation box
//            guard let targetTextView = translationBoxes.first else { return }
//        
//        translateText(textToTranslate: textToTranslate, targetLanguage: targetLanguage, textView: targetTextView)
//    }
//    
//    @IBAction func addLanguageButtonPressed(_ sender: Any) {
////        showLanguagePicker()
////        addTranslationBox()
//    }
//     
////MARK: - INSTANCE METHODS
//    
//    // Translation logic
//    func translateText(textToTranslate: String, targetLanguage: String, textView: UITextView) {
//
//            let apiKey = "AIzaSyDSUgVp8M7dBql7rdEXZJ7ibETMpllqoL8"
//            let url = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)&q=\(textToTranslate)&target=\(targetLanguage)")!
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Error: \(error)")
//                    return
//                }
//                guard let data = data else {
//                    print("No data received.")
//                    return
//                }
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//
//                    if let translations = json?["data"] as? [String: Any],
//                        let translatedText = translations["translations"] as? [[String: Any]],
//                        let translation = translatedText.first?["translatedText"] as? String {
//
//                        DispatchQueue.main.async {
//                            // Update the text view with the translated text
//                            textView.text = translation
//                        }
//                    }
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//            }
//
//            task.resume()
//        }
//    }

//    func showLanguagePicker() {
//        let languagePicker = UIAlertController(title: "Select Language", message: nil, preferredStyle: .actionSheet)
//        languagePicker.modalPresentationStyle = .popover
//
//        let pickerView = UIPickerView()
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        languagePicker.view.addSubview(pickerView)
//
//        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        languagePicker.addAction(selectAction)
//        languagePicker.addAction(cancelAction)
//
//        if let popoverController = languagePicker.popoverPresentationController {
//            popoverController.sourceView = addLanguageButton
//            popoverController.sourceRect = addLanguageButton.bounds
//        }
//
//        present(languagePicker, animated: true, completion: nil)
//    }
//    
    
//// the constraints for the new translation box
//    func addTranslationBox() {
//        let newTranslationBox = UITextView()
//        newTranslationBox.translatesAutoresizingMaskIntoConstraints = false
//        newTranslationBox.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        newTranslationBox.backgroundColor = .lightGray
//        
//// Adds the new translation box to the stack view
//    translationStackView.addArrangedSubview(newTranslationBox)
//
//// Perform translation for the new language
//        if let selectedLanguage = selectedLanguage {
//        translateText(textToTranslate: inputTranslationBox, targetLanguage: selectedLanguage, textView: newTranslationBox)
//        }
//        
//            // Save the new translation box to the array for future reference
//            translationBoxes.append(newTranslationBox)
//
//}
//           
//extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    var languages: [String] {
//        // Add the languages you want to support in the picker
//        return ["fr", "es", "ht", "de", ]
//    }
//
//    var selectedLanguage: String {
//        return languages.first ?? ""
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return languages.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return languages[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        // Handle language selection if needed
//        // ...
//    }
//}
//




