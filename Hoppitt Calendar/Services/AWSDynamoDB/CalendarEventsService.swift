//
//  AWSDynamoDBService.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 27/10/2023.
//

import AWSDynamoDB

public class CalendarEventsTable {
    let tableName = "Hoppitt-Calendar-Events"
    
    public init() {
        // Configure your AWS credentials and region
        let configuration = AWSServiceConfiguration(region: .APSoutheast2, credentialsProvider: AWSStaticCredentialsProvider(accessKey: ACCESS_KEY, secretKey: SECRET_KEY))
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func generateID() -> String {
        return UUID().uuidString
    }
    
    func addEvent(event: CalendarEvent) async throws {
        let dynamoDB = AWSDynamoDB.default()
        guard let id = AWSDynamoDBAttributeValue() else {
            return print("Error setting id")
        }
        id.s = event.id
        
        guard let input = AWSDynamoDBPutItemInput() else {
            return print("Error setting tableName")
        }
        input.tableName = self.tableName

        guard let title = AWSDynamoDBAttributeValue() else {
            return print("Error setting title")
        }
        title.s = event.title
        
        guard let date = AWSDynamoDBAttributeValue() else {
            return print("Error setting date")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let dateString = dateFormatter.string(from: event.date)
        date.s = dateString
        
        guard let time = AWSDynamoDBAttributeValue() else {
            return print("Error setting time")
        }
        let timeString = dateFormatter.string(from: event.time)
        time.s = timeString
        
        guard let who = AWSDynamoDBAttributeValue() else {
            return print("Error setting person")
        }
        who.s = event.who
        
        guard let isKeyDate = AWSDynamoDBAttributeValue() else {
            return print("Error setting isKeyDate")
        }
        isKeyDate.s = String(event.isKeyDate)
        
        input.item = [
            "id": id,
            "title": title,
            "date": date,
            "time": time,
            "who": who,
            "isKeyDate": isKeyDate,
        ]

        try await dynamoDB.putItem(input)
    }
    
    func getEvents() async throws -> [CalendarEvent] {
        let dynamoDB = AWSDynamoDB.default()
        
        guard let query = AWSDynamoDBScanInput() else {
            return []
        }
        query.tableName = tableName
        
        let response = try await dynamoDB.scan(query)
        
        var eventList: [CalendarEvent] = []
        
        for record in response.items.unsafelyUnwrapped {
            let id: String = record["id"]!.s.unsafelyUnwrapped
            let title: String = record["title"]!.s.unsafelyUnwrapped
            let dateString: String = record["date"]!.s.unsafelyUnwrapped
            let timeString: String = record["time"]!.s.unsafelyUnwrapped
            let who: String = record["who"]!.s.unsafelyUnwrapped
            let isKeyDate: String = record["isKeyDate"]!.s.unsafelyUnwrapped
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
            dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
            let date = dateFormatter.date(from: dateString) ?? Date()
            let time = dateFormatter.date(from: timeString) ?? Date()
            
            let event = CalendarEvent(id: id, title: title, date: date, time: time, who: who, isKeyDate: Bool(isKeyDate) ?? false)
            eventList.append(event)
        }
        return eventList
    }
    
    func editEvent(event: CalendarEvent) async throws {
        let dynamoDB = AWSDynamoDB.default()
        guard let id = AWSDynamoDBAttributeValue() else {
            return print("Error setting id")
        }
        id.s = event.id

        guard let title = AWSDynamoDBAttributeValue() else {
            return print("Error setting title")
        }
        title.s = event.title
        let updatedTitle: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedTitle.value = title
        updatedTitle.action = AWSDynamoDBAttributeAction.put
        
        guard let date = AWSDynamoDBAttributeValue() else {
            return print("Error setting date")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let dateString = dateFormatter.string(from: event.date)
        date.s = dateString
        let updatedDate: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedDate.value = date
        updatedDate.action = AWSDynamoDBAttributeAction.put
        
        guard let time = AWSDynamoDBAttributeValue() else {
            return print("Error setting time")
        }
        let timeString = dateFormatter.string(from: event.time)
        time.s = timeString
        let updatedTime: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedTime.value = time
        updatedTime.action = AWSDynamoDBAttributeAction.put
        
        guard let who = AWSDynamoDBAttributeValue() else {
            return print("Error setting person")
        }
        who.s = event.who
        let updatedWho: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedWho.value = who
        updatedWho.action = AWSDynamoDBAttributeAction.put
        
        guard let isKeyDate = AWSDynamoDBAttributeValue() else {
            return print("Error setting isKeyDate")
        }
        isKeyDate.s = String(event.isKeyDate)
        let updatedIsKeyDate: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedIsKeyDate.value = isKeyDate
        updatedIsKeyDate.action = AWSDynamoDBAttributeAction.put
        
        guard let updatedInput = AWSDynamoDBUpdateItemInput() else {
            return print("Error setting tableName")
        }
        updatedInput.tableName = self.tableName
        updatedInput.key = ["id": id]
        
        updatedInput.attributeUpdates = [
            "title": updatedTitle,
            "date": updatedDate,
            "time": updatedTime,
            "who": updatedWho,
            "isKeyDate": updatedIsKeyDate,
        ]
        updatedInput.returnValues = AWSDynamoDBReturnValue.updatedNew

        try await dynamoDB.updateItem(updatedInput)
    }
    
    func deleteEvent(event: CalendarEvent) async throws {
        let dynamoDB = AWSDynamoDB.default()
        guard let id = AWSDynamoDBAttributeValue() else {
            return print("Error setting id")
        }
        id.s = event.id
        
        guard let deleteInput = AWSDynamoDBDeleteItemInput() else {
            return print("Error setting tableName")
        }
        deleteInput.tableName = self.tableName
        deleteInput.key = ["id": id]

        try await dynamoDB.deleteItem(deleteInput)
    }
}
