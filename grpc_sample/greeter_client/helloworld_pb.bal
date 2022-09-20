import ballerina/grpc;

public isolated client class GreeterClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR_HELLOWORLD, getDescriptorMapHelloworld());
    }

    isolated remote function sayHello(HelloRequest|ContextHelloRequest req) returns HelloReply|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloworld.Greeter/sayHello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <HelloReply>result;
    }

    isolated remote function sayHelloContext(HelloRequest|ContextHelloRequest req) returns ContextHelloReply|grpc:Error {
        map<string|string[]> headers = {};
        HelloRequest message;
        if req is ContextHelloRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloworld.Greeter/sayHello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <HelloReply>result, headers: respHeaders};
    }
}

public client class GreeterHelloReplyCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendHelloReply(HelloReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextHelloReply(ContextHelloReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextHelloRequest record {|
    HelloRequest content;
    map<string|string[]> headers;
|};

public type ContextHelloReply record {|
    HelloReply content;
    map<string|string[]> headers;
|};

public type HelloRequest record {|
    string name = "";
|};

public type HelloReply record {|
    string message = "";
|};

const string ROOT_DESCRIPTOR_HELLOWORLD = "0A1068656C6C6F776F726C642E70726F746F120A68656C6C6F776F726C6422220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522260A0A48656C6C6F5265706C7912180A076D65737361676518012001280952076D65737361676532470A0747726565746572123C0A0873617948656C6C6F12182E68656C6C6F776F726C642E48656C6C6F526571756573741A162E68656C6C6F776F726C642E48656C6C6F5265706C79620670726F746F33";

public isolated function getDescriptorMapHelloworld() returns map<string> {
    return {"helloworld.proto": "0A1068656C6C6F776F726C642E70726F746F120A68656C6C6F776F726C6422220A0C48656C6C6F5265717565737412120A046E616D6518012001280952046E616D6522260A0A48656C6C6F5265706C7912180A076D65737361676518012001280952076D65737361676532470A0747726565746572123C0A0873617948656C6C6F12182E68656C6C6F776F726C642E48656C6C6F526571756573741A162E68656C6C6F776F726C642E48656C6C6F5265706C79620670726F746F33"};
}

