pragma solidity ^0.4.19;
pragma experimental "v0.5.0";

import 'XYDeprecatable.sol';
import 'ERC20.sol';
import 'SafeMath.sol';

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

    struct Query {
        uint xyoValue;
        uint ethValue;
        address xyoAddress;
        uint accuracyThreshold;
        uint certaintyThresold;
        uint minimumDelay;
        uint epoch;
        int answer;
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
    mapping (address => Query[]) public pendingQueries;
    address[] public askers;

    // Stores a mapping of xyoAddresses to answers
    // there can be multiple answers for question
    // a worse answer can never be entered
    // if a better answer comes in, the previous answer gets 25% or the reward
    // the winning answer always get 75% of the reward

    mapping (address => Answer[][]) public answeredQueries;

    ERC20 xyoToken;

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

    constructor (address _xyoToken) public {
      xyoToken = ERC20(_xyoToken);
    }

    function publishQuery (
        uint _xyoValue,
        address _xyoAddress,
        uint _accuracy,
        uint _certainty,
        uint _delay,
        uint _epoch,
        address _xynotify) public payable returns(uint) {

        require(msg.value > 0);
        require(_xyoValue > 0);

        uint newLength = pendingQueries[msg.sender].push(Query(
            _xyoValue,
            msg.value,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch,
            -1,
            _xynotify));

        emit QueryReceived(
            _xyoValue,
            msg.value,
            _xyoAddress,
            _accuracy,
            _certainty,
            _delay,
            _epoch);

        return newLength - 1;
    }

    function resolveQuery(Query query, uint index, Answer[] answers) internal {
      uint winner = 0;
      uint winningScore = (answers[0].accuracy - query.accuracyThreshold) + (answers[0].accuracy - query.accuracyThreshold);
      for (uint i = 1; i < answers.length; i++) {
        if (answers[i].accuracy > query.accuracyThreshold && answers[i].accuracy > query.accuracyThreshold) {
          uint score = (answers[i].accuracy - query.accuracyThreshold) + (answers[i].accuracy - query.accuracyThreshold);
          if (score > winningScore) {
            winner = i;
          }
        }
      }

      query.answer = int(winner);

      if (query.xynotify != 0) {
        XYUncalibratedQueryNotify(query.xynotify).answer(
          answers[winner].xyoAddress,
          index,
          answers[winner].latitude,
          answers[winner].longitude,
          answers[winner].altitude,
          answers[winner].accuracy,
          answers[winner].certainty,
          answers[winner].epoch
          );
      }
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

        Query storage pendingQuery = pendingQueries[_xyoAddress][_index];

        answeredQueries[_xyoAddress][_index].push(Answer(
            _xyoAddress, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch));
        if (pendingQuery.xynotify != 0) {
            XYUncalibratedQueryNotify(pendingQuery.xynotify).answer(
                _xyoAddress, _index, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        }
        emit AnswerReceived(_xyoAddress, _index, _latitude, _longitude, _altitude, _accuracy, _certainty, _epoch);
        if ((_accuracy >= pendingQuery.accuracyThreshold) && (_certainty >= pendingQuery.certaintyThresold)) {
          resolveQuery(pendingQuery, _index, answeredQueries[_xyoAddress][_index]);
        }
    }

}
