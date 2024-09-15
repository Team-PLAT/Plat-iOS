//
//  NetworkManager.swift
//  PLAT
//
//  Created by 조세연 on 8/18/24.
//

import Foundation

class NetworkClient: HTTPMethod {
    
    /// StatusCode 성공 범위
    private let successStatusCodeRange = 200...299
    
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
    
    /// URL을 URLRequest 타입으로 반환합니다.
    private func urlToRequest(_ httpMethodList: HTTPMethodList, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethodList.rawValue
        
        request.setValue(
            HTTPHeader.mimeTypeValue,
            forHTTPHeaderField: HTTPHeader.mimeTypeHeader
        )
        
        request.setValue(
            HTTPHeader.authTokenValue("TOKEN"), // TODO: 액세스 토큰 삽입
            forHTTPHeaderField: HTTPHeader.authTokenHeader
        )
        
        return request
    }
    
    /// StatusCode를 반환합니다.
    private func statusCode(to response: URLResponse) -> Int? {
        (response as? HTTPURLResponse)?.statusCode
    }
}

// MARK: - Legacy

extension NetworkClient {
    //    /// POST (login)
    //    func post<T: Decodable, U: Encodable>(url: URL, body: U) async -> Result<T, Error> {
    //        do {
    //            var request = URLRequest(url: url)
    //            request.httpMethod = HTTPMethodList.post
    //            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //            request.httpBody = try JSONEncoder().encode(body)
    //
    //            let (data, response) = try await URLSession.shared.data(for: request)
    //
    //            guard let httpResponse = response as? HTTPURLResponse,
    //                  (200...299).contains(httpResponse.statusCode) else {
    //                return .failure(NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0))
    //            }
    //
    //            let decodedData = try JSONDecoder().decode(T.self, from: data)
    //            return .success(decodedData)
    //        } catch {
    //            if let urlError = error as? URLError {
    //                return .failure(NetworkError.urlError(urlError))
    //            } else {
    //                return .failure(NetworkError.error(error))
    //            }
    //        }
    //    }
}
