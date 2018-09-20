import Foundation

protocol Cipher {
    func encode(_ plaintext: String, secret: String) -> String

    func decode(_ encryptedText: String, secret: String) -> String
    
    func validInputCheck( text: String, secret: String ) -> String
}

struct CeaserCipher: Cipher {

    func validInputCheck(text: String, secret: String) -> String {
        // Cipher Text Exists
        if( text.isEmpty ) { return "Please Enter Cipher Text" }
        
        // Secret must be present, and a valid number
        if( secret.isEmpty )            { return "Please Enter Cipher Key" }
        else if( Int( secret ) == nil  || Int( secret )! < 0) { return "Please Enter Valid Cipher Key" }
        
        return "" // No Errors
    }
    
    func encode(_ plaintext: String, secret: String) -> String {
        // Check for Invalid Input
        let errorMessage = validInputCheck( text: plaintext, secret: secret )
        if( !errorMessage.isEmpty ) { return errorMessage }
        
        var encoded = ""
        let shiftBy = UInt32(secret)!

        for character in plaintext {
            let unicode = character.unicodeScalars.first!.value
            let shiftedUnicode = unicode + shiftBy
            // update: UInt8 -> UInt16
            let shiftedCharacter = String(UnicodeScalar(UInt16(shiftedUnicode))!)
            encoded += shiftedCharacter
        }
        return encoded
    }
    
    func decode(_ encryptedText: String, secret: String) -> String {
        // Check for Invalid Input
        let errorMessage = validInputCheck( text: encryptedText, secret: secret )
        if( !errorMessage.isEmpty ) { return errorMessage }
        
        var decoded = ""
        let shiftBy = UInt32(secret)!
        
        for character in encryptedText {
            let unicode = character.unicodeScalars.first!.value
            let shiftedUnicode = unicode - shiftBy
            // error: Thread 1: Fatal error: Not enough bits to represent a signed value
            // fix: UInt8 -> UInt16
            let shiftedCharacter = String(UnicodeScalar(UInt16(shiftedUnicode))!)
            
            decoded += shiftedCharacter
        }
        return decoded
    }
}
