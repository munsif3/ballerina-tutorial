import ballerina/io;

public function main() {
    string[] countries = filterCountriesByCases(covidTable, 10000000);
    io:println("Countries with more than 10 million cases: ", countries);

    [string, decimal][] countriesByDeaths = findCountriesByHighestNoOfDeaths(covidTable, 3);
    io:println("Top 3 countries by the highest no. of deaths: ", countriesByDeaths);

    string[] c = ["USA", "India", "Afghanistan"];
    [string, decimal][] countriesWithRecovered = findRecoveredPatientsOfCountries(covidTable, c);
    io:println("Countries with number of Recovered patients:", countriesWithRecovered);

    printErroneousData(covidTable);
}

public function filterCountriesByCases(table<CovidEntry> dataTable, decimal noOfCases) returns string[] {
    string[] filteredCountries = from CovidEntry entry in dataTable
        where entry.cases > noOfCases
        select entry.country;
    return filteredCountries;
}

public function findCountriesByHighestNoOfDeaths(table<CovidEntry> dataTable, int n) returns [string, decimal][] {
    [string, decimal][] countriesWithDeaths = from CovidEntry entry in dataTable
        order by entry.deaths descending
        limit n
        select [entry.country, entry.deaths];
    return countriesWithDeaths;
}

public function findRecoveredPatientsOfCountries(table<CovidEntry> dataTable, string[] countries) returns [string, decimal][] {
    [string, decimal][] countriesWithRecovered = from CovidEntry entry in dataTable
        join string country in countries on entry.country equals country
        select [entry.country, entry.recovered];
    return countriesWithRecovered;
}

public function printErroneousData(table<CovidEntry> dataTable) {
    string[] countries = from CovidEntry entry in dataTable
        let decimal sum = entry.recovered + entry.deaths + entry.active
        where entry.cases != sum
        select entry.country;

    if countries.length() > 0 {
        io:println("Found erroneous entries for countries: ", countries);
    }
}

public type CovidEntry record {|
    readonly string iso_code;
    string country;
    decimal cases;
    decimal deaths;
    decimal recovered;
    decimal active;
|};

public final table<CovidEntry> key(iso_code) covidTable = table [
        {iso_code: "AFG", country: "Afghanistan", cases: 159303, deaths: 7386, recovered: 146084, active: 5833},
        {iso_code: "SL", country: "Sri Lanka", cases: 598536, deaths: 5243, recovered: 568637, active: 14656},
        {iso_code: "US", country: "USA", cases: 69808350, deaths: 880976, recovered: 43892277, active: 25035097},
        {iso_code: "IND", country: "India", cases: 80808350, deaths: 980976, recovered: 33892279, active: 35035095}
    ];
