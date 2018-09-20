import Foundation
// Rail-Fence Cipher - Jumble plain text in a zig-zag fashion
// using two dimensional arrays

// How the Cipher works

// Encoding
// 1. Create an array of strings, the size of the secret key
//    (they will act as rows of a "2D Array"
// 2. Traverse the string, adding the first character to one of the rows
//    of the array of Strings.
// 3. Remove the first character of the string
// 4. Increment the row position in the array of strings, the value incremented
//    will be negated to a positive or negative value based on the current row

// Decoding
// 1. Create a 2D array of characters of size secret key x text length
// 2. Fill the entire array with a characters to signify an invalid spot
// 3. Traverse the 2D array in a zig zag pattern, changing the characters to
//    signify a valid spot in the array to place a character
// 4. Traverse the 2D array row by row, adding the first character of the encoded string
//    to a valid space
// 5. After placing all characters in the array, traverse the 2D another time in a zig zag
//    pattern adding characters to the decoded string
// 6. Return the decoded string

struct RailfenceCipher: Cipher {
    func validInputCheck( text: String, secret: String ) -> String {
        // Cipher Text Exists
        if( text.isEmpty ) { return "Please Enter Cipher Text" }
        
        // Secret must be present, a number, and greater than 1
        if( secret.isEmpty )            { return "Please Enter Cipher Key" }
        else if( Int( secret ) == nil ) { return "Please Enter Valid Cipher Key" }
        else if( Int( secret )! <= 1 )  { return "Please Enter Cipher Key Greater Than 1" }
        
        return "" // No Errors
    }
    
    // Flips -1 or +1 based on conditional
    func conditionalDirection( _ direction: Int, _ row: Int, _ MAX_UPPER_BOUND: Int ) -> Int {
        if( row == MAX_UPPER_BOUND || row == 0 ) { return ( direction * -1 ) }
        
        return direction
    }
    
    func encode( _ plaintext: String, secret: String ) -> String {
        // Check for Invalid Input
        let errorMessage = validInputCheck( text: plaintext, secret: secret )
        if( !errorMessage.isEmpty ) { return errorMessage }
        
        // Remove Spaces from Cipher Text
        var trimmedCipherText = plaintext.replacingOccurrences( of: " ", with: "" )
        
        var encryptedSubstringsArray = Array( repeating: "", count: Int( secret )! )
        let MAX_UPPER_BOUND = Int( secret )! - 1
        var currentRow = 0, direction = -1
        
        // Add characters to substrings in zig-zag pattern
        while !trimmedCipherText.isEmpty {
            let firstCharacter = trimmedCipherText.prefix( 1 )
            
            encryptedSubstringsArray[ currentRow ] += firstCharacter

            trimmedCipherText.remove( at: trimmedCipherText.startIndex )
            
            // Allows us to move in a zig-zag pattern through the 2D array
            direction = conditionalDirection( direction, currentRow, MAX_UPPER_BOUND )
            currentRow += direction
        }
        
        var encryptedText = ""
        
        for substring in encryptedSubstringsArray { encryptedText += substring }
        
        return encryptedText
    }
    
    func decode( _ encryptedText: String, secret: String ) -> String {
        // Check for Invalid Input
        let errorMessage = validInputCheck( text: encryptedText, secret: secret )
        
        if( !errorMessage.isEmpty ) { return errorMessage }
        
        // Set Variables needed for decoding algorithm
        let MAX_COLUMNS = encryptedText.count, MAX_UPPER_BOUND = Int( secret )! - 1
        var currentRow = 0, direction = -1, textToDecode = encryptedText
        
        // Create secret x MAX_COLUMNS 2D array of X's
        var decodeMatrix = Array( repeating: Array(repeating: "❌", count: MAX_COLUMNS ), count: Int( secret )! )
        
        // Traverse the decode matrix and place ✅'s on valid places to save characters
        // from the encrypted string
        for index in 0..<MAX_COLUMNS {
            decodeMatrix[ currentRow ][ index ] = "✅"

            // Allows us to move in a zig-zag pattern through the 2D array
            direction = conditionalDirection( direction, currentRow, MAX_UPPER_BOUND )
            currentRow += direction
        }
        
        // Place encrypedText's characters in valid spots
        for row in 0...MAX_UPPER_BOUND {
            for column in 0..<MAX_COLUMNS {
                if( decodeMatrix[ row ][ column ] == "✅" ) {
                    let firstCharacter = textToDecode.prefix( 1 )
                    
                    decodeMatrix[ row ][ column ].removeAll()
                    decodeMatrix[ row ][ column ] = String( firstCharacter )
                    
                    textToDecode.remove( at: textToDecode.startIndex )
                }
            }
        }
        
        // Build decrypted text string
        var decryptedText = ""
        currentRow = 0; direction = -1 // Reset currentRow and Direction
        
        for index in 0..<MAX_COLUMNS {
            decryptedText += decodeMatrix[ currentRow ][ index ]
            
            // Allows us to move in a zig-zag pattern through the 2D array
            direction = conditionalDirection( direction, currentRow, MAX_UPPER_BOUND )
            currentRow += direction
        }
        
        return decryptedText
    }
}
