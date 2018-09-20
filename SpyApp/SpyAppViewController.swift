import UIKit

class SpyAppViewController: UIViewController {

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var secret: UITextField!
    
    @IBOutlet weak var output: UITextView!
    
    @IBOutlet weak var cesarCipherButton: UIButton!
    @IBOutlet weak var alphanumericCipherButton: UIButton!
    @IBOutlet weak var emojiCipherButton: UIButton!
    @IBOutlet weak var railfenceCipherButton: UIButton!
    
    @IBOutlet weak var encodeButton: UIButton!
    @IBOutlet weak var decodeButton: UIButton!
    
    let factory = CipherFactory()
    var cipher: Cipher!
    
    var plaintext: String {
        if let text = input.text {
            return text
        } else {
            return ""
        }
    }
    
    var encryptedText: String {
        if let text = input.text {
            return text
        } else {
            return ""
        }
    }
    
    var secretText: String {
        if let text = secret.text {
            return text
        } else {
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Button Styling done at run time - Rounded Corners
        cesarCipherButton.layer.cornerRadius = 5
        alphanumericCipherButton.layer.cornerRadius = 5
        emojiCipherButton.layer.cornerRadius = 5
        railfenceCipherButton.layer.cornerRadius = 5
        
        encodeButton.layer.cornerRadius = 5
        decodeButton.layer.cornerRadius = 5
        output.layer.cornerRadius = 5
    }

    @IBAction func encodeButtonPressed(_ sender: UIButton) {
        if let cipher = self.cipher {
            output.text = cipher.encode(plaintext, secret: secretText)
        } else {
            output.text = "Please select a Cipher."
        }
    }

    @IBAction func decodeButtonPressed(_ sender: UIButton) {
        if let cipher = self.cipher {
            output.text = cipher.decode(encryptedText, secret: secretText)
        } else {
            output.text = "Please select a Cipher."
        }
    }
    
    @IBAction func cipherButtonPressed(_ sender: UIButton) {
        guard
          let buttonLabel = sender.titleLabel,
          let buttonText = buttonLabel.text
        else {
            output.text = "No button or no button text."
            return
        }
        cipher = factory.cipher(for: buttonText)
    }
}
