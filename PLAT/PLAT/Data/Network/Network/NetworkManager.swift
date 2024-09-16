//
//  NetworkClient.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

final class NetworkClient: HTTPMethod {
    
    static let shared = NetworkClient()
    private init() {}
    
    /// StatusCode 성공 범위
    private let successStatusCodeRange = 200...299
    
    /// 로그인 진행(토큰 X, POST)
    func signIn<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, any Error> {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethodList.post.rawValue
            
            request.setValue(
                HTTPHeader.mimeTypeValue,
                forHTTPHeaderField: HTTPHeader.mimeTypeHeader
            )
            
            request.httpBody = try JSONEncoder().encode(body)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = statusCode(to: response) else {
                return .failure(NetworkError.httpResponseError)
            }
            
            guard successStatusCodeRange.contains(statusCode) else {
                let error = NetworkError.serverError(statusCode: statusCode)
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(error)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                NetworkLog.success(
                    url: url,
                    statusCode: statusCode,
                    data: decodedData
                )
                return .success(decodedData)
            } catch {
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(NetworkError.decodingError)
            }
        } catch {
            if let urlError = error as? URLError {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.urlError(urlError))
            } else {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.error(error))
            }
        }
    }
    
    /// GET (쿼리로 데이터 전달)
    func get<T: Decodable>(url: URL) async -> Result<T, Error> {
        do {
            let request = urlToRequest(.get, url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = statusCode(to: response) else {
                return .failure(NetworkError.httpResponseError)
            }
            
            guard successStatusCodeRange.contains(statusCode) else {
                let error = NetworkError.serverError(statusCode: statusCode)
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(error)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                NetworkLog.success(
                    url: url,
                    statusCode: statusCode,
                    data: decodedData
                )
                return .success(decodedData)
            } catch {
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(NetworkError.decodingError)
            }
        } catch {
            if let urlError = error as? URLError {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.urlError(urlError))
            } else {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.error(error))
            }
        }
    }
    
    /// POST (Authorization)
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error> {
        do {
            var request = urlToRequest(.post, url: url)
            request.httpBody = try JSONEncoder().encode(body)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = statusCode(to: response) else {
                return .failure(NetworkError.httpResponseError)
            }
            
            guard successStatusCodeRange.contains(statusCode) else {
                let error = NetworkError.serverError(statusCode: statusCode)
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(error)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                NetworkLog.success(
                    url: url,
                    statusCode: statusCode,
                    data: decodedData
                )
                return .success(decodedData)
            } catch {
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(NetworkError.decodingError)
            }
        } catch {
            if let urlError = error as? URLError {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.urlError(urlError))
            } else {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.error(error))
            }
        }
    }
    
    /// POST: Multipart
    func postImage<T: Decodable>(url: URL, imageData: Data) async -> Result<T, any Error> {
        do {
            let uniqueString = UUID().uuidString
            let request = urlToImageRequest(url: url, uniqueString: uniqueString)
            let imageData = preprocessingImageData(imageData: imageData, uniqueString: uniqueString)
            
            let (data, response) = try await URLSession.shared.upload(for: request, from: imageData)
            
            guard let statusCode = statusCode(to: response) else {
                return .failure(NetworkError.httpResponseError)
            }
            
            guard successStatusCodeRange.contains(statusCode) else {
                let error = NetworkError.serverError(statusCode: statusCode)
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(error)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                NetworkLog.success(
                    url: url,
                    statusCode: statusCode,
                    data: decodedData
                )
                return .success(decodedData)
            } catch {
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(NetworkError.decodingError)
            }
        } catch {
            if let urlError = error as? URLError {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.urlError(urlError))
            } else {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.error(error))
            }
        }
    }
    
    /// PATCH
    func patch<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error> {
        do {
            var request = urlToRequest(.patch, url: url)
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = statusCode(to: response) else {
                return .failure(NetworkError.httpResponseError)
            }
            
            guard successStatusCodeRange.contains(statusCode) else {
                let error = NetworkError.serverError(statusCode: statusCode)
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(error)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                NetworkLog.success(
                    url: url,
                    statusCode: statusCode,
                    data: decodedData
                )
                return .success(decodedData)
            } catch {
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(NetworkError.decodingError)
            }
        } catch {
            if let urlError = error as? URLError {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.urlError(urlError))
            } else {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.error(error))
            }
        }
    }
    
    /// DELETE
    func delete<T: Decodable>(url: URL) async -> Result<T, Error> {
        do {
            let request = urlToRequest(.delete, url: url)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = statusCode(to: response) else {
                return .failure(NetworkError.httpResponseError)
            }
            
            guard successStatusCodeRange.contains(statusCode) else {
                let error = NetworkError.serverError(statusCode: statusCode)
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(error)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                NetworkLog.success(
                    url: url,
                    statusCode: statusCode,
                    data: decodedData
                )
                return .success(decodedData)
            } catch {
                NetworkLog.failure(
                    url: url,
                    statusCode: statusCode,
                    error: error
                )
                return .failure(NetworkError.decodingError)
            }
        } catch {
            if let urlError = error as? URLError {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.urlError(urlError))
            } else {
                NetworkLog.failure(
                    url: url,
                    statusCode: 999,
                    error: error
                )
                return .failure(NetworkError.error(error))
            }
        }
    }
}

// MARK: - Helper

extension NetworkClient {
    
    private enum HTTPMethodList: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    private enum HTTPHeader {
        static let mimeTypeHeader = "Content-Type"
        static let mimeTypeValue = "application/json"
        static let authTokenHeader = "Authorization"
        
        static func authTokenValue(_ token: String) -> String {
            "Bearer \(token)"
        }
    }
    
    /// StatusCode를 반환합니다.
    private func statusCode(to response: URLResponse) -> Int? {
        (response as? HTTPURLResponse)?.statusCode
    }
    
    /// URL을 URLRequest 타입으로 반환합니다.
    private func urlToRequest(_ httpMethodList: HTTPMethodList, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethodList.rawValue
        
        request.setValue(
            HTTPHeader.mimeTypeValue,
            forHTTPHeaderField: HTTPHeader.mimeTypeHeader
        )
        
        request.setValue(
            HTTPHeader.authTokenValue(UserSecurityManager.shared.accessToken),
            forHTTPHeaderField: HTTPHeader.authTokenHeader
        )
        
        return request
    }
    
    /// URL을 이미지 전송이 가능한 Multipart URLRequest 타입으로 반환합니다.
    private func urlToImageRequest(url: URL, uniqueString: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethodList.post.rawValue
        
        let contentType = "multipart/form-data; boundary=\(uniqueString)"
        request.setValue(contentType, forHTTPHeaderField: HTTPHeader.mimeTypeHeader)
        
        request.setValue(
            HTTPHeader.authTokenValue(UserSecurityManager.shared.accessToken),
            forHTTPHeaderField: HTTPHeader.authTokenHeader
        )
        
        return request
    }
    
    /// 이미지 데이터를 Multipart 통신이 가능한 형태로 가공 후 반환합니다.
    private func preprocessingImageData(imageData: Data, uniqueString: String) -> Data {
        var imageData = imageData
        imageData.append("--\(uniqueString)\r\n".data(using: .utf8)!)
        imageData.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        imageData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        imageData.append(imageData)
        imageData.append("\r\n".data(using: .utf8)!)
        imageData.append("--\(uniqueString)--\r\n".data(using: .utf8)!)
        return imageData
    }
}
