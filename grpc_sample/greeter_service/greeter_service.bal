import ballerina/grpc;

listener grpc:Listener grpcListener = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_HELLOWORLD, descMap: getDescriptorMapHelloworld()}
service "Greeter" on grpcListener {

    remote function sayHello(HelloRequest value) returns HelloReply|error {
        return {message: "Hello " + value.name};
    }
}
