// Task #2
import Foundation

struct AlphanumericCesarCipher: Cipher {
    
    func validInputCheck(text: String, secret: String) -> String {
        // Cipher Text Exists
        if( text.isEmpty )                 { return "Please Enter Cipher Text" }
        else if( !isAlphanumeric( text ) ) { return "Please Enter Alphanumeric Cipher Text Only" }
        
        // Secret must be present, and a valid number
        if( secret.isEmpty )            { return "Please Enter Cipher Key" }
        else if( Int( secret ) == nil  || Int( secret )! < 0 ) { return "Please Enter Valid Cipher Key" }

        return "" // No Errors
    }
    
    func isAlphanumeric( _ text: String ) -> Bool {
        return !text.isEmpty && text.range( of: "[^a-zA-Z0-9]", options: .regularExpression ) == nil
    }
    
    func codeInBounds( _ code:UInt32 ) -> UInt32 {
        let upperCaseAUnicode = String( "A" ).unicodeScalars.first!.value
        let upperCaseZUnicode = String( "Z" ).unicodeScalars.first!.value
        let numberZeroUnicode = String( "0" ).unicodeScalars.first!.value
        let numberNineUnicode = String( "9" ).unicodeScalars.first!.value
        
        if ( code > upperCaseZUnicode ) {
            return numberZeroUnicode
            
        } else if ( code == upperCaseAUnicode - 1 ) {
            return numberNineUnicode
            
        } else if ( code < numberZeroUnicode ) {
            return upperCaseZUnicode
            
        } else if ( code == numberNineUnicode + 1 ) {
            return upperCaseAUnicode
            
        }
        
        return code
    }
    
    func encode( _ plaintext: String, secret: String ) -> String {
        // Check for Invalid Input
        let errorMessage = validInputCheck( text: plaintext, secret: secret )
        if( !errorMessage.isEmpty ) { return errorMessage }
        
        var encodedText = ""
        let shiftBy = UInt32( secret )!
        let lowerCaseText = plaintext.uppercased()
        
        for character in lowerCaseText {
            let unicode = character.unicodeScalars.first!.value
            var shiftedUnicode = unicode + shiftBy
            shiftedUnicode = codeInBounds( shiftedUnicode )
            
            // update: UInt8 -> UInt16
            let shiftedCharacter = String( UnicodeScalar( UInt16( shiftedUnicode ) )! )
            
            encodedText += shiftedCharacter
        }
        return encodedText
    }
    
    func decode( _ encryptedText: String, secret: String ) -> String {
        // Check for Invalid Input
        let errorMessage = validInputCheck( text: encryptedText, secret: secret )
        if( !errorMessage.isEmpty ) { return errorMessage }

        var decodedMessage = ""
        let shiftBy = UInt32( secret )!
        
        for character in encryptedText {
            let unicode = character.unicodeScalars.first!.value
            var shiftedUnicode = unicode - shiftBy
            shiftedUnicode = codeInBounds( shiftedUnicode )
            
            // error: Thread 1: Fatal error: Not enough bits to represent a signed value
            // fix: UInt8 -> UInt16
            let shiftedCharacter = String( UnicodeScalar( UInt16( shiftedUnicode ) )! )
            
            decodedMessage += shiftedCharacter
        }
        return decodedMessage
    }
}
