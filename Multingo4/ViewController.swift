import UIKit

class ViewController: UIViewController {
    
//MARK: - IB Outlets
    @IBOutlet var firstTranslationOutput: UITextView!
    @IBOutlet var secondTranslationOutput: UITextView!
    @IBOutlet var thirdTranslationOutput: UITextView!
    @IBOutlet var inputTranslationBox: UITextView!
    
//MARK: - Instance Properties
    // Added variables to track the active container tag and selected languages
    var activeContainerTag: Int?
    var selectedLanguages: [Int: String] = [:]
    
    let availableLanguages = ["es", "fr", "ht", "de", "it", "zh", "pt"]
    
    // Dictionary to map language abbreviations with their full names
    let languageMapping: [String: String] = [
        "es": "Spanish",
        "fr": "French",
        "ht": "Haitian Creole",
        "de": "German",
        "it": "Italian",
        "zh": "Chinese",
        "pt": "Portuguese"
    ]
    
//MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//MARK: - IB ACTIONS
    @IBAction func translateButtonPressed(_ sender: UIButton) {
        
        // To handle an empty input
        guard let inputText = inputTranslationBox.text, !inputText.isEmpty else {
            return
        }
        
        // Get the target languages for each container
        let targetLanguages: [String] = [
            selectedLanguages[1] ?? "",
            selectedLanguages[2] ?? "",
            selectedLanguages[3] ?? ""
        ]
        
        translateTexts(text: inputText, targetLanguages: targetLanguages)
    }
    
    // Function to change languages via UIAlertController for each button
    @IBAction func changeLanguageButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Language", message: nil, preferredStyle: .actionSheet)
        
        for languageAbbreviation in availableLanguages {
            if let languageFullName = languageMapping[languageAbbreviation] {
                let action = UIAlertAction(title: languageFullName, style: .default) { [weak self] _ in
                    self?.didSelectLanguage(languageAbbreviation, forContainerWithTag: sender.tag)
                    
                    // Updates the button title with the selected language
                    sender.setTitle(languageFullName, for: .normal)
                }
                alertController.addAction(action)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - INSTANCE METHODS
    // Update the selectedLanguages dictionary with the selected language for the specific container
    func didSelectLanguage(_ language: String, forContainerWithTag tag: Int) {
        selectedLanguages[tag] = language
        
        // You can perform additional actions, such as updating translations
        translateTexts(text: inputTranslationBox.text, targetLanguages: Array(selectedLanguages.values))
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
                        textView.text = translation.removingPercentEncoding ?? translation
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }

    // To show language selection alert
    func showLanguageSelectionAlert() {
        let alertController = UIAlertController(title: "Select Language", message: nil, preferredStyle: .actionSheet)
        
        // Array of available languages
        let availableLanguages = ["Spanish", "French", "Haitian Creole", "German"]
        
        // Create actions for each language
        for (index, language) in availableLanguages.enumerated() {
            let action = UIAlertAction(title: language, style: .default) { [weak self] _ in
                // Handle language selection
                self?.handleLanguageSelection(index)
            }
            alertController.addAction(action)
        }
        // Added cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    // To handle language selection
    func handleLanguageSelection(_ selectedLanguageIndex: Int) {
        guard let activeContainerTag = activeContainerTag else {
            return
        }
        
        // Array of available languages
        let availableLanguages = ["Spanish", "French", "Haitian Creole", "German"] // Add more languages as needed
        
        // Get the selected language
        let selectedLanguage = availableLanguages[selectedLanguageIndex]
        
        // Update the selected language for the active container
        selectedLanguages[activeContainerTag] = selectedLanguage
        
        // Update the UI based on the selected language
        updateUITranslationForContainer(tag: activeContainerTag, language: selectedLanguage)
    }
    
    // Add the updateUITranslationForContainer method
    func updateUITranslationForContainer(tag: Int, language: String) {
        // Perform translation or update UI elements based on the selected language
        switch tag {
        case 1:
            // Update UI elements for the first container
            // Example: translateTexts(text: inputTranslationBox.text, targetLanguages: [language])
            firstTranslationOutput.text = language
        case 2:
            // Update UI elements for the second container
            secondTranslationOutput.text = language
        case 3:
            // Update UI elements for the third container
            thirdTranslationOutput.text = language
        default:
            break
        }
    }
    
}

extension String {
        var htmlDecoded: String {
            let decoded = try? NSAttributedString(data: Data(utf8), options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
            return decoded ?? self
        }
    }


// fix encoding issues
// rearrange buttons
// add the change lang func to the other two boxes
// add the changeLang button to the inputbox


