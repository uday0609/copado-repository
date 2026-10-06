public with sharing class ParkLocator {

    public static String[] country(String countryName) {

        ParkService.ParksImplPort service = new ParkService.ParksImplPort();
        return service.byCountry(countryName);
    }
}