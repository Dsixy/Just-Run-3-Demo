class_name CouponManager

var couponValue: int = 100

signal couponChangeS

func add_coupon(value: int):
	self.couponValue += value
	couponChangeS.emit()

func cost_coupon(value: int):
	self.couponValue = max(0, couponValue - value)
	self.couponChangeS.emit()
