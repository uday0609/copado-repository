@isTest
global class ParkServiceMock implements WebServiceMock {

    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {

       ParkService.byCountryResponse fakeResponse =
            new ParkService.byCountryResponse();

        fakeResponse.return_x = new String[]{
            'Yosemite',
            'Yellowstone'
        };

        response.put('response_x', fakeResponse);
    }
}