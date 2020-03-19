const app = require('express')()

const { createUser } = require("./user")
const {
  standMasterAddress,
  standMasterAbi,
  userAbi
} = require("./utils")

app.get('/', (req, res) => res.send('Hello from the server'))

export default provider = ethers.getDefaultProvider()

export default const StandMasterContract = new ethers.Contract(standMasterAddress, standMasterAbi)

app.post('/create', createUser)

const PORT = process.env.PORT || 7777

app.listen(PORT, () => console.log(`Server started on port ${PORT}`))
