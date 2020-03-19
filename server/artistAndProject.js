import { ethers } from 'ethers'
const {
        StandMasterContract,
        provider
      } = require('./index')
const {
        validateCreation,
        standMasterAddress,
        artistAbi,
        projectAbi
      } = require('./utils')

exports.addTier = (req, res) => {

}

let clipboard = {
"function addTier(uint _threshold, uint _epochs, string _name, string _description)",
"function addContent(string _tierName, string _contentHash)",
"receive()",
"function cashOut(uint amount)"
}
