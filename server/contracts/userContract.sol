pragma solidity >=0.4.0 <0.7.0;

import "./artistContract";
import "./projectContract";

contract StandMasterContract {
    address[] public users;
    address[] public artists;
    address[] public projects;

    enum Types {
        user,
        artistOrProject,
        deleted
    };

    mapping (address => Types) typeOf;

    event Created(address contractAddress, uint time);
    event UserCreated(address root, address user, string name, uint time);
    event UserRemoved(address user, uint time);
    event ArtistCreated(address user, address artist, uint time);
    event ArtistRemoved(address user, address artist, uint time);
    event ProjectCreated(address user, address project, uint time);
    event ProjectRemoved(address user, address project, uint time);

    modifier onlyUser() {
      require(
        typeOf[msg.sender] == Types.user,
        "only user accounts may perform this action"
      );
      _;
    }

    constructor() {
      emit Created(address(this), now);
    }

    function createUser(
        string public name
    ) public {
        address userContract = new UserContract(msg.sender, name);
        users.push(userContract);
        isUser[userContract] = true;
        typeOf[userContract] = Types.user;

        emit UserCreated(msg.sender, userContract, name, now);
    }

    function removeUser(address user) public {
        require(msg.sender == user);
        users.pop(user);
        typeOf[user] == Types.deleted;

        emit UserRemoved(user, now);
    }

    function addOrRemoveArtist(address artist) public onlyUser {
        if(
          !typeOf[artist] ||
          typeOf[artist] == Types.deleted
        ){
          artists.push(artist);
          typeOf[artist] = Types.artist;

          emit ArtistCreated(msg.sender, artist, now);
        } else if (
          typeOf[artist] == Types.artistOrProject
        ){
          artists.pop(artist);
          typeOf[artist] = Types.deleted;

          emit ArtistRemoved(msg.sender, artist, now);
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

          emit ProjectCreated(msg.sender, project, now);
        } else if (
          typeOf[project] == Types.project
        ){
          projects.pop(project);
          typeOf[project] = Types.deleted;

          emit ProjectRemoved(msg.sender, project, now);
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

    event Liked(address liker, address liked, uint time);
    event Uniked(address unliker, address unliked, uint time);
    event Followed(address follower, address followed, uint time);
    event Unfollowed(address unfollower, address unfollowed, uint time);
    event Funded(address giver, address recipient, uint amountLocked, uint epochs, string, epochType, uint time);
    event ProfileEdited(address user, string contentType, string contentHash, uint time);
    event CashedOut(address from, address to, uint amount, uint time);
    event AccountDeleted(address root, address user, uint time);

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

    function createArtist(string name) public onlyOwner {
        require(
          !User.artist,
          "You already have an artist page"
        );

        User.artist = true;
        address artistContract = new ArtistOrProjectContract(User.root, name);
        User.artAddress = artistContract;
        master.addArtist(address(artistContract));
    }

    function createProject(string name) public onlyOwner {
        address projectContract = new ArtistProjectContract(User.root, name);
        User.projects.push(projectContract);
        master.addProject(address(projectContract));
    }

    function likeUnlike(address toLike) public onlyOwner onlyMember(toLike) {
        // would checking the address be nice?
        // not sure I can work with the Type enum like this
        if(master.typeOf[toLike] == Types.user) {
            UserContract user = UserContract(toLike);
            user.getLikedUnliked(address(this));
        } else if(master.typeOf[toLike] == Types.artistOrProject) {
            ArtistOrProjectContract artOrProj = ArtistOrProjectContract(toLike);
            artOrProj.getLikedUnliked(address(this));
        } else {
          revert("Something strange happened - you should not be seeing this");
        }
    }

    function getLikedUnliked(address liker) public onlyMember(liker) {
        require(liker == msg.sender);
        // if liker isn't already in likes
        if(isIn(liker, likes)) {
            User.likes.pop(liker);
            emit Uniked(msg.sender, address(this), now);
        } else {
            User.likes.push(liker);
            emit Liked(msg.sender, address(this), now)
        }
    }

    function followUnfollow(address toFollow) public onlyOwner onlyMember(toFollow) {
        if(master.typeOf[toLike] == Types.user) {
            UserContract user = UserContract(toLike);
            user.getFollowedUnfollowed(address(this));
        } else if(master.typeOf[toLike] == Types.artistOrProject) {
            ArtistOrProjectContract artOrProj = ArtistOrProjectContract(toLike);
            artOrProj.getFollowedUnfollowed(address(this));
        } else {
          revert("Something strange happened - you should not be seeing this");
        }
    }

    function getFollowedUnfollowed(address follower) public onlyMember(follower) {
        require(follower == msg.sender);
        if(isIn(follower, follows)){
            User.follows.pop(follower);
            emit Unfollowed(msg.sender, address(this), now);
        } else {
            User.follows.push(follower);
            emit Followed(msg.sender, address(this), now);
        }
    }

    function comment(address destination, Comment comment)
      public
      onlyOwner
      onlyMember(destination) {
        require(master.typeOf[destination] == Type.artOrProject);
        ArtistOrProjectContract artOrProj = ArtistOrProjectContract(destination);
        artOrProj.getComment(address(this), comment);
    }

    function fund(
      address payable artistOrProject,
      uint amountToLock,
      uint epochs,
      string epochType
    ) public payable onlyOwner {
      require(
        master.typeOf[artistOrProject] == Types.artist ||
        master.typeOf[artistOrProject] == Types.project
      )
        // research subscriptions (EIP 1337? Sablier?)
        // different for project (one time) and artist (stream/subscribe)?

      emit Funded(address(this), artistOrProject, amountLocked, epochs, epochType, now);
    }

    function editProfile(string contentType, string contentHash) public onlyOwner {
        if(contentType == 'image') User.image = contentHash;
        if(contentType == 'bio') User.bio == contentHash;

        emit ProfileEdited(address(this), contentType, contentHash, now);
    }

    function cashOut(uint amount) public onlyOwner {
        User.root.transfer(amount);

        emit CashedOut(address(this), User.root, msg.value, now);
    }

    function deleteAccount() public onlyOwner {
        User.root.transfer(this.value);
        master.removeUser(this);

        emit AccountDeleted(msg.sender, address(this), now);
    }

    function isIn(address _addr, address[] _array) internal returns(bool){
        for(i=0;i<_array.length;i++){
            if _array[i] == _addr return true
        }
        return false;
    }
}
