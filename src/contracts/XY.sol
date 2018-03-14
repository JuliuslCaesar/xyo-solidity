pragma solidity ^0.4.19;

import './SafeMath.sol';


interface XYNotify {
    function answer(address xyoAddress, int latitude, int longitude, int altitude, uint accuracy, uint certainty, uint epoch) external;
}


contract XY {
    using SafeMath for *;

    struct PendingQuery {
        uint xyoValue;
        address xyoAddress;
        uint accuracyThreshold;
        uint certaintyThreshold;
        uint minimumDelay;
        uint epoch;
        address xynotify;
        uint expireTime;
    }

    struct Answer {
        address xyoAddress;
        int latitude;
        int longitude;
        int altitude;
        uint accuracy;
        uint certainty;
        uint epoch;
    }

    // Stores a mapping of pending queries
    mapping (address => PendingQuery) public pendingQueries;

    // Stores a mapping of xyoAddresses to answers
    mapping (address => Answer) public answeredQueries;
    address[] public answerList;

    event QueryReceived(uint xyoValue, address xyoAddress, uint accuracy, uint certainty, uint delay, uint epoch, uint expireTime);
    event AnswerReceived(address xyoAddress, int latitude, int longitude, int altitude, uint accuracy, uint certainty, uint epoch);

    function publishQuery(uint _xyoValue, address _xyoAddress, uint _accuracy, uint _certainty, uint _delay, uint _epoch, address _xynotify, uint _expireTime) public returns(bool) {
        require(_xyoValue > 0);
        pendingQueries[msg.sender] = PendingQuery(_xyoValue, _xyoAddress, _accuracy, _certainty, _delay, _epoch, _xynotify, _expireTime);
        emit QueryReceived(_xyoValue, _xyoAddress, _accuracy, _certainty, _delay, _epoch, _expireTime);
        return true;
    }

    // this is how a diviner sets the answer.  Need to implement the origin proof
    function publishAnswer(address _xyoAddress, int _latitude, int _longitude, int _altitude, uint _accuracy, uint _certainty, uint _epoch) public returns(bool) {
        if (now > pendingQueries[msg.sender].expireTime) {
            return false;
        }
        // TODO: Have to verify before returning
        answeredQueries[_xyoAddress] = Answer(_xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        answerList.push(_xyoAddress);
        pendingQueries[msg.sender].xyoValue = 0;
        if (pendingQueries[msg.sender].xynotify != 0) {
            XYNotify(pendingQueries[msg.sender].xynotify).answer(_xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        }
        emit AnswerReceived(_xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        return true;
    }

    function hasPendingQuery() view public returns(bool) {
       if(pendingQueries[msg.sender].xyoValue > 0 && now <= pendingQueries[msg.sender].expireTime) {
           return true;
       }
       return false;
    }

}
