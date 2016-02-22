# -*- coding: utf-8 -*-
# wx_tests.jl

import Wx
using Base.Test

println("Testing: Wx")
@test Wx.WxApp()
println("done.")
