import ballerina/http;
import ballerina/mime;

# APIs for sampling from and fine-tuning language models
public isolated client class Client {
    final http:Client clientEp;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://api.openai.com/v1") returns error? {
        http:ClientConfiguration httpClientConfig = {auth: config.auth, httpVersion: config.httpVersion, timeout: config.timeout, forwarded: config.forwarded, poolConfig: config.poolConfig, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, validation: config.validation};
        do {
            if config.http1Settings is ClientHttp1Settings {
                ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
                httpClientConfig.http1Settings = {...settings};
            }
            if config.http2Settings is http:ClientHttp2Settings {
                httpClientConfig.http2Settings = check config.http2Settings.ensureType(http:ClientHttp2Settings);
            }
            if config.cache is http:CacheConfig {
                httpClientConfig.cache = check config.cache.ensureType(http:CacheConfig);
            }
            if config.responseLimits is http:ResponseLimitConfigs {
                httpClientConfig.responseLimits = check config.responseLimits.ensureType(http:ResponseLimitConfigs);
            }
            if config.secureSocket is http:ClientSecureSocket {
                httpClientConfig.secureSocket = check config.secureSocket.ensureType(http:ClientSecureSocket);
            }
            if config.proxy is http:ProxyConfig {
                httpClientConfig.proxy = check config.proxy.ensureType(http:ProxyConfig);
            }
        }
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        return;
    }
    # Returns a list of files that belong to the user's organization.
    #
    # + return - OK 
    resource isolated function get files() returns ListFilesResponse|error {
        string resourcePath = string `/files`;
        ListFilesResponse response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Upload a file that contains document(s) to be used across various endpoints/features. Currently, the size of all the files uploaded by one organization can be up to 1 GB. Please contact us if you need to increase the storage limit.
    #
    # + return - OK 
    resource isolated function post files(CreateFileRequest payload) returns OpenAIFile|error {
        string resourcePath = string `/files`;
        http:Request request = new;
        mime:Entity[] bodyParts = check createBodyParts(payload);
        request.setBodyParts(bodyParts);
        OpenAIFile response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Returns information about a specific file.
    #
    # + file_id - The ID of the file to use for this request 
    # + return - OK 
    resource isolated function get files/[string file_id]() returns OpenAIFile|error {
        string resourcePath = string `/files/${getEncodedUri(file_id)}`;
        OpenAIFile response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Delete a file.
    #
    # + file_id - The ID of the file to use for this request 
    # + return - OK 
    resource isolated function delete files/[string file_id]() returns DeleteFileResponse|error {
        string resourcePath = string `/files/${getEncodedUri(file_id)}`;
        DeleteFileResponse response = check self.clientEp-> delete(resourcePath);
        return response;
    }
    # Returns the contents of the specified file
    #
    # + file_id - The ID of the file to use for this request 
    # + return - OK 
    resource isolated function get files/[string file_id]/content() returns string|error {
        string resourcePath = string `/files/${getEncodedUri(file_id)}/content`;
        string response = check self.clientEp->get(resourcePath);
        return response;
    }
    # List your organization's fine-tuning jobs
    #
    # + return - OK 
    resource isolated function get 'fine\-tunes() returns ListFineTunesResponse|error {
        string resourcePath = string `/fine-tunes`;
        ListFineTunesResponse response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Creates a job that fine-tunes a specified model from a given dataset.
    # 
    # Response includes details of the enqueued job including job status and the name of the fine-tuned models once complete.
    # 
    # [Learn more about Fine-tuning](/docs/guides/fine-tuning)
    #
    # + return - OK 
    resource isolated function post 'fine\-tunes(CreateFineTuneRequest payload) returns FineTune|error {
        string resourcePath = string `/fine-tunes`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody, "application/json");
        FineTune response = check self.clientEp->post(resourcePath, request);
        return response;
    }
    # Gets info about the fine-tune job.
    # 
    # [Learn more about Fine-tuning](/docs/guides/fine-tuning)
    #
    # + fine_tune_id - The ID of the fine-tune job 
    # + return - OK 
    resource isolated function get 'fine\-tunes/[string fine_tune_id]() returns FineTune|error {
        string resourcePath = string `/fine-tunes/${getEncodedUri(fine_tune_id)}`;
        FineTune response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Immediately cancel a fine-tune job.
    #
    # + fine_tune_id - The ID of the fine-tune job to cancel 
    # + return - OK 
    resource isolated function post 'fine\-tunes/[string fine_tune_id]/cancel() returns FineTune|error {
        string resourcePath = string `/fine-tunes/${getEncodedUri(fine_tune_id)}/cancel`;
        http:Request request = new;
        //TODO: Update the request as needed;
        FineTune response = check self.clientEp-> post(resourcePath, request);
        return response;
    }
    # Get fine-grained status updates for a fine-tune job.
    #
    # + fine_tune_id - The ID of the fine-tune job to get events for. 
    # + 'stream - Whether to stream events for the fine-tune job. If set to true, events will be sent as data-only [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format) as they become available. The stream will terminate with a `data: [DONE]` message when the job is finished (succeeded, cancelled, or failed). If set to false, only events generated so far will be returned. 
    # + return - OK 
    resource isolated function get 'fine\-tunes/[string fine_tune_id]/events(boolean 'stream = false) returns ListFineTuneEventsResponse|error {
        string resourcePath = string `/fine-tunes/${getEncodedUri(fine_tune_id)}/events`;
        map<anydata> queryParam = {"stream": 'stream};
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        ListFineTuneEventsResponse response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Lists the currently available models, and provides basic information about each one such as the owner and availability.
    #
    # + return - OK 
    resource isolated function get models() returns ListModelsResponse|error {
        string resourcePath = string `/models`;
        ListModelsResponse response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Retrieves a model instance, providing basic information about the model such as the owner and permissioning.
    #
    # + model - The ID of the model to use for this request 
    # + return - OK 
    resource isolated function get models/[string model]() returns Model|error {
        string resourcePath = string `/models/${getEncodedUri(model)}`;
        Model response = check self.clientEp->get(resourcePath);
        return response;
    }
    # Delete a fine-tuned model. You must have the Owner role in your organization.
    #
    # + model - The model to delete 
    # + return - OK 
    resource isolated function delete models/[string model]() returns DeleteModelResponse|error {
        string resourcePath = string `/models/${getEncodedUri(model)}`;
        DeleteModelResponse response = check self.clientEp-> delete(resourcePath);
        return response;
    }
}
