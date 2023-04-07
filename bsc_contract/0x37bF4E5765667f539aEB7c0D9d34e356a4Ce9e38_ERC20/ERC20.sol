/**
 *Submitted for verification at BscScan.com on 2023-03-30
*/

// SPDX-License-Identifier: MIT
//pragma solidity ^0.8.6; 6����0������
pragma solidity ^0.8.0;



// �ṩ�йص�ǰִ�������ĵ���Ϣ����������ķ����߼������ݡ� ��Ȼ��Щͨ������ͨ�� msg.sender �� msg.data ��ã�����Ӧ������ֱ�ӷ�ʽ�������ǣ���Ϊ�ڴ���Ԫ����ʱ�����ͺ�֧��ִ�е��ʻ����ܲ���ʵ�ʵķ����ߣ���Ӧ�ö��ԣ���
// ֻ���м�ġ����Ƴ��򼯵ĺ�Լ����Ҫ�����Լ��
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// ʵ��{IERC20}�ӿ�
contract ERC20 is Context{
    string public _name;
    string public _symbol;
    uint256 public _decimals;
    uint256 public _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    
    address public marketingAddress = 0x0000000000000000000000000000000000000001;//Ӫ����ַ
    address public holdingCurrencyAddress = 0x0000000000000000000000000000000000000002;//�ֱҷֺ��ַ
    address public lpAddress = 0x0000000000000000000000000000000000000003;//LP�طֺ��ַ
    address public dynamicAddress = 0x0000000000000000000000000000000000000004;//��̬������ַ

    // uint256 public slippage = 60;//��ʼ���׻���ǧ�ֱ�

    uint256 public blackHoleSlippage = 5;//ͨ���ٷֱ�
    uint256 public marketingSlippage = 15;//Ӫ����ַǧ�ֱ�
    uint256 public holdingCurrencySlippage = 10;//�ֱҷֺ��ַǧ�ֱ�
    uint256 public lpSlippage = 10;//LP��ǧ�ֱ�
    uint256 public dynamicSlippage = 20;//��̬����ǧ�ֱ�


    //�������ѵĵ�ַ
    mapping(address=>bool) public _FeeList;
    

    //����Ա
    address public owners;
    modifier _Owner {   //����Ա
        require(owners == msg.sender);
        _;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner,address indexed spender,uint256 value);
    event FeeList(address address_,bool status_);

    event holdingCurrencyEvent(address address_,uint256 value);//�ֱҷֺ��¼�
    event lpEvent(address address_,uint256 value);//LP���¼�
    event dynamicEvent(address address_,uint256 value);//��̬�����¼�


    constructor(address address_) {
        _name = "BDJ1";
        _symbol = "BDJ2";
        _decimals = 18;
        owners = msg.sender;
        _mint(address_, 22000000 * 10**decimals());
        _burn(address_, 11000000 * 10**decimals());
        
    }
    function name() public view virtual returns (string memory) {
        return _name;
    }
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }
    function decimals() public view virtual returns (uint256) {
        return _decimals;
    }
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }
    function allowance(address owner, address spender) public view virtual returns (uint256){
        return _allowances[owner][spender];
    }
    function setOwner(address owner_) public _Owner returns (bool) {
        owners = owner_;
        return true;
    }
    //�޸ļ�����ַ
    function setAddress(address address_ , uint256 type_) public _Owner returns (bool) {
        require(address_ != address(0), "ERC20: incorrect address");
        if(type_ == 1){
            marketingAddress = address_;
            return true;
        }
        if(type_ == 2){
            holdingCurrencyAddress = address_;
            return true;
        }
        if(type_ == 3){
            lpAddress = address_;
            return true;
        }
        if(type_ == 4){
            dynamicAddress = address_;
            return true;
        }
        return false;
    }
    //�޸ļ�����ַ������ǧ�ֱ�
    function setSlippage(uint256 slippage_ , uint256 type_) public _Owner returns (bool) {
        require(slippage_ < 100, "ERC20: slippage out of range");
        require(slippage_ > 0, "ERC20: slippage less than range");
        if(type_ == 0){
            blackHoleSlippage = slippage_;
            return true;
        }
        if(type_ == 1){
            marketingSlippage = slippage_;
            return true;
        }
        if(type_ == 2){
            holdingCurrencySlippage = slippage_;
            return true;
        }
        if(type_ == 3){
            lpSlippage = slippage_;
            return true;
        }
        if(type_ == 4){
            dynamicSlippage = slippage_;
            return true;
        }
        return false;
    }

    //������ȡ�����ѵĵ�ַ
    function setFeeList(address address_,bool state_) public _Owner returns (bool){
        _FeeList[address_] = state_;
        emit FeeList(address_,state_); 
        return true;
    }
    // //�޸Ľ��׻���
    // function setSlippage(uint256 slippage_) public _Owner returns (bool) {
    //     require(slippage_ < 100, "ERC20: slippage out of range");
    //     require(slippage_ > 0, "ERC20: slippage less than range");
    //     slippage = slippage_;
    //     return true;
    // }
    function transferall(address[] memory recipient, uint256[] memory amount) public virtual returns (bool){
        require(recipient.length == amount.length,"ERC20: Array lengths are different");
        for(uint i = 0; i < recipient.length ; i++){
            _transfer(_msgSender(), recipient[i], amount[i]);
        }
        return true;
    }
    function transfer(address recipient, uint256 amount)
        public
        virtual
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }
        return true;
    }

    // ���ӵ��������� spender �Ŀ���������
    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    // ���ٵ��������� spender �Ŀ���������
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    // ��amount�����Ĵ��Ҵ� sender �ƶ��� recipient
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _beforeTokenTransfer(sender, recipient, amount);
        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );

        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        uint256 accountAmount = amount;
        //ת�����ǽ���������ַ  ��  ����  
        if(_FeeList[sender] && !_FeeList[recipient]){
            uint256 a = amount*blackHoleSlippage/1000;//�ڶ�
            _burn(sender, a);
            _balances[sender] += a;
            uint256 b = amount*marketingSlippage/1000;//Ӫ����ַ
            _balances[marketingAddress] += b;
            emit Transfer(sender, marketingAddress, b);
            uint256 c = amount*holdingCurrencySlippage/1000;//�ֱҷֺ�
            _balances[holdingCurrencyAddress] += c;
            emit holdingCurrencyEvent(recipient,c);
            emit Transfer(sender, holdingCurrencyAddress, c);
            uint256 d = amount*lpSlippage/1000;//LP��
            _balances[lpAddress] += d;
            emit lpEvent(recipient,d);
            emit Transfer(sender, lpAddress, d);
            uint256 e = amount*dynamicSlippage/1000;//��̬
            _balances[dynamicAddress] += e;
            emit dynamicEvent(recipient,e);
            emit Transfer(sender, dynamicAddress, e);
            accountAmount = accountAmount - a - b - c - d - e;
        }

        //ת�����ǽ���������ַ  ��  ����  
        if(_FeeList[recipient] && !_FeeList[sender]){
            uint256 a = amount*blackHoleSlippage/1000;//�ڶ�
            _burn(sender, a);
            _balances[sender] += a;
            uint256 b = amount*marketingSlippage/1000;//Ӫ����ַ
            _balances[marketingAddress] += b;
            emit Transfer(sender, marketingAddress, b);
            uint256 c = amount*holdingCurrencySlippage/1000;//�ֱҷֺ�
            _balances[holdingCurrencyAddress] += c;
            emit holdingCurrencyEvent(sender,c);
            emit Transfer(sender, holdingCurrencyAddress, c);
            uint256 d = amount*lpSlippage/1000;//LP��
            _balances[lpAddress] += d;
            emit lpEvent(sender,d);
            emit Transfer(sender, lpAddress, d);
            uint256 e = amount*dynamicSlippage/1000;//��̬
            _balances[dynamicAddress] += e;
            emit dynamicEvent(sender,e);
            emit Transfer(sender, dynamicAddress, e);
            accountAmount = accountAmount - a - b - c - d - e;
        }
        _balances[recipient] += accountAmount;
        emit Transfer(sender, recipient, accountAmount);
        _afterTokenTransfer(sender, recipient, amount);
    }

    // ����
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    // ����
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;
        _balances[address(0)] += amount;
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }

    // �� `amount` ����Ϊ `spender` �� `owner` �Ĵ��ҵĽ���
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    // ���κδ���ת��֮ǰ���õĹ��ӣ� �������Һ�����
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    // ���κδ���ת��֮����õĹ��ӣ� �������Һ�����
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}