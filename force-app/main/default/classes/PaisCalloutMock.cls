@isTest
global class PaisCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"name":{"common":"Colombia"},"capital":["Bogotá"],"region":"Americas"}]');
        res.setStatusCode(200);
        return res;
    }
}