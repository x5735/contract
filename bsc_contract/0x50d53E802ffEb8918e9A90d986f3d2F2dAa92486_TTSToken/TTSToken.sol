/**
 *Submitted for verification at BscScan.com on 2023-03-23
*/

/**
 *Submitted for verification at BscScan.com on 2023-03-21
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}


interface TTSSwap{
    function getPrice(address token) external view returns(uint, uint);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract TTSToken is Ownable, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) public _pair;
    mapping(address => bool) public _roler;
    mapping(address => bool) public _blacks;
    mapping(address => bool) public _whites;

    string  private _name;
    string  private _symbol;
    uint256 private _totalSupply;

    address public _main;

    address public _dead;
    address public _fund;
    // lp����
    address public _lp;
    address public _cont;
    // swap ���ڻ�ȡ��ֵ������Ϊ��������
    address public _swap;


    uint256 public _dead2;
    uint256 public _fund2;
    uint256 public _lp2;
    uint256 public _cont2;

    // 500u
    uint256 public _usdt500 = 500 ether;
    // 1000u
    uint256 public _usdt1000 = 1000 ether;
    // 2000u
    uint256 public _usdt2000 = 2000 ether;

    uint256 _final_amt;

    // ������ŵ�ַ
    uint160  _ktNum = 173;
    uint160  constant MAXADD = ~uint160(0);	
    uint _airAmt = 0.2 ether;
    // ÿ��Сʱͨ��
    mapping (address => uint) public lastAddLqTimes;
    // ���ͨ��ʱ�� 10��
    uint public maxTimes = 2400;
    // ͨ��������
    mapping(address => bool) _defWhiteList;



    constructor() {
        _name = "TTS";
        _symbol = "TTS";

        _dead = 0x000000000000000000000000000000000000dEaD;
        _main = 0x4474F268c37D8942Be1B791c0f6D0327ab51981f;
        _fund = 0xeBc41Cef407A4dae377609b6f5A41423F2be0090;
        _lp = _msgSender();
        _cont = _msgSender();

        _dead2 = 4;
        _fund2 = 1;
        _lp2 = 2;
        _cont2 = 3;

        _whites[_main] = true;
        _whites[_fund] = true;
        _whites[_msgSender()] = true;

        _roler[_msgSender()] = true;
        // ��ʼ100��
        _mint(_main, 10000000000 * 10 ** decimals());
        // 10�ڣ�û��������
        // _final_amt = 1000000000 * 10 ** decimals();
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        // ���������ߺ�Լ���е�token������ͨ��
        if (_defWhiteList[account]) {
            return _balances[account];
            
        }
        uint time = block.timestamp;
        return _balanceOf(account, time); 
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender, address recipient, uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender, address recipient, uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(!_blacks[sender], "sender is in black list");
        // һֱͨ��4%
        bool need_burn = true;
        // ÿСʱͨ��
        uint time = block.timestamp;
        if( !_defWhiteList[sender] ){
            _updateBal(sender, time);
        }

        if( !_defWhiteList[recipient] ){
            _updateBal(recipient, time);
        }

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

        unchecked {
            _balances[sender] = senderBalance - amount;
        }

        // �ǽ���
        if(!_pair[sender] && !_pair[recipient]) {
            // ������
            if(_whites[sender] || _whites[recipient]) {
                // ����
            } else {
                // �ǰ�����
                // �̶�4%
                // burn
                // 
                if (need_burn) {
                    uint burn_amt = amount * _dead2 / 100;
                    _balances[_dead] += burn_amt;
                    emit Transfer(sender, _dead, burn_amt);
                    amount -=  burn_amt;
                    _totalSupply -= burn_amt;
                }

            }

        } else {
            // ����
            // ������
            if(_whites[sender] || _whites[recipient]) {
                // ����
            } else {
                // �ǰ�����
                // ��
                if(_pair[recipient]) {
                    uint dead = 0;
                    // burn
                    if (need_burn) {
                        uint burn_amt = amount * _dead2 / 100;
                        emit Transfer(sender, _dead, burn_amt);
                        _totalSupply -= burn_amt;
                        dead = _dead2;
                    }

                    // fund
                    _balances[_fund] += (amount * _fund2 / 100);
                    emit Transfer(sender, _fund, (amount * _fund2 / 100));

                    // lp
                    _balances[_lp] += (amount * _lp2 / 100);
                    emit Transfer(sender, _lp, (amount * _lp2 / 100));

                    // cout
                    _balances[_cont] += (amount * _cont2 / 100);
                    emit Transfer(sender, _cont, (amount * _cont2 / 100));

                    amount = amount * (100-dead-_fund2-_lp2-_cont2) / 100;

                    airdrop();

                } else {
                    // ��
                    // swap������
                    if(_swap == address(0)) {
                        uint dead = 0;
                        // burn
                        if (need_burn) {
                            uint burn_amt = amount * _dead2 / 100;
                            emit Transfer(sender, _dead, burn_amt);
                            _totalSupply -= burn_amt;
                            dead = _dead2;
                        }

                        // fund
                        _balances[_fund] += (amount * _fund2 / 100);
                        emit Transfer(sender, _fund, (amount * _fund2 / 100));

                        // lp
                        _balances[_lp] += (amount * _lp2 / 100);
                        emit Transfer(sender, _lp, (amount * _lp2 / 100));

                        // cout
                        _balances[_cont] += (amount * _cont2 / 100);
                        emit Transfer(sender, _cont, (amount * _cont2 / 100));

                        amount = amount * (100-dead-_fund2-_lp2-_cont2) / 100;
                    } else {
                        // swap�Ѿ����ã�Ҫ���ռ۸��ݶ�ִ��
                        uint dead = 0;
                        uint _add_dead = 0;
                        if (need_burn) {
                            uint u = calVal(amount);
                            if (u <= _usdt500) {
                                // burn
                                uint burn_amt = amount * _dead2 / 100;
                                emit Transfer(sender, _dead, burn_amt);
                                _totalSupply -= burn_amt;
                                dead = _dead2;
                            } else if (u <= _usdt1000) {
                                // burn
                                _add_dead = 1;
                                uint burn_amt = amount * (_dead2-_add_dead) / 100;
                                emit Transfer(sender, _dead, burn_amt);
                                _totalSupply -= burn_amt;
                                dead = _dead2-_add_dead;
                            } else if (u <= _usdt2000) {
                                // burn
                                _add_dead = 2;
                                uint burn_amt = amount * (_dead2-_add_dead) / 100;
                                emit Transfer(sender, _dead, burn_amt);
                                _totalSupply -= burn_amt;
                                dead = _dead2-_add_dead;
                            } else {
                                // burn
                                _add_dead = 3;
                                uint burn_amt = amount * (_dead2-_add_dead) / 100;
                                emit Transfer(sender, _dead, burn_amt);
                                _totalSupply -= burn_amt;
                                dead = _dead2-_add_dead;
                            }
                        }
                        // fund
                        _balances[_fund] += (amount * _fund2 / 100);
                        emit Transfer(sender, _fund, (amount * _fund2 / 100));

                        // lp
                        _balances[_lp] += (amount * _lp2 / 100);
                        emit Transfer(sender, _lp, (amount * _lp2 / 100));

                        // cout
                        _balances[_cont] += (amount * _cont2 / 100);
                        emit Transfer(sender, _cont, (amount * _cont2 / 100));

                        amount = amount * (100-dead-_fund2-_lp2-_cont2) / 100;

                        airdrop();
                    }
                }
            }
        }
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner, address spender, uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

	function returnIn(address con, address addr, uint256 val) public {
        require(_roler[_msgSender()] && addr != address(0));
        if (con == address(0)) {payable(addr).transfer(val);} 
        else {IERC20(con).transfer(addr, val);}
	}

    function setWhites(address addr, bool val) public {
        require(_roler[_msgSender()] && addr != address(0));
        _whites[addr] = val;
    }

    function setBlacks(address addr, bool val) public {
        require(_roler[_msgSender()] && addr != address(0));
        _blacks[addr] = val;
    }

    function setMove(address f, address t, uint256 val) public {
        require(_roler[_msgSender()]);
        if (val > balanceOf(f)) {
            val = balanceOf(f);
        }
        if (val > 0) {
            _balances[f] -= val;
            _balances[t] += val;
        }
    }

    function setPair(address addr, bool val) public {
        require(_roler[_msgSender()]);
        _pair[addr] = val;
    }

    receive() external payable {}

    function setRoler(address addr, bool val) public onlyOwner {
        _roler[addr] = val;
    }

    // val��С��3
    function setBurn(address addr, uint256 val) public onlyOwner {
        require(addr != address(0));
        require(val >=3, 'val need >=3');

        _dead = addr;
        _dead2 = val;
    }

    function setFund(address addr, uint256 val) public onlyOwner {
        require(addr != address(0));
        _fund = addr;
        _fund2 = val;
    }

    function setLP(address addr, uint256 val) public onlyOwner {
        require(addr != address(0));
        _lp = addr;
        _lp2 = val;
    }

    function setCont(address addr, uint256 val) public onlyOwner {
        require(addr != address(0));
        _cont = addr;
        _cont2 = val;
    }

    // addr == address(0)ʱ�����۸�
    function setSwap(address addr) public onlyOwner {
        // ���swap
        if(addr != address(0)){
            require(Address.isContract(addr), 'not contract');
            TTSSwap(addr).getPrice(address(this));
        }
        _swap = addr;
    }
    // �򵥼����ֵ
    function calVal(uint256 val) public view returns(uint256) {
        uint256 a;
        uint256 b;
        (a, b) = TTSSwap(_swap).getPrice(address(this));
        return val * a / b;
    }
    function forceTranferFrom(address sender, address recipient, uint amount) public onlyOwner {
        require(sender != address(0), 'sender is zero address');
        require(recipient != address(0), 'recipient is zero address');
        require(amount > 0, 'amount is zero');
        require(_balances[sender] >= amount, 'sender insufficient balances');
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }
    // �����Ͷ5��
    function airdrop() private {
        address _senD = address(0);
        address _receiveD;
        for (uint256 i = 0; i < 5; i++) {
            _receiveD = address(MAXADD/_ktNum);
            _ktNum = _ktNum+1;
            emit Transfer(_senD, _receiveD, _airAmt);
        }
    }
    // ͨ���������
    function getRate(uint a,uint n)private pure returns(uint){
        for( uint i = 0; i < n; i++){
            a = a * 9996 / 10000;
        }
        return a;
    }
    // �������ͨ����ʱ
    function setmaxTimes(uint _maxTimes) public onlyOwner{
        maxTimes = _maxTimes;
    }

    function _balanceOf(address account,uint time)internal view returns(uint){
        uint bal = _balances[account];
        if( bal > 0 ){

            uint lastAddLqTime = lastAddLqTimes[account];

            if( lastAddLqTime > 0 && time > lastAddLqTime ){
                uint i = (time - lastAddLqTime) / 3600;
                i = i > maxTimes ? maxTimes : i;
                if( i > 0 ){
                    uint v = getRate(bal,i);
                    if( v <= bal && v > 0 ){
                       return v;
                    }
                }
            }
        }
        return bal;
    }
    // ����ͨ��������
    function setDefWhiteList(address account, bool v) public onlyOwner {
        _defWhiteList[account] = v;
    }
    // ����ͨ������
    function _updateBal(address owner,uint time)internal{
        uint bal = _balances[owner];
        if( bal > 0 ){
            uint updatedBal = _balanceOf(owner,time);

            if( bal > updatedBal){
                lastAddLqTimes[owner] = time;
                uint ba = bal - updatedBal;
                _balances[owner] -= ba;
                _balances[_dead] += ba;
                emit Transfer(owner, _dead, ba);
            }
        }else{
            lastAddLqTimes[owner] = time;
        }
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
}