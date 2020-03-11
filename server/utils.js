const isEmpty = string => {
    if(string.trim() === '') return true
    else return false
}

exports.validateCreation = data => {
    let errors = {}

    if(isEmpty(data.name)) {
        errors.name = "Name required"
    }
    //need an address validator here

    return {
        errors,
        valid: Object.keys(errors).length === 0 ? true : false
    }
}
