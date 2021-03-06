import Foundation

public extension Networking {

    @discardableResult
    public func DELETEWithBody(_ path: String, parameterType: ParameterType = .json, parameters: Any? = nil, completion: @escaping (_ json: Any?, _ error: NSError?) -> Void) -> String {
        let requestID = self.request(.DELETE, path: path, parameterType: parameterType, parameters: parameters, parts: nil, responseType: .json) { json, headers, error in
            completion(json, error)
        }
        
        return requestID
    }
    
    /**
     DELETE request to the specified path, using the provided parameters.
     - parameter path: The path for the DELETE request.
     - parameter completion: A closure that gets called when the DELETE request is completed, it contains a `JSON` object and an `NSError`.
     - returns: The request identifier.
     */
    @discardableResult
    public func DELETE(_ path: String, parameters: Any? = nil, completion: @escaping (_ json: Any?, _ error: NSError?) -> Void) -> String {
        let parameterType = parameters != nil ? ParameterType.formURLEncoded : ParameterType.none
        let requestID = self.request(.DELETE, path: path, parameterType: parameterType, parameters: parameters, parts: nil, responseType: .json) { json, headers, error in
            completion(json, error)
        }

        return requestID
    }

    /**
     DELETE request to the specified path, using the provided parameters.
     - parameter path: The path for the DELETE request.
     - parameter completion: A closure that gets called when the DELETE request is completed, it contains a `JSON` object and an `NSError`.
     - returns: The request identifier.
     */
    @discardableResult
    public func DELETE(_ path: String, parameters: Any? = nil, completion: @escaping (_ json: Any?, _ headers: [AnyHashable: Any], _ error: NSError?) -> Void) -> String {
        let parameterType = parameters != nil ? ParameterType.formURLEncoded : ParameterType.none
        let requestID = self.request(.DELETE, path: path, parameterType: parameterType, parameters: parameters, parts: nil, responseType: .json, completion: completion)

        return requestID
    }

    /**
     Registers a fake DELETE request for the specified path. After registering this, every DELETE request to the path, will return the registered response.
     - parameter path: The path for the faked DELETE request.
     - parameter response: An `Any` that will be returned when a DELETE request is made to the specified path.
     - parameter statusCode: By default it's 200, if you provide any status code that is between 200 and 299 the response object will be returned, otherwise we will return an error containig the provided status code.
     */
    public func fakeDELETE(_ path: String, response: Any?, statusCode: Int = 200) {
        self.fake(.DELETE, path: path, response: response, responseType: .json, statusCode: statusCode)
    }

    /**
     Registers a fake DELETE request to the specified path using the contents of a file. After registering this, every DELETE request to the path, will return the contents of the registered file.
     - parameter path: The path for the faked DELETE request.
     - parameter fileName: The name of the file, whose contents will be registered as a reponse.
     - parameter bundle: The NSBundle where the file is located.
     */
    public func fakeDELETE(_ path: String, fileName: String, bundle: Bundle = Bundle.main) {
        self.fake(.DELETE, path: path, fileName: fileName, bundle: bundle)
    }

    /**
     Cancels the DELETE request for the specified path. This causes the request to complete with error code URLError.cancelled.
     - parameter path: The path for the cancelled DELETE request.
     - parameter completion: A closure that gets called when the cancellation is completed.
     */
    public func cancelDELETE(_ path: String, completion: (() -> Void)? = nil) {
        let url = try! self.url(for: path)
        self.cancelRequest(.data, requestType: .DELETE, url: url, completion: completion)
    }
}
