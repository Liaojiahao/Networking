struct FakeRequest {
    let response: Any?
    let responseType: Networking.ResponseType
    let statusCode: Int

    static func find(ofType type: Networking.RequestType, forPath path: String, in collection: [Networking.RequestType: [String: FakeRequest]]) -> FakeRequest? {
        guard let requests = collection[type] else { return nil }

        guard path.characters.count > 0 else { return nil }
        var evaluatedPath = path
        evaluatedPath.removeFirstLetterIfDash()
        evaluatedPath.removeLastLetterIfDash()
        let lookupPathParts = evaluatedPath.components(separatedBy: "/")

        for originalFakedPath in requests.keys {
            guard originalFakedPath.characters.count > 0 else { continue }
            guard let response = requests[originalFakedPath]?.response else { return nil }

            var fakedPath = originalFakedPath
            fakedPath.removeFirstLetterIfDash()
            fakedPath.removeLastLetterIfDash()
            let fakePathParts = fakedPath.components(separatedBy: "/")
            guard lookupPathParts.count == fakePathParts.count else { continue }
            guard lookupPathParts.first == fakePathParts.first else { continue }
            guard lookupPathParts.count != 1 && fakePathParts.count != 1 else { return requests[originalFakedPath] }


            for (index, fakePathPart) in fakePathParts.enumerated() {
                var replacedValues = [[String: String]]()
                if fakePathPart.contains("{") {
                    replacedValues[fakePathPart] = lookupPathParts[index]
                }
            }

            let responseString = String(data: try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted), encoding: .utf8)!
            let mutatedString = responseString.replacingOccurrences(of: "{userID}", with: replacedValue)
            let stringData = mutatedString.data(using: .utf8)
            let finalJSON = try! JSONSerialization.jsonObject(with: stringData!, options: [])
            return FakeRequest(response: finalJSON, responseType: .json, statusCode: 200)


            // take first element from requested path
            // search in list of faked paths
            // Not found? Continue.
            // Found?
            // If that's all the components, use the path
            // If there are more components, continue with next component
            // Next component. Starts with {?
        }

        // Before this was just a dictionary and you could use the path to get it. But now is more complex than that.
        // Now you need to check for possible matches for an specific path.

        // get all faked paths
        // remove leading and tail '/'
        // split using '/'
        // filter using the number of elements
        // take first element from requested path
        // search in list of faked paths
        // Not found? Continue.
        // Found?
        // If that's all the components, use the path
        // If there are more components, continue with next component
        // Next component. Starts with {?

        let result = requests[path]

        return result
    }

    /*
     NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
     NSString *firstLetter = [[mutableString substringToIndex:1] lowercaseString];
     [mutableString replaceCharactersInRange:NSMakeRange(0,1) withString:firstLetter];

    return [mutableString copy]; */
}

extension String {

    mutating func removeFirstLetterIfDash() {
        let initialCharacter = self.substring(to: self.index(after: self.startIndex))
        if initialCharacter == "/" {
            if self.characters.count > 1 {
                self.remove(at: self.startIndex)
            } else {
                self = ""
            }
        }
    }

    mutating func removeLastLetterIfDash() {
        let initialCharacter: String
        if self.characters.count > 1 {
            let index = self.index(self.endIndex, offsetBy: -1)
            initialCharacter = self.substring(from: index)
        } else {
            initialCharacter = self.substring(to: self.endIndex)
        }

        if initialCharacter == "/" {
            if self.characters.count > 1 {
                self.remove(at: self.index(self.endIndex, offsetBy: -1))
            } else {
                self = ""
            }
        }
    }
}
