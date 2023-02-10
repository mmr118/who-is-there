//
//  StorageManager.swift
//  whoisthere
//
//  Created by Monica Rondón on 10.02.23.
//

import Foundation

struct StorageManager {

    private let allUserDatasKey = "SAVED_USER_DATAS_KEY"
    private let currentUserDataKey = "CURRENT_USER_DATA_KEY"

    static let shared = StorageManager()

    private var userDefaults: UserDefaults

    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func currentUser() -> User? {
        guard let data = userDefaults.data(forKey: currentUserDataKey) else { return nil }
        return data.jsonObject(User.self)
    }

    public func allUsers() -> [User] {
        guard let data = userDefaults.data(forKey: allUserDatasKey) else { return [] }
        return data.jsonObject([User].self)
    }

    @discardableResult
    public func setCurrentUser(_ newCurrent: User) -> Bool {
        guard newCurrent != currentUser() else { return false }
        save(newCurrent)
        userDefaults.set(newCurrent.jsonData(), forKey: currentUserDataKey)
        return true
    }

    @discardableResult
    public func save(_ newUser: User) -> Bool {
        guard newUser.hasAllDataFilled else { return false }
        guard newUser.name != "ERROR" else { return false }
        var allUsers = allUsers()
        guard !allUsers.contains(newUser) else { return false }
        userDefaults.set(allUsers.jsonData(), forKey: allUserDatasKey)
        return true
    }

}
