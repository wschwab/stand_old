const app = require('express')()

const { createUser } = require("./user")

app.get('/', (req, res) => res.send('Hello from the server'))

export default provider = ethers.getDefaultProvider()

export default const standMasterAddress = "0x" // should obviously have real address
export default const standMasterAbi = [
  "event Created(address contractAddress)",
  "event UserCreated(address root, address user, string name)",
  "event UserRemoved(address user)",
  "event ArtistCreated(address user, address artist)",
  "event ArtistRemoved(address user, address artist)",
  "event ProjectRemoved(address user, address project)",
  "event ProjectRemoved(address user, address project)",
  "constructor()",
  "function createUser(string name)",
  "function removeUser(address user)",
  "function addOrRemoveArtist(address artist)"
]
export default const StandMasterContract = new ethers.Contract(standMasterAddress, standMasterAbi)

app.post('/create', createUser)

const PORT = process.env.PORT || 7777

app.listen(PORT, () => console.log(`Server started on port ${PORT}`))
