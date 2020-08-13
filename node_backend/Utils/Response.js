
exports.ERROR = (response,message,code,data = null) => {
    response.status(code)
    return response.json({
        status: "FAILED",
        code: code,
        message: message,
        data: data
    })
}

exports.SUCCESS = (response,message,code,data = null) => {
    response.status(code)
    return response.json({
        status: "SUCCESS",
        code: code,
        message: message,
        data: data
    })
}

// exports = {
//     ERROR: (response,message,code,data = null) => {
//         return response.json({
//             status: "FAILED",
//             code: code,
//             message: message,
//             data: data
//         }).status(code)
//     },
//     SUCCESS: (response,message,code,data = null) => {
//         return response.json({
//             status: "SUCCESS",
//             code: code,
//             message: message,
//             data: data
//         }).status(code)
//     }
// }