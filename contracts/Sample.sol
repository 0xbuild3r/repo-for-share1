pragma solidity ^0.6.0;

import "./Libraries/tokens/IERC20.sol";
import "./Libraries/tokens/SafeERC20.sol";
import "./Libraries/math/SafeMath.sol";
import "./Libraries/utils/Address.sol";
import "./Libraries/utils/Ownable.sol";

contract Sample is Ownable {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    IERC20 public token;

    mapping(address => uint256) public attributions;
    uint256 public totalAttributions;

    constructor(address _token) public {
        token = IERC20(_token);
    }

    function addValue(
        uint256 _amount,
        address _from,
        address _beneficiary
    ) external returns (uint256 _attributions) {
        uint256 _pool = valueAll();
        token.safeTransferFrom(_from, address(this), _amount);
        if (totalAttributions == 0) {
            _attributions = _amount;
        } else {
            _attributions = _amount.mul(totalAttributions).div(_pool);
        }
        totalAttributions = totalAttributions.add(_attributions);
        attributions[_beneficiary] = attributions[_beneficiary].add(
            _attributions
        );
    }

    function withdrawValue(uint256 _amount, address _to) external {
        require(attributions[msg.sender] > 0 && valueOf(msg.sender) >= _amount);
        uint256 _targetAttribution =
            totalAttributions.mul(_amount).div(valueAll());
        attributions[msg.sender] = attributions[msg.sender].sub(
            _targetAttribution
        );
        totalAttributions = totalAttributions.sub(_targetAttribution);
        token.transfer(_to, _amount);
    }

    function valueOf(address _target) public view returns (uint256) {
        if (attributions[_target] > 0) {
            return valueAll().mul(attributions[_target]).div(totalAttributions);
        } else {
            return 0;
        }
    }

    function valueAll() public view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
