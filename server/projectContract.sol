pragma solidity >=0.4.0 <0.7.0;

// see notes in artistContract
// don't need tiers to restrict content

contract ProjectContract {
    struct Tier {
        uint public threshold;
        string public name;
        string public description;
    }

    struct Content {
        string public contentHash;
    }

    struct Project {
        address public root;
        address public user;
        string public name;
        string public image; // should point to storage hash of a default image
        Content[] public content;
        mapping (uint => string) comments; // uint should be timestamps
    }

    constructor(address _root, string _name) {
        Project.root = _root;
        Project.user = msg.sender;
        Project.name = _name;
    }
}
