var token = "Basic d2VpOjEyMzQ1Njc="

export const authorizer = async (event) => {

    let response = {
        "isAuthorized": false,
    };


    if (event.headers.authorization === token) {
        response = {
            "isAuthorized": true,
        };
    }

    return response;

};