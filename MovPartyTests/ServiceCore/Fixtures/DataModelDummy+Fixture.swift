import Foundation

extension DataModelDummy {
    static func fixture(
        name: String = "name",
        age: Int = 0
    ) -> Self {
        .init(
            name: name,
            age: age
        )
    }
}
