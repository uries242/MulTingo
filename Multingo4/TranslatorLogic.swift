import UIKit

struct Translator {
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
