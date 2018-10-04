//
//  NetworkService.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import Alamofire

protocol HasNetworkService: AnyObject {
    var networkService: NetworkServiceProvider { get }
}

protocol NetworkServiceProvider: AnyObject {
    func getUbernodes(completion: @escaping (Result<Ubernodes, NetworkError>) -> Void)
    func getNode(id: String, completion: @escaping (Result<Node, NetworkError>) -> Void)
    func downloadImage(nodeImage: Node.Image, progressUpdate: @escaping (Double) -> Void, completion: @escaping (Result<Void, NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProvider {
    typealias Dependencies = HasFileManagerService

    private var dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    private var alamofire: SessionManager {
        let sessionManager: SessionManager = .default

        return sessionManager
    }

    private var reachable: Bool {
        guard let reachabilityManager: NetworkReachabilityManager = NetworkReachabilityManager() else {
            return false
        }

        return reachabilityManager.isReachable
    }

    func getUbernodes(completion: @escaping (Result<Ubernodes, NetworkError>) -> Void) {
        performGET(url: Constants.Nasa.ubernodes(), completion: { result in
            switch result {
            case let .success(data):
                let ubernodes: Ubernodes

                do {
                    let jsonDecoder: JSONDecoder = JSONDecoder()
                    ubernodes = try jsonDecoder.decode(Ubernodes.self, from: data)
                } catch _ {
                    return completion(.failure(.unknown))
                }

                completion(.success(ubernodes))

            case let .failure(networkError):
                completion(.failure(networkError))
            }
        })
    }

    func getNode(id: String, completion: @escaping (Result<Node, NetworkError>) -> Void) {
        performGET(url: Constants.Nasa.nodeURL(id: id), completion: { result in
            switch result {
            case let .success(data):
                let ubernodes: Node

                do {
                    let jsonDecoder: JSONDecoder = JSONDecoder()
                    ubernodes = try jsonDecoder.decode(Node.self, from: data)
                } catch _ {
                    return completion(.failure(.unknown))
                }

                completion(.success(ubernodes))

            case let .failure(networkError):
                completion(.failure(networkError))
            }
        })
    }

    func downloadImage(nodeImage: Node.Image, progressUpdate: @escaping (Double) -> Void, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard reachable else {
            completion(.failure(.unreachable))
            return
        }

        let imageName: String = nodeImage.filename

        guard dependencies.fileManagerService.imageAlreadyDownloaded(imageName: imageName) == false else {
            completion(.success(()))
            return
        }

        let downloadDirectory: URL

        do {
            downloadDirectory = try dependencies.fileManagerService.downloadDirectory(filename: imageName)
        } catch _ {
            completion(.failure(.unknown))
            return
        }

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            (downloadDirectory, [.removePreviousFile])
        }

        alamofire.download(Constants.Nasa.imageURL(name: imageName), to: destination).downloadProgress(closure: { progress in
            progressUpdate(progress.fractionCompleted)
        }).responseData(completionHandler: { response in
            completion(.success(()))
        })
    }

    private func performGET(url: URLConvertible, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard reachable else {
            completion(.failure(.unreachable))
            return
        }

        alamofire.request(url, method: .get, encoding: JSONEncoding.default).validate().responseData(completionHandler: { responseData in
            #if DEBUG
                print(responseData.timeline)
            #endif

            guard let response: HTTPURLResponse = responseData.response else {
                completion(.failure(.notFound))
                return
            }

            switch responseData.result {
            case let .success(data):
                completion(.success(data))

            case .failure:
                let networkError: NetworkError = NetworkError(rawValue: response.statusCode)

                completion(.failure(networkError))
            }
        })
    }

    func cancelAllRequests() {
        alamofire.session.getTasksWithCompletionHandler({ dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach({ task in
                task.cancel()
            })

            uploadTasks.forEach({ task in
                task.cancel()
            })

            downloadTasks.forEach({ task in
                task.cancel()
            })
        })
    }
}
