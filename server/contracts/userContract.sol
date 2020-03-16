pragma solidity >=0.4.0 <0.7.0;

import "./artistContract";
import "./projectContract";

contract StandMasterContract {
    address[] public users;
    address[] public artists;
    address[] public projects;

    enum Types {
        user,
        artist,
        project,
        deleted
    };

    event Created(address contractAddress);
    event UserCreated(address root, address user, string name);
    event UserRemoved(address user);
    event ArtistCreated(address user, address artist);
    event ArtistRemoved(address user, address artist);
    event ProjectCreated(address user, address project);
    event ProjectRemoved(address user, address project);

    mapping (address => Types) typeOf;

    modifier onlyUser() {
      require(
        typeOf[msg.sender] == Types.user,
        "only user accounts may perform this action"
      );
      _;
    }

    constructor() {
      emit Created(this);
    }

    function createUser(
        string public name
    ) public {
        address userContract = new UserContract(msg.sender, name);
        users.push(userContract);
        isUser[userContract] = true;
        typeOf[userContract] = Types.user;

        emit UserCreated(msg.sender, userContract, name);
    }

    function removeUser(address user) public {
        require(msg.sender == user);
        users.pop(user);
        typeOf[user] == Types.deleted;

        emit UserRemoved(user);
    }

    function addOrRemoveArtist(address artist) public onlyUser {
        if(
          !typeOf[artist] ||
          typeOf[artist] == Types.deleted
        ){
          artists.push(artist);
          typeOf[artist] = Types.artist;

          emit ArtistCreated(msg.sender, artist);
        } else if (
          typeOf[artist] == Types.artist
        ){
          artists.pop(artist);
          typeOf[artist] = Types.deleted;

          emit ArtistRemoved(msg.sender, artist);
        } else {
          revert("Something strange happened - you should not be seeing this");
        }
    }

    function addOrRemoveProject(address project) public onlyUser {
        if(
          !typeOf[project] ||
          typeOf[project] == Types.deleted
        ){
          projects.push(project);
          typeOf[project] = Types.project;

          emit ProjectCreated(msg.sender, project);
        } else if (
          typeOf[project] == Types.project
        ){
          projects.pop(project);
          typeOf[project] = Types.deleted;

          emit ProjectRemoved(msg.sender, project);
        } else {
          revert("Something strange happened - you should not be seeing this");
        }
      }
}

// currently cashing out just dumps it in the root user account
// this needs other options, especially if there is going to be a fiat offramps

contract UserContract {
    address masterAddr;
    StandMasterContract master;

    struct User {
        address payable public root;
        string public name;
        string public image; // should point to storage hash of a default image
        string public bio; // I think this should also just be a link
        address public artAddress;
        address[] public likes;
        address[] public follows;
        address[] public isFunding;
        address[] public projects;
        bool public artist;
    }

    modifier onlyOwner {
        require(msg.sender == User.root);
        _;
    }

    modifier onlyMember(address destination) {
      require(
        master.typeOf[destination] &&
        master.typeOf[destination] != Types.deleted
      );
      _;
    }

    constructor(address _root, string _name) public {
        masterAddr = msg.sender;
        master = StandMasterContract(masterAddr);

        User.root = _root;
        User.name = _name;
    }

    function createArtist(
        string name
    ) public onlyOwner {
        require(
          User.artAddress == address(0) &&
          !User.artist,
          "You already have an artist page"
        );

        User.artist = true;
        address artistContract = new ArtistContract(User.root, name);
        User.artAddress = artistContract;
        master.addArtist(address(artistContract));
    }

    function createProject(
        string name
    ) public onlyOwner {
        address projectContract = new ProjectContract(User.root, name);
        User.projects.push(projectContract);
        master.addProject(address(projectContract));
    }

    function likeUnlike(address toLike) public onlyOwner onlyMember(toLike) {
        // would checking the address be nice?
        // not sure I can work with the Type enum like this
        if(master.typeOf[toLike] == Types.user) {
            UserContract user = UserContract(toLike);
            user.getLikedUnliked(address(this));
        } else if(master.typeOf[toLike] == Types.artist) {
            ArtistContract artist = ArtistContract(toLike)
            artist.getLikedUnliked(address(this));
        } else if(master.typeOf[toLike] == Types.project) {
            ProjectContract project = ProjectContract(address(this));
            project.getLikedUnliked(address(this));
        }
    }

    function getLikedUnliked(address liker) public onlyMember(liker) {
        // if liker isn't already in likes
        if(isIn(liker, likes)) {
            User.likes.pop(liker);
        } else {
            User.likes.push(liker);
        }
    }

    function followUnfollow(address toFollow) public onlyOwner onlyMember(toFollow) {
        if(master.typeOf[toLike] == Types.user) {
            UserContract user = UserContract(toLike);
            user.getFollowedUnfollowed(address(this));
        } else if(master.typeOf[toLike] == Types.artist) {
            ArtistContract artist = ArtistContract(toLike)
            artist.getFollowedUnfollowed(address(this));
        } else if(master.typeOf[toLike] == Types.project) {
            ProjectContract project = ProjectContract(address(this));
            project.getFollowedUnfollowed(address(this));
        }
    }

    function getFollowedUnfollowed(address follower) public onlyMember(follower) {
        if(isIn(follower, follows)){
            User.follows.pop(follower);
        } else {
            User.follows.push(follower);
        }
    }

    function fund(address artistOrProject) public onlyOwner {
      require(
        master.typeOf[artistOrProject] == Types.artist ||
        master.typeOf[artistOrProject] == Types.project
      )
        // research subscriptions (EIP 1337?)

    }

    function editProfile(string whichContent, string newHash) public onlyOwner {
        if(whichContent == 'image') User.image = newHash;
        if(whichContent == 'bio') User.bio == newHash;
    }

    function cashOut(uint amount) public onlyOwner {
        User.root.transfer(amount);
    }

    function deleteAccount() public onlyOwner {
        User.root.transfer(this.value);
        master.removeUser(this);
    }

    function isIn(address _addr, address[] _array) internal returns(bool){
        for(i=0;i<_array.length;i++){
            if _array[i] == _addr return true
        }
        return false;
    }
}
