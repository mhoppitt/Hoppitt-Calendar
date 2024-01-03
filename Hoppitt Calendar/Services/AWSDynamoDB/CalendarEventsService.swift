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
        
        guard let hasEndDate = AWSDynamoDBAttributeValue() else {
            return print("Error setting isKeyDate")
        }
        hasEndDate.s = String(event.hasEndDate)
        
        guard let startDate = AWSDynamoDBAttributeValue() else {
            return print("Error setting start date")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let startDateString = dateFormatter.string(from: event.startDate)
        startDate.s = startDateString
        
        guard let endDate = AWSDynamoDBAttributeValue() else {
            return print("Error setting end date")
        }
        let endDateString = dateFormatter.string(from: event.endDate)
        endDate.s = endDateString
        
        guard let who = AWSDynamoDBAttributeValue() else {
            return print("Error setting person")
        }
        who.s = event.who
        
        guard let isKeyDate = AWSDynamoDBAttributeValue() else {
            return print("Error setting isKeyDate")
        }
        isKeyDate.s = String(event.isKeyDate)
        
        guard let isOutForDinner = AWSDynamoDBAttributeValue() else {
            return print("Error setting isOutForDinner")
        }
        isOutForDinner.s = String(event.isOutForDinner)
        
        input.item = [
            "id": id,
            "title": title,
            "hasEndDate": hasEndDate,
            "startDate": startDate,
            "endDate": endDate,
            "who": who,
            "isKeyDate": isKeyDate,
            "isOutForDinner": isOutForDinner,
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        
        for record in response.items.unsafelyUnwrapped {
            let id: String = record["id"]!.s.unsafelyUnwrapped
            let title: String = record["title"]!.s.unsafelyUnwrapped
            let hasEndDate: String = record["hasEndDate"]!.s.unsafelyUnwrapped
            let startDateString: String = record["startDate"]!.s.unsafelyUnwrapped
            let endDateString: String = record["endDate"]!.s.unsafelyUnwrapped
            let who: String = record["who"]!.s.unsafelyUnwrapped
            let isKeyDate: String = record["isKeyDate"]!.s.unsafelyUnwrapped
            let isOutForDinner: String = record["isOutForDinner"]!.s.unsafelyUnwrapped
            
            let startDate = dateFormatter.date(from: startDateString) ?? Date()
            let endDate = dateFormatter.date(from: endDateString) ?? Date()
            
            let event = CalendarEvent(id: id, title: title, hasEndDate: Bool(hasEndDate) ?? false, startDate: startDate, endDate: endDate, who: who, isKeyDate: Bool(isKeyDate) ?? false, isOutForDinner: Bool(isOutForDinner) ?? false)
            eventList.append(event)
        }
        let sortedEventList = eventList.sorted {
            $0.startDate < $1.startDate
        }
        return sortedEventList
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
        
        guard let hasEndDate = AWSDynamoDBAttributeValue() else {
            return print("Error setting hasEndDate")
        }
        hasEndDate.s = String(event.hasEndDate)
        let updatedHasEndDate: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedHasEndDate.value = hasEndDate
        updatedHasEndDate.action = AWSDynamoDBAttributeAction.put
        
        guard let startDate = AWSDynamoDBAttributeValue() else {
            return print("Error setting start date")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
        let startDateString = dateFormatter.string(from: event.startDate)
        startDate.s = startDateString
        let updatedStartDate: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedStartDate.value = startDate
        updatedStartDate.action = AWSDynamoDBAttributeAction.put
        
        guard let endDate = AWSDynamoDBAttributeValue() else {
            return print("Error setting end date")
        }
        let endDateString = dateFormatter.string(from: event.endDate)
        endDate.s = endDateString
        let updatedEndDate: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedEndDate.value = endDate
        updatedEndDate.action = AWSDynamoDBAttributeAction.put
        
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
        
        guard let isOutForDinner = AWSDynamoDBAttributeValue() else {
            return print("Error setting isOutForDinner")
        }
        isOutForDinner.s = String(event.isOutForDinner)
        let updatedIsOutForDinner: AWSDynamoDBAttributeValueUpdate = AWSDynamoDBAttributeValueUpdate()
        updatedIsOutForDinner.value = isOutForDinner
        updatedIsOutForDinner.action = AWSDynamoDBAttributeAction.put
        
        guard let updatedInput = AWSDynamoDBUpdateItemInput() else {
            return print("Error setting tableName")
        }
        updatedInput.tableName = self.tableName
        updatedInput.key = ["id": id]
        
        updatedInput.attributeUpdates = [
            "title": updatedTitle,
            "hasEndDate": updatedHasEndDate,
            "startDate": updatedStartDate,
            "endDate": updatedEndDate,
            "who": updatedWho,
            "isKeyDate": updatedIsKeyDate,
            "isOutForDinner": updatedIsOutForDinner,
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
    
    func cleanupTable(events: [CalendarEvent]) async throws {
        for event in events {
            if event.endDate < DateService().getFortnightFromToday()[0] {
                try await deleteEvent(event: event)
            }
        }
    }
}
