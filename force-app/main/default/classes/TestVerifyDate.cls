/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : TestVerifyDate
 * Author          : <YourName>
 * Created Date    : Jun 3, 2026
 * Last Modified By: <YourName>
 * Last Modified On: Jun 3, 2026
 * Description     : This class implements for......
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Jun 3, 2026  │ <YourName>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

@isTest
private class TestVerifyDate {

    @isTest
    static void testDateWithin30Days() {
        Date date1 = Date.newInstance(2026, 6, 1);
        Date date2 = Date.newInstance(2026, 6, 20);

        Date result = VerifyDate.CheckDates(date1, date2);

        System.assertEquals(
            date2,
            result,
            'When date2 is within 30 days, date2 should be returned.'
        );
    }

    @isTest
    static void testDateMoreThan30Days() {
        Date date1 = Date.newInstance(2026, 6, 1);
        Date date2 = Date.newInstance(2026, 7, 1); // Exactly 30 days later

        Date expectedEndOfMonth = Date.newInstance(2026, 6, 30);

        Date result = VerifyDate.CheckDates(date1, date2);

        System.assertEquals(
            expectedEndOfMonth,
            result,
            'When date2 is 30 or more days away, end of month should be returned.'
        );
    }

    @isTest
    static void testDateInPast() {
        Date date1 = Date.newInstance(2026, 6, 15);
        Date date2 = Date.newInstance(2026, 6, 10);

        Date expectedEndOfMonth = Date.newInstance(2026, 6, 30);

        Date result = VerifyDate.CheckDates(date1, date2);

        System.assertEquals(
            expectedEndOfMonth,
            result,
            'When date2 is before date1, end of month should be returned.'
        );
    }

    @isTest
    static void testEndOfMonthForFebruaryLeapYear() {
        Date date1 = Date.newInstance(2028, 2, 10);
        Date date2 = Date.newInstance(2028, 3, 15);

        Date expectedEndOfMonth = Date.newInstance(2028, 2, 29);

        Date result = VerifyDate.CheckDates(date1, date2);

        System.assertEquals(
            expectedEndOfMonth,
            result,
            'Should correctly calculate end of month for leap year February.'
        );
    }
}