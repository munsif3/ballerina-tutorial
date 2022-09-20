import ballerina/io;

GreeterClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    HelloReply sayHello = check ep->sayHello({name: "Ballerina"});
    io:println(`Response : ${sayHello.message}`);
}
