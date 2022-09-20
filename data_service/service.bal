import ballerina/http;

service /employees on new http:Listener(8080) {

    isolated resource function post .(@http:Payload Employee emp) returns int|error? {
        return addEmployee(emp);
    }

    isolated resource function get [int id]() returns Employee|error? {
        return getEmployee(id);
    }

    isolated resource function get .() returns Employee[]|error? {
        return getAllEmployees();
    }

    isolated resource function put .(@http:Payload Employee emp) returns int|error? {
        return updateEmployee(emp);
    }

    isolated resource function delete [int id]() returns int|error? {
        return removeEmployee(id);
    }
}
