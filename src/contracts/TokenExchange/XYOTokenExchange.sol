pragma solidity ^0.4.19;

import "ERC20.sol";
import "XYKillable.sol";
import "SafeMath.sol";

contract XYOTokenExchange is XYKillable{

  using SafeMath
  for * ;

  // when a seller creates a sell order, they can never list more than maxTokensAvailable
  // and they can not

  struct Buyer {
    uint minPrice;
    uint maxPrice;
    uint maxTokens; // can never list more than this at once
    uint maxTokensPerBlock; // every 15 seconds or so
    BuyOrder[] orders;
  }

  struct Seller {
    uint minPrice;
    uint maxPrice;
    uint maxTokens; // can never list more than this at once
    uint maxTokensPerBlock; // every 15 seconds or so
    SellOrder[] orders;
  }

  struct SellOrder {
    address seller;
    uint tokens;
    uint price; // 0 = market (XYO per ETH)
    uint expireBlock;
    uint completedBlock;
  }

  struct BuyOrder {
    address buyer;
    uint tokens;
    uint price; //0 = market (XYO per ETH)
    uint expireBlock;
    uint completedBlock;
  }

  uint[] sellPrices; //low to high list of sell prices
  uint[] buyPrices; //low to high list of buy prices

  mapping(uint => SellOrder[]) public sellOrders;
  mapping(uint => BuyOrder[]) public buyOrders;

  mapping(address => Seller) public sellers;
  mapping(address => Buyer) public buyers;

  ERC20 public token; //address of the ERC20 token
  bool sellTransactionFeeAsPercent;
  uint transactionFee;
  address beneficiary;

  /* Public */

  constructor (
      address _token,
      address _beneficiary
  )
  public
  {
    token = ERC20(_token);
    sellTransactionFeeAsPercent = false;
    transactionFee = 0;
    beneficiary = _beneficiary;
  }

  function () public onlyNotKilled payable {
    purchase();
  }

  function purchase() public onlyNotKilled payable {
    uint purchaseEth = msg.value;

    while (purchaseEth > 0) {
      SellOrder memory order = getNextSellOrder();
      uint saleEth = getSellOrderMaxEth(order);
      uint tokens = 0;
      if (saleEth > purchaseEth) {
        tokens = purchaseEth * order.price;
        token.transferFrom(this, msg.sender, tokens);
        order.seller.transfer(purchaseEth);
        purchaseEth = 0;
        order.tokens = order.tokens - tokens;
      } else {
        tokens = saleEth * order.price;
        token.transferFrom(this, msg.sender, tokens);
        order.seller.transfer(saleEth);
        purchaseEth = purchaseEth - saleEth;
        order.tokens = 0;
        removeSellOrder(order);
      }
    }
  }

  function kill() public onlyOwner {
    token.transferFrom(this, beneficiary, token.balanceOf(this));
    beneficiary.transfer(address(this).balance);
    killed = true;
  }

  function buy(uint tokens, uint price, uint expires) public payable onlyNotKilled {
    return buyImpl(tokens, price, expires);
  }

  function sell(uint tokens, uint price, uint expires) public onlyNotKilled {
    return sellImpl(tokens, price, expires);
  }

  function getMaxSellableBySeller(address seller) public view returns (uint) {
    return getMaxSellableBySellerImpl(seller);
  }

  function getMaxBuyableByBuyer(address buyer) public view returns (uint) {
    return getMaxBuyableByBuyerImpl(buyer);
  }

  /* Implementation */

  modifier onlySeller() {
    Seller storage seller = sellers[msg.sender];
    require(seller.maxTokens > 0);
    _;
  }

  modifier onlyBuyer() {
    Buyer storage buyer = buyers[msg.sender];
    require(buyer.maxTokens > 0);
    _;
  }

  function getSellOrderMaxEth(SellOrder sellOrder) internal pure returns (uint) {
    return sellOrder.tokens * sellOrder.price;
  }

  function setSeller(
    address seller,
    uint minPrice,
    uint maxPrice,
    uint maxTokens,
    uint maxTokensPerBlock
  ) public onlyOwner {
    sellers[seller].minPrice = minPrice;
    sellers[seller].maxPrice = maxPrice;
    sellers[seller].maxTokens = maxTokens;
    sellers[seller].maxTokensPerBlock = maxTokensPerBlock;
  }

  function setBuyer(
    address buyer,
    uint minPrice,
    uint maxPrice,
    uint maxTokens,
    uint maxTokensPerBlock
  ) public onlyOwner onlyNotKilled {
    buyers[buyer].minPrice = minPrice;
    buyers[buyer].maxPrice = maxPrice;
    buyers[buyer].maxTokens = maxTokens;
    buyers[buyer].maxTokensPerBlock = maxTokensPerBlock;
  }

  function addSellPrice(uint price) internal {
    uint slot = findPriceSlot(sellPrices, price);
    for (uint i = slot; i < sellPrices.length; i++) {
      sellPrices[ i + 1 ] = sellPrices[i];
    }
    sellPrices[slot] = price;
  }

  function removeSellPrice(uint price) internal {
    int index = findPriceIndex(sellPrices, price);
    if (index >= 0) {
      for (uint i = 0; i < sellPrices.length - 1; i++) {
        sellPrices[i] = sellPrices[ i + 1 ];
      }
      delete sellPrices[ sellPrices.length - 1 ];
      sellPrices.length--;
    }
  }

  function addBuyPrice(uint price) internal {
    uint slot = findPriceSlot(buyPrices, price);
    for (uint i = slot; i < buyPrices.length; i++) {
      buyPrices[ i + 1 ] = buyPrices[i];
    }
    buyPrices[slot] = price;
  }

  function removeBuyPrice(uint price) internal {
    int index = findPriceIndex(buyPrices, price);
    if (index >= 0) {
      for (uint i = 0; i < buyPrices.length - 1; i++) {
        buyPrices[i] = buyPrices[ i + 1 ];
      }
      delete buyPrices[ buyPrices.length - 1 ];
      buyPrices.length--;
    }
  }

  function findPriceIndex(uint[] array, uint price) internal pure returns (int) {
    for (uint i = 0; i < array.length-1; i++){
        if (array[i] == price) {
          return int(i);
        }
    }
    return -1;
  }

  function findPriceSlot(uint[] array, uint price) internal pure returns (uint) {
    for (uint i = 0; i < array.length-1; i++){
        if (array[i] >= price) {
          return i;
        }
    }
    return array.length;
  }

  function getNextSellOrder() internal view returns(SellOrder) {
    uint sellPrice = sellPrices[0];
    SellOrder[] storage orders = sellOrders[sellPrice];
    SellOrder storage order = orders[0];
    return order;
  }

  function removeSellOrder(SellOrder order) internal {
    if (order.tokens > 0) {
      token.transferFrom(this, order.seller, order.tokens);
      order.tokens = 0;
    }
    compressSellOrders(order.price);
  }

  function compressSellOrders(uint price) internal {
    SellOrder[] storage orders = sellOrders[price];
    uint index = 0;
    while (index < orders.length) {
      if (orders[index].tokens == 0) {
        for (uint i = index; i < orders.length - 1; i++) {
          orders[i] = orders[ i + 1 ];
        }
        delete orders[ orders.length - 1 ];
        orders.length--;
      } else {
        index = index + 1;
      }
    }
  }

  function compressBuyOrders(uint price) internal {
    BuyOrder[] storage orders = buyOrders[price];
    uint index = 0;
    while (index < orders.length) {
      if (orders[index].tokens == 0) {
        for (uint i = index; i < orders.length - 1; i++) {
          orders[i] = orders[ i + 1 ];
        }
        delete orders[ orders.length - 1 ];
        orders.length--;
      } else {
        index = index + 1;
      }
    }
  }

  //execute as much of the order as possible, return a revised order if not completed
  function processBuyOrder(BuyOrder buyOrder) internal onlyBuyer {
    while(buyOrder.tokens > 0) {
      uint sellPrice = sellPrices[0];
      if (sellPrice <= buyOrder.price) {
        SellOrder[] storage orders = sellOrders[sellPrice];
        while(orders.length > 0) {
          SellOrder storage order = orders[0];
          uint tokensToSend = 0;
          uint ethToSend = 0;
          if (order.tokens >= buyOrder.tokens) {
            order.tokens = order.tokens - buyOrder.tokens;
            buyOrder.tokens = 0;
            tokensToSend = buyOrder.tokens;
            ethToSend = buyOrder.tokens * sellPrice;
          } else {
            buyOrder.tokens = buyOrder.tokens - order.tokens;
            tokensToSend = order.tokens;
            ethToSend = order.tokens * sellPrice;
          }

          token.transferFrom(this, buyOrder.buyer, tokensToSend);
          address(order.seller).transfer(ethToSend);

          if (order.tokens == 0) {
            for (uint i = 0; i < orders.length - 1; i++) {
              orders[i] = orders[ i + 1 ];
            }
            delete orders[ orders.length - 1 ];
            orders.length--;
          } else {
            return;
          }
        }
      } else {
        return;
      }
    }
    revert(); //should never get here
  }

  //execute as much of the order as possible, return a revised order if not completed
  function processSellOrder(SellOrder sellOrder) internal onlySeller returns (SellOrder) {
    while(sellOrder.tokens > 0) {
      uint buyPrice = buyPrices[0];
      if (buyPrice <= sellOrder.price) {
        BuyOrder[] storage orders = buyOrders[buyPrice];
        while(orders.length > 0) {
          uint tokensToSend = 0;
          uint ethToSend = 0;
          BuyOrder storage order = orders[0];
          if (order.tokens >= sellOrder.tokens) {
            order.tokens = order.tokens - sellOrder.tokens;
            sellOrder.tokens = 0;
            tokensToSend = sellOrder.tokens;
            ethToSend = sellOrder.tokens * buyPrice;
          } else {
            sellOrder.tokens = sellOrder.tokens - order.tokens;
            tokensToSend = order.tokens;
            ethToSend = order.tokens * buyPrice;
          }

          token.transferFrom(this, order.buyer, tokensToSend);
          address(sellOrder.seller).transfer(ethToSend);

          if (order.tokens == 0) {
            for (uint i = 0; i < orders.length - 1; i++) {
              orders[i] = orders[ i + 1 ];
            }
            delete orders[ orders.length - 1 ];
            orders.length--;
          } else {
            return;
          }
        }
      } else {
        return;
      }
    }
    revert(); //should never get here
  }

  function fundsNeededForBuyOrder(uint tokens, uint price) pure internal returns(uint) {
    return SafeMath.mul(tokens / (10 ** 9), price / (10 ** 9));
  }

  function getMaxSellableBySellerImpl(address _seller) internal view returns (uint) {
    Seller storage seller = sellers[_seller];
    if (seller.maxTokens > 0) {
      uint blocksToCheck = 5000;
      uint totalRecent = 0;
      uint totalUnsold = 0;
      uint tokensAllowed = 0;
      uint tokensAllowedRecent = 0;
      for (uint index = 0; index < seller.orders.length; index++) {
        if (block.number - seller.orders[index].expireBlock > blocksToCheck) {
          totalRecent = totalRecent + seller.orders[index].tokens;
        }

        if (seller.orders[index].completedBlock >= block.number && seller.orders[index].completedBlock == 0) {
          totalUnsold = totalUnsold + seller.orders[index].tokens;
        }
      }
      tokensAllowed = seller.maxTokens - totalUnsold;
      if (tokensAllowed < 0) {tokensAllowed = 0;}
      tokensAllowedRecent = seller.maxTokensPerBlock * 5000 - totalRecent;
      if (tokensAllowedRecent < 0) {tokensAllowedRecent = 0;}
      if (tokensAllowedRecent < tokensAllowed) {
        return tokensAllowedRecent;
      } else {
        return tokensAllowed;
      }
    }
    return 0;
  }

  function getMaxBuyableByBuyerImpl(address _buyer) internal view returns (uint) {
    Buyer storage buyer = buyers[_buyer];
    if (buyer.maxTokens > 0) {
      uint blocksToCheck = 5000;
      uint totalRecent = 0;
      uint totalUnbought = 0;
      uint tokensAllowed = 0;
      uint tokensAllowedRecent = 0;
      for (uint index = 0; index < buyer.orders.length; index++) {
        if (block.number - buyer.orders[index].completedBlock > blocksToCheck) {
          totalRecent = totalRecent + buyer.orders[index].tokens;
        }

        if (buyer.orders[index].expireBlock >= block.number && buyer.orders[index].completedBlock == 0) {
          totalUnbought = totalUnbought + buyer.orders[index].tokens;
        }
      }
      tokensAllowed = buyer.maxTokens - totalUnbought;
      if (tokensAllowed < 0) {tokensAllowed = 0;}
      tokensAllowedRecent = buyer.maxTokensPerBlock * 5000 - totalRecent;
      if (tokensAllowedRecent < 0) {tokensAllowedRecent = 0;}
      if (tokensAllowedRecent < tokensAllowed) {
        return tokensAllowedRecent;
      } else {
        return tokensAllowed;
      }
    }
    return 0;
  }

  function buyImpl(uint tokens, uint price, uint expires) internal onlyNotKilled {
    require (getMaxBuyableByBuyer(msg.sender) >= tokens);

    uint fundsNeeded = fundsNeededForBuyOrder(tokens, price);

    require (fundsNeeded <= msg.value);

    address(this).transfer(fundsNeeded);

    BuyOrder memory buyOrder = BuyOrder(msg.sender, tokens, price, expires, 0);
    processBuyOrder(buyOrder);
    if (buyOrder.tokens > 0) {
      buyOrders[price].push(buyOrder);
    }
  }

  function sellImpl(uint tokens, uint price, uint expires) internal onlyNotKilled {
    require (getMaxSellableBySeller(msg.sender) >= tokens);
    // it is required that the caller first assigns transfer rights to the contract
    token.transferFrom(msg.sender, this, tokens);

    SellOrder memory sellOrder = SellOrder(msg.sender, tokens, price, expires, 0);
    processSellOrder(sellOrder);
    if (sellOrder.tokens > 0) {
      sellOrders[price].push(sellOrder);
    }
  }

}
