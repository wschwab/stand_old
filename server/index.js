const ethers = require('ethers')

const app = require('express')()

const {
  createUser,
  createArtist,
  createProject,
  likeOrUnlike,
  followOrUnfollow,
  comment,
  fund,
  editProfile,
  deleteAccount,
  getProfile
} = require("./user")
const {
  addTier,
  addContent,
  artprojCashOut,
  getArtprojProfile
} = require('./artistAndProject')
const {
  standMasterAddress,
  standMasterAbi,
  userAbi
} = require("./utils")

app.get('/', (req, res) => res.send('Hello from the server'))

export default provider = ethers.getDefaultProvider()

export default
const StandMasterContract = new ethers.Contract(standMasterAddress, standMasterAbi)

// user/master contract
app.post('/create', createUser)
app.post('/create', createArtist)
app.post('/create', createProject)
app.post('/user', likeOrUnlike)
app.post('/user', followOrUnfollow)
app.post('/user/:userId', comment) // id of art or proj should also be valid
app.post('/user', fund)
app.post('/user', editProfile)
app.post('/user', cashOut)
app.post('/user', deleteAccount)
app.get('/user/:userId', getProfile)

// artist/project contract
app.post('/artistOrProject', addTier)
app.post('/artistOrProject', addContent)
app.post('/artistOrProject', artprojCashOut)
app.get('/artistOrProject/:artOrProjId', getArtOrProjProfile)

const PORT = process.env.PORT || 7777

app.listen(PORT, () => console.log(`Server started on port ${PORT}`))
