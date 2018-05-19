module.exports = {"functionHashes":{"answerList(uint256)":"c9930ee0","answeredQueries(address)":"2afe70fd","hasPendingQuery()":"e491650e","pendingQueries(address)":"7fc4077e","publishAnswer(address,int256,int256,int256,uint256,uint256,uint256)":"12b74932","publishQuery(uint256,address,uint256,uint256,uint256,uint256,address)":"4540b9a3"},"gasEstimates":{"creation":[362,322800],"external":{"answerList(uint256)":925,"answeredQueries(address)":2125,"hasPendingQuery()":610,"pendingQueries(address)":2184,"publishAnswer(address,int256,int256,int256,uint256,uint256,uint256)":null,"publishQuery(uint256,address,uint256,uint256,uint256,uint256,address)":143780},"internal":{}},"interface":"[{\"constant\":false,\"inputs\":[{\"name\":\"_xyoAddress\",\"type\":\"address\"},{\"name\":\"_latitude\",\"type\":\"int256\"},{\"name\":\"_longitude\",\"type\":\"int256\"},{\"name\":\"_altitude\",\"type\":\"int256\"},{\"name\":\"_accuracy\",\"type\":\"uint256\"},{\"name\":\"_certainty\",\"type\":\"uint256\"},{\"name\":\"_epoch\",\"type\":\"uint256\"}],\"name\":\"publishAnswer\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"address\"}],\"name\":\"answeredQueries\",\"outputs\":[{\"name\":\"xyoAddress\",\"type\":\"address\"},{\"name\":\"latitude\",\"type\":\"int256\"},{\"name\":\"longitude\",\"type\":\"int256\"},{\"name\":\"altitude\",\"type\":\"int256\"},{\"name\":\"accuracy\",\"type\":\"uint256\"},{\"name\":\"certainty\",\"type\":\"uint256\"},{\"name\":\"epoch\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_xyoValue\",\"type\":\"uint256\"},{\"name\":\"_xyoAddress\",\"type\":\"address\"},{\"name\":\"_accuracy\",\"type\":\"uint256\"},{\"name\":\"_certainty\",\"type\":\"uint256\"},{\"name\":\"_delay\",\"type\":\"uint256\"},{\"name\":\"_epoch\",\"type\":\"uint256\"},{\"name\":\"_xynotify\",\"type\":\"address\"}],\"name\":\"publishQuery\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"address\"}],\"name\":\"pendingQueries\",\"outputs\":[{\"name\":\"xyoValue\",\"type\":\"uint256\"},{\"name\":\"xyoAddress\",\"type\":\"address\"},{\"name\":\"accuracyThreshold\",\"type\":\"uint256\"},{\"name\":\"certaintyThresold\",\"type\":\"uint256\"},{\"name\":\"minimumDelay\",\"type\":\"uint256\"},{\"name\":\"epoch\",\"type\":\"uint256\"},{\"name\":\"xynotify\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"answerList\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"hasPendingQuery\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"xyoValue\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"xyoAddress\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"accuracy\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"certainty\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"delay\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"epoch\",\"type\":\"uint256\"}],\"name\":\"QueryReceived\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"xyoAddress\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"latitude\",\"type\":\"int256\"},{\"indexed\":false,\"name\":\"longitude\",\"type\":\"int256\"},{\"indexed\":false,\"name\":\"altitude\",\"type\":\"int256\"},{\"indexed\":false,\"name\":\"accuracy\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"certainty\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"epoch\",\"type\":\"uint256\"}],\"name\":\"AnswerReceived\",\"type\":\"event\"}]"}