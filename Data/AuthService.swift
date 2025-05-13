//
//  AuthService.swift
//  swift-login-system-tutorial
//
//  Created by Tharin Saeung on 27/11/2566 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    public static let shared = AuthService()
    private init() {}
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: The users information (email, password)
    ///   - completion: A completion with two values...
    ///   - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
    ///   - Error?: An optional error if firebase provides once
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?)->Void) {
        let email = userRequest.email
        let password = userRequest.password
        let firstName = userRequest.firstName
        let lastName = userRequest.lastName
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "email": email,
                    "first_name": firstName,
                    "last_name": lastName
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    completion(true, nil)
                }
        }
    }
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?)->Void) {
        Auth.auth().signIn(
            withEmail: userRequest.email,
            password: userRequest.password
        ) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?)->Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    public func fetchUser(completion: @escaping (User?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let email = snapshotData["email"] as? String {
                    let user = User(email: email, userUID: userUID)
                    completion(user, nil)
                }
        
        }
    }
    
    public func checkAuth() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
    }
}
