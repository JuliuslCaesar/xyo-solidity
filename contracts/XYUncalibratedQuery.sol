pragma solidity ^0.4.19;

import "./XYDeprecatable.sol";
import './SafeMath.sol';

interface XYUncalibratedQueryNotify {
    function answer(
        address xyoAddress,
        uint index,
        int latitude,
        int longitude,
        int altitude,
        uint accuracy,
        uint certainty,
        uint epoch) external;
}

contract XYUncalibratedQuery is XYDeprecatable {
    using SafeMath for *;

    struct PendingQuery {
        uint xyoValue;
        uint ethValue;
        address xyoAddress;
        uint accuracyThreshold;
        uint certaintyThresold;
        uint minimumDelay;
        uint epoch;
        address xynotify;
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
    mapping (address => PendingQuery[]) public pendingQueries;

    // Stores a mapping of xyoAddresses to answers
    // there can be multiple answers for question
    // a worse answer can never be entered
    // if a better answer comes in, the previous answer gets 25% or the reward
    // the winning answer always get 75% of the reward

    mapping (address => Answer[][]) public answeredQueries;
    address[] public answerList;

    event QueryReceived(
        uint xyoValue,
        uint ethValue,
        address xyoAddress,
        uint accuracy,
        uint certainty,
        uint delay,
        uint epoch
        );

    event AnswerReceived(
        address xyoAddress,
        uint index,
        int latitude,
        int longitude,
        int altitude,
        uint accuracy,
        uint certainty,
        uint epoch
        );

    function publishQuery (
        uint _xyoValue,
        address _xyoAddress,
        uint _accuracy,
        uint _certainty,
        uint _delay,
        uint _epoch,
        address _xynotify) public payable {

        require(msg.value > 0);
        require(_xyoValue > 0);

        pendingQueries[msg.sender].push(PendingQuery(
            _xyoValue,
            msg.value,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch,
            _xynotify));

        QueryReceived(
            _xyoValue,
            msg.value,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch);
    }

    function publishAnswer(
        address _xyoAddress,
        uint _index,
        int _latitude,
        int _longitude,
        int _altitude,
        uint _accuracy,
        uint _certainty,
        uint _epoch) public {

        PendingQuery storage pendingQuery = pendingQueries[_xyoAddress][_index];

        answeredQueries[_xyoAddress][_index].push(Answer(
            _xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch));
        answerList.push(_xyoAddress);
        pendingQuery.xyoValue = 0;
        if (pendingQuery.xynotify != 0) {
            XYUncalibratedQueryNotify(pendingQuery.xynotify).answer(
                _xyoAddress, _index, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        }
        AnswerReceived(_xyoAddress, _index, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
    }

}
