const { validateCreation } = require('./utils')

exports.createUser = (req, res) => {
    const newUser = {
        name: req.body.name,
        address: parseInt(req.body.address, 16) //|| web3.createNewAddress(),
    }

    const { valid, errors } = validateCreation(newUser)

    if(!valid) return res.status(400).json(errors)

    // use address to generate a user contract
    // user contract should be stored in the user data
}
