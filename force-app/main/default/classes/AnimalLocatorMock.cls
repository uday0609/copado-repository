@isTest
global class AnimalLocatorMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse response = new HttpResponse();

        response.setHeader('Content-Type', 'application/json');

        response.setBody(
            '{"animal":{"id":1,"name":"Mock Animal"}}'
        );

        response.setStatusCode(200);

        return response;
    }
}