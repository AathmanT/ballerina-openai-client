This is a generated connector for [OpenAI Images API](https://beta.openai.com/docs/api-reference/images) OpenAPI Specification. OpenAI is an American artificial intelligence research laboratory consisting of a non-profit corporation and a for-profit subsidiary. OpenAI conducts AI research with the declared intention of promoting and developing friendly AI. The OpenAI Images API provides a way to access new DALL.E models developed by OpenAI for a variety of image related tasks.

## Prerequisites

Before using this connector in your Ballerina application, complete the following:

* Create an [OpenAI Account](https://beta.openai.com/signup/).
* Obtain an API key by following [these instructions](https://platform.openai.com/docs/api-reference/authentication).

## Quickstart

To use the OpenAI Images connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import connector
First, import the `ballerinax/openai.images` module into the Ballerina project.

```ballerina
import ballerinax/openai.images;
```

### Step 2: Create a new connector instance
Create and initialize `images:Client` with the `apiKey` obtained.
```ballerina
    images:Client imagesClient = check new ({
        auth: {
            token: "sk-XXXXXXXXX"
        }
    });
```

### Step 3: Invoke connector operation
1. Now you can use the operations available within the connector. Note that they are in the form of remote operations.

    Following is an example on generating image using the OpenAI DALL.E model:

    Generate image with DALL.E

    ```ballerina
    public function main() returns error? {
        images:CreateImageRequest createImageRequest = {
            prompt: "A cute baby sea otter",
            n: 1,
            size: "256x256",
            response_format: "url",
            user: "user-1234"
        };
        images:ImagesResponse|error unionResult = check imagesClient->/images/generations.post(createImageRequest);
        if unionResult is images:ImagesResponse {
            io:println(unionResult);
        } else {
            io:println(unionResult);
        }
    }
    ``` 
2. Use `bal run` command to compile and run the Ballerina program.