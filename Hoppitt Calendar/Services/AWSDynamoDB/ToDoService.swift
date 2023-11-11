//
//  ToDoService.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 7/11/2023.
//

import AWSDynamoDB

public class ToDoTable {
    let tableName = "Hoppitt-Calendar-ToDo"
    
    public init() {
        // Configure your AWS credentials and region
        let configuration = AWSServiceConfiguration(region: .APSoutheast2, credentialsProvider: AWSStaticCredentialsProvider(accessKey: ACCESS_KEY, secretKey: SECRET_KEY))
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func generateID() -> String {
        return UUID().uuidString
    }
    
    func addToDo(todo: ToDo) async throws {
        let dynamoDB = AWSDynamoDB.default()
        guard let id = AWSDynamoDBAttributeValue() else {
            return print("Error setting id")
        }
        id.s = todo.id
        
        guard let input = AWSDynamoDBPutItemInput() else {
            return print("Error setting tableName")
        }
        input.tableName = self.tableName

        guard let title = AWSDynamoDBAttributeValue() else {
            return print("Error setting title")
        }
        title.s = todo.title
        
        guard let date = AWSDynamoDBAttributeValue() else {
            return print("Error setting date")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let dateString = dateFormatter.string(from: todo.date)
        date.s = dateString
        
        guard let who = AWSDynamoDBAttributeValue() else {
            return print("Error setting person")
        }
        who.s = todo.who
        
        guard let isCompleted = AWSDynamoDBAttributeValue() else {
            return print("Error setting isCompleted")
        }
        isCompleted.s = String(todo.isCompleted)
        
        input.item = [
            "id": id,
            "title": title,
            "date": date,
            "who": who,
            "isCompleted": isCompleted,
        ]

        try await dynamoDB.putItem(input)
    }
    
    func getToDoList() async throws -> [ToDo] {
        let dynamoDB = AWSDynamoDB.default()
        
        guard let query = AWSDynamoDBScanInput() else {
            return []
        }
        query.tableName = tableName
        
        let response = try await dynamoDB.scan(query)
        
        var todoList: [ToDo] = []
        
        for record in response.items.unsafelyUnwrapped {
            let id: String = record["id"]!.s.unsafelyUnwrapped
            let title: String = record["title"]!.s.unsafelyUnwrapped
            let dateString: String = record["date"]!.s.unsafelyUnwrapped
            let who: String = record["who"]!.s.unsafelyUnwrapped
            let isCompleted: String = record["isCompleted"]!.s.unsafelyUnwrapped
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
            dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
            let date = dateFormatter.date(from: dateString) ?? Date()
            
            let todo = ToDo(id: id, title: title, date: date, who: who, isCompleted: Bool(isCompleted) ?? false)
            todoList.append(todo)
        }
        let sortedTodoList = todoList.sorted {
            $0.date < $1.date
        }
        return sortedTodoList
    }
    
    func editToDoItem(todo: ToDo) async throws {
        let dynamoDB = AWSDynamoDB.default()
        guard let id = AWSDynamoDBAttributeValue() else {
            return print("Error setting id")
        }
        id.s = todo.id

        guard let title = AWSDynamoDBAttributeValue() else {
            return print("Error setting title")
        }
        title.s = todo.title
        let updatedTitle: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedTitle.value = title
        updatedTitle.action = AWSDynamoDBAttributeAction.put
        
        guard let date = AWSDynamoDBAttributeValue() else {
            return print("Error setting date")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let dateString = dateFormatter.string(from: todo.date)
        date.s = dateString
        let updatedDate: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedDate.value = date
        updatedDate.action = AWSDynamoDBAttributeAction.put
        
        guard let who = AWSDynamoDBAttributeValue() else {
            return print("Error setting person")
        }
        who.s = todo.who
        let updatedWho: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedWho.value = who
        updatedWho.action = AWSDynamoDBAttributeAction.put
        
        guard let isCompleted = AWSDynamoDBAttributeValue() else {
            return print("Error setting isCompleted")
        }
        isCompleted.s = String(todo.isCompleted)
        let updatedIsCompleted: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedIsCompleted.value = isCompleted
        updatedIsCompleted.action = AWSDynamoDBAttributeAction.put
        
        guard let updatedInput = AWSDynamoDBUpdateItemInput() else {
            return print("Error setting tableName")
        }
        updatedInput.tableName = self.tableName
        updatedInput.key = ["id": id]
        
        updatedInput.attributeUpdates = [
            "title": updatedTitle,
            "date": updatedDate,
            "who": updatedWho,
            "isCompleted": updatedIsCompleted,
        ]
        updatedInput.returnValues = AWSDynamoDBReturnValue.updatedNew

        try await dynamoDB.updateItem(updatedInput)
    }
    
    func deleteToDoItem(todo: ToDo) async throws {
        let dynamoDB = AWSDynamoDB.default()
        guard let id = AWSDynamoDBAttributeValue() else {
            return print("Error setting id")
        }
        id.s = todo.id
        
        guard let deleteInput = AWSDynamoDBDeleteItemInput() else {
            return print("Error setting tableName")
        }
        deleteInput.tableName = self.tableName
        deleteInput.key = ["id": id]

        try await dynamoDB.deleteItem(deleteInput)
    }
}
