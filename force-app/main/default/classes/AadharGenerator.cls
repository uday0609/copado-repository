public class AadharGenerator {
    @InvocableMethod(label='Generate Random Aadhar' description='Generates a random 12-digit string')
    public static List<String> generate() {
        String randomAadhar = '';
        
        // पहले 11 अंक रैंडमली जनरेट करें
        for(Integer i=0; i<12; i++) {
            // 0 से 9 के बीच रैंडम नंबर
            Integer digit = Integer.valueOf(Math.floor(Math.random() * 10));
            
            // आधार का पहला अंक 0 या 1 नहीं हो सकता (नियम के अनुसार)
            if(i == 0 && (digit == 0 || digit == 1)) {
                digit = 2; 
            }
            randomAadhar += String.valueOf(digit);
        }
        
        // 12वां अंक जोड़ें (अभी के लिए रैंडम)
        randomAadhar += String.valueOf(Integer.valueOf(Math.floor(Math.random() * 10)));
        
        return new List<String>{randomAadhar};
    }
}