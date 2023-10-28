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
        date.s = event.date

        input.item = [
            "id": id,
            "title" : title,
            "date" : date
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
            let date: String = record["date"]!.s.unsafelyUnwrapped
            
            let event = CalendarEvent(id: id, title: title, date: date)
            eventList.append(event)
        }
        return eventList
    }
}
