pragma solidity >=0.4.0 <0.7.0;

// see notes in artistContract
// going back and forth on tiers - currently think projects can have them

contract ProjectContract {
    struct Tier {
        uint public threshold;
        string public name;
        string public description;
        mapping (address => bool) isMemberOfThisTier;
    }

    struct Content {
        string public tierName;
        string public contentHash;
    }

    struct Project {
        address public root;
        address public user;
        string public name;
        uint public deadline; //uint should be timestamp
        string public image; // should point to storage hash of a default image
        Tier[] public tiers;
        Content[] public content;
        mapping (uint => string) comments; // uint should be timestamps
    }

    modifier onlyOwner {
        require(msg.sender == Project.user || msg.sender == Project.root);
        _;
    }

    modifier onlyMember(address destination) {
      require(
        master.typeOf[destination] &&
        master.typeOf[destination] != Types.deleted
      );
      _;
    }

    constructor(address _root, string _name) {
        Project.root = _root;
        Project.user = msg.sender;
        Project.name = _name;
    }

    function addTier(
        uint _threshold,
        string _name,
        string _description
    )
        public onlyOwner
    {
        Project.tiers.push(Tier({
            threshold: _threshold,
            name: _name,
            description: _description
        }));
    }

    function addContent(
        string _tierName,
        string _contentHash
    )
        public onlyOwner
    {
        assert(
            for(i = 0; i < tiers.length; i++){
                if tiers[i].name === _tierName return true
            }
            return false
        );
        Project.content.push(Content({
            tierName: _tierName,
            contentHash: _contentHash
        }));
    }

    receive() external payable onlyMember(msg.sender) {
      for(i = 0; i < tiers.length; i++){
        if (msg.value >= tiers[i].threshold){
          tiers[i].isMemberOfThisTier[msg.sender] == true;
        }
      }
    }

    function cashOut(uint amount) public onlyOwner {
        Project.root.transfer(amount);
    }
}
