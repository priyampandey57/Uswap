// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./interfaceIERC20.sol";
import "./interfaceIUniswapV2Router.sol";
import "./interfaceIUniswapV2Pair.sol";
import "./interfaceIUniswapV2Factory.sol";
import "./interfacePWETH.sol";

// https://uniswap.org/docs/v2/smart-contracts

contract Uswap {
     address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
     address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

     function swapTtoT(
         address _tokenIn,
         address _tokenOut,
         uint _amountIn,
         uint _amountOutMin,
         address _to 
     ) external {
       console.log(address(this));
       console.log(msg.sender);
         IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
         IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, _amountIn);

      address[] memory path;
      path = new address[](3);
      path[0] = _tokenIn;
      path[1] = WETH;
      path[2] = _tokenOut;
    
    IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
      _amountIn,
      _amountOutMin,
      path,
      _to,
      block.timestamp
    );
  }
 
  function swapEtoT(
    uint _amountIn,
    address _tokenOut,
    uint _amountOutMin,
    address _to
  )external payable{
   
   // _amountIn = msg.value;
    PWETH(WETH).deposit{value: msg.value}();
    IERC20(WETH).approve(UNISWAP_V2_ROUTER, _amountIn);

    address [] memory path;
    path = new address[](2);
    path[0] = WETH;
    path[1] = _tokenOut;
   //console.log(IERC20(WETH).balanceOf(address(this)));
   //console.log("msg.value" , msg.value);
   IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
      _amountIn,
      _amountOutMin,
      path,
      _to,
      block.timestamp
    );
  //  IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactETHForTokens{value: msg.value}(
  //   _amountOutMin,
  //   path,
  //   _to,
  //    block.timestamp
  // );
  // this.swapTtoT(WETH, _tokenOut, _amountIn, _amountOutMin, _to);
  }

  function swapTtoE(
    address _tokenIn,
    uint _amountIn,
    uint _amountOutMin,
    address _to
  )external payable {
    IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
    IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, _amountIn);

    address [] memory path;
    path = new address[](2);
    path[0] = _tokenIn;
    path[1] = WETH;

      PWETH(WETH).transfer(_to, msg.value);
//console.log(block.timestamp);
    IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForETH(
    _amountIn,
    _amountOutMin,
    path,
    _to,
    block.timestamp
  );
 
  }

  function getAmountOutMin (
    address _tokenIn,
    address _tokenOut,
    uint _amountIn
  ) external view returns (uint) {
    address[] memory path;
      path = new address[](3);
      path[0] = _tokenIn;
      path[1] = WETH;
      path[2] = _tokenOut;
     

     // length same as path
    uint[] memory amountOutMins =
      IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsOut(_amountIn, path);

      return amountOutMins[path.length - 1];
  }

}
